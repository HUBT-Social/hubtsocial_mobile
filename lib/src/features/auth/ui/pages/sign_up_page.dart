import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/ui/input/input_field.dart';

import '../../../../core/configs/assets.dart';
import '../../../../core/navigation/route.dart';
import '../widgets/system_setting.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _studentCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            Assets.startedBg,
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: SingleChildScrollView(
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
                      context.loc.sign_up,
                      style: context.textTheme.displaySmall?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 6),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: InputField.number(
                            hintText: context.loc.student_code,
                            controller: _studentCodeController,
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
                          child: InputField.email(
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
                          child: InputField.email(
                            hintText: context.loc.confirm_password,
                            controller: _confirmPasswordController,
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
                      ],
                    ),
                    FilledButton(
                      onPressed: () {
                        AppRoute.home.go(context);
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
                      height: 50,
                    ),
                    InkWell(
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
    ));
  }
}
