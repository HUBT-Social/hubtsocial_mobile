import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hubtsocial_mobile/src/core/navigation/route.dart';
import 'package:hubtsocial_mobile/src/core/presentation/screens/not_found_screen.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/screens/email_verify_screen.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/screens/get_started_screen.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/screens/information_screen.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/screens/two_factor_screen.dart';
import 'package:hubtsocial_mobile/src/features/home/ui/pages/home_page.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';

import '../../features/auth/domain/entities/user_token.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/main_wrapper/ui/main_wrapper.dart';
import '../../features/notifications/ui/pages/notifications_page.dart';
import '../../features/profile/domain/entities/user.dart';
import '../../features/profile/ui/pages/profile_screen.dart';
import '../app/providers/user_provider.dart';
import '../injections/injections.dart';
import '../logger/logger.dart';

part 'router.dart';
