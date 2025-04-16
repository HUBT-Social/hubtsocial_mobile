import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/constants/assets.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/presentation/dialog/confirmation_dialog.dart';
import 'dart:async';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';

import '../../../features/auth/presentation/bloc/auth_bloc.dart';

sealed class AppDialog {
  const AppDialog._();
  static void showMessageDialog(Widget message, {int closeTime = 0}) {
    AppDialog.closeDialog();
    SmartDialog.show(builder: (context) {
      return message;
    });
    if (closeTime != 0) {
      Timer(
        Duration(seconds: closeTime),
        () {
          AppDialog.closeDialog();
        },
      );
    }
  }

  static void showLoadingDialog({String? message}) {
    if (message != null) {
      logger.d('Loading message: $message');
    }
    AppDialog.closeDialog();
    SmartDialog.show(
        clickMaskDismiss: false,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 10.h),
                Text(message ?? 'loading'),
              ],
            ),
          );
        });
  }

  static void showConfirm({
    required Widget child,
    required VoidCallback onCancel,
    required VoidCallback onSuccess,
  }) {
    AppDialog.closeDialog();
    SmartDialog.show(builder: (context) {
      return Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            child,
            SizedBox(height: 30.h),
            SizedBox(
              // width: context.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      // width: context.width * 0.3,
                      // child: RoundedButton(
                      //   radius: 15,
                      //   buttonColour: Colours.highStaticColour,
                      //   label: BaseText(
                      //     value: 'cancel',
                      //     color: Colors.white,
                      //     size: 15,
                      //   ),
                      //   onPressed: onCancel,
                      // ),
                      ),
                  SizedBox(
                      // width: context.width * 0.3,
                      // child: RoundedButton(
                      //   radius: 15,
                      //   label: BaseText(
                      //     value: 'confirm',
                      //     color: Colors.white,
                      //     size: 15,
                      //   ),
                      //   onPressed: onSuccess,
                      // ),
                      )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  static Widget successMessage(String message, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.r,
            width: 100.r,
            child: Lottie.asset(AppLotties.success),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: 200.w,
            child: Text(
              message,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  static Widget errorMessage(String message, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.r,
            width: 100.r,
            child: Lottie.asset(AppLotties.wrongInput),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: 200.w,
            child: Text(
              message,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  static void closeDialog() {
    SmartDialog.dismiss();
  }

  static void showModelBottomBottomSheet(
      {required BuildContext context, required Widget child}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          padding: EdgeInsets.only(left: 20.w, top: 20.h, right: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          child: child,
        );
      },
    );
  }

  static void showDatePickerDialog(
      {required String from,
      required String to,
      required Function(DateTimeRange) onDateSelected}) {
    SmartDialog.show(builder: (context) {
      return Container(
          // decoration: BoxDecoration(
          //   color: Colours.backgroundColour,
          //   borderRadius: BorderRadius.circular(10),
          //   border: Border.all(
          //     color: Colours.highStaticColour.withOpacity(0.15),
          //   ),
          // ),
          // width: context.width * 0.8,
          // child: RangeDatePicker(
          //   slidersColor: Colors.black,
          //   highlightColor: Colours.primaryColour,
          //   splashColor: Colours.primaryColour,
          //   selectedRange: DateTimeRange(
          //     start: CoreUtils.toDate(from),
          //     end: CoreUtils.toDate(to),
          //   ),
          //   minDate: DateTime.now().subtract(
          //     const Duration(days: 365),
          //   ),
          //   maxDate: DateTime.now(),
          //   onRangeSelected: onDateSelected,
          // ),
          );
    });
  }

  static Future<void> showDeleteAccountConfirmationDialog(
    BuildContext context,
  ) async {
    final confirmed = await _showConfirmationDialog(
      context,
      title: 'Delete Account',
      message: 'Are you sure you want to delete your account forever? '
          'It can take up to 30 days. This cannot be undone.',
      confirmText: 'Delete My Account',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      // TODO: implement delete account
      context.showSnackBarMessage('Request submitted.');
    }
  }

  static Future<void> showSignOutConfirmationDialog(
    BuildContext context,
  ) async {
    final confirmed = await _showConfirmationDialog(
      context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      confirmText: 'Sign Out',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      AppDialog.showLoadingDialog(message: 'Logging out');

      context.read<AuthBloc>().add(const SignOutEvent());
    }
  }

  static Future<bool> _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    bool isDestructive = false,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: title,
            message: message,
            confirmText: confirmText,
            isDestructive: isDestructive,
          ),
        ) ??
        false;
  }
}
