import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/pages/user_profile_screen.dart';
import '../../../chat/presentation/pages/chats_list_screen.dart';
import '../../../tracking/presentation/pages/live_tracking_screen.dart';
import '../../../wallet/presentation/pages/wallet_screen.dart';
import '../../domain/entities/order_entity.dart';
import '../cubit/ai_order_cubit.dart';
import '../cubit/ai_order_state.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../widgets/active_order_card.dart';
import '../widgets/ai_assistant_card.dart';
import '../widgets/courier_home_view.dart';
import '../widgets/home_header_widget.dart';
import 'ai_order_review_screen.dart';
import 'courier_order_details_screen.dart';
import 'my_orders_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  final UserEntity user;
  const MainLayoutScreen({super.key, required this.user});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentNavIndex = 0;
  late bool _isCourierMode;
  final _aiPromptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isCourierMode = widget.user.role == 'courier';
    context.read<OrdersCubit>().loadAllOrders(widget.user.id);
  }

  @override
  void dispose() {
    _aiPromptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: _buildCurrentTab()),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentNavIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const MyOrdersScreen();
      case 2:
        return const ChatsListScreen();
      case 3:
        return WalletScreen(initialBalance: widget.user.walletBalance);
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: () =>
          context.read<OrdersCubit>().loadAllOrders(widget.user.id),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeHeaderWidget(
              user: widget.user,
              isCourierMode: _isCourierMode,
              onModeChanged: (val) => setState(() => _isCourierMode = val),
              onProfileTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserProfileScreen(user: widget.user),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _isCourierMode
                  ? CourierHomeView(
                      onOrderDetailsTap: (order) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CourierOrderDetailsScreen(order: order),
                          ),
                        );
                      },
                    )
                  : _buildCustomerContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerContent() {
    return BlocConsumer<AiOrderCubit, AiOrderState>(
      listener: (context, state) {
        if (state is AiOrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        } else if (state is AiOrderSuccess) {
          _aiPromptController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AiOrderReviewScreen(
                initialPrompt: state.originalPrompt,
                generatedItems: state.items,
              ),
            ),
          );
        }
      },
      builder: (context, aiState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AiAssistantCard(
              controller: _aiPromptController,
              isLoading: aiState is AiOrderLoading,
              onPrepareOrder: () {
                context.read<AiOrderCubit>().generateOrderFromPrompt(
                  _aiPromptController.text,
                );
              },
            ),
            const SizedBox(height: 12),
            // زر إنشاء قائمة طلب يدوية بدون ذكاء اصطناعي
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AiOrderReviewScreen(
                      initialPrompt: '',
                      generatedItems: [],
                      isManualMode: true,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.playlist_add_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              label: const Text(
                'أو أنشئ قائمة طلبك يدوياً',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.surface,
                minimumSize: const Size(double.infinity, 46),
                side: BorderSide(color: AppColors.primary.withOpacity(0.35)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'طلباتي النشطة',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _currentNavIndex = 1),
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            BlocBuilder<OrdersCubit, OrdersState>(
              builder: (context, orderState) {
                final orders = orderState is OrdersLoaded
                    ? orderState.customerOrders
                    : <OrderEntity>[];
                final activeOrder = orders.isNotEmpty ? orders.first : null;

                if (orderState is OrdersLoading && activeOrder == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (activeOrder == null) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 40,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'لا توجد لديك طلبات نشطة حالياً',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'اكتب طلبك في الأعلى وسيقوم الذكاء الاصطناعي بتجهيزه فوراً!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ActiveOrderCard(
                  orderNumber: activeOrder.shortOrderNumber,
                  title: activeOrder.description,
                  subtitle:
                      '${activeOrder.items.length} أغراض · الإجمالي ${(activeOrder.estimatedPrice + activeOrder.deliveryFee).toStringAsFixed(2)} ₪',
                  statusText: activeOrder.statusArabic,
                  currentStep: activeOrder.stepIndex,
                  courierName: activeOrder.courierId != null
                      ? 'محمد الخطيب'
                      : 'جاري تعيين مندوب...',
                  courierRating: '4.9',
                  courierVehicle: 'دراجة نارية',
                  etaText: activeOrder.courierId != null
                      ? 'يصل خلال 12 دقيقة'
                      : 'تم إرسال طلبك للمندوبين القريبين',
                  onTrackTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveTrackingScreen(
                          orderNumber: activeOrder.shortOrderNumber,
                        ),
                      ),
                    );
                  },
                  onChatTap: () => setState(() => _currentNavIndex = 2),
                  onCallTap: () {},
                );
              },
            ),
          ],
        );
      },
    );
  }
}
