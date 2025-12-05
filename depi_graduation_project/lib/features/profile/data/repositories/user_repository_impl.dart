import 'dart:io';

import 'package:whatsapp/core/services/supabase_service.dart';
import 'package:whatsapp/features/profile/data/model/user_model.dart';
import 'package:whatsapp/features/profile/data/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseService _supabaseService;

  UserRepositoryImpl(this._supabaseService);

  @override
  Future<void> updateUserProfile(UserModel user, File? newImageFile) async {
    String? newAvatarUrl = user.avatarUrl;

    if (newImageFile != null) {
      newAvatarUrl = await _supabaseService.uploadAvatar(newImageFile, user);
    }

    final updateData = {'full_name': user.fullName, 'avatar_url': newAvatarUrl};

    await _supabaseService.updateUserProfile(userId: user.id, data: updateData);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final User? authUser = Supabase.instance.client.auth.currentUser;

    if (authUser != null) {
      final userData = await _supabaseService.getUserProfile(authUser.id);

      if (userData != null) {
        return UserModel.fromJson(userData);
      }
    }
    return null;
  }
}
