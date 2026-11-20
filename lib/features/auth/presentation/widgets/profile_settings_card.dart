import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProfileSettingsCard extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final VoidCallback onChangePasswordTap;
  final VoidCallback onLogoutTap;

  const ProfileSettingsCard({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
    required this.onChangePasswordTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            onTap: onChangePasswordTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.lock_outline_rounded, color: AppColors.textPrimary, size: 20),
            ),
            title: const Text(
              'تغيير كلمة المرور',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textMuted),
          ),
          const Divider(color: AppColors.borderLight, height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.dark_mode_outlined, color: AppColors.textPrimary, size: 20),
            ),
            title: const Text(
              'الوضع الليلي',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            trailing: Switch(
              value: isDarkMode,
              activeColor: AppColors.primary,
              onChanged: onDarkModeChanged,
            ),
          ),
          const Divider(color: AppColors.borderLight, height: 1),
          InkWell(
            onTap: onLogoutTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: const Color(0xFFFEF2F2).withOpacity(0.6),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 20),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 15,
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
