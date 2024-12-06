import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/presentation/input/input_field.dart';
import '../../../../core/navigation/route.dart';
import '../../../../core/presentation/dialog/app_dialog.dart';
import '../bloc/auth_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _usernameOrEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String savedEmail = '';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) async {
          logDebug('Current state: $state');
          if (state is AuthError) {
            AppDialog.showMessageDialog(
                AppDialog.errorMessage(state.message, context));
          } else if (state is AuthLoading) {
            AppDialog.showLoadingDialog(message: context.loc.forgot_password);
          } else if (state is VerifyForgotPassword) {
            AppDialog.closeDialog();
            AppRoute.passwordVerify.push(context);
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
                      context.loc.forgot_password,
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      context.loc.enter_message,
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
                                onChanged: (value) {
                                  // context.read<AuthBloc>().add(
                                  //     UpdateEmailEvent(value.trim()));
                                }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    FilledButton(
                      onPressed: () {
                        _onSignInButtonClicked();
                        AppRoute.passwordVerify.path;
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

  void _onSignInButtonClicked() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.closeKeyboard();

    // String email = '';
    // final emailState = context.read<AuthBloc>().state;
    // if (emailState is EmailUpdatedState) {
    //   email = emailState.email;
    // }
    context.read<AuthBloc>().add(
          ForgotPasswordEvent(
              usernameOrEmail: _usernameOrEmailController.text.trim()),
        );
  }
}
