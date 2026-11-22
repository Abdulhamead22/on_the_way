import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/pages/auth_screen.dart';
import 'features/orders/presentation/cubit/ai_order_cubit.dart';
import 'features/orders/presentation/pages/main_layout_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? 
                      dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';

  await Hive.initFlutter();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  await di.initDependencies();

  runApp(const OnTheWayApp());
}

class OnTheWayApp extends StatelessWidget {
  const OnTheWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => di.sl<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider<AiOrderCubit>(
          create: (_) => di.sl<AiOrderCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'عَ الطريق',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading || state is AuthInitial) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is AuthAuthenticated) {
              return MainLayoutScreen(user: state.user);
            }
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
