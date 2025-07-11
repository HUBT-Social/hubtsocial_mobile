// ignore: unused_import
import 'package:intl/intl.dart' as intl;
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
  String get first_name_hint => 'Please enter your first name';

  @override
  String get next => 'Next';

  @override
  String get last_name => 'Last name';

  @override
  String get last_name_hint => 'Please enter your last name';

  @override
  String get otp_expired => 'OTP Expired';

  @override
  String the_code_will(String value) {
    return 'The code will expire in: $value';
  }

  @override
  String get email => 'Email';

  @override
  String get save_changes => 'Save changes';

  @override
  String get edit_profile => 'Edit profile';

  @override
  String get change_photo => 'Change photo';

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
  String get do_not_have_an_account => 'Don\"t have an account?';

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

  @override
  String get change_theme => 'Change theme';

  @override
  String get change_language => 'Change language';

  @override
  String get change_password => 'Change password';

  @override
  String get support_center => 'Support Center';

  @override
  String get feedback_for_developers => 'Feedback for developers';

  @override
  String get delete_account => 'Delete account';

  @override
  String get sign_out => 'Sign out';

  @override
  String get see_your_personal_page => 'See your personal page!';

  @override
  String get try_again => 'Try again';

  @override
  String get no_messages => 'No messages';

  @override
  String get click_to_try_again => 'Click to try again';

  @override
  String get calender_format_month => 'Month';

  @override
  String get calender_format_2_week => '2 Week';

  @override
  String get calender_format_week => 'Week';

  @override
  String get the_day_before => 'The day before';

  @override
  String get the_time_before => 'Hours ago';

  @override
  String get the_muniest_before => 'Minutes ago';

  @override
  String get just_finished => 'Just finished';

  @override
  String get all => 'All';

  @override
  String get unread => 'Unread';

  @override
  String get system => 'System';

  @override
  String get messages => 'Messages';

  @override
  String get groups => 'Groups';

  @override
  String get schedule => 'Schedule';

  @override
  String get screen_not_found => 'Screen not found';

  @override
  String get screen_not_found_oh_no => 'Oh no!';

  @override
  String get screen_not_found_message => 'May be bigfoot has broken this page';

  @override
  String get screen_not_found_back => 'Back';

  @override
  String question_value(String value) {
    return 'Question $value';
  }

  @override
  String question_count(Object value) {
    return '$value questions';
  }

  @override
  String get teacherCodeInputTitle => 'Enter Teacher Code';

  @override
  String get teacherCodeLabel => 'Teacher Code';

  @override
  String get teacherCodeHint => 'Example: GV001';

  @override
  String get enterTeacherCodeInstruction => 'Please enter the teacher code to continue';

  @override
  String get invalidTeacherCode => 'Invalid teacher code!';

  @override
  String duration_minutes(int value) {
    return '$value minutes';
  }

  @override
  String credits(int value) {
    return 'Credits $value';
  }

  @override
  String get congratulation => 'Congratulation!';

  @override
  String get youHaveCompletedQuiz => 'You have completed Quiz.';

  @override
  String get score => 'Score';

  @override
  String get testTime => 'Test time';

  @override
  String get backToHomepage => 'Back to homepage';

  @override
  String get quizDetailTitle => 'Quiz detail title';

  @override
  String get shuffleQuestions => 'Shuffle questions';

  @override
  String get shuffleAnswers => 'Shuffle answers';

  @override
  String get startQuiz => 'Start quiz';

  @override
  String zoom_cannot_be_accessed(String zoom_id) {
    return 'Zoom cannot be accessed $zoom_id';
  }

  @override
  String get copied => 'Copied';

  @override
  String get student_list => 'Student list';

  @override
  String get content => 'Content';

  @override
  String get evaluate => 'Evaluate';

  @override
  String get information => 'Information';

  @override
  String get present => 'Present';

  @override
  String get absent => 'Absent';

  @override
  String get late => 'Late';

  @override
  String get exam_ban => 'Exam ban';

  @override
  String get study => 'Study';

  @override
  String get exam => 'Exam';

  @override
  String get seminar => 'Seminar';

  @override
  String get retake_exam => 'Retake exam';

  @override
  String get functions => 'Functions';

  @override
  String get revise => 'Revise';

  @override
  String get module => 'Module';

  @override
  String get academic_result => 'Academic result';

  @override
  String get total_result => 'Overall result';

  @override
  String get pending_subjects => 'Pending subjects';

  @override
  String get retake_subjects => 'Retake subjects';

  @override
  String get failed_subjects => 'Failed subjects';

  @override
  String get score_analysis => 'Score analysis';

  @override
  String get subject_code => 'Subject code';

  @override
  String get subject_name => 'Subject name';

  @override
  String get credits_short => 'Credits';

  @override
  String get score10 => 'Score 10';

  @override
  String get pay_tuition => 'Pay tuition';

  @override
  String get school_survey => 'School survey';

  @override
  String get instructor_evaluation => 'Instructor Evaluation';

  @override
  String get academic_advisor => 'Academic advisor';

  @override
  String get features_currently_in_development => 'Features currently in development';

  @override
  String get coming_soon => 'Coming soon';

  @override
  String get no_data => 'No data';

  @override
  String get filter_notifications => 'Filter notifications';

  @override
  String get mark_all_as_read => 'Mark all as read';

  @override
  String get no_notifications_in_filter => 'No notifications in this filter';

  @override
  String get teacherEvaluationTitle => 'Teacher Evaluation';

  @override
  String get teacherInfoTitle => 'Teacher Information:';

  @override
  String get teacherNameLabel => 'Teacher Name:';

  @override
  String get teacherCodeLabelShort => 'Teacher Code:';

  @override
  String get teacherDepartmentLabel => 'Department:';

  @override
  String get teacherGenderLabel => 'Gender:';

  @override
  String get teacherBirthDateLabel => 'Birth Date:';

  @override
  String get evaluationInstruction => 'Please evaluate the following criteria:';

  @override
  String get question1 => 'Does the lecturer communicate clearly and understandably?';

  @override
  String get question2 => 'Is the lecturer enthusiastic and dedicated in teaching?';

  @override
  String get question3 => 'Are you satisfied with the lecturer\'s teaching methods?';

  @override
  String get question4 => 'Does the lecturer encourage students to ask questions and participate in discussions?';

  @override
  String get question5 => 'Does the lecturer provide sufficient materials and useful learning resources?';

  @override
  String get question6 => 'Does the lecturer evaluate fairly and objectively?';

  @override
  String get question7 => 'Does the lecturer effectively resolve emerging issues?';

  @override
  String get question8 => 'Do you feel respected and listened to when interacting with the lecturer?';

  @override
  String get question9 => 'Overall, are you satisfied with this lecturer?';

  @override
  String get submitEvaluationButton => 'Submit Evaluation';

  @override
  String get evaluationSuccessMessage => 'Your evaluation has been successfully submitted!';

  @override
  String get evaluationErrorMessage => 'Please evaluate all questions.';

  @override
  String get notificationSettingsTitle => 'Notification Settings';

  @override
  String get blockedNotificationTypesTitle => 'Block Notifications by Type';

  @override
  String get blockChatNotifications => 'Block chat notifications';

  @override
  String get blockTimetableNotifications => 'Block timetable notifications';

  @override
  String get blockBroadcastNotifications => 'Block general notifications';

  @override
  String get blockMaintenanceNotifications => 'Block maintenance notifications';

  @override
  String get blockAcademicWarningNotifications => 'Block academic warning notifications';

  @override
  String get blockExamNotifications => 'Block exam notifications';

  @override
  String get blockGroupNotifications => 'Block group notifications';

  @override
  String get notificationSoundsTitle => 'Notification Sounds';

  @override
  String get playSoundForChatNotifications => 'Play sound for chat notifications';

  @override
  String get playSoundForTimetableNotifications => 'Play sound for timetable notifications';

  @override
  String get playSoundForBroadcastNotifications => 'Play sound for general notifications';

  @override
  String get playSoundForMaintenanceNotifications => 'Play sound for maintenance notifications';

  @override
  String get playSoundForAcademicWarningNotifications => 'Play sound for academic warning notifications';

  @override
  String get playSoundForExamNotifications => 'Play sound for exam notifications';

  @override
  String get playSoundForGroupNotifications => 'Play sound for group notifications';
}
