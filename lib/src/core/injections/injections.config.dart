// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_ce_flutter/adapters.dart' as _i170;
import 'package:hubtsocial_mobile/src/core/injections/module.dart' as _i107;
import 'package:hubtsocial_mobile/src/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i953;
import 'package:hubtsocial_mobile/src/features/auth/data/repos/auth_repo_impl.dart'
    as _i457;
import 'package:hubtsocial_mobile/src/features/auth/domain/repos/auth_repo.dart'
    as _i936;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/forgot_password_user_case.dart'
    as _i411;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/information_user_case.dart'
    as _i556;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/otp_user_case.dart'
    as _i245;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/reset_password.dart'
    as _i492;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/set_new_password_user_case.dart'
    as _i356;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/sign_in_user_case.dart'
    as _i627;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/sign_out.dart'
    as _i488;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/sign_up_user_case.dart'
    as _i287;
import 'package:hubtsocial_mobile/src/features/auth/presentation/bloc/auth_bloc.dart'
    as _i715;
import 'package:hubtsocial_mobile/src/features/chat/data/datasources/chat_remote_data_source.dart'
    as _i745;
import 'package:hubtsocial_mobile/src/features/chat/data/repos/chat_repo_impl.dart'
    as _i293;
import 'package:hubtsocial_mobile/src/features/chat/domain/repos/chat_repo.dart'
    as _i965;
import 'package:hubtsocial_mobile/src/features/chat/domain/usercases/fetch_chat_usercase.dart'
    as _i1020;
import 'package:hubtsocial_mobile/src/features/chat/presentation/bloc/chat_bloc.dart'
    as _i359;
import 'package:hubtsocial_mobile/src/features/chat/presentation/bloc/receive_chat/receive_chat_cubit.dart'
    as _i441;
import 'package:hubtsocial_mobile/src/features/quiz/data/datasources/quiz_remote_data_source.dart'
    as _i250;
import 'package:hubtsocial_mobile/src/features/quiz/data/repos/quiz_repo_impl.dart'
    as _i129;
import 'package:hubtsocial_mobile/src/features/quiz/domain/repos/quiz_repo.dart'
    as _i13;
import 'package:hubtsocial_mobile/src/features/quiz/domain/usercases/fetch_quiz_usercase.dart'
    as _i35;
import 'package:hubtsocial_mobile/src/features/quiz/domain/usercases/get_quiz_info_usercase.dart'
    as _i572;
import 'package:hubtsocial_mobile/src/features/quiz/presentation/bloc/quiz_bloc.dart'
    as _i1023;
import 'package:hubtsocial_mobile/src/features/quiz/presentation/bloc/quiz_info_bloc.dart'
    as _i251;
import 'package:hubtsocial_mobile/src/features/quiz/presentation/bloc/quiz_question_bloc.dart'
    as _i1002;
import 'package:hubtsocial_mobile/src/features/room_chat/data/datasources/room_chat_remote_data_source.dart'
    as _i311;
import 'package:hubtsocial_mobile/src/features/room_chat/data/repos/room_chat_repo_impl.dart'
    as _i942;
import 'package:hubtsocial_mobile/src/features/room_chat/domain/repos/room_chat_repo.dart'
    as _i133;
import 'package:hubtsocial_mobile/src/features/room_chat/domain/usercases/fetch_room_chat_usercase.dart'
    as _i1063;
import 'package:hubtsocial_mobile/src/features/room_chat/domain/usercases/get_room_member_usercase.dart'
    as _i892;
import 'package:hubtsocial_mobile/src/features/room_chat/presentation/bloc/room_chat_bloc.dart'
    as _i285;
import 'package:hubtsocial_mobile/src/features/timetable/data/datasources/timetable_remote_data_source.dart'
    as _i806;
import 'package:hubtsocial_mobile/src/features/timetable/data/repos/timetable_repo_impl.dart'
    as _i576;
import 'package:hubtsocial_mobile/src/features/timetable/domain/repos/timetable_repo.dart'
    as _i113;
import 'package:hubtsocial_mobile/src/features/timetable/domain/usercases/init_timetable_usercase.dart'
    as _i753;
import 'package:hubtsocial_mobile/src/features/timetable/presentation/bloc/timetable_bloc.dart'
    as _i786;
import 'package:hubtsocial_mobile/src/features/user/data/datasources/user_profile_remote_datasource.dart'
    as _i592;
import 'package:hubtsocial_mobile/src/features/user/data/repos/user_repo_impl.dart'
    as _i674;
import 'package:hubtsocial_mobile/src/features/user/domain/repos/user_repo.dart'
    as _i1042;
import 'package:hubtsocial_mobile/src/features/user/domain/usecases/change_password_usercase.dart'
    as _i789;
import 'package:hubtsocial_mobile/src/features/user/domain/usecases/init_user_usercase.dart'
    as _i477;
import 'package:hubtsocial_mobile/src/features/user/domain/usecases/update_user_usercase.dart'
    as _i925;
import 'package:hubtsocial_mobile/src/features/user/presentation/bloc/user_bloc.dart'
    as _i527;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i441.ReceiveChatCubit>(() => _i441.ReceiveChatCubit());
    gh.factory<_i1002.QuizQuestionBloc>(() => _i1002.QuizQuestionBloc());
    gh.lazySingleton<_i170.HiveInterface>(() => registerModule.hive);
    gh.lazySingleton<_i892.FirebaseMessaging>(
        () => registerModule.firebaseMessaging);
    gh.lazySingleton<_i592.UserProfileRemoteDataSource>(() =>
        _i592.UserProfileRemoteDataSourceImpl(
            hiveAuth: gh<_i170.HiveInterface>()));
    gh.lazySingleton<_i806.TimetableRemoteDataSource>(
        () => _i806.TimetableRemoteDataSourceImpl(
              hiveAuth: gh<_i170.HiveInterface>(),
              messaging: gh<_i892.FirebaseMessaging>(),
            ));
    gh.lazySingleton<_i250.QuizRemoteDataSource>(
        () => _i250.QuizRemoteDataSourceImpl(
              hiveAuth: gh<_i170.HiveInterface>(),
              messaging: gh<_i892.FirebaseMessaging>(),
            ));
    gh.lazySingleton<_i1042.UserRepo>(
        () => _i674.UserRepoImpl(gh<_i592.UserProfileRemoteDataSource>()));
    gh.lazySingleton<_i113.TimetableRepo>(
        () => _i576.TimetableRepoImpl(gh<_i806.TimetableRemoteDataSource>()));
    gh.lazySingleton<_i745.ChatRemoteDataSource>(
        () => _i745.ChatRemoteDataSourceImpl(
              hiveAuth: gh<_i170.HiveInterface>(),
              messaging: gh<_i892.FirebaseMessaging>(),
            ));
    gh.lazySingleton<_i311.RoomChatRemoteDataSource>(
        () => _i311.RoomChatRemoteDataSourceImpl(
              hiveAuth: gh<_i170.HiveInterface>(),
              messaging: gh<_i892.FirebaseMessaging>(),
            ));
    gh.lazySingleton<_i953.AuthRemoteDataSource>(
        () => _i953.AuthRemoteDataSourceImpl(
              hiveAuth: gh<_i170.HiveInterface>(),
              messaging: gh<_i892.FirebaseMessaging>(),
            ));
    gh.lazySingleton<_i133.RoomChatRepo>(
        () => _i942.RoomChatRepoImpl(gh<_i311.RoomChatRemoteDataSource>()));
    gh.lazySingleton<_i753.InitTimetableUserCase>(
        () => _i753.InitTimetableUserCase(gh<_i113.TimetableRepo>()));
    gh.lazySingleton<_i936.AuthRepo>(
        () => _i457.AuthRepoImpl(gh<_i953.AuthRemoteDataSource>()));
    gh.lazySingleton<_i1063.FetchRoomChatUserCase>(
        () => _i1063.FetchRoomChatUserCase(gh<_i133.RoomChatRepo>()));
    gh.lazySingleton<_i892.GetRoomMemberUserCase>(
        () => _i892.GetRoomMemberUserCase(gh<_i133.RoomChatRepo>()));
    gh.lazySingleton<_i789.ChangePasswordUserCase>(
        () => _i789.ChangePasswordUserCase(gh<_i1042.UserRepo>()));
    gh.lazySingleton<_i477.InitUserUserCase>(
        () => _i477.InitUserUserCase(gh<_i1042.UserRepo>()));
    gh.lazySingleton<_i925.UpdateUserUserCase>(
        () => _i925.UpdateUserUserCase(gh<_i1042.UserRepo>()));
    gh.lazySingleton<_i13.QuizRepo>(
        () => _i129.QuizRepoImpl(gh<_i250.QuizRemoteDataSource>()));
    gh.lazySingleton<_i965.ChatRepo>(
        () => _i293.ChatRepoImpl(gh<_i745.ChatRemoteDataSource>()));
    gh.lazySingleton<_i35.FetchQuizUserCase>(
        () => _i35.FetchQuizUserCase(gh<_i13.QuizRepo>()));
    gh.lazySingleton<_i572.GetQuizInfoUserCase>(
        () => _i572.GetQuizInfoUserCase(gh<_i13.QuizRepo>()));
    gh.factory<_i527.UserBloc>(() => _i527.UserBloc(
          initUserProfile: gh<_i477.InitUserUserCase>(),
          updateUserProfile: gh<_i925.UpdateUserUserCase>(),
          changedPassword: gh<_i789.ChangePasswordUserCase>(),
        ));
    gh.factory<_i1023.QuizBloc>(
        () => _i1023.QuizBloc(fetchQuiz: gh<_i35.FetchQuizUserCase>()));
    gh.factory<_i251.QuizInfoBloc>(
        () => _i251.QuizInfoBloc(getQuizInfo: gh<_i572.GetQuizInfoUserCase>()));
    gh.lazySingleton<_i1020.FetchChatUserCase>(
        () => _i1020.FetchChatUserCase(gh<_i965.ChatRepo>()));
    gh.factory<_i285.GetRoomChatBloc>(() => _i285.GetRoomChatBloc(
          fetchRoomChat: gh<_i1063.FetchRoomChatUserCase>(),
          getRoomChat: gh<_i892.GetRoomMemberUserCase>(),
        ));
    gh.factory<_i359.ChatBloc>(
        () => _i359.ChatBloc(fetchChat: gh<_i1020.FetchChatUserCase>()));
    gh.factory<_i786.TimetableBloc>(() =>
        _i786.TimetableBloc(fetchTimetable: gh<_i753.InitTimetableUserCase>()));
    gh.lazySingleton<_i411.ForgotPasswordUserCase>(
        () => _i411.ForgotPasswordUserCase(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i556.InformationUserCase>(
        () => _i556.InformationUserCase(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i245.TwoFactorUserCase>(
        () => _i245.TwoFactorUserCase(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i245.VerifyEmailUserCase>(
        () => _i245.VerifyEmailUserCase(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i245.VerifyPasswordUserCase>(
        () => _i245.VerifyPasswordUserCase(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i492.ResetPassword>(
        () => _i492.ResetPassword(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i356.SetNewPasswordUserCase>(
        () => _i356.SetNewPasswordUserCase(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i627.SignInUserCase>(
        () => _i627.SignInUserCase(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i488.SignOut>(() => _i488.SignOut(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i287.SignUpUserCase>(
        () => _i287.SignUpUserCase(gh<_i936.AuthRepo>()));
    gh.factory<_i715.AuthBloc>(() => _i715.AuthBloc(
          signIn: gh<_i627.SignInUserCase>(),
          twoFactor: gh<_i245.TwoFactorUserCase>(),
          password: gh<_i245.VerifyPasswordUserCase>(),
          forgotPassword: gh<_i411.ForgotPasswordUserCase>(),
          verifyEmail: gh<_i245.VerifyEmailUserCase>(),
          signUp: gh<_i287.SignUpUserCase>(),
          resetPassword: gh<_i492.ResetPassword>(),
          verifyPassword: gh<_i245.VerifyPasswordUserCase>(),
          setnewpassword: gh<_i356.SetNewPasswordUserCase>(),
          signOut: gh<_i488.SignOut>(),
          informationUserCase: gh<_i556.InformationUserCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i107.RegisterModule {}
