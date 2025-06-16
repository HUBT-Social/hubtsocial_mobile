import 'package:hubtsocial_mobile/src/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRepository {
  Future<UserProfileModel> getUserProfile(String userName);
}
