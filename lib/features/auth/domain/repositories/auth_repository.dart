import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRepository {
  Future<User?> loginAnonymously();
  Future<void> logout();
  Future<void> deleteAccount();
  User? get currentUser;
}
