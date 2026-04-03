import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<User?> loginAnonymously();
  Future<void> logout();
  Session? get currentSession;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentSession => supabaseClient.auth.currentSession;

  @override
  Future<User?> loginAnonymously() async {
    final response = await supabaseClient.auth.signInAnonymously();
    return response.user;
  }

  @override
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }
}
