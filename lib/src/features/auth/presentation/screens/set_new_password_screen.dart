import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/navigation/route.dart';
import '../../../../core/presentation/dialog/app_dialog.dart';
import '../../../../core/presentation/input/input_field.dart';
import '../widgets/background.dart';
import '../widgets/system_setting.dart';

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
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) async {
          if (state is AuthError) {
            // AuthError when the user is not found
            AppDialog.showMessageDialog(
                AppDialog.errorMessage(state.message, context));
          } else if (state is AuthLoading) {
            // Shown Loading Dialog
            AppDialog.showLoadingDialog(message: 'signing');
          } else if (state is SetNewPasswordSuccess) {
            AppDialog.closeDialog();
            AppRoute.signIn.pushReplacement(context);
          } else {
            AppDialog.closeDialog();
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: InputField.name(
                                    controller: _newPasswordController,
                                    textInputAction: TextInputAction.next,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        AppRoute.forgotPassword.push(context);
                                      },
                                      child: Text(
                                        context
                                            .loc.forgot_password_question_mark,
                                        style: context.textTheme.labelLarge
                                            ?.copyWith(
                                          color:
                                              context.colorScheme.surfaceTint,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
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
                          SizedBox(
                            height: 12,
                          ),
                          InkWell(
                            onTap: () {
                              AppRoute.signUp.push(context);
                            },
                            child: Text(
                              context.loc.do_not_have_an_account,
                              style: context.textTheme.labelLarge?.copyWith(
                                color: context.colorScheme.surfaceTint,
                              ),
                            ),
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

    context.read<AuthBloc>().add(SetNewPasswordEvent(
          newPassword: _newPasswordController.text.trim(),
          confirmNewPassword: _confirmNewPasswordController.text.trim(),
        ));
  }
}
