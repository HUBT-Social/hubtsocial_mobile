import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/widgets/background.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/widgets/input_two_factor.dart';
import 'package:hubtsocial_mobile/src/features/auth/ui/widgets/system_setting.dart';
import '../../../../core/ui/dialog/app_dialog.dart';
import '../bloc/auth_bloc.dart';

class TwoFactorPage extends StatefulWidget {
  const TwoFactorPage({super.key});

  @override
  State<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
  final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();
  final otp5Controller = TextEditingController();
  final otp6Controller = TextEditingController();
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
            // AppNavigator.pauseAndPushNewScreenWithoutBack(
            //     context: context, routname: Dashboard.routeName, delayTime: 2);
          } else if (state is AuthLoading) {
            // Shown Loading Dialog
            // SmartDialog.showLoading();
            AppDialog.showLoadingDialog(message: 'đang xác thực');
          } else if (state is VerifyingTwoFactor) {
            // Phone number is valid and move to Verification Screen
            // AppNavigator.pauseAndPushScreen(
            //   context: context,
            //   routname: VerificationScreen.routeName,
            //   delayTime: 0,
            //   arguments: {
            //     'phoneNumber': phoneNumberController.text.trim(),
            //   },
            // );
          } else {
            AppDialog.closeDialog();
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
                            context.loc.enter_code,
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InputAuthOTP(
                                          otpController: otp1Controller),
                                      InputAuthOTP(
                                          otpController: otp2Controller),
                                      InputAuthOTP(
                                          otpController: otp3Controller),
                                      InputAuthOTP(
                                          otpController: otp4Controller),
                                      InputAuthOTP(
                                          otpController: otp5Controller),
                                      InputAuthOTP(
                                          otpController: otp6Controller),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FilledButton(
                            onPressed: () {
                              _onTwoFactorButtonClicked();
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

  void _onTwoFactorButtonClicked() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.closeKeyboard();
    String code = "";
    code += otp1Controller.text.trim();
    code += otp2Controller.text.trim();
    code += otp3Controller.text.trim();
    code += otp4Controller.text.trim();
    code += otp5Controller.text.trim();
    code += otp6Controller.text.trim();
    if (code.length == 6) {
      context.read<AuthBloc>().add(TwoFactorEvent(
            postcode: code,
          ));
    } else {
      // otp1Controller.clear();
      // otp2Controller.clear();
      // otp3Controller.clear();
      // otp4Controller.clear();
      // otp5Controller.clear();
      // otp6Controller.clear();
    }
  }
}
