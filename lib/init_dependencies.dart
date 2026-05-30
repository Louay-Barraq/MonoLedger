import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:monoledger/core/config/app_config.dart';
import 'package:monoledger/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:monoledger/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:monoledger/features/auth/domain/repositories/auth_repository.dart';
import 'package:monoledger/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:monoledger/features/home/data/data_sources/session_remote_data_source.dart';
import 'package:monoledger/features/home/data/repositories/session_repository_impl.dart';
import 'package:monoledger/features/home/domain/repositories/session_repository.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';
import 'package:monoledger/features/transactions/data/data_sources/transaction_remote_data_source.dart';
import 'package:monoledger/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:monoledger/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:monoledger/features/transactions/presentation/bloc/transaction_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  _initAuth();
  _initHome();
  _initTransactions();
}

void _initAuth() {
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => AuthBloc(serviceLocator()),
  );
}

void _initHome() {
  serviceLocator.registerLazySingleton<SessionRemoteDataSource>(
    () => SessionRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => SessionBloc(serviceLocator()),
  );
}

void _initTransactions() {
  serviceLocator.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => TransactionBloc(serviceLocator()),
  );
}
