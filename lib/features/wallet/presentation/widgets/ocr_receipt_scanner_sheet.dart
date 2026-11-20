import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class OcrReceiptScannerSheet extends StatefulWidget {
  final ValueChanged<double> onConfirmAmount;

  const OcrReceiptScannerSheet({
    super.key,
    required this.onConfirmAmount,
  });

  @override
  State<OcrReceiptScannerSheet> createState() => _OcrReceiptScannerSheetState();
}

class _OcrReceiptScannerSheetState extends State<OcrReceiptScannerSheet> {
  final double _extractedAmount = 45.00;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // مقبض السحب العلوي
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // العنوان وزر الإغلاق
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'مسح الفاتورة واستخراج المبلغ (OCR)',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // إطار الكاميرا وخط الليزر الأخضر (نفس تصميم Figma)
          Container(
            height: 210,
            decoration: BoxDecoration(
              color: const Color(0xFF0B1220),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // نموذج الفاتورة الممسوحة
                Container(
                  width: 145,
                  height: 175,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const Divider(height: 16),
                      _ReceiptSkeletonLine(width: 95),
                      const SizedBox(height: 6),
                      _ReceiptSkeletonLine(width: 75),
                      const SizedBox(height: 6),
                      _ReceiptSkeletonLine(width: 85),
                      const Spacer(),
                      const Divider(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          Text(
                            '${_extractedAmount.toStringAsFixed(2)} ₪',
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // إطار التركيز الأخضر
                Container(
                  width: 215,
                  height: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF10B981).withOpacity(0.7), width: 1.5),
                  ),
                ),

                // خط الليزر الأخضر المتوهج
                Container(
                  width: 215,
                  height: 2,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.8),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // بطاقة النتيجة المستخرجة
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الإجمالي المستخرج تلقائياً',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'دقة عالية',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '${_extractedAmount.toStringAsFixed(2)} ₪',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // زر تأكيد المبلغ ورفع الفاتورة
          CustomButton(
            text: 'تأكيد المبلغ ورفع الفاتورة',
            onPressed: () {
              Navigator.pop(context);
              widget.onConfirmAmount(_extractedAmount);
            },
          ),
        ],
      ),
    );
  }
}

class _ReceiptSkeletonLine extends StatelessWidget {
  final double width;
  const _ReceiptSkeletonLine({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 5,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
