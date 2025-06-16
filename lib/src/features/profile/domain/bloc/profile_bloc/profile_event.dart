import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/profile/data/models/user_profile_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetUserProfile extends ProfileEvent {
  final String userName;

  const GetUserProfile(this.userName);

  @override
  List<Object> get props => [userName];
}
