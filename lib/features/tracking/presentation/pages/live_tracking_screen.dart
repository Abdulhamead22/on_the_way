import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/courier_status_floating_card.dart';
import '../widgets/live_tracking_map_section.dart';
import '../widgets/order_chat_section.dart';

class LiveTrackingScreen extends StatefulWidget {
  final String orderNumber;
  const LiveTrackingScreen({super.key, this.orderNumber = '#4821'});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final _msgController = TextEditingController();
  final List<ChatMessageModel> _messages = [
    ChatMessageModel(
      text: 'تم شراء جميع الأغراض، وهذه صورة الفاتورة',
      time: '10:42 ص',
      isMe: false,
      hasReceiptPreview: true,
    ),
    ChatMessageModel(
      text: 'يعطيك العافية، بانتظارك!',
      time: '10:43 ص',
      isMe: true,
    ),
  ];

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessageModel(
          text: text,
          time: 'الآن',
          isMe: true,
        ),
      );
      _msgController.clear();
    });
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
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
title: Row(
children: [
Text(
'تتبع الطلب ${widget.orderNumber}',
style: const TextStyle(
color: AppColors.textPrimary,
fontSize: 16,
fontWeight: FontWeight.w700,
),
),
const SizedBox(width: 8),
Container(
padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
decoration: BoxDecoration(
color: const Color(0xFFECFDF5),
borderRadius: BorderRadius.circular(999),
border: Border.all(color: const Color(0xFFD1FAE5)),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Container(
width: 7,
height: 7,
decoration: const BoxDecoration(
color: Color(0xFF22C55E),
shape: BoxShape.circle,
),
),
const SizedBox(width: 5),
const Text(
'في الطريق إليك',
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
body: Column(
children: [
// الخريطة العلوية + البطاقة العائمة المتداخلة
Stack(
clipBehavior: Clip.none,
children: [
const LiveTrackingMapSection(etaText: 'يصل خلال 8 دقائق'),
Padding(
padding: const EdgeInsets.only(top: 155),
child: CourierStatusFloatingCard(
courierName: 'محمد الخطيب',
rating: '4.9',
currentStep: 2,
onCallTap: () {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('جاري الاتصال بالمندوب محمد الخطيب...')),
);
},
),
),
],
),
const SizedBox(height: 8),
// منطقة الشات الفوري التفاعلي
Expanded(
child: OrderChatSection(
messages: _messages,
messageController: _msgController,
onSendMessage: _sendMessage,
),
),
],
),
);
}
}
