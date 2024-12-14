import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/input_auth_otp.dart';

import '../../../../core/logger/logger.dart';
import '../../../../core/navigation/route.dart';
import '../../../../core/presentation/dialog/app_dialog.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/container_auth.dart';

class TwoFactorPage extends StatefulWidget {
  const TwoFactorPage({required this.maskEmail, super.key});

  final String maskEmail;
  @override
  State<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
  final otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) async {
          if (state is AuthError) {
            AppDialog.showMessageDialog(
                AppDialog.errorMessage(state.message, context));
          } else if (state is SignedIn) {
            AppDialog.showMessageDialog(
                AppDialog.successMessage('wellcomeBack', context));
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
                child: InputAuthOTP(
                  controller: otpController,
                  onCompleted: (value) {
                    _onTwoFactorButtonClicked();
                  },
                ),
              ),
              SizedBox(height: 12),
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
