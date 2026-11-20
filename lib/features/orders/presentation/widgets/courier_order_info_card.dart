import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CourierOrderInfoCard extends StatefulWidget {
  final String customerName;
  final String rating;
  final List<String> shoppingItems;
  final String estimatedBudget;
  final bool isAccepted;
  final VoidCallback onChatTap;
  final VoidCallback onCallTap;

  const CourierOrderInfoCard({
    super.key,
    required this.customerName,
    required this.rating,
    required this.shoppingItems,
    required this.estimatedBudget,
    required this.isAccepted,
    required this.onChatTap,
    required this.onCallTap,
  });

  @override
  State<CourierOrderInfoCard> createState() => _CourierOrderInfoCardState();
}

class _CourierOrderInfoCardState extends State<CourierOrderInfoCard> {
  final Set<int> _checkedIndices = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // معلومات العميل وأزرار التواصل
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.customerName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.accent, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          widget.rating,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _ActionCircle(icon: Icons.chat_bubble_outline_rounded, onTap: widget.onChatTap),
              const SizedBox(width: 8),
              _ActionCircle(icon: Icons.phone_outlined, onTap: widget.onCallTap),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: 16),

          // قائمة المشتريات المطلوبة
          Text(
            'قائمة المشتريات المطلوبة (${widget.shoppingItems.length} أغراض)',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(widget.shoppingItems.length, (index) {
            final isChecked = _checkedIndices.contains(index);
            return InkWell(
              onTap: widget.isAccepted
                  ? () {
                      setState(() {
                        isChecked ? _checkedIndices.remove(index) : _checkedIndices.add(index);
                      });
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isChecked ? AppColors.primary : const Color(0xFFF1FCF9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isChecked ? AppColors.primary : const Color(0xFFD1FAE5),
                        ),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: isChecked ? Colors.white : AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
Expanded(
child: Text(
widget.shoppingItems[index],
style: TextStyle(
color: isChecked ? AppColors.textMuted : AppColors.textSecondary,
fontSize: 14,
decoration: isChecked ? TextDecoration.lineThrough : null,
),
),
),
],
),
),
);
}),
const SizedBox(height: 16),
// صندوق الميزانية التقديرية
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: AppColors.background,
borderRadius: BorderRadius.circular(12),
),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
'ميزانية الشراء التقديرية',
style: TextStyle(
color: AppColors.textSecondary,
fontSize: 12,
fontWeight: FontWeight.w500,
),
),
Text(
widget.estimatedBudget,
style: const TextStyle(
color: AppColors.textPrimary,
fontSize: 16,
fontWeight: FontWeight.w800,
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
class _ActionCircle extends StatelessWidget {
final IconData icon;
final VoidCallback onTap;
const _ActionCircle({required this.icon, required this.onTap});
@override
Widget build(BuildContext context) {
return InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(999),
child: Container(
width: 38,
height: 38,
decoration: const BoxDecoration(
color: Color(0xFFF1FCF9),
shape: BoxShape.circle,
),
child: Icon(icon, color: AppColors.primary, size: 18),
),
);
}
}
