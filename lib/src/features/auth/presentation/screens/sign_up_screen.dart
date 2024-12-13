import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/presentation/input/input_field.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/navigation/route.dart';
import '../../../../core/presentation/dialog/app_dialog.dart';
import '../widgets/container_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isAgreePolicy = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: BlocConsumer<AuthBloc, AuthState>(
      listener: (_, state) async {
        if (state is AuthError) {
          // AuthError when the user is not found
          AppDialog.showMessageDialog(
              AppDialog.errorMessage(state.message, context));
        } else if (state is AuthLoading) {
          // Shown Loading Dialog
          AppDialog.showLoadingDialog(message: 'sign up');
        } else if (state is VerifyEmail) {
          AppDialog.closeDialog();
          AppRoute.emailVerify.pushReplacement(context,
              queryParameters: {"email": _emailController.text.trim()});
        } else {
          AppDialog.closeDialog();
          logDebug(state.toString());
        }
      },
      builder: (context, state) {
        return ContainerAuth(
          children: [
            Text(
              context.loc.sign_up,
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
                    child: InputField.name(
                      hintText: context.loc.user_name,
                      controller: _userNameController,
                      textInputAction: TextInputAction.next,
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
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: InputField.email(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(
                          Icons.email,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: InputField.password(
                      hintText: context.loc.password,
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(
                          Icons.lock,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: InputField.password(
                      hintText: context.loc.confirm_password,
                      controller: _confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(
                          Icons.lock,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  value: isAgreePolicy,
                  onChanged: (value) {
                    setState(
                      () {
                        isAgreePolicy = value!;
                      },
                    );
                  },
                ),
                Text(
                  "I Agree with",
                  // AppLocalizations.of(context).hashCode.toString(),
                  style: context.textTheme.labelLarge,
                ),
                InkWell(
                  autofocus: false,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: Container(
                              height: 300,
                              width: 300,
                              color: context.colorScheme.surface,
                              child: Text("data"),
                            ),
                          );
                        });
                  },
                  child: Text(
                    " privacy and policy",
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colorScheme.surfaceTint,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                _onSignUpButtonClicked();
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
            InkWell(
              autofocus: false,
              onTap: () {
                AppRoute.signIn.push(context);
              },
              child: Text(
                context.loc.already_have_an_account,
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.surfaceTint,
                ),
              ),
            ),
          ],
        );
      },
    ));
  }

  void _onSignUpButtonClicked() {
    if (!_formKey.currentState!.validate() && isAgreePolicy) {
      return;
    }

    context.closeKeyboard();

    context.read<AuthBloc>().add(SignUpEvent(
          userName: _userNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          confirmPassword: _confirmPasswordController.text.trim(),
        ));
  }
}
