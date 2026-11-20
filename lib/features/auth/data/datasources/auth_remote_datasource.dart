import 'package:flutter_application_1/core/errors/exceptions.dart';
import 'package:flutter_application_1/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
  });
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase;
  AuthRemoteDataSourceImpl(this.supabase);

  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerException('فشل تسجيل الدخول، تأكد من البيانات');
      }
      final userData = await supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();
      return UserModel.fromJson(userData);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('حدث خطأ غير متوقع أثناء تسجيل الدخول');
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerException('فشل إنشاء الحساب');
      }
      final newUser = UserModel(
        id: response.user!.id,
        fullName: fullName,
        phone: phone,
        role: role,
      );
      await supabase.from('users').insert(newUser.toJson());
      return newUser;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('حدث خطأ أثناء حفظ بيانات الحساب');
    }
  }

  @override
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    final userData = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    return userData != null ? UserModel.fromJson(userData) : null;
  }
}
