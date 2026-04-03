import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:monoledger/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:monoledger/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:monoledger/features/auth/domain/repositories/auth_repository.dart';
import 'package:monoledger/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:monoledger/features/home/data/data_sources/session_remote_data_source.dart';
import 'package:monoledger/features/home/data/repositories/session_repository_impl.dart';
import 'package:monoledger/features/home/domain/repositories/session_repository.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: 'https://kmceonhtubcrrzfpoxra.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImttY2Vvbmh0dWJjcnJ6ZnBveHJhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQxNDg2NzgsImV4cCI6MjA4OTcyNDY3OH0.PJFCnebtx0Z3lbnRClfTkDHyAYnLl5rpphqfHo_z6Vk',
  );
  
  serviceLocator.registerLazySingleton(() => supabase.client);
  
  _initAuth();
  _initHome();
  _initLedger();
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

void _initLedger() {
  // TODO: Register Ledger dependencies
}
