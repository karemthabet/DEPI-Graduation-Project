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
    return UserModel(
      id: '1',
      name: 'Marina Emad',
      email: 'marina@gmail.com',
      profileImage: 'https://share.google/sJ6qM9ZyIHNYiuXJG',
    );
  }
}
