import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/logger/logger.dart';
import '../../../../router/route.dart';
import '../../../../core/presentation/dialog/app_dialog.dart';
import '../../../../core/presentation/widget/input_field.dart';
import '../widgets/container_auth.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) async {
          if (state is AuthError) {
            AppDialog.showMessageDialog(AppDialog.errorMessage(
              state.message,
              context,
            ));
          } else if (state is AuthLoading) {
            AppDialog.showLoadingDialog(message: context.loc.set_new_password);
          } else if (state is SetNewPasswordSuccess) {
            AppDialog.closeDialog();
            AppRoute.passwordSuccessful.go(context);
          } else {
            AppDialog.closeDialog();
            logger.d(state.toString());
          }
        },
        builder: (context, state) {
          return ContainerAuth(
            children: [
              Text(
                context.loc.set_new_password,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: InputField.password(
                        controller: _newPasswordController,
                        textInputAction: TextInputAction.done,
                        hintText: context.loc.password,
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          size: 28.r,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: InputField.password(
                        controller: _confirmNewPasswordController,
                        textInputAction: TextInputAction.done,
                        hintText: context.loc.password,
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          size: 28.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

    context.read<AuthBloc>().add(SetNewPasswordEvent(
          newPassword: _newPasswordController.text.trim(),
          confirmNewPassword: _confirmNewPasswordController.text.trim(),
        ));
  }
}
