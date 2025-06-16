import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/features/profile/data/models/user_profile_model.dart';
import 'package:hubtsocial_mobile/src/features/profile/domain/bloc/profile_bloc/profile_event.dart';
import 'package:hubtsocial_mobile/src/features/profile/domain/bloc/profile_bloc/profile_state.dart';
import 'package:hubtsocial_mobile/src/features/profile/domain/repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<GetUserProfile>(_onGetUserProfile);
  }

  Future<void> _onGetUserProfile(
    GetUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final UserProfileModel userProfile =
          await profileRepository.getUserProfile(event.userName);
      emit(ProfileLoaded(userProfile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
