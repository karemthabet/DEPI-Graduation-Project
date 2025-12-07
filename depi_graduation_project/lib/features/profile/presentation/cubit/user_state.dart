import 'package:equatable/equatable.dart';
import 'package:whatsapp/features/profile/data/model/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserUpdateSuccess extends UserLoaded {
  final String message;
  const UserUpdateSuccess(super.user, this.message);

  @override
  List<Object?> get props => [user, message];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserLoggedOut extends UserState {
  const UserLoggedOut();

  @override
  List<Object?> get props => [];
}
