import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/order_entity.dart';
import '../models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<OrderModel> createOrder({
    required String customerId,
    required String description,
    required List<OrderItemEntity> items,
    required double estimatedPrice,
    required double deliveryFee,
  });

  Future<List<OrderModel>> getCustomerOrders(String customerId);
  Future<List<OrderModel>> getAvailableOrders(String currentUserId);
  Future<List<OrderModel>> getCourierActiveOrders(String courierId);
  Future<void> acceptOrder({
    required String orderId,
    required String courierId,
  });
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final SupabaseClient supabase;
  OrdersRemoteDataSourceImpl(this.supabase);

  @override
  Future<OrderModel> createOrder({
    required String customerId,
    required String description,
    required List<OrderItemEntity> items,
    required double estimatedPrice,
    required double deliveryFee,
  }) async {
    try {
      final cleanTitle = description.trim().isEmpty ? 'طلب توصيل' : description.trim();
      final response = await supabase
          .from('orders')
          .insert({
            'customer_id': customerId,
            'title': cleanTitle,
            'description': cleanTitle,
            'items': items.map((e) => e.toJson()).toList(),
            'estimated_price': estimatedPrice,
            'delivery_fee': deliveryFee,
            'status': 'pending',
          })
          .select()
          .single();

      return OrderModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('خطأ في قاعدة البيانات: ${e.message}');
    } catch (e) {
      throw ServerException('تعذر نشر الطلب: ${e.toString()}');
    }
  }

  @override
  Future<List<OrderModel>> getCustomerOrders(String customerId) async {
    try {
      final response = await supabase
          .from('orders')
          .select()
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('تعذر جلب الطلبات');
    }
  }

  @override
  Future<List<OrderModel>> getAvailableOrders(String currentUserId) async {
    try {
      // استبعاد طلبات المستخدم نفسه حتى لا يقبل المندوب طلبه الشخصي!
      final response = await supabase
          .from('orders')
          .select()
          .eq('status', 'pending')
          .neq('customer_id', currentUserId)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('تعذر جلب الطلبات القريبة');
    }
  }

  @override
  Future<List<OrderModel>> getCourierActiveOrders(String courierId) async {
    try {
      final response = await supabase
          .from('orders')
          .select()
          .eq('courier_id', courierId)
          .neq('status', 'delivered')
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('تعذر جلب مهامك الحالية');
    }
  }

  @override
  Future<void> acceptOrder({
    required String orderId,
    required String courierId,
  }) async {
    try {
      await supabase
          .from('orders')
          .update({
            'courier_id': courierId,
            'status': 'accepted',
          })
          .eq('id', orderId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('تعذر قبول الطلب');
    }
  }
}
