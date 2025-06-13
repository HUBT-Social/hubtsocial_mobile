// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get language => '中文';

  @override
  String get choose_language => '选择您的首选语言';

  @override
  String get choose_theme => '选择您的首选主题';

  @override
  String get app_name => 'HUBT社交';

  @override
  String get university_name => '河内商业技术大学';

  @override
  String get department => '信息技术系';

  @override
  String get home => '主页';

  @override
  String get chat => '聊天';

  @override
  String get timetable => '时间表';

  @override
  String get menu => '菜单';

  @override
  String get profile => '个人资料';

  @override
  String get welcome => '欢迎！';

  @override
  String get welcome_info => '通过 HUBT SOCIAL 体验有趣的事情。';

  @override
  String get sign_in => '登录';

  @override
  String get set_new_password => '设置新密码';

  @override
  String get enter_code => '输入代码';

  @override
  String get student_code => '学号';

  @override
  String get user_name => '用户名';

  @override
  String get first_name => '名字';

  @override
  String get first_name_hint => '请输入您的名字';

  @override
  String get next => '下一步';

  @override
  String get last_name => '姓氏';

  @override
  String get last_name_hint => '请输入您的姓氏';

  @override
  String get otp_expired => 'OTP 已过期';

  @override
  String the_code_will(String value) {
    return '代码将在 $value 后过期';
  }

  @override
  String get email => '电子邮件';

  @override
  String get save_changes => '保存更改';

  @override
  String get edit_profile => '编辑个人资料';

  @override
  String get change_photo => '更换照片';

  @override
  String get about_this_profile => '关于此个人资料';

  @override
  String get birth_of_date => '出生日期';

  @override
  String get gender => '性别';

  @override
  String get signup_information => '信息';

  @override
  String get phone_number => '电话号码';

  @override
  String get skip => '跳过';

  @override
  String get username_or_email => '用户名或电子邮件';

  @override
  String get do_not_have_an_account => '没有帐户？';

  @override
  String get already_have_an_account => '您已经有帐户了？';

  @override
  String get remember_me => '记住我';

  @override
  String get forgot_password_question_mark => '忘记您的帐户？';

  @override
  String get forgot_password => '忘记密码';

  @override
  String get password_verify => 'OTP 验证';

  @override
  String get sign_up => '注册';

  @override
  String get password => '密码';

  @override
  String get confirm_password => '确认密码';

  @override
  String get continue_text => '继续';

  @override
  String get required => '请输入';

  @override
  String get enter_valid_email => '输入有效的电子邮件';

  @override
  String get password_change_successful => '密码更改成功！';

  @override
  String password_must_be_at_least(int value) {
    return '密码长度必须至少为 $value 个字符';
  }

  @override
  String get password_must_contain_at_least_one_capital_letter => '密码必须包含至少一个大写字母';

  @override
  String get theme_system => '系统';

  @override
  String get theme_light => '浅色';

  @override
  String get theme_dark => '深色';

  @override
  String get forgot_password_message => '请输入您的用户名或电子邮件以重置密码';

  @override
  String enter_otp_message(String maskMail) {
    return '输入我们发送给您的 6 位数代码，邮箱为 $maskMail';
  }

  @override
  String get enter_message => '请输入您的用户名或电子邮件以重置密码';

  @override
  String get resend => '重新发送';

  @override
  String get otp_expire_message => 'Otp 过期消息';

  @override
  String get starts => '开始';

  @override
  String get notifications => '通知';

  @override
  String get markAllAsRead => '标记全部为已读';

  @override
  String get noNotifications => '没有通知';

  @override
  String get justNow => '刚才';

  @override
  String minutesAgo(int minutes) {
    return '$minutes 分钟前';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours 小时前';
  }

  @override
  String get timeFormat => 'yyyy/MM/dd HH:mm';

  @override
  String get follow => '关注';

  @override
  String get share => '分享';

  @override
  String get post => '帖子';

  @override
  String get reply => '回复';

  @override
  String get repost => '转发';

  @override
  String get camera => '相机';

  @override
  String get change_theme => '更改主题';

  @override
  String get change_language => '更改语言';

  @override
  String get change_password => '更改密码';

  @override
  String get support_center => '支持中心';

  @override
  String get feedback_for_developers => '给开发者的反馈';

  @override
  String get delete_account => '删除帐户';

  @override
  String get sign_out => '退出登录';

  @override
  String get see_your_personal_page => '查看您的个人页面！';

  @override
  String get try_again => '请再试一次';

  @override
  String get no_messages => '没有消息';

  @override
  String get click_to_try_again => '点击重试';

  @override
  String get calender_format_month => '月份';

  @override
  String get calender_format_2_week => '2 星期';

  @override
  String get calender_format_week => '星期';

  @override
  String get the_day_before => '前一天';

  @override
  String get the_time_before => '几小时前';

  @override
  String get the_muniest_before => '几分钟前';

  @override
  String get just_finished => '刚刚结束';

  @override
  String get all => '全部';

  @override
  String get unread => '未读';

  @override
  String get system => '系统';

  @override
  String get messages => '消息';

  @override
  String get groups => '群组';

  @override
  String get schedule => '日程';

  @override
  String get screen_not_found => '未找到屏幕';

  @override
  String get screen_not_found_oh_no => '哦不！';

  @override
  String get screen_not_found_message => '未找到';

  @override
  String get screen_not_found_back => '返回';

  @override
  String question_value(String value) {
    return '问题 $value';
  }

  @override
  String question_count(Object value) {
    return '$value 个问题';
  }

  @override
  String get teacherCodeInputTitle => '输入教师代码';

  @override
  String get teacherCodeLabel => '教师代码';

  @override
  String get teacherCodeHint => '示例: GV001';

  @override
  String get enterTeacherCodeInstruction => '请输入教师代码以继续';

  @override
  String get invalidTeacherCode => '无效的教师代码！';

  @override
  String duration_minutes(int value) {
    return '$value 分钟';
  }

  @override
  String credits(int value) {
    return '积分 $value';
  }

  @override
  String get congratulation => '恭喜！';

  @override
  String get youHaveCompletedQuiz => '您已完成测验';

  @override
  String get score => '分数';

  @override
  String get testTime => '测试时间';

  @override
  String get backToHomepage => '返回主页';

  @override
  String get quizDetailTitle => '测验详情';

  @override
  String get shuffleQuestions => '打乱问题';

  @override
  String get shuffleAnswers => '打乱答案';

  @override
  String get startQuiz => '开始测验';

  @override
  String zoom_cannot_be_accessed(String zoom_id) {
    return 'Zoom 无法访问 $zoom_id';
  }

  @override
  String get copied => '已复制';

  @override
  String get student_list => '学生名单';

  @override
  String get content => '内容';

  @override
  String get evaluate => '评估';

  @override
  String get information => '信息';

  @override
  String get present => '在场';

  @override
  String get absent => '缺席';

  @override
  String get late => '迟到';

  @override
  String get exam_ban => '考试禁令';

  @override
  String get study => '学习';

  @override
  String get exam => '考试';

  @override
  String get seminar => '研讨会';

  @override
  String get retake_exam => '重考';

  @override
  String get functions => '功能';

  @override
  String get revise => '复习';

  @override
  String get module => '模块';

  @override
  String get academic_result => '学业成绩';

  @override
  String get total_result => '总成绩';

  @override
  String get pending_subjects => '待定科目';

  @override
  String get retake_subjects => '重修科目';

  @override
  String get failed_subjects => '不及格科目';

  @override
  String get score_analysis => '分数分析';

  @override
  String get subject_code => '科目代码';

  @override
  String get subject_name => '科目名称';

  @override
  String get credits_short => '学分';

  @override
  String get score10 => '10分制';

  @override
  String get pay_tuition => '缴纳学费';

  @override
  String get school_survey => '学校调查';

  @override
  String get instructor_evaluation => '教师评价';

  @override
  String get academic_advisor => '学业顾问';

  @override
  String get features_currently_in_development => '正在开发的功能';

  @override
  String get coming_soon => '即将推出';

  @override
  String get no_data => '没有数据';

  @override
  String get filter_notifications => '筛选通知';

  @override
  String get mark_all_as_read => '全部标记为已读';

  @override
  String get no_notifications_in_filter => '此筛选器中没有通知';

  @override
  String get teacherEvaluationTitle => '教师评价';

  @override
  String get teacherInfoTitle => '教师信息:';

  @override
  String get teacherNameLabel => '教师姓名:';

  @override
  String get teacherCodeLabelShort => '教师代码:';

  @override
  String get teacherDepartmentLabel => '系别:';

  @override
  String get teacherGenderLabel => '性别:';

  @override
  String get teacherBirthDateLabel => '出生日期:';

  @override
  String get evaluationInstruction => '请评估以下标准:';

  @override
  String get question1 => '讲师是否清晰易懂地传达信息？';

  @override
  String get question2 => '讲师在教学中是否充满热情和奉献精神？';

  @override
  String get question3 => '您对讲师的教学方法满意吗？';

  @override
  String get question4 => '讲师是否鼓励学生提问并参与讨论？';

  @override
  String get question5 => '讲师是否提供了足够的材料和有用的学习资源？';

  @override
  String get question6 => '讲师是否公平客观地进行评估？';

  @override
  String get question7 => '讲师是否有效解决出现的问题？';

  @override
  String get question8 => '在与讲师互动时，您是否感到受到尊重和倾听？';

  @override
  String get question9 => '总的来说，您对这位讲师满意吗？';

  @override
  String get submitEvaluationButton => '提交评价';

  @override
  String get evaluationSuccessMessage => '您的评价已成功提交！';

  @override
  String get evaluationErrorMessage => '请评估所有问题。';

  @override
  String get notificationSettingsTitle => '通知设置';

  @override
  String get blockedNotificationTypesTitle => '按类型阻止通知';

  @override
  String get blockChatNotifications => '阻止聊天通知';

  @override
  String get blockTimetableNotifications => '阻止时间表通知';

  @override
  String get blockBroadcastNotifications => '阻止一般通知';

  @override
  String get blockMaintenanceNotifications => '阻止维护通知';

  @override
  String get blockAcademicWarningNotifications => '阻止学业警告通知';

  @override
  String get blockExamNotifications => '阻止考试通知';

  @override
  String get blockGroupNotifications => '阻止群组通知';

  @override
  String get notificationSoundsTitle => '通知声音';

  @override
  String get playSoundForChatNotifications => '播放聊天通知声音';

  @override
  String get playSoundForTimetableNotifications => '播放时间表通知声音';

  @override
  String get playSoundForBroadcastNotifications => '播放一般通知声音';

  @override
  String get playSoundForMaintenanceNotifications => '播放维护通知声音';

  @override
  String get playSoundForAcademicWarningNotifications => '播放学业警告通知声音';

  @override
  String get playSoundForExamNotifications => '播放考试通知声音';

  @override
  String get playSoundForGroupNotifications => '播放群组通知声音';
}
