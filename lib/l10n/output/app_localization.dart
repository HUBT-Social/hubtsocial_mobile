import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localization_en.dart';
import 'app_localization_ja.dart';
import 'app_localization_ko.dart';
import 'app_localization_ru.dart';
import 'app_localization_vi.dart';
import 'app_localization_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'output/app_localization.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('ru'),
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// No description provided for @choose_language.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get choose_language;

  /// No description provided for @choose_theme.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred theme'**
  String get choose_theme;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'HUBT Social'**
  String get app_name;

  /// No description provided for @university_name.
  ///
  /// In en, this message translates to:
  /// **'HaNoi University of Business and Technology'**
  String get university_name;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department Information Technology'**
  String get department;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @timetable.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get timetable;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @welcome_info.
  ///
  /// In en, this message translates to:
  /// **'Experience interesting things with HUBT SOCIAL.'**
  String get welcome_info;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @set_new_password.
  ///
  /// In en, this message translates to:
  /// **'Set New PassWord'**
  String get set_new_password;

  /// No description provided for @enter_code.
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get enter_code;

  /// No description provided for @student_code.
  ///
  /// In en, this message translates to:
  /// **'Student code'**
  String get student_code;

  /// No description provided for @user_name.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get user_name;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get first_name;

  /// No description provided for @first_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get first_name_hint;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get last_name;

  /// No description provided for @last_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get last_name_hint;

  /// No description provided for @otp_expired.
  ///
  /// In en, this message translates to:
  /// **'OTP Expired'**
  String get otp_expired;

  /// No description provided for @the_code_will.
  ///
  /// In en, this message translates to:
  /// **'The code will expire in: {value}'**
  String the_code_will(String value);

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get save_changes;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get edit_profile;

  /// No description provided for @change_photo.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get change_photo;

  /// No description provided for @about_this_profile.
  ///
  /// In en, this message translates to:
  /// **'About this profile'**
  String get about_this_profile;

  /// No description provided for @birth_of_date.
  ///
  /// In en, this message translates to:
  /// **'Birth of date'**
  String get birth_of_date;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @signup_information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get signup_information;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone_number;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @username_or_email.
  ///
  /// In en, this message translates to:
  /// **'Username or Email'**
  String get username_or_email;

  /// No description provided for @do_not_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Don\"t have an account?'**
  String get do_not_have_an_account;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'You already have an account?'**
  String get already_have_an_account;

  /// No description provided for @remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get remember_me;

  /// No description provided for @forgot_password_question_mark.
  ///
  /// In en, this message translates to:
  /// **'Forgot your account?'**
  String get forgot_password_question_mark;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot_password;

  /// No description provided for @password_verify.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get password_verify;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirm_password;

  /// No description provided for @continue_text.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_text;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Please enter'**
  String get required;

  /// No description provided for @enter_valid_email.
  ///
  /// In en, this message translates to:
  /// **'Enter valid email'**
  String get enter_valid_email;

  /// No description provided for @password_change_successful.
  ///
  /// In en, this message translates to:
  /// **'Password change successful!'**
  String get password_change_successful;

  /// No description provided for @password_must_be_at_least.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {value} characters long'**
  String password_must_be_at_least(int value);

  /// No description provided for @password_must_contain_at_least_one_capital_letter.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one capital letter'**
  String get password_must_contain_at_least_one_capital_letter;

  /// No description provided for @theme_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get theme_system;

  /// No description provided for @theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_light;

  /// No description provided for @theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark;

  /// No description provided for @forgot_password_message.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Username or Email to reset the password'**
  String get forgot_password_message;

  /// No description provided for @enter_otp_message.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code we sent you at Email {maskMail} '**
  String enter_otp_message(String maskMail);

  /// No description provided for @enter_message.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Username or Email to reset the password'**
  String get enter_message;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @otp_expire_message.
  ///
  /// In en, this message translates to:
  /// **'Otp expire message'**
  String get otp_expire_message;

  /// No description provided for @starts.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get starts;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes ago'**
  String minutesAgo(int minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String hoursAgo(int hours);

  /// No description provided for @timeFormat.
  ///
  /// In en, this message translates to:
  /// **'dd/MM/yyyy HH:mm'**
  String get timeFormat;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @repost.
  ///
  /// In en, this message translates to:
  /// **'Repost'**
  String get repost;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @change_theme.
  ///
  /// In en, this message translates to:
  /// **'Change theme'**
  String get change_theme;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get change_language;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password;

  /// No description provided for @support_center.
  ///
  /// In en, this message translates to:
  /// **'Support Center'**
  String get support_center;

  /// No description provided for @feedback_for_developers.
  ///
  /// In en, this message translates to:
  /// **'Feedback for developers'**
  String get feedback_for_developers;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account;

  /// No description provided for @sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get sign_out;

  /// No description provided for @see_your_personal_page.
  ///
  /// In en, this message translates to:
  /// **'See your personal page!'**
  String get see_your_personal_page;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;

  /// No description provided for @no_messages.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get no_messages;

  /// No description provided for @click_to_try_again.
  ///
  /// In en, this message translates to:
  /// **'Click to try again'**
  String get click_to_try_again;

  /// No description provided for @calender_format_month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calender_format_month;

  /// No description provided for @calender_format_2_week.
  ///
  /// In en, this message translates to:
  /// **'2 Week'**
  String get calender_format_2_week;

  /// No description provided for @calender_format_week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get calender_format_week;

  /// No description provided for @the_day_before.
  ///
  /// In en, this message translates to:
  /// **'The day before'**
  String get the_day_before;

  /// No description provided for @the_time_before.
  ///
  /// In en, this message translates to:
  /// **'Hours ago'**
  String get the_time_before;

  /// No description provided for @the_muniest_before.
  ///
  /// In en, this message translates to:
  /// **'Minutes ago'**
  String get the_muniest_before;

  /// No description provided for @just_finished.
  ///
  /// In en, this message translates to:
  /// **'Just finished'**
  String get just_finished;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @screen_not_found.
  ///
  /// In en, this message translates to:
  /// **'Screen not found'**
  String get screen_not_found;

  /// No description provided for @screen_not_found_oh_no.
  ///
  /// In en, this message translates to:
  /// **'Oh no!'**
  String get screen_not_found_oh_no;

  /// No description provided for @screen_not_found_message.
  ///
  /// In en, this message translates to:
  /// **'May be bigfoot has broken this page'**
  String get screen_not_found_message;

  /// No description provided for @screen_not_found_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get screen_not_found_back;

  /// No description provided for @question_value.
  ///
  /// In en, this message translates to:
  /// **'Question {value}'**
  String question_value(String value);

  /// No description provided for @question_count.
  ///
  /// In en, this message translates to:
  /// **'{value} questions'**
  String question_count(Object value);

  /// No description provided for @teacherCodeInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Teacher Code'**
  String get teacherCodeInputTitle;

  /// No description provided for @teacherCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Teacher Code'**
  String get teacherCodeLabel;

  /// No description provided for @teacherCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Example: GV001'**
  String get teacherCodeHint;

  /// No description provided for @enterTeacherCodeInstruction.
  ///
  /// In en, this message translates to:
  /// **'Please enter the teacher code to continue'**
  String get enterTeacherCodeInstruction;

  /// No description provided for @invalidTeacherCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid teacher code!'**
  String get invalidTeacherCode;

  /// No description provided for @duration_minutes.
  ///
  /// In en, this message translates to:
  /// **'{value} minutes'**
  String duration_minutes(int value);

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits {value}'**
  String credits(int value);

  /// No description provided for @congratulation.
  ///
  /// In en, this message translates to:
  /// **'Congratulation!'**
  String get congratulation;

  /// No description provided for @youHaveCompletedQuiz.
  ///
  /// In en, this message translates to:
  /// **'You have completed Quiz.'**
  String get youHaveCompletedQuiz;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @testTime.
  ///
  /// In en, this message translates to:
  /// **'Test time'**
  String get testTime;

  /// No description provided for @backToHomepage.
  ///
  /// In en, this message translates to:
  /// **'Back to homepage'**
  String get backToHomepage;

  /// No description provided for @quizDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz detail title'**
  String get quizDetailTitle;

  /// No description provided for @shuffleQuestions.
  ///
  /// In en, this message translates to:
  /// **'Shuffle questions'**
  String get shuffleQuestions;

  /// No description provided for @shuffleAnswers.
  ///
  /// In en, this message translates to:
  /// **'Shuffle answers'**
  String get shuffleAnswers;

  /// No description provided for @startQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start quiz'**
  String get startQuiz;

  /// No description provided for @zoom_cannot_be_accessed.
  ///
  /// In en, this message translates to:
  /// **'Zoom cannot be accessed {zoom_id}'**
  String zoom_cannot_be_accessed(String zoom_id);

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @student_list.
  ///
  /// In en, this message translates to:
  /// **'Student list'**
  String get student_list;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @evaluate.
  ///
  /// In en, this message translates to:
  /// **'Evaluate'**
  String get evaluate;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @late.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get late;

  /// No description provided for @exam_ban.
  ///
  /// In en, this message translates to:
  /// **'Exam ban'**
  String get exam_ban;

  /// No description provided for @study.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get study;

  /// No description provided for @exam.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get exam;

  /// No description provided for @seminar.
  ///
  /// In en, this message translates to:
  /// **'Seminar'**
  String get seminar;

  /// No description provided for @retake_exam.
  ///
  /// In en, this message translates to:
  /// **'Retake exam'**
  String get retake_exam;

  /// No description provided for @functions.
  ///
  /// In en, this message translates to:
  /// **'Functions'**
  String get functions;

  /// No description provided for @revise.
  ///
  /// In en, this message translates to:
  /// **'Revise'**
  String get revise;

  /// No description provided for @module.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get module;

  /// No description provided for @academic_result.
  ///
  /// In en, this message translates to:
  /// **'Academic result'**
  String get academic_result;

  /// No description provided for @pay_tuition.
  ///
  /// In en, this message translates to:
  /// **'Pay tuition'**
  String get pay_tuition;

  /// No description provided for @school_survey.
  ///
  /// In en, this message translates to:
  /// **'School survey'**
  String get school_survey;

  /// No description provided for @instructor_evaluation.
  ///
  /// In en, this message translates to:
  /// **'Instructor Evaluation'**
  String get instructor_evaluation;

  /// No description provided for @academic_advisor.
  ///
  /// In en, this message translates to:
  /// **'Academic advisor'**
  String get academic_advisor;

  /// No description provided for @features_currently_in_development.
  ///
  /// In en, this message translates to:
  /// **'Features currently in development'**
  String get features_currently_in_development;

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get coming_soon;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get no_data;

  /// No description provided for @filter_notifications.
  ///
  /// In en, this message translates to:
  /// **'Filter notifications'**
  String get filter_notifications;

  /// No description provided for @mark_all_as_read.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get mark_all_as_read;

  /// No description provided for @no_notifications_in_filter.
  ///
  /// In en, this message translates to:
  /// **'No notifications in this filter'**
  String get no_notifications_in_filter;

  /// No description provided for @teacherEvaluationTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher Evaluation'**
  String get teacherEvaluationTitle;

  /// No description provided for @teacherInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher Information:'**
  String get teacherInfoTitle;

  /// No description provided for @teacherNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Teacher Name:'**
  String get teacherNameLabel;

  /// No description provided for @teacherCodeLabelShort.
  ///
  /// In en, this message translates to:
  /// **'Teacher Code:'**
  String get teacherCodeLabelShort;

  /// No description provided for @teacherDepartmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Department:'**
  String get teacherDepartmentLabel;

  /// No description provided for @teacherGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender:'**
  String get teacherGenderLabel;

  /// No description provided for @teacherBirthDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Date:'**
  String get teacherBirthDateLabel;

  /// No description provided for @evaluationInstruction.
  ///
  /// In en, this message translates to:
  /// **'Please evaluate the following criteria:'**
  String get evaluationInstruction;

  /// No description provided for @question1.
  ///
  /// In en, this message translates to:
  /// **'Does the lecturer communicate clearly and understandably?'**
  String get question1;

  /// No description provided for @question2.
  ///
  /// In en, this message translates to:
  /// **'Is the lecturer enthusiastic and dedicated in teaching?'**
  String get question2;

  /// No description provided for @question3.
  ///
  /// In en, this message translates to:
  /// **'Are you satisfied with the lecturer\'\'s teaching methods?'**
  String get question3;

  /// No description provided for @question4.
  ///
  /// In en, this message translates to:
  /// **'Does the lecturer encourage students to ask questions and participate in discussions?'**
  String get question4;

  /// No description provided for @question5.
  ///
  /// In en, this message translates to:
  /// **'Does the lecturer provide sufficient materials and useful learning resources?'**
  String get question5;

  /// No description provided for @question6.
  ///
  /// In en, this message translates to:
  /// **'Does the lecturer evaluate fairly and objectively?'**
  String get question6;

  /// No description provided for @question7.
  ///
  /// In en, this message translates to:
  /// **'Does the lecturer effectively resolve emerging issues?'**
  String get question7;

  /// No description provided for @question8.
  ///
  /// In en, this message translates to:
  /// **'Do you feel respected and listened to when interacting with the lecturer?'**
  String get question8;

  /// No description provided for @question9.
  ///
  /// In en, this message translates to:
  /// **'Overall, are you satisfied with this lecturer?'**
  String get question9;

  /// No description provided for @submitEvaluationButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Evaluation'**
  String get submitEvaluationButton;

  /// No description provided for @evaluationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your evaluation has been successfully submitted!'**
  String get evaluationSuccessMessage;

  /// No description provided for @evaluationErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please evaluate all questions.'**
  String get evaluationErrorMessage;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettingsTitle;

  /// No description provided for @blockedNotificationTypesTitle.
  ///
  /// In en, this message translates to:
  /// **'Block Notifications by Type'**
  String get blockedNotificationTypesTitle;

  /// No description provided for @blockChatNotifications.
  ///
  /// In en, this message translates to:
  /// **'Block chat notifications'**
  String get blockChatNotifications;

  /// No description provided for @blockTimetableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Block timetable notifications'**
  String get blockTimetableNotifications;

  /// No description provided for @blockBroadcastNotifications.
  ///
  /// In en, this message translates to:
  /// **'Block general notifications'**
  String get blockBroadcastNotifications;

  /// No description provided for @blockMaintenanceNotifications.
  ///
  /// In en, this message translates to:
  /// **'Block maintenance notifications'**
  String get blockMaintenanceNotifications;

  /// No description provided for @blockAcademicWarningNotifications.
  ///
  /// In en, this message translates to:
  /// **'Block academic warning notifications'**
  String get blockAcademicWarningNotifications;

  /// No description provided for @blockExamNotifications.
  ///
  /// In en, this message translates to:
  /// **'Block exam notifications'**
  String get blockExamNotifications;

  /// No description provided for @blockGroupNotifications.
  ///
  /// In en, this message translates to:
  /// **'Block group notifications'**
  String get blockGroupNotifications;

  /// No description provided for @notificationSoundsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Sounds'**
  String get notificationSoundsTitle;

  /// No description provided for @playSoundForChatNotifications.
  ///
  /// In en, this message translates to:
  /// **'Play sound for chat notifications'**
  String get playSoundForChatNotifications;

  /// No description provided for @playSoundForTimetableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Play sound for timetable notifications'**
  String get playSoundForTimetableNotifications;

  /// No description provided for @playSoundForBroadcastNotifications.
  ///
  /// In en, this message translates to:
  /// **'Play sound for general notifications'**
  String get playSoundForBroadcastNotifications;

  /// No description provided for @playSoundForMaintenanceNotifications.
  ///
  /// In en, this message translates to:
  /// **'Play sound for maintenance notifications'**
  String get playSoundForMaintenanceNotifications;

  /// No description provided for @playSoundForAcademicWarningNotifications.
  ///
  /// In en, this message translates to:
  /// **'Play sound for academic warning notifications'**
  String get playSoundForAcademicWarningNotifications;

  /// No description provided for @playSoundForExamNotifications.
  ///
  /// In en, this message translates to:
  /// **'Play sound for exam notifications'**
  String get playSoundForExamNotifications;

  /// No description provided for @playSoundForGroupNotifications.
  ///
  /// In en, this message translates to:
  /// **'Play sound for group notifications'**
  String get playSoundForGroupNotifications;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja', 'ko', 'ru', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'ru': return AppLocalizationsRu();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
