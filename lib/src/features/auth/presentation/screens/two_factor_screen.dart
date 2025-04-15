import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/input_auth_otp.dart';

import '../../../../core/logger/logger.dart';
import '../../../../router/route.dart';
import '../../../../core/presentation/dialog/app_dialog.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/container_auth.dart';
import '../widgets/otp_count_down_timer.dart';

class TwoFactorPage extends StatefulWidget {
  const TwoFactorPage({required this.maskEmail, super.key});

  final String maskEmail;
  @override
  State<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
  final otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late CountdownTimerController countdownTimerController;

  @override
  void initState() {
    super.initState();
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 150; //2m30s
    countdownTimerController =
        CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  void onEnd() {
    try {
      context.pop();
      AppDialog.showMessageDialog(
          AppDialog.errorMessage(context.loc.otp_expire_message, context));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) async {
          if (state is AuthError) {
            AppDialog.showMessageDialog(
                AppDialog.errorMessage(state.message, context));
          } else if (state is VerifyTwoFactorSuccess) {
            countdownTimerController.dispose();
            AppDialog.showMessageDialog(
                AppDialog.successMessage(context.loc.welcome, context));
            AppDialog.closeDialog();
            AppRoute.home.go(context);
          } else if (state is AuthLoading) {
            AppDialog.showLoadingDialog(message: 'signing');
          } else {
            AppDialog.closeDialog();
            logger.d(state.toString());
          }
        },
        builder: (context, state) {
          return ContainerAuth(
            children: [
              Text(
                context.loc.enter_code,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              Text(
                context.loc.enter_otp_message(widget.maskEmail),
                textAlign: TextAlign.center,
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              Form(
                key: _formKey,
                child: InputAuthOTP(
                  controller: otpController,
                  onCompleted: (value) {
                    _onTwoFactorButtonClicked();
                  },
                ),
              ),
              FilledButton(
                onPressed: () {
                  _onTwoFactorButtonClicked();
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    context.loc.sign_in,
                    style: context.textTheme.bodyLarge
                        ?.copyWith(color: context.colorScheme.onPrimary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OtpCountDownTimer(
                      countdownTimerController: countdownTimerController),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _onTwoFactorButtonClicked() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.closeKeyboard();

    context.read<AuthBloc>().add(
          TwoFactorEvent(
            postcode: otpController.text.trim(),
          ),
        );
  }
}
