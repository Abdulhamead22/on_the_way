import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AiOrderItem {
  String name;
  int count;
  String unit;
  double unitPrice;
  bool isSelected;

  AiOrderItem({
    required this.name,
    required String quantity,
    required double price,
    this.isSelected = true,
  })  : count = _extractCount(quantity),
        unit = _extractUnit(quantity),
        unitPrice = price / _extractCount(quantity);

  double get totalPrice => unitPrice * count;
  String get formattedQuantity => '$count $unit'.trim();

  static int _extractCount(String q) {
    final match = RegExp(r'\d+').firstMatch(q);
    final val = match != null ? int.tryParse(match.group(0)!) ?? 1 : 1;
    return val > 0 ? val : 1;
  }

  static String _extractUnit(String q) {
    final cleaned = q.replaceAll(RegExp(r'\d+'), '').trim();
    return cleaned.isEmpty ? 'قطعة' : cleaned;
  }
}

class AiSuggestedItemsCard extends StatelessWidget {
  final List<AiOrderItem> items;
  final ValueChanged<int> onToggleItem;
  final VoidCallback onQuantityChanged;
  final VoidCallback onAddItemTap;

  const AiSuggestedItemsCard({
    super.key,
    required this.items,
    required this.onToggleItem,
    required this.onQuantityChanged,
    required this.onAddItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'قائمة الأغراض',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFD1FAE5)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 12, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'قابلة للتعديل',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'القائمة فارغة، اضغط على "إضافة غرض" بالأسفل لإضافة مشترياتك',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.borderLight, height: 24),
              itemBuilder: (context, index) {
                final item = items[index];
                return Row(
                  children: [
                    InkWell(
                      onTap: () => onToggleItem(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: item.isSelected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: item.isSelected ? AppColors.primary : const Color(0xFFCBD5E1),
                            width: 1.5,
                          ),
                        ),
                        child: item.isSelected
                            ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              color: item.isSelected ? AppColors.textPrimary : AppColors.textMuted,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: item.isSelected ? null : TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // أزرار التحكم بالكمية (- العدد +)
                          Row(
                            children: [
                              _QtyButton(
                                icon: Icons.remove_rounded,
                                onTap: item.isSelected && item.count > 1
                                    ? () {
                                        item.count--;
                                        onQuantityChanged();
                                      }
                                    : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  item.formattedQuantity,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              _QtyButton(
                                icon: Icons.add_rounded,
                                onTap: item.isSelected
                                    ? () {
                                        item.count++;
                                        onQuantityChanged();
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${item.totalPrice.toStringAsFixed(2)} ₪',
                      style: TextStyle(
                        color: item.isSelected ? AppColors.primary : AppColors.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );
              },
            ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onAddItemTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD1FAE5)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'إضافة غرض آخر',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: enabled ? AppColors.background : AppColors.borderLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Icon(
          icon,
          size: 14,
          color: enabled ? AppColors.primary : AppColors.textMuted,
        ),
      ),
    );
  }
}
