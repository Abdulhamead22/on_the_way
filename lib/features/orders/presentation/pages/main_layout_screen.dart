import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/user_profile_screen.dart';
import 'package:flutter_application_1/features/chat/presentation/pages/chats_list_screen.dart';
import 'package:flutter_application_1/features/orders/presentation/pages/courier_order_details_screen.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/wallet_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../tracking/presentation/pages/live_tracking_screen.dart';
import '../widgets/active_order_card.dart';
import '../widgets/ai_assistant_card.dart';
import '../widgets/courier_home_view.dart';
import '../widgets/home_header_widget.dart';
import 'ai_order_review_screen.dart';
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
    return SingleChildScrollView(
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
                    onOrderDetailsTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CourierOrderDetailsScreen(),
                        ),
                      );
                    },
                  )
                : _buildCustomerContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AiAssistantCard(
          controller: _aiPromptController,
          onPrepareOrder: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AiOrderReviewScreen(
                  initialPrompt: _aiPromptController.text.trim(),
                ),
              ),
            );
          },
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
        ActiveOrderCard(
          orderNumber: '#4821',
          title: 'طلب من سوبرماركت الدرة',
          subtitle: '5 أغراض · الدفع من المحفظة',
          statusText: 'قيد التوصيل',
          currentStep: 2,
          courierName: 'محمد الخطيب',
          courierRating: '4.9',
          courierVehicle: 'دراجة نارية',
          etaText: 'يصل خلال 12 دقيقة',
          onTrackTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LiveTrackingScreen(),
              ),
            );
          },
          onChatTap: () => setState(() => _currentNavIndex = 2),
          onCallTap: () {},
        ),
      ],
    );
  }
}
