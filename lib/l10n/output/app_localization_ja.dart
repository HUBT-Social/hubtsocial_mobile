// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get language => '日本語';

  @override
  String get choose_language => 'ご希望の言語を選択してください';

  @override
  String get choose_theme => 'ご希望のテーマを選択してください';

  @override
  String get app_name => 'HUBTソーシャル';

  @override
  String get university_name => 'ハノイ経営工科大学';

  @override
  String get department => '情報技術学部';

  @override
  String get home => 'ホーム';

  @override
  String get chat => 'チャット';

  @override
  String get timetable => '時間割';

  @override
  String get menu => 'メニュー';

  @override
  String get profile => 'プロフィール';

  @override
  String get welcome => 'ようこそ！';

  @override
  String get welcome_info => 'HUBTソーシャルで面白いことを体験しましょう。';

  @override
  String get sign_in => 'サインイン';

  @override
  String get set_new_password => '新しいパスワードを設定';

  @override
  String get enter_code => 'コードを入力';

  @override
  String get student_code => '学生コード';

  @override
  String get user_name => 'ユーザー名';

  @override
  String get first_name => '名';

  @override
  String get next => '次へ';

  @override
  String get last_name => '姓';

  @override
  String get otp_expired => 'OTPの有効期限が切れました';

  @override
  String the_code_will(String value) {
    return 'コードは$value後に期限切れになります';
  }

  @override
  String get email => 'メールアドレス';

  @override
  String get save_changes => '変更を保存';

  @override
  String get edit_profile => 'プロフィールを編集';

  @override
  String get change_photo => '写真を変更';

  @override
  String get about_this_profile => 'このプロフィールについて';

  @override
  String get birth_of_date => '生年月日';

  @override
  String get gender => '性別';

  @override
  String get signup_information => '情報';

  @override
  String get phone_number => '電話番号';

  @override
  String get skip => 'スキップ';

  @override
  String get username_or_email => 'ユーザー名またはメールアドレス';

  @override
  String get do_not_have_an_account => 'アカウントをお持ちではありませんか？';

  @override
  String get already_have_an_account => 'すでにアカウントをお持ちですか？';

  @override
  String get remember_me => 'ログイン情報を記憶する';

  @override
  String get forgot_password_question_mark => 'アカウントをお忘れですか？';

  @override
  String get forgot_password => 'パスワードをお忘れですか';

  @override
  String get password_verify => 'OTP認証';

  @override
  String get sign_up => 'サインアップ';

  @override
  String get password => 'パスワード';

  @override
  String get confirm_password => 'パスワードを確認';

  @override
  String get continue_text => '続行';

  @override
  String get required => '入力してください';

  @override
  String get enter_valid_email => '有効なメールアドレスを入力してください';

  @override
  String get password_change_successful => 'パスワードの変更に成功しました！';

  @override
  String password_must_be_at_least(int value) {
    return 'パスワードは$value文字以上である必要があります';
  }

  @override
  String get password_must_contain_at_least_one_capital_letter => 'パスワードには少なくとも1つの大文字を含める必要があります';

  @override
  String get theme_system => 'システム';

  @override
  String get theme_light => 'ライト';

  @override
  String get theme_dark => 'ダーク';

  @override
  String get forgot_password_message => 'パスワードをリセットするには、ユーザー名またはメールアドレスを入力してください';

  @override
  String enter_otp_message(String maskMail) {
    return 'メールアドレス$maskMailに送信された6桁のコードを入力してください';
  }

  @override
  String get enter_message => 'パスワードをリセットするには、ユーザー名またはメールアドレスを入力してください';

  @override
  String get resend => '再送信';

  @override
  String get otp_expire_message => 'OTP有効期限切れメッセージ';

  @override
  String get starts => '開始';

  @override
  String get notifications => '通知';

  @override
  String get markAllAsRead => 'すべて既読にする';

  @override
  String get noNotifications => '通知はありません';

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(int minutes) {
    return '$minutes分前';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours時間前';
  }

  @override
  String get timeFormat => 'yyyy/MM/dd HH:mm';

  @override
  String get follow => 'フォロー';

  @override
  String get share => '共有';

  @override
  String get post => '投稿';

  @override
  String get reply => '返信';

  @override
  String get repost => '再投稿';

  @override
  String get camera => 'カメラ';

  @override
  String get change_theme => 'テーマを変更';

  @override
  String get change_language => '言語を変更';

  @override
  String get change_password => 'パスワードを変更';

  @override
  String get support_center => 'サポートセンター';

  @override
  String get feedback_for_developers => '開発者へのフィードバック';

  @override
  String get delete_account => 'アカウントを削除';

  @override
  String get sign_out => 'サインアウト';

  @override
  String get see_your_personal_page => 'あなたの個人ページを見る!';

  @override
  String get try_again => '再試行';

  @override
  String get no_messages => 'メッセージはありません';

  @override
  String get click_to_try_again => '再試行するにはクリックしてください';

  @override
  String get calender_format_month => '月';

  @override
  String get calender_format_2_week => '2週間';

  @override
  String get calender_format_week => '週';

  @override
  String get the_day_before => '前日';

  @override
  String get the_time_before => '数時間前';

  @override
  String get the_muniest_before => '数分前';

  @override
  String get just_finished => 'ちょうど終わった';

  @override
  String get all => 'すべて';

  @override
  String get unread => '未読';

  @override
  String get system => 'システム';

  @override
  String get messages => 'メッセージ';

  @override
  String get groups => 'グループ';

  @override
  String get schedule => 'スケジュール';
}
