import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class ActiveOrderCard extends StatelessWidget {
  final String orderNumber;
  final String title;
  final String subtitle;
  final String statusText;
  final int currentStep; // 0: تم التأكيد, 1: تم الاستلام, 2: قيد التوصيل, 3: تم التسليم
  final String courierName;
  final String courierRating;
  final String courierVehicle;
  final String etaText;
  final VoidCallback onTrackTap;
  final VoidCallback onChatTap;
  final VoidCallback onCallTap;

  const ActiveOrderCard({
    super.key,
    required this.orderNumber,
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.currentStep,
    required this.courierName,
    required this.courierRating,
    required this.courierVehicle,
    required this.etaText,
    required this.onTrackTap,
    required this.onChatTap,
    required this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0).withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // الصف العلوي: رقم الطلب وشارة الحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderNumber,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // عنوان الطلب وتفاصيله
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          // شريط تقدم الطلب (4 مراحل)
          _OrderProgressStepper(currentStep: currentStep),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: 16),

          // معلومات المندوب وأزرار التواصل
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.borderLight,
                child: const Icon(Icons.person_rounded, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courierName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '★ $courierRating',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(' · ', style: TextStyle(color: AppColors.textSecondary)),
                        Text(
                          courierVehicle,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _CircleActionBtn(icon: Icons.chat_bubble_rounded, onTap: onChatTap),
              const SizedBox(width: 8),
              _CircleActionBtn(icon: Icons.phone_rounded, onTap: onCallTap),
            ],
          ),
          const SizedBox(height: 14),

          // الوقت المتوقع للوصول
          Text(
            etaText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // زر تتبع مباشر
          ElevatedButton.icon(
            onPressed: onTrackTap,
            icon: const Icon(Icons.location_on_rounded, color: Colors.white, size: 18),
            label: const Text(
              'تتبع مباشر',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 46),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderProgressStepper extends StatelessWidget {
  final int currentStep;
  const _OrderProgressStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['تم التأكيد', 'تم الاستلام', 'قيد التوصيل', 'تم التسليم'];

    return Row(
      children: List.generate(steps.length, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == 0
                          ? Colors.transparent
                          : (index <= currentStep ? AppColors.primary : const Color(0xFFE2E8F0)),
                    ),
                  ),
                  Container(
                    width: isCurrent ? 16 : 12,
                    height: isCurrent ? 16 : 12,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? Colors.white
                          : (isCompleted ? AppColors.primary : const Color(0xFFE2E8F0)),
                      shape: BoxShape.circle,
                      border: isCurrent
                          ? Border.all(color: AppColors.primary, width: 2.5)
                          : null,
                    ),
                    child: isCurrent
                        ? Center(
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == steps.length - 1
                          ? Colors.transparent
                          : (index < currentStep ? AppColors.primary : const Color(0xFFE2E8F0)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                steps[index],
                style: TextStyle(
                  fontSize: 10,
                  color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _CircleActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
width: 40,
height: 40,
decoration: const BoxDecoration(
color: Color(0xFFCCFBF1),
shape: BoxShape.circle,
),
child: Icon(icon, color: AppColors.primary, size: 18),
),
);
}
}
