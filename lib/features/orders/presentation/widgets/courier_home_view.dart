import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'courier_active_map_card.dart';
import 'nearby_order_card.dart';

class CourierHomeView extends StatefulWidget {
  final VoidCallback onOrderDetailsTap;
  const CourierHomeView({super.key, required this.onOrderDetailsTap});

  @override
  State<CourierHomeView> createState() => _CourierHomeViewState();
}

class _CourierHomeViewState extends State<CourierHomeView> {
  bool isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // شريط حالة التوفر (متاح / غير متاح)
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

        // خريطة المناطق النشطة
        CourierActiveMapCard(isAvailable: isAvailable),
        const SizedBox(height: 24),

        // عنوان قائمة الطلبات القريبة
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isAvailable ? 'طلبات قريبة منك (3)' : 'فعّل حالة التوفر لرؤية الطلبات',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (isAvailable)
              TextButton(
                onPressed: () {},
                child: const Text(
                  'مشاهدة الكل',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // بطاقات الطلبات القريبة
        if (isAvailable) ...[
          NearbyOrderCard(
            orderNumber: '#4825',
            profitText: 'ربحك: 15.00 ₪',
            routeTitle: 'سوبرماركت النور ← حي الرمال',
            distanceText: 'يبعد 1.2 كم',
            itemsCountText: '4 أغراض',
            isHighProfit: true,
            onDetailsTap: widget.onOrderDetailsTap,
          ),
          const SizedBox(height: 16),
          NearbyOrderCard(
            orderNumber: '#4826',
            profitText: 'ربحك: 10.00 ₪',
            routeTitle: 'صيدلية الشفاء ← شارع الوحدة',
            distanceText: 'يبعد 2.0 كم',
            itemsCountText: '2 أغراض',
            isHighProfit: false,
            onDetailsTap: widget.onOrderDetailsTap,
          ),
        ] else
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
                Text(
                  'أنت في وضع الراحة حالياً',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
