import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/navigation/route.dart';
import '../../../../core/presentation/dialog/app_dialog.dart';
import '../../../../core/presentation/input/input_field.dart';

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
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding:
                    EdgeInsets.only(right: 12, left: 12, top: 24, bottom: 12),
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
                      context.loc.set_new_password,
                      style: context.textTheme.headlineMedium?.copyWith(
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
                            child: InputField.password(
                              controller: _newPasswordController,
                              textInputAction: TextInputAction.done,
                              hintText: context.loc.password,
                              prefixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Icon(
                                  Icons.lock_rounded,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: InputField.password(
                              controller: _confirmNewPasswordController,
                              textInputAction: TextInputAction.done,
                              hintText: context.loc.password,
                              prefixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Icon(
                                  Icons.lock_rounded,
                                ),
                              ),
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
                          style: context.textTheme.bodyLarge
                              ?.copyWith(color: context.colorScheme.onPrimary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
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
