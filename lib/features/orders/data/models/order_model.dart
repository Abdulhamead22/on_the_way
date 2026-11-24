import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.customerId,
    super.courierId,
    required super.description,
    required super.items,
    required super.estimatedPrice,
    required super.deliveryFee,
    required super.status,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>?) ?? [];
    return OrderModel(
      id: json['id'].toString(),
      customerId: json['customer_id'].toString(),
      courierId: json['courier_id']?.toString(),
      description:
          json['title']?.toString() ??
          json['description']?.toString() ??
          'طلب توصيل',
      items: rawItems
          .map((e) => OrderItemEntity.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      estimatedPrice: (json['estimated_price'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 10.0,
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }
}
