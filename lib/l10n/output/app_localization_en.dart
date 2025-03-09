import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get choose_language => 'Select your preferred language';

  @override
  String get choose_theme => 'Select your preferred theme';

  @override
  String get app_name => 'HUBT Social';

  @override
  String get university_name => 'HaNoi University of Business and Technology';

  @override
  String get department => 'Department Information Technology';

  @override
  String get home => 'Home';

  @override
  String get chat => 'Chat';

  @override
  String get timetable => 'Timetable';

  @override
  String get menu => 'Menu';

  @override
  String get profile => 'Profile';

  @override
  String get welcome => 'Welcome!';

  @override
  String get welcome_info => 'Experience interesting things with HUBT SOCIAL.';

  @override
  String get sign_in => 'Sign in';

  @override
  String get set_new_password => 'Set New PassWord';

  @override
  String get enter_code => 'Enter Code';

  @override
  String get student_code => 'Student code';

  @override
  String get user_name => 'User name';

  @override
  String get first_name => 'First name';

  @override
  String get next => 'Next';

  @override
  String get last_name => 'Last name';

  @override
  String get otp_expired => 'OTP Expired';

  @override
  String the_code_will(String value) {
    return 'The code will expire in: $value';
  }

  @override
  String get email => 'Email';

  @override
  String get save_changes => 'save_changes';

  @override
  String get edit_profile => 'edit_profile';

  @override
  String get change_photo => 'change_photo';

  @override
  String get about_this_profile => 'About this profile';

  @override
  String get birth_of_date => 'Birth of date';

  @override
  String get gender => 'Gender';

  @override
  String get signup_information => 'Information';

  @override
  String get phone_number => 'Phone number';

  @override
  String get skip => 'Skip';

  @override
  String get username_or_email => 'Username or Email';

  @override
  String get do_not_have_an_account => 'Don’t have an account?';

  @override
  String get already_have_an_account => 'You already have an account?';

  @override
  String get remember_me => 'Remember me';

  @override
  String get forgot_password_question_mark => 'Forgot your account?';

  @override
  String get forgot_password => 'Forgot Password';

  @override
  String get password_verify => 'OTP Verification';

  @override
  String get sign_up => 'Sign up';

  @override
  String get password => 'Password';

  @override
  String get confirm_password => 'Confirm password';

  @override
  String get continue_text => 'Continue';

  @override
  String get required => 'Please enter';

  @override
  String get enter_valid_email => 'Enter valid email';

  @override
  String get password_change_successful => 'Password change successful!';

  @override
  String password_must_be_at_least(int value) {
    return 'Password must be at least $value characters long';
  }

  @override
  String get password_must_contain_at_least_one_capital_letter => 'Password must contain at least one capital letter';

  @override
  String get theme_system => 'System';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_dark => 'Dark';

  @override
  String get forgot_password_message => 'Please enter your Username or Email to reset the password';

  @override
  String enter_otp_message(String maskMail) {
    return 'Enter the 6-digit code we sent you at Email $maskMail ';
  }

  @override
  String get enter_message => 'Please enter your Username or Email to reset the password';

  @override
  String get resend => 'Resend';

  @override
  String get otp_expire_message => 'Otp expire message';

  @override
  String get starts => 'Start';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '$minutes minutes ago';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours hours ago';
  }

  @override
  String get timeFormat => 'dd/MM/yyyy HH:mm';

  @override
  String get follow => 'Follow';

  @override
  String get share => 'Share';

  @override
  String get post => 'Post';

  @override
  String get reply => 'Reply';

  @override
  String get repost => 'Repost';

  @override
  String get camera => 'Camera';
}
