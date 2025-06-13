import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/change_password_usercase.dart';
import '../../domain/usecases/init_user_usercase.dart';
import '../../domain/usecases/update_user_usercase.dart';
import '../../domain/repos/user_repo.dart';

part 'user_event.dart';
part 'user_state.dart';

@Injectable()
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required InitUserUserCase initUserProfile,
    required UpdateUserUserCase updateUserProfile,
    required ChangePasswordUserCase changedPassword,
    required UserRepo userRepo,
    required Logger logger,
  })  : _initUserProfile = initUserProfile,
        _updateUserProfile = updateUserProfile,
        _changedPassword = changedPassword,
        _userRepo = userRepo,
        _logger = logger,
        super(UserProfileInitial()) {
    on<UserEvent>((event, emit) {
      emit(UserProfileLoading());
    });
    on<InitUserProfileEvent>(_initUserProfileHandler);
    on<UpdateUserProfileEvent>(_updateUserProfileHandler);
    on<UpdateUserNameEvent>(_updateUserNameHandler);
    on<UpdateUserAvatarEvent>(_updateUserAvatarHandler);
    on<ChangePasswordEvent>(_changedPasswordHandler);
  }

  final InitUserUserCase _initUserProfile;
  final UpdateUserUserCase _updateUserProfile;
  final ChangePasswordUserCase _changedPassword;
  final UserRepo _userRepo;
  final Logger _logger;

  Future<void> _updateUserNameHandler(
    UpdateUserNameEvent event,
    Emitter<UserState> emit,
  ) async {
    // emit(UserProfileLoading()); // Loading is already handled by the global listener
    final resultEither = await _userRepo.updateUserName(
      // userId is likely not needed by the repo impl
      firstName: event.firstName,
      lastName: event.lastName,
    );

    resultEither.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (_) {
        // On successful update (Right(void))
        _logger.i(
            'Username updated successfully. Dispatching InitUserProfileEvent...');
        // Dispatch the event to fetch and load the latest user profile
        add(const InitUserProfileEvent());
      },
    );
  }

  Future<void> _updateUserAvatarHandler(
    UpdateUserAvatarEvent event,
    Emitter<UserState> emit,
  ) async {
    final resultEither = await _userRepo.updateUserAvatar(
      newImage: event.newImage,
    );

    resultEither.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (_) {
        _logger.i(
            'Avatar updated successfully. Dispatching InitUserProfileEvent...');

        add(const InitUserProfileEvent());
      },
    );
  }

  Future<void> _updateUserProfileHandler(
    UpdateUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    final resultEither = await _updateUserProfile(
      UpdateProfileParams(
        userId: event.userId,
        fullName: event.fullName,
        email: event.email,
        avatarUrl: event.avatarUrl,
        newImage: event.newImage,
      ),
    );

    resultEither.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (_) {
        _logger.i(
            'Combined profile update successful. Dispatching InitUserProfileEvent...');

        add(const InitUserProfileEvent());
      },
    );
  }

  Future<void> _initUserProfileHandler(
    InitUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    _logger.i('Fetching initial user profile...');
    final result = await _initUserProfile();
    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (user) {
        _logger.i('Initial user profile fetched: ${user.userName}');
        emit(UserProfileLoaded(user));
      },
    );
  }

  Future<void> _changedPasswordHandler(
    ChangePasswordEvent event,
    Emitter<UserState> emit,
  ) async {
    final result = await _changedPassword(
      ChangePasswordParams(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) => emit(UserProfileError(int.parse(failure.statusCode) == 400
          ? failure.message
          : "serverError")),
      (_) => emit(const ChangedPassword()),
    );
  }
}
