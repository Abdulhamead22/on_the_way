import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/biometric_security_card.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/wallet_transactions_list.dart';

class WalletScreen extends StatefulWidget {
  final double initialBalance;
  const WalletScreen({super.key, this.initialBalance = 50.00});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _biometricEnabled = true;

  final List<WalletTransactionItem> _transactions = const [
    WalletTransactionItem(
      title: 'أرباح توصيل طلب #4819',
      date: 'اليوم، 10:45 ص',
      amountText: '+12.00 ₪',
      isPositive: true,
      icon: Icons.arrow_downward_rounded,
    ),
    WalletTransactionItem(
      title: 'دفع طلب سوبرماركت الدرة',
      date: 'أمس، 08:20 م',
      amountText: '-45.00 ₪',
      isPositive: false,
      icon: Icons.shopping_bag_outlined,
    ),
    WalletTransactionItem(
      title: 'شحن رصيد المحفظة',
      date: '12 نوفمبر، 03:15 م',
      amountText: '+50.00 ₪',
      isPositive: true,
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الشريط العلوي
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.borderLight)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المحفظة والأمان',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFD1FAE5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'متصل ومزامن',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // محتوى المحفظة
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WalletBalanceCard(
                  balance: widget.initialBalance > 0 ? widget.initialBalance : 50.00,
                  onTopUpTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('سيتم فتح نافذة شحن الرصيد')),
                    );
                  },
                  onWithdrawTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('سيتم فتح نافذة سحب الأرباح')),
                    );
                  },
                ),
                const SizedBox(height: 16),
                BiometricSecurityCard(
                  isEnabled: _biometricEnabled,
                  onChanged: (val) {
                    setState(() => _biometricEnabled = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(val ? 'تم تفعيل حماية البصمة 🔐' : 'تم إيقاف حماية البصمة'),
                        backgroundColor: val ? AppColors.primary : AppColors.textSecondary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'سجل العمليات الأخيرة',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                WalletTransactionsList(transactions: _transactions),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
