import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class WalletBalanceCard extends StatelessWidget {
  final double balance;
  final VoidCallback onTopUpTap;
  final VoidCallback onWithdrawTap;

  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.onTopUpTap,
    required this.onWithdrawTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0F766E), Color(0xFF0D5F59)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الرصيد المتاح',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${balance.toStringAsFixed(2)} ₪',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onTopUpTap,
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18, color: AppColors.textPrimary),
                  label: const Text(
                    'شحن الرصيد',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    minimumSize: const Size(0, 46),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onWithdrawTap,
                  icon: const Icon(Icons.arrow_upward_rounded, size: 18, color: Colors.white),
                  label: const Text(
                    'سحب الأرباح',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.15),
                    minimumSize: const Size(0, 46),
                    side: BorderSide(color: Colors.white.withOpacity(0.3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
