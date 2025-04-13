// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get language => '한국어';

  @override
  String get choose_language => '선호하는 언어를 선택하세요';

  @override
  String get choose_theme => '선호하는 테마를 선택하세요';

  @override
  String get app_name => 'HUBT 소셜';

  @override
  String get university_name => '하노이 경영 기술 대학교';

  @override
  String get department => '정보 기술 학부';

  @override
  String get home => '홈';

  @override
  String get chat => '채팅';

  @override
  String get timetable => '시간표';

  @override
  String get menu => '메뉴';

  @override
  String get profile => '프로필';

  @override
  String get welcome => '환영합니다!';

  @override
  String get welcome_info => 'HUBT 소셜과 함께 흥미로운 것들을 경험해보세요.';

  @override
  String get sign_in => '로그인';

  @override
  String get set_new_password => '새 비밀번호 설정';

  @override
  String get enter_code => '코드 입력';

  @override
  String get student_code => '학번';

  @override
  String get user_name => '사용자 이름';

  @override
  String get first_name => '이름';

  @override
  String get next => '다음';

  @override
  String get last_name => '성';

  @override
  String get otp_expired => 'OTP 만료됨';

  @override
  String the_code_will(String value) {
    return '코드는 $value 후에 만료됩니다.';
  }

  @override
  String get email => '이메일';

  @override
  String get save_changes => '변경 사항 저장';

  @override
  String get edit_profile => '프로필 편집';

  @override
  String get change_photo => '사진 변경';

  @override
  String get about_this_profile => '이 프로필 정보';

  @override
  String get birth_of_date => '생년월일';

  @override
  String get gender => '성별';

  @override
  String get signup_information => '정보';

  @override
  String get phone_number => '전화번호';

  @override
  String get skip => '건너뛰기';

  @override
  String get username_or_email => '사용자 이름 또는 이메일';

  @override
  String get do_not_have_an_account => '계정이 없으신가요?';

  @override
  String get already_have_an_account => '이미 계정이 있으신가요?';

  @override
  String get remember_me => '로그인 정보 저장';

  @override
  String get forgot_password_question_mark => '계정을 잊으셨나요?';

  @override
  String get forgot_password => '비밀번호 찾기';

  @override
  String get password_verify => 'OTP 인증';

  @override
  String get sign_up => '회원가입';

  @override
  String get password => '비밀번호';

  @override
  String get confirm_password => '비밀번호 확인';

  @override
  String get continue_text => '계속';

  @override
  String get required => '입력해주세요';

  @override
  String get enter_valid_email => '유효한 이메일을 입력하세요';

  @override
  String get password_change_successful => '비밀번호 변경 성공!';

  @override
  String password_must_be_at_least(int value) {
    return '비밀번호는 최소 $value자 이상이어야 합니다.';
  }

  @override
  String get password_must_contain_at_least_one_capital_letter => '비밀번호는 대문자를 하나 이상 포함해야 합니다.';

  @override
  String get theme_system => '시스템';

  @override
  String get theme_light => '라이트';

  @override
  String get theme_dark => '다크';

  @override
  String get forgot_password_message => '비밀번호를 재설정하려면 사용자 이름 또는 이메일을 입력하세요.';

  @override
  String enter_otp_message(String maskMail) {
    return '이메일 $maskMail(으)로 전송된 6자리 코드를 입력하세요.';
  }

  @override
  String get enter_message => '비밀번호를 재설정하려면 사용자 이름 또는 이메일을 입력하세요.';

  @override
  String get resend => '재전송';

  @override
  String get otp_expire_message => 'OTP 만료 메시지';

  @override
  String get starts => '시작';

  @override
  String get notifications => '알림';

  @override
  String get markAllAsRead => '모두 읽음으로 표시';

  @override
  String get noNotifications => '알림 없음';

  @override
  String get justNow => '방금 전';

  @override
  String minutesAgo(int minutes) {
    return '$minutes분 전';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours시간 전';
  }

  @override
  String get timeFormat => 'yyyy/MM/dd HH:mm';

  @override
  String get follow => '팔로우';

  @override
  String get share => '공유';

  @override
  String get post => '게시물';

  @override
  String get reply => '답글';

  @override
  String get repost => '리포스트';

  @override
  String get camera => '카메라';

  @override
  String get change_theme => '테마 변경';

  @override
  String get change_language => '언어 변경';

  @override
  String get change_password => '비밀번호 변경';

  @override
  String get support_center => '고객 센터';

  @override
  String get feedback_for_developers => '개발자에게 피드백 보내기';

  @override
  String get delete_account => '계정 삭제';

  @override
  String get sign_out => '로그아웃';

  @override
  String get see_your_personal_page => '개인 페이지 보기!';
}
