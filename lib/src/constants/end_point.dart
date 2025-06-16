import 'environment.dart';

class EndPoint {
  static String get apiUrl => "${Environment.getApiUrl}/api";
  static String get chatHub => Environment.getChatHub;

  static String get _auth => "$apiUrl/auth";
  static String get authSignIn => "$_auth/sign-in";
  static String get authSignInTwoFactor => "$authSignIn/verify-two-factor";
  static String get twoFactorPassword => "$authSignIn/verify-two-factor";
  static String get authSignUp => "$_auth/sign-up";
  static String get authSignUpVerifyEmail => "$authSignUp/verify-otp";
  static String get authForgotPassword => "$_auth/forgot-password";
  static String get authVerifyPassword =>
      "$authForgotPassword/password-verification";
  static String get authSetNewPassword => "$authForgotPassword/change-password";
  static String get authRegister => "$_auth/register";
  static String get authConfirmCode => "$_auth/confirm-code";
  static String get authRefreshToken => "$_auth/refresh-token";
  static String get authDeleteToken => "$_auth/delete-token";

  static String get user => "$apiUrl/user";
  static String get userGetUser => user;
  static String get informationUser => "$user/add-info-user";
  static String get updateFcmToken => "$user/update/fcm-token";
  static String get updateAvatar => "$user/update-avatar";
  static String get uptateName =>
      "$user/update/name"; // trong update name này có first name và lastName
  static String get getScore => "$user/get-score";
  static String get module => "$user/get-user-courese";
  static String get getClassInfoScore => "$user/get-class-info/score";
  static String get getClassInfo => "$user/get-class-info";
  static String get _chat => "$apiUrl/chat";
  static String get chatView => "$_chat/load-rooms";
  static String get roomHistory => "$_chat/room/get-history";
  static String get roomInfo => "$_chat/room/info";

  static String get _schooldata => "$user/schooldata";
  static String get checkVersion => "$_schooldata/check-version";
  static String get timetable => "$_schooldata/timetable";
  static String get timetableInfo => "$_schooldata/timetable-info";
  static String get questions => "$_schooldata/questions";
  static String get questionsDetail => "$_schooldata/questions-detail";

  static const String classScoreAnalysis = '/api/class-score-analysis';

  static const String authResetPassword = 'auth/reset-password';
  static const String authInformation = 'auth/information';

  static const String userUpdateUser = 'user/update-user';
  static const String userChangePassword = 'user/change-password';

  static const String moduleGetModule = 'module/get-module';

  static const String quizGetQuiz = 'quiz/get-quiz';
  static const String quizGetQuizInfo = 'quiz/get-quiz-info';
  static const String quizSubmitQuiz = 'quiz/submit-quiz';

  static const String timetableGetTimetable = 'timetable/get-timetable';
  static const String timetableCheckSchedule = 'timetable/check-schedule';
}
