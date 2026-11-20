import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../tracking/presentation/pages/live_tracking_screen.dart';
import '../widgets/chat_thread_card.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

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
                'المحادثات',
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
                child: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),

        // قائمة المحادثات
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            children: [
              ChatThreadCard(
                name: 'محمد الخطيب',
                orderNumber: 'طلب #4821',
                lastMessage: 'تم شراء جميع الأغراض، وهذه صورة الفاتورة',
                timeText: '10:42 ص',
                unreadCount: 2,
                isOnline: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const LiveTrackingScreen(orderNumber: '#4821'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              ChatThreadCard(
                name: 'سارة محمود',
                orderNumber: 'طلب #4818',
                lastMessage: 'شكراً جزيلاً على سرعة التوصيل!',
                timeText: 'أمس',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const LiveTrackingScreen(orderNumber: '#4818'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              ChatThreadCard(
                name: 'خالد عمر',
                orderNumber: 'طلب #4815',
                lastMessage: 'وصلت عند باب العمارة',
                timeText: '12 نوفمبر',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const LiveTrackingScreen(orderNumber: '#4815'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
