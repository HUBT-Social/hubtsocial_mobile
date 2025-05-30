part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class InitUserProfileEvent extends UserEvent {
  const InitUserProfileEvent();
}

class UpdateUserProfileEvent extends UserEvent {
  const UpdateUserProfileEvent({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.newImage,
  });
  final String userId;
  final String fullName;
  final String email;
  final String avatarUrl;
  final File? newImage;

  @override
  List<Object> get props => [userId, fullName, email, avatarUrl];
}

class UpdateUserNameEvent extends UserEvent {
  const UpdateUserNameEvent({
    required this.userId,
    required this.firstName,
    required this.lastName,
  });
  final String userId;
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [userId, firstName, lastName];
}

class UpdateUserAvatarEvent extends UserEvent {
  const UpdateUserAvatarEvent({
    required this.newImage,
  });
  final File newImage;

  @override
  List<Object> get props => [];
}

class ChangePasswordEvent extends UserEvent {
  const ChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });

  final String oldPassword;
  final String newPassword;

  @override
  List<String> get props => [oldPassword, newPassword];
}
