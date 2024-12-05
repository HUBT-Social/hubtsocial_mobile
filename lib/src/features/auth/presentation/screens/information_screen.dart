import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/presentation/input/input_field.dart';

import '../../../../core/navigation/route.dart';
import '../widgets/background.dart';
import '../widgets/system_setting.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final _studentCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Background(),
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
                      "Information",
                      style: context.textTheme.displaySmall?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 6),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: InputField.name(
                            hintText: context.loc.user_name,
                            controller: _studentCodeController,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Icon(
                                Icons.person,
                              ),
                            ),
                            onChanged: (value) {},
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
                          "I Agree with",
                          style: context.textTheme.labelLarge,
                        ),
                        InkWell(
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
                    FilledButton(
                      onPressed: () {
                        AppRoute.home.pushReplacement(context);
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
    ));
  }
}
