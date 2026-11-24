import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../tracking/presentation/pages/live_tracking_screen.dart';
import '../../../wallet/presentation/widgets/ocr_receipt_scanner_sheet.dart';
import '../../domain/entities/order_entity.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../widgets/courier_order_info_card.dart';
import '../widgets/courier_route_map_section.dart';

class CourierOrderDetailsScreen extends StatefulWidget {
  final OrderEntity order;
  const CourierOrderDetailsScreen({super.key, required this.order});

  @override
  State<CourierOrderDetailsScreen> createState() => _CourierOrderDetailsScreenState();
}

class _CourierOrderDetailsScreenState extends State<CourierOrderDetailsScreen> {
  late bool isAccepted;

  @override
  void initState() {
    super.initState();
    isAccepted = widget.order.status != 'pending';
  }

  void _acceptOrder() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<OrdersCubit>().acceptOrderByCourier(
            orderId: widget.order.id,
            courierId: authState.user.id,
          );
    }
  }

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
    final formattedItems = widget.order.items
        .map((e) => '${e.name} (${e.quantity}) - ${e.price.toStringAsFixed(1)} ₪')
        .toList();

    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is OrderActionSuccess) {
          setState(() => isAccepted = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.primary),
          );
        } else if (state is OrdersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'تفاصيل الطلب ${widget.order.shortOrderNumber}',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w800),
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
child: Center(
child: Text(
'ربحك: ${widget.order.deliveryFee.toStringAsFixed(2)} ₪',
style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700),
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
CourierRouteMapSection(
distanceText: 'إجمالي المسافة: 4.2 كم',
pickupName: widget.order.description,
dropoffName: 'موقع العميل',
),
Padding(
padding: const EdgeInsets.only(top: 215),
child: CourierOrderInfoCard(
customerName: 'عميل التطبيق',
rating: '4.9',
shoppingItems: formattedItems,
estimatedBudget: '${widget.order.estimatedPrice.toStringAsFixed(2)} ₪',
isAccepted: isAccepted,
onChatTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => LiveTrackingScreen(orderNumber: widget.order.shortOrderNumber),
),
);
},
onCallTap: () {},
),
),
],
),
),
),
Container(
padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
decoration: BoxDecoration(
color: AppColors.surface,
border: const Border(top: BorderSide(color: AppColors.borderLight)),
boxShadow: [
BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -4)),
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
style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w700),
),
),
const SizedBox(width: 12),
Expanded(
child: ElevatedButton(
onPressed: _acceptOrder,
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primary,
minimumSize: const Size(double.infinity, 52),
elevation: 0,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
),
child: const Text(
'قبول الطلب والبدء',
style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
),
),
),
],
),
),
],
),
),
);
}
}
