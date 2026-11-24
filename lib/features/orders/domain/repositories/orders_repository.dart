import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, OrderEntity>> createOrder({
    required String customerId,
    required String description,
    required List<OrderItemEntity> items,
    required double estimatedPrice,
    required double deliveryFee,
  });

  Future<Either<Failure, List<OrderEntity>>> getCustomerOrders(String customerId);
  Future<Either<Failure, List<OrderEntity>>> getAvailableOrders(String currentUserId);
  Future<Either<Failure, List<OrderEntity>>> getCourierActiveOrders(String courierId);
  Future<Either<Failure, void>> acceptOrder({
    required String orderId,
    required String courierId,
  });
}
