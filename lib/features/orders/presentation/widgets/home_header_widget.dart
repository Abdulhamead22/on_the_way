import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/domain/entities/user_entity.dart';

class HomeHeaderWidget extends StatelessWidget {
  final UserEntity user;
  final bool isCourierMode;
  final ValueChanged<bool> onModeChanged;
  final VoidCallback onProfileTap;

  const HomeHeaderWidget({
    super.key,
    required this.user,
    required this.isCourierMode,
    required this.onModeChanged,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // معلومات المستخدم والصورة
              GestureDetector(
                onTap: onProfileTap,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary.withOpacity(0.12),
                      child: Text(
                        user.fullName.isNotEmpty ? user.fullName[0] : 'أ',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'أهلاً، ${user.fullName.split(' ').first}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          isCourierMode ? 'مستعد لاستقبال الطلبات؟' : 'ماذا تحتاج اليوم؟',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // شارة رصيد المحفظة
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded, size: 16, color: Color(0xFFD97706)),
                    const SizedBox(width: 6),
                    Text(
                      '${user.walletBalance.toStringAsFixed(2)} ₪',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // مبدّل الوضع (وضع العميل / وضع المندوب)
          Container(
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _ModeTab(
                    title: 'وضع العميل',
                    isSelected: !isCourierMode,
                    onTap: () => onModeChanged(false),
                  ),
                ),
                Expanded(
                  child: _ModeTab(
                    title: 'وضع المندوب',
                    isSelected: isCourierMode,
                    onTap: () => onModeChanged(true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeTab({
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
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
