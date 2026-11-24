import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/network/network_info.dart';
import 'core/services/gemini_service.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/orders/data/datasources/orders_remote_datasource.dart';
import 'features/orders/data/repositories/orders_repository_impl.dart';
import 'features/orders/domain/repositories/orders_repository.dart';
import 'features/orders/presentation/cubit/ai_order_cubit.dart';
import 'features/orders/presentation/cubit/orders_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  sl.registerLazySingleton(() => GeminiService());

  // Features - Auth
  sl.registerFactory(() => AuthCubit(authRepository: sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Features - Orders & AI
  sl.registerFactory(() => AiOrderCubit(geminiService: sl()));
  sl.registerFactory(() => OrdersCubit(ordersRepository: sl()));
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(sl()),
  );
}
