import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/ui/input/input_field.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/background.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/system_setting.dart';
import '../../../../core/navigation/route.dart';
import '../../../../core/ui/dialog/app_dialog.dart';
import '../bloc/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();
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
          } else if (state is SignedIn) {
            // SignedIn and move to Dashboard
            AppDialog.showMessageDialog(
                AppDialog.sucessMessage('wellcomeBack', context));
            AppDialog.closeDialog();
            AppRoute.splash.go(context);
          } else if (state is AuthLoading) {
            // Shown Loading Dialog
            AppDialog.showLoadingDialog(message: 'signing');
          } else if (state is VerifyTwoFactor) {
            //Phone number is valid and move to Verification Screen
            AppDialog.closeDialog();
            AppRoute.twoFactor.push(context);
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
                            context.loc.sign_in,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
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
                              _onSignInButtonClicked();
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                context.loc.sign_in,
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
