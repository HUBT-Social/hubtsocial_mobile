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
  String get next => 'Далее';

  @override
  String get last_name => 'Фамилия';

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
}
