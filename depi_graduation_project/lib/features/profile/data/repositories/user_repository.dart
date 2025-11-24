import 'package:whatsapp/features/profile/data/model/user_model.dart';

abstract class UserRepository {
  Future<void> updateUserProfile(UserModel user);
  Future<UserModel?> getCurrentUser();
}
