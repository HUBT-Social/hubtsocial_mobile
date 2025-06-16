part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetUserProfile extends ProfileEvent {
  final String username;

  const GetUserProfile(this.username);

  @override
  List<Object> get props => [username];
}
