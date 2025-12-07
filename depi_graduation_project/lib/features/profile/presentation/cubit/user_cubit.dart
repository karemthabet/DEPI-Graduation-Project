import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/profile/data/model/user_model.dart';
import 'package:whatsapp/features/profile/data/repositories/user_repository.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_state.dart';

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

  Future<void> updateUserProfile(UserModel user, File? newImageFile, {bool isProfileImageRemoved = false}) async {
    emit(UserLoading());
    try {
      await _userRepository.updateUserProfile(user, newImageFile, isProfileImageRemoved: isProfileImageRemoved);

      final updatedUser = await _userRepository.getCurrentUser();
      
      if (updatedUser != null) {
        emit(UserUpdateSuccess(updatedUser, 'Profile updated successfully!'));
      } else {
        emit(const UserError('Failed to fetch updated profile'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> signOutUser() async {
    try {
      emit(UserLoading());
      await _userRepository.signOut();

      emit(const UserLoggedOut());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    emit(UserLoading());
    try {
      await _userRepository.changePassword(oldPassword, newPassword);
      final currentUser = await _userRepository.getCurrentUser();
      if (currentUser != null) {
        emit(UserUpdateSuccess(currentUser, 'Password changed successfully'));
      } else {
        emit(const UserError('Password changed, but failed to reload profile'));
      }
    } catch (e) {
      if (e.toString().contains('The old password is incorrect')) {
        emit(const UserError('The old password is incorrect'));
      } else {
        emit(UserError(e.toString()));
      }
    }
  }
}
