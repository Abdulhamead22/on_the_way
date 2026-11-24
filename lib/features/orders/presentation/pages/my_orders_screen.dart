import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../tracking/presentation/pages/live_tracking_screen.dart';
import '../../domain/entities/order_entity.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../widgets/order_history_card.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool showCurrentOrders = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final allOrders = state is OrdersLoaded ? state.customerOrders : <OrderEntity>[];
        final currentOrders = allOrders.where((o) => o.status != 'delivered').toList();
        final pastOrders = allOrders.where((o) => o.status == 'delivered').toList();
        final displayedOrders = showCurrentOrders ? currentOrders : pastOrders;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'طلباتي',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.borderLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.filter_list_rounded, color: AppColors.textPrimary, size: 20),
                  ),
                ],
              ),
            ),

            // التبويب الدائري بالأعداد الحقيقية من Supabase
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _TabPill(
                        title: 'الطلبات الحالية (${currentOrders.length})',
                        isSelected: showCurrentOrders,
                        onTap: () => setState(() => showCurrentOrders = true),
                      ),
                    ),
                    Expanded(
                      child: _TabPill(
                        title: 'الطلبات السابقة (${pastOrders.length})',
                        isSelected: !showCurrentOrders,
                        onTap: () => setState(() => showCurrentOrders = false),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // قائمة الطلبات
            Expanded(
              child: displayedOrders.isEmpty
                  ? Center(
                      child: Text(
                        showCurrentOrders ? 'لا توجد طلبات حالية' : 'لا توجد طلبات سابقة مكتملة',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      itemCount: displayedOrders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final order = displayedOrders[index];
                        final total = (order.estimatedPrice + order.deliveryFee).toStringAsFixed(2);
                        return OrderHistoryCard(
                          orderNumber: order.shortOrderNumber,
                          dateText: '${order.items.length} أغراض',
                          title: order.description,
                          statusText: order.statusArabic,
                          isActive: showCurrentOrders,
                          courierName: order.courierId != null ? 'مندوب معيّن' : 'بانتظار قبول مندوب',
                          totalAmount: '$total ₪',
                          onActionTap: () {
                            if (showCurrentOrders) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LiveTrackingScreen(orderNumber: order.shortOrderNumber),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _TabPill extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabPill({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
