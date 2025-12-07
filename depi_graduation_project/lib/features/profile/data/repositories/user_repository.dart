import 'dart:io';

import 'package:whatsapp/features/profile/data/model/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> getCurrentUser();
  Future<void> updateUserProfile(UserModel user, File? newImageFile, {bool isProfileImageRemoved = false});
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> signOut();
}
