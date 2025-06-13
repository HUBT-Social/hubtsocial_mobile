// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get language => 'Русский';

  @override
  String get choose_language => 'Выберите предпочитаемый язык';

  @override
  String get choose_theme => 'Выберите предпочитаемую тему';

  @override
  String get app_name => 'HUBT Social';

  @override
  String get university_name => 'Ханойский университет бизнеса и технологий';

  @override
  String get department => 'Факультет информационных технологий';

  @override
  String get home => 'Главная';

  @override
  String get chat => 'Чат';

  @override
  String get timetable => 'Расписание';

  @override
  String get menu => 'Меню';

  @override
  String get profile => 'Профиль';

  @override
  String get welcome => 'Добро пожаловать!';

  @override
  String get welcome_info => 'Испытайте интересные вещи с HUBT SOCIAL.';

  @override
  String get sign_in => 'Войти';

  @override
  String get set_new_password => 'Установить новый пароль';

  @override
  String get enter_code => 'Введите код';

  @override
  String get student_code => 'Студенческий код';

  @override
  String get user_name => 'Имя пользователя';

  @override
  String get first_name => 'Имя';

  @override
  String get first_name_hint => 'Пожалуйста, введите ваше имя';

  @override
  String get next => 'Далее';

  @override
  String get last_name => 'Фамилия';

  @override
  String get last_name_hint => 'Пожалуйста, введите вашу фамилию';

  @override
  String get otp_expired => 'Срок действия OTP истек';

  @override
  String the_code_will(String value) {
    return 'Срок действия кода истечет через: $value';
  }

  @override
  String get email => 'Электронная почта';

  @override
  String get save_changes => 'Сохранить изменения';

  @override
  String get edit_profile => 'Редактировать профиль';

  @override
  String get change_photo => 'Сменить фото';

  @override
  String get about_this_profile => 'Об этом профиле';

  @override
  String get birth_of_date => 'Дата рождения';

  @override
  String get gender => 'Пол';

  @override
  String get signup_information => 'Информация';

  @override
  String get phone_number => 'Номер телефона';

  @override
  String get skip => 'Пропустить';

  @override
  String get username_or_email => 'Имя пользователя или Email';

  @override
  String get do_not_have_an_account => 'Нет аккаунта?';

  @override
  String get already_have_an_account => 'У вас уже есть аккаунт?';

  @override
  String get remember_me => 'Запомнить меня';

  @override
  String get forgot_password_question_mark => 'Забыли свой аккаунт?';

  @override
  String get forgot_password => 'Забыли пароль';

  @override
  String get password_verify => 'Проверка OTP';

  @override
  String get sign_up => 'Зарегистрироваться';

  @override
  String get password => 'Пароль';

  @override
  String get confirm_password => 'Подтвердите пароль';

  @override
  String get continue_text => 'Продолжить';

  @override
  String get required => 'Пожалуйста введите';

  @override
  String get enter_valid_email => 'Введите действительный email';

  @override
  String get password_change_successful => 'Пароль успешно изменен!';

  @override
  String password_must_be_at_least(int value) {
    return 'Пароль должен содержать не менее $value символов';
  }

  @override
  String get password_must_contain_at_least_one_capital_letter => 'Пароль должен содержать хотя бы одну заглавную букву';

  @override
  String get theme_system => 'Системная';

  @override
  String get theme_light => 'Светлая';

  @override
  String get theme_dark => 'Темная';

  @override
  String get forgot_password_message => 'Пожалуйста, введите ваше имя пользователя или Email для сброса пароля';

  @override
  String enter_otp_message(String maskMail) {
    return 'Введите 6-значный код, который мы отправили вам на Email $maskMail';
  }

  @override
  String get enter_message => 'Пожалуйста, введите ваше имя пользователя или Email для сброса пароля';

  @override
  String get resend => 'Отправить повторно';

  @override
  String get otp_expire_message => 'Срок действия OTP истек';

  @override
  String get starts => 'Начать';

  @override
  String get notifications => 'Уведомления';

  @override
  String get markAllAsRead => 'Отметить все как прочитанные';

  @override
  String get noNotifications => 'Нет уведомлений';

  @override
  String get justNow => 'Только что';

  @override
  String minutesAgo(int minutes) {
    return '$minutes минут назад';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours часов назад';
  }

  @override
  String get timeFormat => 'dd.MM.yyyy HH:mm';

  @override
  String get follow => 'Подписаться';

  @override
  String get share => 'Поделиться';

  @override
  String get post => 'Пост';

  @override
  String get reply => 'Ответить';

  @override
  String get repost => 'Репост';

  @override
  String get camera => 'Камера';

  @override
  String get change_theme => 'Сменить тему';

  @override
  String get change_language => 'Сменить язык';

  @override
  String get change_password => 'Сменить пароль';

  @override
  String get support_center => 'Центр поддержки';

  @override
  String get feedback_for_developers => 'Обратная связь для разработчиков';

  @override
  String get delete_account => 'Удалить аккаунт';

  @override
  String get sign_out => 'Выйти';

  @override
  String get see_your_personal_page => 'Посмотреть свою личную страницу!';

  @override
  String get try_again => 'Попробовать снова';

  @override
  String get no_messages => 'Нет сообщений';

  @override
  String get click_to_try_again => 'Нажмите, чтобы попробовать снова';

  @override
  String get calender_format_month => 'Месяц';

  @override
  String get calender_format_2_week => '2 недели';

  @override
  String get calender_format_week => 'Неделя';

  @override
  String get the_day_before => 'день назад';

  @override
  String get the_time_before => 'час назад';

  @override
  String get the_muniest_before => 'минуту назад';

  @override
  String get just_finished => 'Только что завершено';

  @override
  String get all => 'Все';

  @override
  String get unread => 'Непрочитанные';

  @override
  String get system => 'Система';

  @override
  String get messages => 'Сообщения';

  @override
  String get groups => 'Группы';

  @override
  String get schedule => 'Расписание';

  @override
  String get screen_not_found => 'Экран не найден';

  @override
  String get screen_not_found_oh_no => 'Oй нет!';

  @override
  String get screen_not_found_message => 'Не найдено';

  @override
  String get screen_not_found_back => 'Назад';

  @override
  String question_value(String value) {
    return 'Вопрос $value';
  }

  @override
  String question_count(Object value) {
    return '$value вопросов';
  }

  @override
  String get teacherCodeInputTitle => 'Введите код преподавателя';

  @override
  String get teacherCodeLabel => 'Код преподавателя';

  @override
  String get teacherCodeHint => 'Пример: GV001';

  @override
  String get enterTeacherCodeInstruction => 'Пожалуйста, введите код преподавателя для продолжения';

  @override
  String get invalidTeacherCode => 'Неверный код преподавателя!';

  @override
  String duration_minutes(int value) {
    return '$value минут';
  }

  @override
  String credits(int value) {
    return 'Кредиты $value';
  }

  @override
  String get congratulation => 'Поздравляем!';

  @override
  String get youHaveCompletedQuiz => 'Вы завершили тест';

  @override
  String get score => 'Результат';

  @override
  String get testTime => 'Время теста';

  @override
  String get backToHomepage => 'Вернуться на главную страницу';

  @override
  String get quizDetailTitle => 'Название теста';

  @override
  String get shuffleQuestions => 'Перемешать вопросы';

  @override
  String get shuffleAnswers => 'Перемешать ответы';

  @override
  String get startQuiz => 'Начать тест';

  @override
  String zoom_cannot_be_accessed(String zoom_id) {
    return 'Zoom не может быть доступен $zoom_id';
  }

  @override
  String get copied => 'Скопировано';

  @override
  String get student_list => 'Список студентов';

  @override
  String get content => 'Содержание';

  @override
  String get evaluate => 'Оценить';

  @override
  String get information => 'Информация';

  @override
  String get present => 'Присутствует';

  @override
  String get absent => 'Отсутствует';

  @override
  String get late => 'Опоздание';

  @override
  String get exam_ban => 'Запрет на экзамен';

  @override
  String get study => 'Учеба';

  @override
  String get exam => 'Экзамен';

  @override
  String get seminar => 'Семинар';

  @override
  String get retake_exam => 'Пересдать экзамен';

  @override
  String get functions => 'Функции';

  @override
  String get revise => 'Повторение';

  @override
  String get module => 'Модуль';

  @override
  String get academic_result => 'Успеваемость';

  @override
  String get total_result => 'Общий результат';

  @override
  String get pending_subjects => 'Предметы в ожидании оценки';

  @override
  String get retake_subjects => 'Пересдача предметов';

  @override
  String get failed_subjects => 'Несданные предметы';

  @override
  String get score_analysis => 'Анализ оценок';

  @override
  String get subject_code => 'Код предмета';

  @override
  String get subject_name => 'Название предмета';

  @override
  String get credits_short => 'Кредиты';

  @override
  String get score10 => 'Оценка (10 баллов)';

  @override
  String get pay_tuition => 'Оплата обучения';

  @override
  String get school_survey => 'Школьный опрос';

  @override
  String get instructor_evaluation => 'Оценка преподавателя';

  @override
  String get academic_advisor => 'Учебный консультант';

  @override
  String get features_currently_in_development => 'Функции, которые в настоящее время разрабатываются';

  @override
  String get coming_soon => 'Скоро будет доступно';

  @override
  String get no_data => 'Нет данных';

  @override
  String get filter_notifications => 'Фильтр уведомлений';

  @override
  String get mark_all_as_read => 'Отметить все как прочитанные';

  @override
  String get no_notifications_in_filter => 'Нет уведомлений в этом фильтре';

  @override
  String get teacherEvaluationTitle => 'Оценка преподавателя';

  @override
  String get teacherInfoTitle => 'Информация о преподавателе:';

  @override
  String get teacherNameLabel => 'Имя преподавателя:';

  @override
  String get teacherCodeLabelShort => 'Код преподавателя:';

  @override
  String get teacherDepartmentLabel => 'Кафедра:';

  @override
  String get teacherGenderLabel => 'Пол:';

  @override
  String get teacherBirthDateLabel => 'Дата рождения:';

  @override
  String get evaluationInstruction => 'Пожалуйста, оцените следующие критерии:';

  @override
  String get question1 => 'Преподаватель объясняет ясно и понятно?';

  @override
  String get question2 => 'Преподаватель проявляет энтузиазм и преданность в преподавании?';

  @override
  String get question3 => 'Вы удовлетворены методами преподавания преподавателя?';

  @override
  String get question4 => 'Преподаватель поощряет студентов задавать вопросы и участвовать в обсуждениях?';

  @override
  String get question5 => 'Преподаватель предоставляет достаточно материалов и полезных учебных ресурсов?';

  @override
  String get question6 => 'Преподаватель оценивает справедливо и объективно?';

  @override
  String get question7 => 'Преподаватель эффективно решает возникающие проблемы?';

  @override
  String get question8 => 'Вы чувствуете уважение и что вас слушают при взаимодействии с преподавателем?';

  @override
  String get question9 => 'В целом, вы удовлетворены этим преподавателем?';

  @override
  String get submitEvaluationButton => 'Отправить оценку';

  @override
  String get evaluationSuccessMessage => 'Ваша оценка успешно отправлена!';

  @override
  String get evaluationErrorMessage => 'Пожалуйста, оцените все вопросы.';

  @override
  String get notificationSettingsTitle => 'Настройки уведомлений';

  @override
  String get blockedNotificationTypesTitle => 'Блокировать уведомления по типу';

  @override
  String get blockChatNotifications => 'Блокировать чат-уведомления';

  @override
  String get blockTimetableNotifications => 'Блокировать уведомления расписания';

  @override
  String get blockBroadcastNotifications => 'Блокировать общие уведомления';

  @override
  String get blockMaintenanceNotifications => 'Блокировать уведомления о техническом обслуживании';

  @override
  String get blockAcademicWarningNotifications => 'Блокировать уведомления об академических предупреждениях';

  @override
  String get blockExamNotifications => 'Блокировать уведомления об экзаменах';

  @override
  String get blockGroupNotifications => 'Блокировать групповые уведомления';

  @override
  String get notificationSoundsTitle => 'Звуки уведомлений';

  @override
  String get playSoundForChatNotifications => 'Воспроизводить звук для уведомлений чата';

  @override
  String get playSoundForTimetableNotifications => 'Воспроизводить звук для уведомлений расписания';

  @override
  String get playSoundForBroadcastNotifications => 'Воспроизводить звук для общих уведомлений';

  @override
  String get playSoundForMaintenanceNotifications => 'Воспроизводить звук для уведомлений о техническом обслуживании';

  @override
  String get playSoundForAcademicWarningNotifications => 'Воспроизводить звук для уведомлений об академических предупреждениях';

  @override
  String get playSoundForExamNotifications => 'Воспроизводить звук для уведомлений об экзаменах';

  @override
  String get playSoundForGroupNotifications => 'Воспроизводить звук для групповых уведомлений';
}
