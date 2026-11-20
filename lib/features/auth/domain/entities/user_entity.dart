import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final String role; // 'customer' or 'courier'
  final String? avatarUrl;
  final double walletBalance;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.walletBalance = 0.0,
  });

  @override
  List<Object?> get props => [id, fullName, phone, role, avatarUrl, walletBalance];
}
