import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class OrderRouteMapPreview extends StatelessWidget {
  final String distanceText;
  final VoidCallback onPickupTap;
  final VoidCallback onDropoffTap;

  const OrderRouteMapPreview({
    super.key,
    required this.distanceText,
    required this.onPickupTap,
    required this.onDropoffTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // خلفية تمثيلية للخريطة (سنستبدلها بـ FlutterMap الحي في مرحلة الخرائط)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  const Color(0xFFCCFBF1).withOpacity(0.5),
                  const Color(0xFFF1F5F9),
                  const Color(0xFFFEF3C7).withOpacity(0.4),
                ],
              ),
            ),
          ),
          // دبوس نقطة الاستلام
          Positioned(
            top: 32,
            right: 40,
            child: GestureDetector(
              onTap: onPickupTap,
              child: _MapPinBadge(
                label: 'نقطة الاستلام',
                color: AppColors.primary,
              ),
            ),
          ),
          // دبوس نقطة التسليم
          Positioned(
            bottom: 32,
            left: 40,
            child: GestureDetector(
              onTap: onDropoffTap,
              child: _MapPinBadge(
                label: 'نقطة التسليم',
                color: AppColors.accent,
              ),
            ),
          ),
          // شارة المسافة في المنتصف
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.route_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    distanceText,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
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

class _MapPinBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _MapPinBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
          ),
        ),
      ],
    );
  }
}
