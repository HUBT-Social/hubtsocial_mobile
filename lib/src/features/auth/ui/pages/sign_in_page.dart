import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/ui/input/input_field.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/widgets/background.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/widgets/system_setting.dart';

import '../../../../core/navigation/route.dart';
import '../../../../core/ui/widget/loading_overlay.dart';
import '../../bloc/auth_cubit.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: _onAuthState,
      builder: (context, state) {
        return LoadingOverlay(
          loading: state is AuthLoading,
          child: Scaffold(
            body: Stack(
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
                                    child: InputField.name(
                                      controller: _userNameController,
                                      textInputAction: TextInputAction.next,
                                      hintText: context.loc.user_name,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          context.loc
                                              .forgot_password_question_mark,
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
            ),
          ),
        );
      },
    );
  }

  void _onAuthState(BuildContext context, AuthState state) {
    if (state is AuthFailure) {
      context.showSnackBarMessage(
        state.errorMessage,
        isError: true,
      );
      return;
    }

    if (state is AuthSuccess) {
      if (state.user != null) {
        AppRoute.home.go(context);
      }
    }
  }

  void _onLoginButtonClicked() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.closeKeyboard();

    final userName = _userNameController.text.trim();
    final password = _passwordController.text.trim();

    context.read<AuthCubit>().signInWithEmailAndPassword(
          email: userName,
          password: password,
        );
  }
}
