import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/presentation/widget/input_field.dart';
import '../../../../core/logger/logger.dart';
import '../../../../router/route.dart';
import '../../../../core/presentation/dialog/app_dialog.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/container_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();
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
            AppRoute.home.go(context);
          } else if (state is AuthLoading) {
            AppDialog.showLoadingDialog(message: 'signing');
          } else if (state is VerifyTwoFactor) {
            AppDialog.closeDialog();
            AppRoute.twoFactor
                .push(context, queryParameters: {"maskEmail": state.maskEmail});
          } else {
            AppDialog.closeDialog();
            logger.d(state.toString());
          }
        },
        builder: (context, state) {
          return ContainerAuth(
            children: [
              Text(
                context.loc.sign_in,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.r),
                      child: InputField.name(
                        controller: _usernameOrEmailController,
                        textInputAction: TextInputAction.next,
                        hintText: context.loc.username_or_email,
                        prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Icon(
                            Icons.person,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.r),
                      child: InputField.password(
                        controller: _passwordController,
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
                          autofocus: false,
                          onTap: () {
                            AppRoute.forgotPassword.push(context);
                          },
                          child: Text(
                            context.loc.forgot_password_question_mark,
                            style: context.textTheme.labelLarge?.copyWith(
                              color: context.colorScheme.surfaceTint,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              FilledButton(
                onPressed: () {
                  _onSignInButtonClicked();
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
              SizedBox(height: 12.h),
              InkWell(
                autofocus: false,
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
            ],
          );
        },
      ),
    );
  }

  void _onSignInButtonClicked() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.closeKeyboard();

    context.read<AuthBloc>().add(SignInEvent(
          usernameOrEmail: _usernameOrEmailController.text.trim(),
          password: _passwordController.text.trim(),
        ));
  }
}
