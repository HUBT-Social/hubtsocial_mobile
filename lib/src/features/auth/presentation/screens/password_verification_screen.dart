import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/container_auth.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/input_auth_otp.dart';
import '../../../../core/navigation/route.dart';
import '../../../../core/presentation/dialog/app_dialog.dart';
import '../bloc/auth_bloc.dart';

class PasswordVerifiCationScreen extends StatefulWidget {
  const PasswordVerifiCationScreen({required this.maskEmail, super.key});

  final String maskEmail;

  @override
  State<PasswordVerifiCationScreen> createState() =>
      _PasswordVerifiCationScreenState();
}

class _PasswordVerifiCationScreenState
    extends State<PasswordVerifiCationScreen> {
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) async {
          logger.d('Current state: $state');
          if (state is AuthError) {
            AppDialog.showMessageDialog(
                AppDialog.errorMessage(state.message, context));
          } else if (state is AuthLoading) {
            AppDialog.showLoadingDialog(message: context.loc.password_verify);
          } else if (state is VerifyForgotPasswordSuccess) {
            AppDialog.closeDialog();
            AppRoute.setNewPassword.pushReplacement(context);
          } else {
            AppDialog.closeDialog();
            logger.d(state.toString());
          }
        },
        builder: (context, state) {
          return ContainerAuth(
            children: [
              Text(
                context.loc.password_verify,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12),
              Text(
                context.loc.enter_otp_message(widget.maskEmail),
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
                    context.loc.continue_text,
                    style: context.textTheme.bodyLarge
                        ?.copyWith(color: context.colorScheme.onPrimary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
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

    context.read<AuthBloc>().add(VerifyPasswordEvent(
          postcode: otpController.text.trim(),
        ));
  }
}
