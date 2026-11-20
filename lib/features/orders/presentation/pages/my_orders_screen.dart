import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../tracking/presentation/pages/live_tracking_screen.dart';
import '../widgets/order_history_card.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool showCurrentOrders = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الهيدر العلوي
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'طلباتي',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.borderLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.filter_list_rounded, color: AppColors.textPrimary, size: 20),
              ),
            ],
          ),
        ),

        // التبويب الدائري للتبديل بين الحالية والسابقة
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TabPill(
                    title: 'الطلبات الحالية (1)',
                    isSelected: showCurrentOrders,
                    onTap: () => setState(() => showCurrentOrders = true),
                  ),
                ),
                Expanded(
                  child: _TabPill(
                    title: 'الطلبات السابقة (12)',
                    isSelected: !showCurrentOrders,
                    onTap: () => setState(() => showCurrentOrders = false),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // قائمة الطلبات
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            children: showCurrentOrders
                ? [
                    OrderHistoryCard(
                      orderNumber: '#4821',
                      dateText: 'اليوم، 06:15 م',
                      title: 'طلب من سوبرماركت الدرة',
                      statusText: 'قيد التوصيل',
                      isActive: true,
                      courierName: 'محمد الخطيب',
                      totalAmount: '45.00 ₪',
                      onActionTap: () {
                        Navigator.push(
                          context,
MaterialPageRoute(builder: (_) => const LiveTrackingScreen()),
);
},
),
]
: [
OrderHistoryCard(
orderNumber: '#4818',
dateText: 'أمس، 04:30 م',
title: 'توصيل مستندات - وسط البلد',
statusText: 'تم التسليم',
isActive: false,
totalAmount: '15.00 ₪',
onActionTap: () {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('جاري تجهيز إعادة الطلب...')),
);
},
),
const SizedBox(height: 16),
OrderHistoryCard(
orderNumber: '#4810',
dateText: '18 نوفمبر، 01:20 م',
title: 'وجبة غداء ومشروبات - حي الرمال',
statusText: 'تم التسليم',
isActive: false,
totalAmount: '62.00 ₪',
onActionTap: () {},
),
],
),
),
],
);
}
}
class _TabPill extends StatelessWidget {
final String title;
final bool isSelected;
final VoidCallback onTap;
const _TabPill({
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
padding: const EdgeInsets.symmetric(vertical: 11),
decoration: BoxDecoration(
color: isSelected ? AppColors.primary : Colors.transparent,
borderRadius: BorderRadius.circular(999),
),
child: Text(
title,
textAlign: TextAlign.center,
style: TextStyle(
color: isSelected ? Colors.white : AppColors.textSecondary,
fontSize: 13,
fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
),
),
),
);
}
}
