import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/ui/input/input_field.dart';

import '../../../../core/configs/assets.dart';
import '../../../../core/localization/ui/widget/button_change_localization.dart';
import '../../../../core/navigation/route.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _studentCodeController = TextEditingController();
  final _passwordController = TextEditingController();
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
            child: Container(
              width: 380,
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadiusDirectional.all(Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.shadow.withAlpha(128),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(right: 12, left: 12, top: 24, bottom: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.loc.sign_up,
                      style: context.textTheme.displaySmall?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: InputField(
                            controller: _studentCodeController,
                            textInputAction: TextInputAction.next,
                            hintText: context.loc.student_code,
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
                            controller: _studentCodeController,
                            textInputAction: TextInputAction.next,
                            // hintText: Em,
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
                          child: InputField(
                            controller: _studentCodeController,
                            textInputAction: TextInputAction.next,
                            hintText: context.loc.student_code,
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
                          child: InputField(
                            controller: _studentCodeController,
                            textInputAction: TextInputAction.next,
                            hintText: context.loc.student_code,
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
                          child: InputField.password(
                            controller: _passwordController,
                            textInputAction: TextInputAction.next,
                            hintText: "••••••••••",
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
                            controller: _passwordController,
                            textInputAction: TextInputAction.next,
                            hintText: "••••••••••",
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
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
                    FilledButton(
                      onPressed: () {
                        AppRoute.home.go(context);
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
                    SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      child: Text(
                        context.loc.do_not_have_an_account,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  children: [
                    ButtonChangeLocalization(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
