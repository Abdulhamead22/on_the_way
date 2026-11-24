import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import 'courier_active_map_card.dart';
import 'nearby_order_card.dart';

class CourierHomeView extends StatefulWidget {
  final ValueChanged<OrderEntity> onOrderDetailsTap;
  const CourierHomeView({super.key, required this.onOrderDetailsTap});

  @override
  State<CourierHomeView> createState() => _CourierHomeViewState();
}

class _CourierHomeViewState extends State<CourierHomeView> {
  bool isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final availableOrders = state is OrdersLoaded ? state.availableOrders : <OrderEntity>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'حالة استقبال الطلبات',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => isAvailable = !isAvailable),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isAvailable ? const Color(0xFFECFDF5) : AppColors.borderLight,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isAvailable ? const Color(0xFFD1FAE5) : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isAvailable ? AppColors.primary : AppColors.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isAvailable ? 'متاح للعمل' : 'غير متاح',
                          style: TextStyle(
                            color: isAvailable ? AppColors.primary : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isAvailable ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                          color: isAvailable ? AppColors.primary : AppColors.textMuted,
                          size: 26,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CourierActiveMapCard(isAvailable: isAvailable),
            const SizedBox(height: 24),
            Text(
              isAvailable
                  ? 'طلبات قريبة منك (${availableOrders.length})'
                  : 'فعّل حالة التوفر لرؤية الطلبات',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            if (!isAvailable)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 40, color: AppColors.textMuted),
                    SizedBox(height: 8),
                    Text('أنت في وضع الراحة حالياً', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  ],
                ),
              )
            else if (availableOrders.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 40, color: AppColors.textMuted),
                    SizedBox(height: 8),
                    Text('لا توجد طلبات جديدة حالياً، اسحب للتحديث', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              )
            else
              ...availableOrders.map((order) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: NearbyOrderCard(
                      orderNumber: order.shortOrderNumber,
                      profitText: 'ربحك: ${order.deliveryFee.toStringAsFixed(2)} ₪',
                      routeTitle: order.description,
                      distanceText: 'يبعد 1.5 كم',
                      itemsCountText: '${order.items.length} أغراض',
                      isHighProfit: order.deliveryFee >= 10,
                      onDetailsTap: () => widget.onOrderDetailsTap(order),
                    ),
                  )),
          ],
        );
      },
    );
  }
}
