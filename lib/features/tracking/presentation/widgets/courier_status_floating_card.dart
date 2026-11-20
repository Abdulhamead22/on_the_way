import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CourierStatusFloatingCard extends StatelessWidget {
  final String courierName;
  final String rating;
  final int
  currentStep; // 0: تم القبول, 1: تم الشراء, 2: في الطريق, 3: تم التسليم
  final VoidCallback onCallTap;

  const CourierStatusFloatingCard({
    super.key,
    required this.courierName,
    required this.rating,
    required this.currentStep,
    required this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // صورة المندوب مع نقطة الاتصال الخضراء
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
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
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.accent,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating,
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
              InkWell(
                onTap: onCallTap,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD1FAE5)),
                  ),
                  child: const Icon(
                    Icons.phone_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _TrackingStepper(currentStep: currentStep),
        ],
      ),
    );
  }
}

class _TrackingStepper extends StatelessWidget {
  final int currentStep;
  const _TrackingStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['تم القبول', 'تم الشراء', 'في الطريق', 'تم التسليم'];

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
                          : (index <= currentStep
                                ? AppColors.primary
                                : AppColors.borderLight),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? Colors.white
                          : (isCompleted
                                ? AppColors.primary
                                : AppColors.borderLight),
                      shape: BoxShape.circle,
                      border: isCurrent
                          ? Border.all(color: AppColors.primary, width: 3)
                          : null,
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 12,
                            color: Colors.white,
                          )
                        : (isCurrent
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
                              : null),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == steps.length - 1
                          ? Colors.transparent
                          : (index < currentStep
                                ? AppColors.primary
                                : AppColors.borderLight),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                steps[index],
                style: TextStyle(
                  fontSize: 11,
                  color: isCurrent
                      ? AppColors.primary
                      : AppColors.textSecondary,
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
