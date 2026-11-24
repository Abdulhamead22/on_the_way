import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();
  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderEntity> customerOrders;
  final List<OrderEntity> availableOrders;
  final List<OrderEntity> courierActiveOrders;

  const OrdersLoaded({
    this.customerOrders = const [],
    this.availableOrders = const [],
    this.courierActiveOrders = const [],
  });

  @override
  List<Object?> get props => [customerOrders, availableOrders, courierActiveOrders];
}

class OrderActionSuccess extends OrdersState {
  final String message;
  const OrderActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}
