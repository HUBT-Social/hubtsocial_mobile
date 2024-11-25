part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserProfileInitial extends UserState {}

class UserProfileLoading extends UserState {}

class UserProfileLoaded extends UserState {
  const UserProfileLoaded(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class UpdatedUserProfile extends UserState {}

class UserProfileError extends UserState {
  const UserProfileError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class ChangedPassword extends UserState {
  const ChangedPassword();

  @override
  List<String> get props => [];
}
