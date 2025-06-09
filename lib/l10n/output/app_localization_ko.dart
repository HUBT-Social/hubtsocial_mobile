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
  String get first_name_hint => '이름을 입력하세요';

  @override
  String get next => '다음';

  @override
  String get last_name => '성';

  @override
  String get last_name_hint => '성을 입력하세요';

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

  @override
  String get try_again => '다시 시도';

  @override
  String get no_messages => '메시지가 없습니다';

  @override
  String get click_to_try_again => '다시 시도하려면 클릭하세요';

  @override
  String get calender_format_month => '월';

  @override
  String get calender_format_2_week => '2 주';

  @override
  String get calender_format_week => '주';

  @override
  String get the_day_before => '하루 전';

  @override
  String get the_time_before => '몇 시간 전';

  @override
  String get the_muniest_before => '몇 분 전';

  @override
  String get just_finished => '방금 끝났습니다';

  @override
  String get all => '모두';

  @override
  String get unread => '읽지 않음';

  @override
  String get system => '시스템';

  @override
  String get messages => '메시지';

  @override
  String get groups => '그룹';

  @override
  String get schedule => '일정';

  @override
  String get screen_not_found => '화면을 찾을 수 없습니다';

  @override
  String get screen_not_found_oh_no => '오, 안돼!';

  @override
  String get screen_not_found_message => '찾을 수 없습니다';

  @override
  String get screen_not_found_back => '뒤로';

  @override
  String question_value(String value) {
    return '질문 $value';
  }

  @override
  String question_count(Object value) {
    return '$value 문제';
  }

  @override
  String get teacherCodeInputTitle => '교사 코드 입력';

  @override
  String get teacherCodeLabel => '교사 코드';

  @override
  String get teacherCodeHint => '예시: GV001';

  @override
  String get enterTeacherCodeInstruction => '계속하려면 교사 코드를 입력하세요';

  @override
  String get invalidTeacherCode => '유효하지 않은 교사 코드입니다!';

  @override
  String duration_minutes(int value) {
    return '$value 분';
  }

  @override
  String credits(int value) {
    return '크레딧 $value';
  }

  @override
  String get congratulation => '축하합니다!';

  @override
  String get youHaveCompletedQuiz => '퀴즈를 완료했습니다';

  @override
  String get score => '점수';

  @override
  String get testTime => '테스트 시간';

  @override
  String get backToHomepage => '홈페이지로 돌아가기';

  @override
  String get quizDetailTitle => '퀴즈 세부정보';

  @override
  String get shuffleQuestions => '문제 섞기';

  @override
  String get shuffleAnswers => '답변 섞기';

  @override
  String get startQuiz => '퀴즈 시작';

  @override
  String zoom_cannot_be_accessed(String zoom_id) {
    return 'Zoom에 접근할 수 없습니다 $zoom_id';
  }

  @override
  String get copied => '복사됨';

  @override
  String get student_list => '학생 목록';

  @override
  String get content => '내용';

  @override
  String get evaluate => '평가';

  @override
  String get information => '정보';

  @override
  String get present => '출석';

  @override
  String get absent => '결석';

  @override
  String get late => '지각';

  @override
  String get exam_ban => '시험 금지';

  @override
  String get study => '공부';

  @override
  String get exam => '시험';

  @override
  String get seminar => '세미나';

  @override
  String get retake_exam => '재시험';

  @override
  String get functions => '기능';

  @override
  String get revise => '복습';

  @override
  String get module => '모듈';

  @override
  String get academic_result => '학업 성적';

  @override
  String get pay_tuition => '등록금 납부';

  @override
  String get school_survey => '학교 설문조사';

  @override
  String get instructor_evaluation => '강사 평가';

  @override
  String get academic_advisor => '학업 상담';

  @override
  String get features_currently_in_development => '현재 개발 중인 기능';

  @override
  String get coming_soon => '곧 출시 예정';

  @override
  String get no_data => '데이터가 없습니다';

  @override
  String get filter_notifications => '알림 필터';

  @override
  String get mark_all_as_read => '모두 읽음으로 표시';

  @override
  String get no_notifications_in_filter => '이 필터에 알림이 없습니다';

  @override
  String get teacherEvaluationTitle => '교사 평가';

  @override
  String get teacherInfoTitle => '교사 정보:';

  @override
  String get teacherNameLabel => '교사 이름:';

  @override
  String get teacherCodeLabelShort => '교사 코드:';

  @override
  String get teacherDepartmentLabel => '학과:';

  @override
  String get teacherGenderLabel => '성별:';

  @override
  String get teacherBirthDateLabel => '생년월일:';

  @override
  String get evaluationInstruction => '다음 기준을 평가하십시오:';

  @override
  String get question1 => '강사는 명확하고 이해하기 쉽게 전달합니까?';

  @override
  String get question2 => '강사는 가르치는 데 열정적이고 헌신적입니까?';

  @override
  String get question3 => '강사의 교수법에 만족하십니까?';

  @override
  String get question4 => '강사는 학생들이 질문하고 토론에 참여하도록 격려합니까?';

  @override
  String get question5 => '강사는 충분한 자료와 유용한 학습 자료를 제공합니까?';

  @override
  String get question6 => '강사는 공정하고 객관적으로 평가합니까?';

  @override
  String get question7 => '강사는 발생하는 문제를 효과적으로 해결합니까?';

  @override
  String get question8 => '강사와 상호 작용할 때 존중받고 경청한다고 느끼십니까?';

  @override
  String get question9 => '전반적으로 이 강사에게 만족하십니까?';

  @override
  String get submitEvaluationButton => '평가 제출';

  @override
  String get evaluationSuccessMessage => '평가가 성공적으로 제출되었습니다!';

  @override
  String get evaluationErrorMessage => '모든 질문을 평가하십시오.';

  @override
  String get notificationSettingsTitle => '알림 설정';

  @override
  String get blockedNotificationTypesTitle => '유형별 알림 차단';

  @override
  String get blockChatNotifications => '채팅 알림 차단';

  @override
  String get blockTimetableNotifications => '시간표 알림 차단';

  @override
  String get blockBroadcastNotifications => '일반 알림 차단';

  @override
  String get blockMaintenanceNotifications => '유지 보수 알림 차단';

  @override
  String get blockAcademicWarningNotifications => '학업 경고 알림 차단';

  @override
  String get blockExamNotifications => '시험 알림 차단';

  @override
  String get blockGroupNotifications => '그룹 알림 차단';

  @override
  String get notificationSoundsTitle => '알림 소리';

  @override
  String get playSoundForChatNotifications => '채팅 알림 소리 재생';

  @override
  String get playSoundForTimetableNotifications => '시간표 알림 소리 재생';

  @override
  String get playSoundForBroadcastNotifications => '일반 알림 소리 재생';

  @override
  String get playSoundForMaintenanceNotifications => '유지 보수 알림 소리 재생';

  @override
  String get playSoundForAcademicWarningNotifications => '학업 경고 알림 소리 재생';

  @override
  String get playSoundForExamNotifications => '시험 알림 소리 재생';

  @override
  String get playSoundForGroupNotifications => '그룹 알림 소리 재생';
}
