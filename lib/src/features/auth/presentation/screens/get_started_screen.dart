import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/navigation/route.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              context.loc.app_name,
              textAlign: TextAlign.center,
              style: context.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: context.colorScheme.surface,
                shadows: [
                  Shadow(
                    color: context.colorScheme.shadow.withAlpha(92),
                    offset: Offset(0, 4),
                    blurRadius: 24,
                  ),
                ],
              ),
            ),
          ),
          Container(
            // height: 220.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(24),
                topEnd: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.shadow.withAlpha(192),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 36, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text(
                    context.loc.welcome,
                    style: context.textTheme.displayMedium?.copyWith(
                        color: context.colorScheme.tertiary,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    context.loc.welcome_info,
                    style: context.textTheme.labelLarge
                        ?.copyWith(color: context.colorScheme.tertiary),
                  ),
                  SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      AppRoute.signIn.pushReplacement(context);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        context.loc.sign_in,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.onPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        autofocus: false,
                        onTap: () {
                          AppRoute.signUp.pushReplacement(context);
                        },
                        child: Text(
                          context.loc.do_not_have_an_account,
                          style: context.textTheme.labelLarge?.copyWith(
                            color: context.colorScheme.surfaceTint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
