import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CourierActiveMapCard extends StatelessWidget {
  final bool isAvailable;
  const CourierActiveMapCard({super.key, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // خلفية تمثيلية للخريطة
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  const Color(0xFFCCFBF1).withOpacity(0.45),
                  const Color(0xFFF1F5F9),
                  const Color(0xFFFEF3C7).withOpacity(0.35),
                ],
              ),
            ),
          ),
          // نقاط الطلبات القريبة (برتقالية)
          if (isAvailable) ...[
            const Positioned(top: 55, left: 65, child: _OrderDotMarker()),
            const Positioned(bottom: 45, right: 75, child: _OrderDotMarker()),
            const Positioned(bottom: 65, left: 100, child: _OrderDotMarker()),
          ],
          // موقع المندوب في المنتصف
          Center(
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: (isAvailable ? AppColors.primary : AppColors.textMuted).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isAvailable ? AppColors.primary : AppColors.textMuted,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8),
                    ],
                  ),
                  child: const Icon(Icons.directions_bike_rounded, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
          // شارة الحالة في الأعلى
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isAvailable ? Icons.local_fire_department_rounded : Icons.pause_circle_filled_rounded,
                    size: 16,
                    color: isAvailable ? AppColors.primary : AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isAvailable ? 'أنت في منطقة نشطة' : 'أنت غير متاح حالياً',
                    style: TextStyle(
                      color: isAvailable ? AppColors.primary : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderDotMarker extends StatelessWidget {
  const _OrderDotMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 6),
        ],
      ),
      child: const Icon(Icons.shopping_bag_rounded, size: 11, color: Colors.white),
    );
  }
}
