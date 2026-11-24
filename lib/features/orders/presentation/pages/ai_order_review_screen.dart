import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../domain/entities/order_entity.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../widgets/ai_suggested_items_card.dart';
import '../widgets/order_route_map_preview.dart';

class AiOrderReviewScreen extends StatefulWidget {
  final String initialPrompt;
  final List<AiOrderItem> generatedItems;
  final bool isManualMode;

  const AiOrderReviewScreen({
    super.key,
    required this.initialPrompt,
    required this.generatedItems,
    this.isManualMode = false,
  });

  @override
  State<AiOrderReviewScreen> createState() => _AiOrderReviewScreenState();
}

class _AiOrderReviewScreenState extends State<AiOrderReviewScreen> {
  final double _deliveryFee = 10.00;
  late List<AiOrderItem> _items;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.generatedItems);
    _titleController = TextEditingController(
      text: widget.initialPrompt.isNotEmpty ? widget.initialPrompt : 'طلب مشتريات مخصص',
    );
    if (widget.isManualMode && _items.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showAddItemDialog());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  double get _estimatedTotal {
    return _items
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void _showAddItemDialog() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1 قطعة');
    final priceCtrl = TextEditingController(text: '10.0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة غرض جديد', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'اسم الغرض'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: qtyCtrl,
              decoration: const InputDecoration(labelText: 'الكمية (مثلاً: 2 كغم)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'السعر الإجمالي للغرض (₪)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _items.add(
                    AiOrderItem(
                      name: nameCtrl.text.trim(),
                      quantity: qtyCtrl.text.trim(),
                      price: double.tryParse(priceCtrl.text) ?? 5.0,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(90, 40)),
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _publishOrder() {
    final selectedItems = _items
        .where((item) => item.isSelected)
        .map((e) => OrderItemEntity(
              name: e.name,
              quantity: e.formattedQuantity,
              price: e.totalPrice,
            ))
        .toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إضافة أو تحديد غرض واحد على الأقل')),
      );
      return;
    }

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<OrdersCubit>().publishOrder(
            customerId: authState.user.id,
            description: _titleController.text.trim(),
            items: selectedItems,
            estimatedPrice: _estimatedTotal,
            deliveryFee: _deliveryFee,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is OrdersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        } else if (state is OrderActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.primary),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: Text(
              widget.isManualMode ? 'إنشاء قائمة طلب يدوية' : 'مراجعة وتعديل الطلب',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OrderRouteMapPreview(
                        distanceText: 'المسافة: 3.5 كم',
                        onPickupTap: () {},
                        onDropoffTap: () {},
                      ),
                      const SizedBox(height: 16),
                      if (widget.isManualMode) ...[
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'عنوان الطلب (مثلاً: أغراض سوبرماركت)',
                            prefixIcon: Icon(Icons.edit_note_rounded, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      AiSuggestedItemsCard(
                        items: _items,
                        onToggleItem: (index) {
                          setState(() {
                            _items[index].isSelected = !_items[index].isSelected;
                          });
                        },
                        onQuantityChanged: () => setState(() {}),
                        onAddItemTap: _showAddItemDialog,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('التكلفة التقديرية', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                        Text(
                          '${_estimatedTotal.toStringAsFixed(2)} ₪',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('رسوم التوصيل', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                        Text(
                          '${_deliveryFee.toStringAsFixed(2)} ₪',
                          style: const TextStyle(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'نشر الطلب الآن',
                      isLoading: state is OrdersLoading,
                      onPressed: _publishOrder,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
