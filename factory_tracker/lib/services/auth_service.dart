import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  // Call this once when the app starts
  Future<void> signInAsTablet() async {
    // Already logged in, do nothing
    if (_client.auth.currentSession != null) return;

    await _client.auth.signInWithPassword(
      email: 'tablet@marecom.com',
      password: '1B2b3b4b0123',
    );
  }

  bool get isLoggedIn => _client.auth.currentSession != null;
}