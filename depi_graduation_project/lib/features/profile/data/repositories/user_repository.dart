import 'package:whatsapp/features/profile/data/model/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> getCurrentUser();
  Future<void> updateUserProfile(UserModel user);
  
}
