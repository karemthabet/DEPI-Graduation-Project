import 'dart:io';
import 'package:hive/hive.dart';

import 'package:whatsapp/core/services/supabase_service.dart';
import 'package:whatsapp/features/profile/data/model/user_model.dart';
import 'package:whatsapp/features/profile/data/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseService _supabaseService;
  final supabase = Supabase.instance.client;
  final Box<UserModel> _userBox = Hive.box<UserModel>('user_cache');

  UserRepositoryImpl(this._supabaseService);

  @override
  Future<void> updateUserProfile(
    UserModel user,
    File? newImageFile, {
    bool isProfileImageRemoved = false,
  }) async {
    String? newAvatarUrl = user.avatarUrl;

    if (isProfileImageRemoved) {
      newAvatarUrl = null;
    } else if (newImageFile != null) {
      newAvatarUrl = await _supabaseService.uploadAvatar(newImageFile, user);
    }

    final updateData = {'full_name': user.fullName, 'avatar_url': newAvatarUrl};

    await _supabaseService.updateUserProfile(userId: user.id, data: updateData);

    // Update cache
    final updatedUser = user.copyWith(avatarUrl: newAvatarUrl);
    await _userBox.put('current_user', updatedUser);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final User? authUser = supabase.auth.currentUser;

      if (authUser != null) {
        final userData = await _supabaseService.getUserProfile(authUser.id);

        if (userData != null) {
          final user = UserModel.fromJson(userData);
          // Save to cache
          await _userBox.put('current_user', user);
          return user;
        }
      }
    } catch (e) {
      // try to load from cache
      if (_userBox.containsKey('current_user')) {
        return _userBox.get('current_user');
      }
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await supabase.auth.signOut();
    await _userBox.clear();
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    final email = supabase.auth.currentUser?.email;
    if (email == null) throw Exception('User email not found');

    try {
      // Verify old password by signing in
      await supabase.auth.signInWithPassword(email: email, password: oldPassword);
      
      // If successful, update to new password
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        throw Exception('The old password is incorrect');
      }
      rethrow;
    }
  }
}
