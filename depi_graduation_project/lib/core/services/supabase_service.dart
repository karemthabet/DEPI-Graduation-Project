import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/profile/data/model/user_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await _client
        // table: 'profiles'
        .from('profiles')
        .select('id, email, full_name, avatar_url')
        .eq('id', userId)
        .single();
    return response;
  }

  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _client.from('profiles').update(data).eq('id', userId);
  }

  //upload profile image to bucket
  Future<String> uploadAvatar(File imageFile, UserModel user) async {
    final ext = imageFile.path.split('.').last;
    final fileName = ' ${user.fullName}.$ext';
    final storagePath = '${user.id}/$fileName';

    final uploadResponse = await _client.storage
        .from('avatars')
        .upload(storagePath, imageFile);
    print('image uploaded');

    final imageUrl = _client.storage.from('avatars').getPublicUrl(storagePath);

    if (imageUrl.isEmpty) {
      throw Exception('Failed to get public URL after upload.');
    }

    return imageUrl;
  }
}
