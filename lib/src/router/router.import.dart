import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:hubtsocial_mobile/src/features/chat/presentation/bloc/receive_chat/receive_chat_cubit.dart';
import 'package:hubtsocial_mobile/src/features/room_chat/presentation/bloc/room_chat_bloc.dart';
import 'package:hubtsocial_mobile/src/features/room_chat/presentation/screens/room_chat_info.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/core/presentation/screens/not_found_screen.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/screens/email_verify_screen.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/screens/get_started_screen.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/screens/two_factor_screen.dart';
import 'package:hubtsocial_mobile/src/features/home/presentation/screens/home_screen.dart';
import 'package:hubtsocial_mobile/src/features/menu/presentation/screens/menu_screen.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';

import '../features/auth/domain/entities/user_token.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/screens/auth_screen.dart';
import '../features/auth/presentation/screens/password_successful_screen.dart';
import '../features/auth/presentation/screens/password_verification_screen.dart';
import '../features/auth/presentation/screens/set_new_password_screen.dart';
import '../features/auth/presentation/screens/sign_up_information_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/chat/presentation/screens/chat_screen.dart';
import '../features/main_wrapper/ui/main_wrapper.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screens.dart';
import '../features/profile/presentation/screens/full_screens.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/room_chat/presentation/screens/room_chat_screen.dart';
import '../features/timetable/presentation/screens/timetable_screen_new.dart';
import '../features/user/presentation/bloc/user_bloc.dart';
import '../core/injections/injections.dart';
import '../core/local_storage/local_storage_key.dart';
import '../core/logger/logger.dart';

part 'router.dart';
part 'router.main.dart';
part 'router.auth.dart';
