import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LiveTrackingMapSection extends StatelessWidget {
  final String etaText;
  const LiveTrackingMapSection({super.key, required this.etaText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E7EB),
      ),
      child: Stack(
        children: [
          // خلفية تمثيلية لشوارع الخريطة
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFDCFCE7).withOpacity(0.6),
                  const Color(0xFFF1F5F9),
                  const Color(0xFFE2E8F0),
                ],
              ),
            ),
          ),
          // شارة الوقت المتبقي في أعلى المنتصف
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
                    const Icon(Icons.access_time_filled_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      etaText,
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
          ),
          // أيقونة دراجة المندوب
          Positioned(
            top: 82,
            left: 110,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(Icons.directions_bike_rounded, color: AppColors.primary, size: 22),
            ),
          ),
          // دبوس وجهة التسليم
          Positioned(
            top: 55,
            right: 65,
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8),
                    ],
                  ),
                  child: const Icon(Icons.home_rounded, color: Colors.white, size: 18),
                ),
                Container(width: 3, height: 8, color: AppColors.accent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
