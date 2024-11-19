// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:hubtsocial_mobile/src/core/injections/module.dart' as _i107;
import 'package:hubtsocial_mobile/src/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i953;
import 'package:hubtsocial_mobile/src/features/auth/data/repos/auth_repo_impl.dart'
    as _i457;
import 'package:hubtsocial_mobile/src/features/auth/domain/repos/auth_repo.dart'
    as _i936;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/otp_user_case.dart'
    as _i245;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/reset_password.dart'
    as _i492;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/sign_in_user_case.dart'
    as _i627;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/sign_out.dart'
    as _i488;
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/sign_up_user_case.dart'
    as _i287;
import 'package:hubtsocial_mobile/src/features/auth/presentation/bloc/auth_bloc.dart'
    as _i715;
import 'package:hubtsocial_mobile/src/features/profile/domain/repos/user_profile_repo.dart'
    as _i81;
import 'package:hubtsocial_mobile/src/features/profile/domain/usecases/change_password.dart'
    as _i462;
import 'package:hubtsocial_mobile/src/features/profile/domain/usecases/init_user_profile.dart'
    as _i223;
import 'package:hubtsocial_mobile/src/features/profile/domain/usecases/update_user_profile.dart'
    as _i62;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i979.HiveInterface>(() => registerModule.hive);
    gh.lazySingleton<_i892.FirebaseMessaging>(
        () => registerModule.firebaseMessaging);
    gh.lazySingleton<_i953.AuthRemoteDataSource>(
        () => _i953.AuthRemoteDataSourceImpl(
              hiveAuth: gh<_i979.HiveInterface>(),
              prefs: gh<_i460.SharedPreferences>(),
              messaging: gh<_i892.FirebaseMessaging>(),
            ));
    gh.lazySingleton<_i462.ChangePassword>(
        () => _i462.ChangePassword(gh<_i81.UserRepo>()));
    gh.lazySingleton<_i223.InitUserProfile>(
        () => _i223.InitUserProfile(gh<_i81.UserRepo>()));
    gh.lazySingleton<_i62.UpdateUserProfile>(
        () => _i62.UpdateUserProfile(gh<_i81.UserRepo>()));
    gh.lazySingleton<_i936.AuthRepo>(
        () => _i457.AuthRepoImpl(gh<_i953.AuthRemoteDataSource>()));
    gh.lazySingleton<_i492.ResetPassword>(
        () => _i492.ResetPassword(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i488.SignOut>(() => _i488.SignOut(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i627.SignInUserCase>(
        () => _i627.SignInUserCase(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i287.SignUpUserCase>(
        () => _i287.SignUpUserCase(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i245.TwoFactorUserCase>(
        () => _i245.TwoFactorUserCase(gh<_i936.AuthRepo>()));
    gh.lazySingleton<_i245.VerifyEmailUserCase>(
        () => _i245.VerifyEmailUserCase(gh<_i936.AuthRepo>()));
    gh.factory<_i715.AuthBloc>(() => _i715.AuthBloc(
          signIn: gh<_i627.SignInUserCase>(),
          twoFactor: gh<_i245.TwoFactorUserCase>(),
          verifyEmail: gh<_i245.VerifyEmailUserCase>(),
          signUp: gh<_i287.SignUpUserCase>(),
          resetPassword: gh<_i492.ResetPassword>(),
          signOut: gh<_i488.SignOut>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i107.RegisterModule {}
