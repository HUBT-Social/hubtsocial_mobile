import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/presentation/input/input_field.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/configs/assets.dart';
import '../../../../core/navigation/route.dart';
import '../../../../core/presentation/dialog/app_dialog.dart';
import '../widgets/background.dart';

class SignUpInformationScreen extends StatefulWidget {
  const SignUpInformationScreen({super.key});

  @override
  State<SignUpInformationScreen> createState() =>
      _SignUpInformationScreenState();
}

class _SignUpInformationScreenState extends State<SignUpInformationScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthOfDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool isAgreePolicy = false;
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
        } else if (state is AuthLoading) {
          // Shown Loading Dialog
          AppDialog.showLoadingDialog(message: context.loc.signup_information);
        } else if (state is VerifySignUp) {
          AppDialog.closeDialog();
          AppRoute.signIn.push(context);
        } else {
          AppDialog.closeDialog();
          logDebug(state.toString());
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
                          context.loc.signup_information,
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
                                  hintText: context.loc.first_name,
                                  controller: _firstNameController,
                                  textInputAction: TextInputAction.next,
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: SvgPicture.asset(
                                        AppIcons.iconFirstName),
                                  ),
                                  onChanged: (value) {},
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: InputField.name(
                                  hintText: context.loc.last_name,
                                  controller: _lastNameController,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: GestureDetector(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );
                                    if (pickedDate != null) {
                                      _birthOfDateController.text =
                                          "${pickedDate.day.toString().padLeft(2, '0')}/"
                                          "${pickedDate.month.toString().padLeft(2, '0')}/"
                                          "${pickedDate.year}";
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: InputField.dob(
                                      hintText: context.loc.birth_of_date,
                                      controller: _birthOfDateController,
                                      textInputAction: TextInputAction.next,
                                      prefixIcon: Align(
                                        widthFactor: 1.0,
                                        heightFactor: 1.0,
                                        child: SvgPicture.asset(
                                            AppIcons.iconBirthdate),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: InputField.gender(
                                  hintText: context.loc.gender,
                                  controller: _genderController,
                                  textInputAction: TextInputAction.done,
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child:
                                        SvgPicture.asset(AppIcons.iconGender),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: InputField.phone(
                                  hintText: context.loc.phone_number,
                                  controller: _phoneNumberController,
                                  textInputAction: TextInputAction.done,
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: SvgPicture.asset(
                                        AppIcons.iconPhoneNumber),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     Checkbox(
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(5),
                        //       ),
                        //       value: isAgreePolicy,
                        //       onChanged: (value) {
                        //         setState(
                        //           () {
                        //             isAgreePolicy = value!;
                        //           },
                        //         );
                        //       },
                        //     ),
                        //     InkWell(
                        //       onTap: () {
                        //         showDialog(
                        //             context: context,
                        //             builder: (BuildContext context) {
                        //               return Center(
                        //                 child: Container(
                        //                   height: 300,
                        //                   width: 300,
                        //                   color: context.colorScheme.surface,
                        //                   child: Text("data"),
                        //                 ),
                        //               );
                        //             });
                        //       },
                        //       child: Text(
                        //         " privacy and policy",
                        //         style: context.textTheme.labelLarge?.copyWith(
                        //           color: context.colorScheme.surfaceTint,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 12,
                        ),
                        FilledButton(
                          onPressed: () {
                            _onSignUpButtonClicked();
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              context.loc.next,
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
                            AppRoute.signIn.push(context);
                          },
                          child: Text(
                            context.loc.skip,
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
            // SafeArea(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       SystemSetting(),
            //     ],
            //   ),
            // ),
          ],
        );
      },
    ));
  }

  void _onSignUpButtonClicked() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.closeKeyboard();

    context.read<AuthBloc>().add(SignUpInformationEvent(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          birtOfDate: _birthOfDateController.text.trim(),
          gender: _genderController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
        ));
  }
}
