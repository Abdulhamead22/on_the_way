import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../tracking/presentation/pages/live_tracking_screen.dart';
import '../../../wallet/presentation/widgets/ocr_receipt_scanner_sheet.dart';
import '../widgets/courier_order_info_card.dart';
import '../widgets/courier_route_map_section.dart';

class CourierOrderDetailsScreen extends StatefulWidget {
  final String orderNumber;
  const CourierOrderDetailsScreen({super.key, this.orderNumber = '#4825'});

  @override
  State<CourierOrderDetailsScreen> createState() => _CourierOrderDetailsScreenState();
}

class _CourierOrderDetailsScreenState extends State<CourierOrderDetailsScreen> {
  bool isAccepted = false;

  void _openOcrScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OcrReceiptScannerSheet(
        onConfirmAmount: (amount) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم تأكيد الفاتورة بقيمة ${amount.toStringAsFixed(2)} ₪ وإرسالها للعميل ✅'),
              backgroundColor: AppColors.primary,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
onPressed: () => Navigator.pop(context),
),
title: Text(
'تفاصيل الطلب ${widget.orderNumber}',
style: const TextStyle(
color: AppColors.textPrimary,
fontSize: 17,
fontWeight: FontWeight.w800,
),
),
actions: [
Container(
margin: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
decoration: BoxDecoration(
color: const Color(0xFFF1FCF9),
borderRadius: BorderRadius.circular(999),
border: Border.all(color: const Color(0xFFE2F7F1)),
),
child: const Center(
child: Text(
'ربحك الصافي: 15.00 ₪',
style: TextStyle(
color: AppColors.primary,
fontSize: 12,
fontWeight: FontWeight.w700,
),
),
),
),
],
),
body: Column(
children: [
Expanded(
child: SingleChildScrollView(
padding: const EdgeInsets.only(bottom: 24),
child: Stack(
children: [
const CourierRouteMapSection(
distanceText: 'إجمالي المسافة: 4.2 كم',
pickupName: 'سوبرماركت النور',
dropoffName: 'حي الرمال',
),
Padding(
padding: const EdgeInsets.only(top: 215),
child: CourierOrderInfoCard(
customerName: 'سارة محمود',
rating: '4.8',
shoppingItems: const [
'حليب طازج 2 لتر',
'خبز أبيض',
'جبنة بيضاء 500 جم',
],
estimatedBudget: '30.00 ₪',
isAccepted: isAccepted,
onChatTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => LiveTrackingScreen(orderNumber: widget.orderNumber),
),
);
},
onCallTap: () {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('جاري الاتصال بالعميلة سارة محمود...')),
);
},
),
),
],
),
),
),
// الشريط السفلي للأزرار
Container(
padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
decoration: BoxDecoration(
color: AppColors.surface,
border: const Border(top: BorderSide(color: AppColors.borderLight)),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.05),
blurRadius: 20,
offset: const Offset(0, -4),
),
],
),
child: isAccepted
? ElevatedButton.icon(
onPressed: _openOcrScanner,
icon: const Icon(Icons.document_scanner_rounded, color: Colors.white),
label: const Text(
'تصوير الفاتورة (OCR)',
style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
),
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.accent,
minimumSize: const Size(double.infinity, 52),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
),
)
: Row(
children: [
OutlinedButton(
onPressed: () => Navigator.pop(context),
style: OutlinedButton.styleFrom(
minimumSize: const Size(100, 52),
side: const BorderSide(color: Color(0xFFE2E8F0)),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
),
child: const Text(
'تجاهل',
style: TextStyle(
color: AppColors.textSecondary,
fontSize: 15,
fontWeight: FontWeight.w700,
),
),
),
const SizedBox(width: 12),
Expanded(
child: ElevatedButton(
onPressed: () {
setState(() => isAccepted = true);
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('تم قبول الطلب! يمكنك الآن تحديد الأغراض عند شرائها'),
backgroundColor: AppColors.primary,
),
);
},
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primary,
minimumSize: const Size(double.infinity, 52),
elevation: 0,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
),
child: const Text(
'قبول الطلب والبدء',
style: TextStyle(
color: Colors.white,
fontSize: 16,
fontWeight: FontWeight.w700,
),
),
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
