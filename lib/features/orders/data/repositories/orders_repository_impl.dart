import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required String customerId,
    required String description,
    required List<OrderItemEntity> items,
    required double estimatedPrice,
    required double deliveryFee,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
    try {
      final order = await remoteDataSource.createOrder(
        customerId: customerId,
        description: description,
        items: items,
        estimatedPrice: estimatedPrice,
        deliveryFee: deliveryFee,
      );
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getCustomerOrders(String customerId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
    try {
      final orders = await remoteDataSource.getCustomerOrders(customerId);
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAvailableOrders(String currentUserId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
    try {
      final orders = await remoteDataSource.getAvailableOrders(currentUserId);
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getCourierActiveOrders(String courierId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
    try {
      final orders = await remoteDataSource.getCourierActiveOrders(courierId);
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> acceptOrder({
    required String orderId,
    required String courierId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
    try {
      await remoteDataSource.acceptOrder(orderId: orderId, courierId: courierId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
