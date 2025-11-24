import 'package:whatsapp/core/services/supabase_service.dart';
import 'package:whatsapp/features/profile/data/model/user_model.dart';
import 'package:whatsapp/features/profile/data/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseService _supabaseService;

  UserRepositoryImpl(this._supabaseService);

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await _supabaseService.updateUserProfile(
      userId: user.id,
      data: {
        'name': user.name,
        'profileImage': user.profileImage,
        'email': user.email,
      },
    );
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final currentUser = _supabaseService.currentUser;
    if (currentUser != null) {
      final data = await _supabaseService.getUserProfile(currentUser.id);
      if (data != null) {
        return UserModel.fromJson(data);
      } else {
        return UserModel(
          id: currentUser.id,
          email: currentUser.email ?? '',
          name: currentUser.userMetadata?['name'] ?? 'User',
          profileImage: currentUser.userMetadata?['avatar_url'],
        );
      }
    }
    return null;
  }
}
