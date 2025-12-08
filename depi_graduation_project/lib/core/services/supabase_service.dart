import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatsapp/features/profile/data/model/user_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  static var userId;

  User? get currentUser => _client.auth.currentUser;

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await _client
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

  //upload profile image to bucket
  Future<String> uploadAvatar(File imageFile, UserModel user) async {
    final ext = imageFile.path.split('.').last;
    final fileName = '${user.fullName}.$ext';
    final storagePath = '${user.id}/$fileName';

    await _client.storage.from('avatars').upload(storagePath, imageFile);

    final imageUrl = _client.storage.from('avatars').getPublicUrl(storagePath);

    if (imageUrl.isEmpty) {
      throw Exception('Failed to get public URL after upload.');
    }

    return imageUrl;
  }
}
