import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository ordersRepository;

  OrdersCubit({required this.ordersRepository}) : super(OrdersInitial());

  List<OrderEntity> _customerOrders = [];
  List<OrderEntity> _availableOrders = [];
  List<OrderEntity> _courierActiveOrders = [];

  Future<void> loadAllOrders(String userId) async {
    emit(OrdersLoading());
    final customerRes = await ordersRepository.getCustomerOrders(userId);
    final availableRes = await ordersRepository.getAvailableOrders(userId);
    final courierRes = await ordersRepository.getCourierActiveOrders(userId);

    customerRes.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => _customerOrders = orders,
    );

    availableRes.fold(
      (_) {},
      (orders) => _availableOrders = orders,
    );

    courierRes.fold(
      (_) {},
      (orders) => _courierActiveOrders = orders,
    );

    emit(OrdersLoaded(
      customerOrders: _customerOrders,
      availableOrders: _availableOrders,
      courierActiveOrders: _courierActiveOrders,
    ));
  }

  Future<void> publishOrder({
    required String customerId,
    required String description,
    required List<OrderItemEntity> items,
    required double estimatedPrice,
    required double deliveryFee,
  }) async {
    emit(OrdersLoading());
    final result = await ordersRepository.createOrder(
      customerId: customerId,
      description: description,
      items: items,
      estimatedPrice: estimatedPrice,
      deliveryFee: deliveryFee,
    );

    await result.fold(
      (failure) async => emit(OrdersError(failure.message)),
      (newOrder) async {
        emit(const OrderActionSuccess('تم نشر طلبك بنجاح! جاري البحث عن أقرب مندوب 🚀'));
        await loadAllOrders(customerId);
      },
    );
  }

  Future<void> acceptOrderByCourier({
    required String orderId,
    required String courierId,
  }) async {
    emit(OrdersLoading());
    final result = await ordersRepository.acceptOrder(
      orderId: orderId,
      courierId: courierId,
    );

    await result.fold(
      (failure) async => emit(OrdersError(failure.message)),
      (_) async {
        emit(const OrderActionSuccess('تم قبول الطلب بنجاح! يمكنك البدء بالشراء الآن ✅'));
        await loadAllOrders(courierId);
      },
    );
  }
}
