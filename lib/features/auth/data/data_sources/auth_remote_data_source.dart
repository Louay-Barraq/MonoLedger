import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<User?> loginAnonymously();
  Future<void> logout();
  Future<void> deleteAccount();
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

  @override
  Future<void> deleteAccount() async {
    await supabaseClient.rpc('delete_my_account');
    // The server deleted the user; drop the local session too.
    await supabaseClient.auth.signOut(scope: SignOutScope.local);
  }
}
