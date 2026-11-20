import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CourierRouteMapSection extends StatelessWidget {
  final String distanceText;
  final String pickupName;
  final String dropoffName;

  const CourierRouteMapSection({
    super.key,
    required this.distanceText,
    required this.pickupName,
    required this.dropoffName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
      ),
      child: Stack(
        children: [
          // خلفية تمثيلية للخريطة
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  const Color(0xFFCCFBF1).withOpacity(0.5),
                  const Color(0xFFF1F5F9),
                  const Color(0xFFFEF3C7).withOpacity(0.45),
                ],
              ),
            ),
          ),
          // شارة المسافة الإجمالية في الأعلى
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.route_rounded, size: 15, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      distanceText,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // نقطة الاستلام
          Positioned(
            top: 75,
            right: 35,
            child: _LocationMarkerCard(
              title: 'نقطة الاستلام',
              subtitle: pickupName,
              color: AppColors.primary,
              icon: Icons.storefront_rounded,
            ),
          ),
          // نقطة التسليم
          Positioned(
            bottom: 45,
            left: 35,
            child: _LocationMarkerCard(
              title: 'نقطة التسليم',
              subtitle: dropoffName,
              color: AppColors.accent,
              icon: Icons.location_on_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationMarkerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _LocationMarkerCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6)],
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
