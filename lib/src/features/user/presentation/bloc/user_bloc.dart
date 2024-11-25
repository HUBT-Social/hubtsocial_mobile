import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/change_password_usercase.dart';
import '../../domain/usecases/init_user_usercase.dart';
import '../../domain/usecases/update_user_usercase.dart';

part 'user_event.dart';
part 'user_state.dart';

@Injectable()
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required InitUserUserCase initUserProfile,
    required UpdateUserUserCase updateUserProfile,
    required ChangePasswordUserCase changedPassword,
  })  : _initUserProfile = initUserProfile,
        _updateUserProfile = updateUserProfile,
        _changedPassword = changedPassword,
        super(UserProfileInitial()) {
    on<UserEvent>((event, emit) {
      emit(UserProfileLoading());
    });
    on<InitUserProfileEvent>(_initUserProfileHandler);
    on<UpdateUserProfileEvent>(_updateUserProfileHandler);
    on<ChangePasswordEvent>(_changedPasswordHandler);
  }

  final InitUserUserCase _initUserProfile;
  final UpdateUserUserCase _updateUserProfile;
  final ChangePasswordUserCase _changedPassword;

  Future<void> _updateUserProfileHandler(
    UpdateUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
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
      (failure) => emit(UserProfileError("serverError")),
      (user) => emit(UpdatedUserProfile()),
    );
  }

  Future<void> _initUserProfileHandler(
    InitUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    final result = await _initUserProfile();
    result.fold(
      (failure) => emit(UserProfileError("serverError")),
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
