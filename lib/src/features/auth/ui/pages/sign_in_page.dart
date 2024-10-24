import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/ui/input/input_field.dart';

import '../../../../core/configs/assets.dart';
import '../../../../core/localization/ui/widget/button_change_localization.dart';
import '../../../../core/navigation/route.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _studentCodeController = TextEditingController();
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
              width: 320,
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadiusDirectional.all(Radius.circular(24)),
                boxShadow: [
                  // BoxShadow(
                  //   color: context.colorScheme.shadow.withAlpha(192),
                  //   blurRadius: 24,
                  // ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          context.loc.sign_in,
                          style: context.textTheme.displaySmall?.copyWith(
                              color: context.colorScheme.tertiary,
                              fontWeight: FontWeight.w800),
                        ),
                        InputField(
                          controller: _studentCodeController,
                          label: "label",
                          textInputAction: TextInputAction.next,
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
                          context.loc.sign_in,
                          style: context.textTheme.bodyLarge
                              ?.copyWith(color: context.colorScheme.onPrimary),
                          textAlign: TextAlign.center,
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
        Row(
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
      ],
    ));
  }
}
