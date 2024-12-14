import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/input_auth_otp.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/navigation/route.dart';
import '../../../../core/presentation/dialog/app_dialog.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/container_auth.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({required this.email, super.key});
  final String email;

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // late CountdownTimer countdownTimer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) async {
          if (state is AuthError) {
            AppDialog.showMessageDialog(
                AppDialog.errorMessage(state.message, context));
          } else if (state is SignedIn) {
            AppRoute.signUpInformation.pushReplacement(context);
          } else if (state is AuthLoading) {
            AppDialog.showLoadingDialog(message: 'Verify');
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
              SizedBox(height: 12),
              Text(
                context.loc.enter_otp_message(widget.email),
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
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  _onVerifyButtonClicked();
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // context.read<AuthBloc>().add(
                      //     ForgotPasswordEvent(
                      //         usernameOrEmail: email));
                      // countdownTimer.reset();
                      // countdownTimer.start(() {
                      //   AppDialog.showMessageDialog(
                      //       AppDialog.errorMessage(
                      //           context.loc.otp_expired, context));
                      // });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.refresh,
                            size: 20, color: context.colorScheme.primary),
                        SizedBox(width: 4),
                        Text(
                          context.loc.resend,
                          style: context.textTheme.labelLarge?.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // AnimatedBuilder(
                  //   animation: countdownTimer,
                  //   builder: (context, child) {
                  //     return Text(
                  //       '${context.loc.the_code_will} ${countdownTimer.formattedTime}',
                  //       style:
                  //           context.textTheme.titleSmall?.copyWith(
                  //         color: context.colorScheme.onSurface,
                  //       ),
                  //       textAlign: TextAlign.right,
                  //     );
                  //   },
                  // ),
                ],
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

    context.read<AuthBloc>().add(VerifyEmailEvent(
          postcode: otpController.text.trim(),
        ));
  }
}
