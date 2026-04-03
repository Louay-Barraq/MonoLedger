import 'package:supabase_flutter/supabase_flutter.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  User? get currentUser => remoteDataSource.currentSession?.user;

  @override
  Future<User?> loginAnonymously() async {
    try {
      return await remoteDataSource.loginAnonymously();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }
}
