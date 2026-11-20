import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class WalletTransactionItem {
  final String title;
  final String date;
  final String amountText;
  final bool isPositive;
  final IconData icon;

  const WalletTransactionItem({
    required this.title,
    required this.date,
    required this.amountText,
    required this.isPositive,
    required this.icon,
  });
}

class WalletTransactionsList extends StatelessWidget {
  final List<WalletTransactionItem> transactions;
  const WalletTransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (_, __) => const Divider(color: AppColors.borderLight, height: 1),
        itemBuilder: (context, index) {
          final item = transactions[index];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.isPositive ? const Color(0xFFECFDF5) : AppColors.borderLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    size: 18,
                    color: item.isPositive ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.date,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.amountText,
                  style: TextStyle(
                    color: item.isPositive ? const Color(0xFF22C55E) : const Color(0xFF334155),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
