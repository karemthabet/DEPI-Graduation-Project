import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  static var userId;

  User? get currentUser => _client.auth.currentUser;

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await _client
        //table
        .from('users')
        .select()
        .eq('id', userId)
        .single();
    return response;
  }

  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _client.from('users').update(data).eq('id', userId);
  }
}
