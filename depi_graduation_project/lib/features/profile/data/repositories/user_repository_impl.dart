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
      data: {'name': user.name, 'profileImage': user.profileImage},
    );
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseService.currentUser;
      if (user == null) return null;

      final userData = await _supabaseService.getUserProfile(user.id);
      
      if (userData != null) {
        return UserModel.fromJson(userData);
      }
      
      // Fallback if profile doesn't exist but auth user does
      return UserModel(
        id: user.id,
        name: user.userMetadata?['name'] ?? 'User',
        email: user.email ?? '',
        profileImage: user.userMetadata?['profileImage'] ?? '',
      );
    } catch (e) {
      // Return null or rethrow depending on desired behavior. 
      // For now, returning null to indicate no user found/error.
      return null;
    }
  }
}
