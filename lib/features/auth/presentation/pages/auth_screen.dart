import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_mode_switcher.dart';
import '../widgets/role_selection_card.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  String selectedRole = 'customer';

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (isLogin) {
      context.read<AuthCubit>().signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    } else {
      context.read<AuthCubit>().signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            fullName: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            role: selectedRole,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          size: 38,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'عَ الطريق',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'توصيلك ومهامك اليومية أسهل وأسرع',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    AuthModeSwitcher(
                      isLogin: isLogin,
                      onChanged: (val) => setState(() => isLogin = val),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(20),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isLogin) ...[
                            CustomTextField(
                              label: 'الاسم الكامل',
                              hintText: 'أدخل اسمك الكامل',
                              controller: _nameController,
                              prefixIcon: Icons.person_outline_rounded,
                              validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال الاسم' : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'رقم الجوال',
                              hintText: '059xxxxxxx',
                              controller: _phoneController,
                              prefixIcon: Icons.phone_android_rounded,
                              keyboardType: TextInputType.phone,
                              validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال رقم الجوال' : null,
                            ),
                            const SizedBox(height: 16),
                          ],
                          CustomTextField(
                            label: 'البريد الإلكتروني',
                            hintText: 'example@mail.com',
                            controller: _emailController,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => val == null || !val.contains('@') ? 'بريد إلكتروني غير صحيح' : null,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'كلمة المرور',
                            hintText: '••••••••',
                            controller: _passwordController,
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            validator: (val) => val == null || val.length < 6 ? 'كلمة المرور 6 أحرف على الأقل' : null,
                          ),
                          if (isLogin) ...[
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'نسيت كلمة المرور؟',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (!isLogin) ...[
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: RoleSelectionCard(
                                    title: 'ابدأ كعميل',
                                    isSelected: selectedRole == 'customer',
                                    onTap: () => setState(() => selectedRole = 'customer'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: RoleSelectionCard(
                                    title: 'ابدأ كمندوب',
                                    isSelected: selectedRole == 'courier',
                                    onTap: () => setState(() => selectedRole = 'courier'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    CustomButton(
                      text: isLogin ? 'تسجيل الدخول' : 'إنشاء الحساب',
                      isLoading: state is AuthLoading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
