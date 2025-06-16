import 'package:dio/dio.dart';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/features/profile/data/models/user_profile_model.dart';
import 'package:hubtsocial_mobile/src/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final Dio _dio;

  ProfileRepositoryImpl(this._dio);

  @override
  Future<UserProfileModel> getUserProfile(String userName) async {
    try {
      final response = await _dio.get(
        '${EndPoint.user}?userName=$userName',
      );
      return UserProfileModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
