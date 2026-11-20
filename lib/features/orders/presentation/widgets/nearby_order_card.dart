import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class NearbyOrderCard extends StatelessWidget {
  final String orderNumber;
  final String profitText;
  final String routeTitle;
  final String distanceText;
  final String itemsCountText;
  final bool isHighProfit;
  final VoidCallback onDetailsTap;

  const NearbyOrderCard({
    super.key,
    required this.orderNumber,
    required this.profitText,
    required this.routeTitle,
    required this.distanceText,
    required this.itemsCountText,
    this.isHighProfit = true,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // رقم الطلب وشارة الربح
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  orderNumber,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isHighProfit ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  profitText,
                  style: TextStyle(
                    color: isHighProfit ? AppColors.primary : AppColors.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // مسار التوصيل
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  routeTitle,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // المسافة وعدد الأغراض
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Row(
              children: [
                const Icon(Icons.near_me_outlined, size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  distanceText,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(width: 24),
                const Icon(Icons.shopping_bag_outlined, size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  itemsCountText,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // زر عرض التفاصيل
          ElevatedButton(
            onPressed: onDetailsTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 48),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'عرض التفاصيل',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
