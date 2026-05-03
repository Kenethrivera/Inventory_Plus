import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<String?> authenticate(String username, String password) async {
    try {
      // Make sure 'users' exactly matches the table name in your Supabase dashboard!
      final res = await _supabase
          .from('profiles')
          .select()
          .eq('username', username)
          .eq('password', password)
          .maybeSingle();

      if (res == null) return null;

      return res['role'] as String?;
    } on PostgrestException catch (e) {
      // THIS will catch SQL errors like wrong table names or missing columns
      throw Exception('DB Error: ${e.message}');
    } catch (e) {
      // THIS catches network/initialization issues
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      // This wipes any Supabase session tokens stored in the device's local storage
      await _supabase.auth.signOut();
    } catch (e) {
      print("Error clearing session: $e");
    }
  }
}


