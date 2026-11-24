import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String name;
  final String quantity;
  final double price;

  const OrderItemEntity({
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'price': price,
      };

  factory OrderItemEntity.fromJson(Map<String, dynamic> json) {
    return OrderItemEntity(
      name: json['name']?.toString() ?? '',
      quantity: json['quantity']?.toString() ?? '1',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [name, quantity, price];
}

class OrderEntity extends Equatable {
  final String id;
  final String customerId;
  final String? courierId;
  final String description;
  final List<OrderItemEntity> items;
  final double estimatedPrice;
  final double deliveryFee;
  final String status; // pending, accepted, purchased, delivering, delivered
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.customerId,
    this.courierId,
    required this.description,
    required this.items,
    required this.estimatedPrice,
    required this.deliveryFee,
    required this.status,
    required this.createdAt,
  });

  String get shortOrderNumber => '#${id.substring(0, 4).toUpperCase()}';

  int get stepIndex {
    switch (status) {
      case 'pending':
        return 0;
      case 'accepted':
        return 1;
      case 'purchased':
      case 'delivering':
        return 2;
      case 'delivered':
        return 3;
      default:
        return 0;
    }
  }

  String get statusArabic {
    switch (status) {
      case 'pending':
        return 'بانتظار مندوب';
      case 'accepted':
        return 'تم القبول';
      case 'purchased':
        return 'تم الشراء';
      case 'delivering':
        return 'قيد التوصيل';
      case 'delivered':
        return 'تم التسليم';
      default:
        return 'قيد المعالجة';
    }
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        courierId,
        description,
        items,
        estimatedPrice,
        deliveryFee,
        status,
        createdAt,
      ];
}
