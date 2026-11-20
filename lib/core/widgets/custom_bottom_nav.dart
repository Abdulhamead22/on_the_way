import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'label': 'الرئيسية', 'icon': Icons.home_rounded},
      {'label': 'طلباتي', 'icon': Icons.receipt_long_rounded},
      {'label': 'المحادثات', 'icon': Icons.chat_bubble_outline_rounded},
      {'label': 'المحفظة', 'icon': Icons.account_balance_wallet_outlined},
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;
          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الخط العلوي الصغير فوق العنصر النشط (نفس تصميم Figma)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 24 : 0,
                    height: 3,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Icon(
                    items[index]['icon'] as IconData,
                    size: 24,
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[index]['label'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? AppColors.primary : AppColors.textMuted,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

