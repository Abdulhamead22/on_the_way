import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entities/user_entity.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_settings_card.dart';

class UserProfileScreen extends StatefulWidget {
  final UserEntity user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
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
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
body: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
ProfileHeaderCard(
fullName: _nameController.text,
phone: _phoneController.text,
onAvatarEditTap: () {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('سيتم تفعيل تغيير الصورة الشخصية قريباً')),
);
},
),
const SizedBox(height: 20),
// بطاقة تعديل البيانات
Container(
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
children: [
CustomTextField(
label: 'الاسم الكامل',
hintText: 'أدخل اسمك',
controller: _nameController,
prefixIcon: Icons.person_outline_rounded,
),
const SizedBox(height: 16),
CustomTextField(
label: 'رقم الجوال',
hintText: '059xxxxxxx',
controller: _phoneController,
prefixIcon: Icons.phone_android_rounded,
keyboardType: TextInputType.phone,
),
const SizedBox(height: 20),
CustomButton(
text: 'حفظ التعديلات',
backgroundColor: AppColors.primary,
textColor: Colors.white,
onPressed: () {
setState(() {});
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('تم حفظ التعديلات بنجاح ✅'),
backgroundColor: AppColors.primary,
),
);
},
),
],
),
),
const SizedBox(height: 20),
// بطاقة الإعدادات وتسجيل الخروج
ProfileSettingsCard(
isDarkMode: _isDarkMode,
onDarkModeChanged: (val) => setState(() => _isDarkMode = val),
onChangePasswordTap: () {},
onLogoutTap: () {
Navigator.pop(context);
context.read().signOut();
},
),
const SizedBox(height: 24),
],
),
),
);
}
}
