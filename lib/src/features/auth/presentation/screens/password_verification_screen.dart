import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/background.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/input_auth_otp.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/system_setting.dart';
import '../../../../core/api/api_request.dart';
import '../../../../core/configs/countdown_timer.dart';
import '../../../../core/configs/end_point.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/local_storage/local_storage_key.dart';
import '../../../../core/navigation/route.dart';
import '../../../../core/presentation/dialog/app_dialog.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/sign_in_response_model.dart';
import '../../domain/usecases/forgot_password_user_case.dart';
import '../bloc/auth_bloc.dart';
import 'forgot_password_screen.dart';

class PasswordVerifiCationScreen extends StatefulWidget {
  const PasswordVerifiCationScreen({super.key});

  @override
  State<PasswordVerifiCationScreen> createState() =>
      _PasswordVerifiCationScreenState();
}

class _PasswordVerifiCationScreenState
    extends State<PasswordVerifiCationScreen> {
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late CountdownTimer countdownTimer;
  // String email = '';
  @override
  void initState() {
    super.initState();
    countdownTimer = CountdownTimer(seconds: 180);
    countdownTimer.start(() {
      AppDialog.showMessageDialog(
          AppDialog.errorMessage(context.loc.otp_expired, context));
    });

    // final emailState = context.read<AuthBloc>().state;
    // if (emailState is EmailUpdatedState) {
    //   email = emailState.email;
    // }
  }

  @override
  void dispose() {
    countdownTimer.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) async {
          logDebug('Current state: $state');
          if (state is AuthError) {
            AppDialog.showMessageDialog(
                AppDialog.errorMessage(state.message, context));
          } else if (state is AuthLoading) {
            AppDialog.showLoadingDialog(message: context.loc.password_verify);
          } else if (state is VerifyForgotPasswordSuccess) {
            AppDialog.closeDialog();
            AppRoute.setNewPassword.push(context);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Background(),
              Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      padding: EdgeInsets.only(
                          right: 12, left: 12, top: 24, bottom: 12),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        borderRadius:
                            BorderRadiusDirectional.all(Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.shadow.withAlpha(128),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.loc.password_verify,
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            context.loc.enter_otp_message,
                            textAlign: TextAlign.center,
                            style: context.textTheme.titleSmall?.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 12),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: InputAuthOTP(
                                          controller: otpController,
                                          onCompleted: (value) {
                                            _onVerifyButtonClicked();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          FilledButton(
                            onPressed: () {
                              _onVerifyButtonClicked();
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                context.loc.continue_text,
                                style: context.textTheme.bodyLarge?.copyWith(
                                    color: context.colorScheme.onPrimary),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // context.read<AuthBloc>().add(
                                  //     ForgotPasswordEvent(
                                  //         usernameOrEmail: email));
                                  countdownTimer.reset();
                                  countdownTimer.start(() {
                                    AppDialog.showMessageDialog(
                                        AppDialog.errorMessage(
                                            context.loc.otp_expired, context));
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.refresh,
                                        size: 20,
                                        color: context.colorScheme.primary),
                                    SizedBox(width: 4),
                                    Text(
                                      context.loc.resend,
                                      style: context.textTheme.labelLarge
                                          ?.copyWith(
                                        color: context.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedBuilder(
                                animation: countdownTimer,
                                builder: (context, child) {
                                  return Text(
                                    '${context.loc.the_code_will} ${countdownTimer.formattedTime}',
                                    style:
                                        context.textTheme.titleSmall?.copyWith(
                                      color: context.colorScheme.onSurface,
                                    ),
                                    textAlign: TextAlign.right,
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              BackButton(),
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SystemSetting(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onVerifyButtonClicked() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.closeKeyboard();

    context.read<AuthBloc>().add(VerifyPasswordEvent(
          postcode: otpController.text.trim(),
        ));
  }
}
