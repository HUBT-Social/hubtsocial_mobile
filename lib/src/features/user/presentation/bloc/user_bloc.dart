import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

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
  })  : _initUserProfile = initUserProfile,
        _updateUserProfile = updateUserProfile,
        _changedPassword = changedPassword,
        _userRepo = userRepo,
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

  Future<void> _updateUserNameHandler(
    UpdateUserNameEvent event,
    Emitter<UserState> emit,
  ) async {
    final result = await _userRepo.updateUserName(
      firstName: event.firstName,
      lastName: event.lastName,
    );
    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (_) => emit(UpdatedUserProfile()),
    );
  }

  Future<void> _updateUserAvatarHandler(
    UpdateUserAvatarEvent event,
    Emitter<UserState> emit,
  ) async {
    final result = await _userRepo.updateUserAvatar(
      newImage: event.newImage,
    );
    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (_) => emit(UpdatedUserProfile()),
    );
  }

  Future<void> _updateUserProfileHandler(
    UpdateUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    // This handler might not be needed anymore or needs adjustment
    // depending on how updateUserProfile is intended to be used.
    // For now, I'll keep it but it might be deprecated.
    final result = await _updateUserProfile(
      UpdateProfileParams(
        userId: event.userId,
        fullName: event.fullName,
        email: event.email,
        avatarUrl: event.avatarUrl,
        newImage: event.newImage,
      ),
    );
    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (_) => emit(UpdatedUserProfile()),
    );
  }

  Future<void> _initUserProfileHandler(
    InitUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    final result = await _initUserProfile();
    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (user) => emit(UserProfileLoaded(user)),
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
          ? failure.errorMessage
          : "serverError")),
      (_) => emit(const ChangedPassword()),
    );
  }
}
