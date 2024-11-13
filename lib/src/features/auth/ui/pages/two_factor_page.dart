import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/ui/input/input_field.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/widgets/background.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/widgets/system_setting.dart';

import '../../../../core/navigation/route.dart';
import '../../../../core/navigation/router.dart';
import '../../../../core/ui/dialog/dialogs.dart';
import '../../../../core/ui/widget/loading_overlay.dart';
import '../bloc/auth_bloc.dart';

class TwoFactorPage extends StatefulWidget {
  const TwoFactorPage({super.key});

  @override
  State<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
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
            Dialogs.showMessageDialog(
                Dialogs.errorMessage(state.message, context));
          } else if (state is SignedIn) {
            // SignedIn and move to Dashboard
            Dialogs.showMessageDialog(
                Dialogs.sucessMessage('wellcomeBack', context));
            // AppNavigator.pauseAndPushNewScreenWithoutBack(
            //     context: context, routname: Dashboard.routeName, delayTime: 2);
          } else if (state is AuthLoading) {
            // Shown Loading Dialog
            // SmartDialog.showLoading();
            Dialogs.showLoadingDialog(message: 'signing');
          } else if (state is VerifyingTwoFactor) {
            Dialogs.showLoadingDialog(message: 'signing');
            // Phone number is valid and move to Verification Screen
            // AppNavigator.pauseAndPushScreen(
            //   context: context,
            //   routname: VerificationScreen.routeName,
            //   delayTime: 0,
            //   arguments: {
            //     'phoneNumber': phoneNumberController.text.trim(),
            //   },
            // );
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
                            style: context.textTheme.displaySmall?.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 6),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: InputField(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          value: true,
                                          onChanged: (value) {},
                                        ),
                                        Text(
                                          context.loc.remember_me,
                                          style: context.textTheme.labelLarge,
                                        ),
                                      ],
                                    ),
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
                          FilledButton(
                            onPressed: () {
                              _onLoginButtonClicked();
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

  void _onLoginButtonClicked() {
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
