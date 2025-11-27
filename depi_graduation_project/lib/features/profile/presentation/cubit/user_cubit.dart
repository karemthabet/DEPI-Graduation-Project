import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/profile/data/model/user_model.dart';
import 'package:whatsapp/features/profile/data/repositories/user_repository.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_state.dart';

// Cubit
class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(this._userRepository) : super(UserInitial());

  Future<void> loadUserProfile() async {
    emit(UserLoading());
    try {
      final user = await _userRepository.getCurrentUser();
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(const UserError('No user logged in'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateUserProfile(UserModel user) async {
    emit(UserLoading());
    try {
      await _userRepository.updateUserProfile(user);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
