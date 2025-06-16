import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/features/user/data/models/user_model.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/usecases/get_user_by_username_usercase.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@Injectable()
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetUserByUsernameUserCase getUserByUsername,
    required Logger logger,
  })  : _getUserByUsername = getUserByUsername,
        _logger = logger,
        super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {
      emit(ProfileLoading());
    });
    on<GetUserProfile>(_getUserByUsernameHandler);
  }

  final GetUserByUsernameUserCase _getUserByUsername;

  final Logger _logger;

  Future<void> _getUserByUsernameHandler(
    GetUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    _logger.i('Fetching initial profile profile...');
    final result = await _getUserByUsername(GetUserByUsernameParams(
      username: event.username,
    ));
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) {
        emit(ProfileLoaded(profile));
      },
    );
  }
}
