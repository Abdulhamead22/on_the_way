import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ChatThreadCard extends StatelessWidget {
  final String name;
  final String orderNumber;
  final String lastMessage;
  final String timeText;
  final int unreadCount;
  final bool isOnline;
  final VoidCallback onTap;

  const ChatThreadCard({
    super.key,
    required this.name,
    required this.orderNumber,
    required this.lastMessage,
    required this.timeText,
    this.unreadCount = 0,
    this.isOnline = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = unreadCount > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // شريط أخضر جانبي للرسائل غير المقروءة
                if (hasUnread)
                  Container(
                    width: 4,
                    color: AppColors.primary,
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // صورة الشخص مع نقطة الاتصال
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: hasUnread
                                  ? AppColors.primary.withOpacity(0.12)
                                  : AppColors.borderLight,
                              child: Icon(
                                Icons.person_rounded,
                                color: hasUnread ? AppColors.primary : AppColors.textSecondary,
                                size: 26,
                              ),
                            ),
                            if (isOnline)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),

                        // الاسم، رقم الطلب، وآخر رسالة
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    timeText,
                                    style: TextStyle(
                                      color: hasUnread ? AppColors.primary : AppColors.textMuted,
                                      fontSize: 11,
                                      fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: hasUnread ? const Color(0xFFF1FCF9) : AppColors.borderLight,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  orderNumber,
                                  style: TextStyle(
                                    color: hasUnread ? AppColors.primary : AppColors.textSecondary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: hasUnread ? const Color(0xFF334155) : AppColors.textSecondary,
                                        fontSize: 13,
                                        fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  if (hasUnread) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '$unreadCount',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
