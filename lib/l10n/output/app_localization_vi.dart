// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get language => 'Tiếng Việt';

  @override
  String get choose_language => 'Chọn ngôn ngữ của bạn';

  @override
  String get choose_theme => 'Chọn chủ đề của bạn';

  @override
  String get app_name => 'Mạng xã hội HUBT';

  @override
  String get university_name => 'Trường Đại học Kinh doanh và Công nghệ Hà Nội';

  @override
  String get department => 'Khoa Công Nghệ Thông Tin';

  @override
  String get home => 'Trang chủ';

  @override
  String get chat => 'Tin nhắn';

  @override
  String get timetable => 'Thời khoá biểu';

  @override
  String get menu => 'Menu';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get welcome => 'Xin chào!';

  @override
  String get welcome_info => 'Hãy trải nghiệm những điều thú vị cùng với HUBT SOCIAL.';

  @override
  String get sign_in => 'Đăng nhập';

  @override
  String get set_new_password => 'Đặt mật khẩu mới';

  @override
  String get enter_code => 'Nhập mã';

  @override
  String get student_code => 'Mã sinh viên';

  @override
  String get user_name => 'Tên đăng nhập';

  @override
  String get first_name => 'Tên của bạn';

  @override
  String get first_name_hint => 'Vui lòng nhập tên của bạn';

  @override
  String get next => 'Tiếp Theo';

  @override
  String get last_name => 'Họ của bạn';

  @override
  String get last_name_hint => 'Vui lòng nhập họ của bạn';

  @override
  String get otp_expired => 'OTP đã hết hạn';

  @override
  String the_code_will(String value) {
    return 'Mã sẽ hết hạn sau: $value';
  }

  @override
  String get email => 'Email';

  @override
  String get save_changes => 'Lưu thay đổi';

  @override
  String get edit_profile => 'Cập nhật thông tin';

  @override
  String get change_photo => 'Đổi ảnh đại diện';

  @override
  String get about_this_profile => 'Thông tin cá nhân';

  @override
  String get birth_of_date => 'Ngày tháng năm sinh';

  @override
  String get gender => 'Giới tính';

  @override
  String get signup_information => 'Thông tin cá nhân ';

  @override
  String get phone_number => 'Số điện thoại';

  @override
  String get skip => 'Bỏ qua';

  @override
  String get username_or_email => 'Tên đăng nhập hoặc Email';

  @override
  String get do_not_have_an_account => 'Bạn chưa có tài khoản?';

  @override
  String get already_have_an_account => 'Bạn đã có tài khoản?';

  @override
  String get remember_me => 'Lưu tài khoản';

  @override
  String get forgot_password_question_mark => 'Quên tài khoản của bạn?';

  @override
  String get forgot_password => 'Quên Mật Khẩu';

  @override
  String get password_verify => 'Xác minh OTP';

  @override
  String get sign_up => 'Đăng ký';

  @override
  String get password => 'Mật khẩu';

  @override
  String get confirm_password => 'Xác nhận mật khẩu';

  @override
  String get continue_text => 'Tiếp tục';

  @override
  String get required => 'Vui lòng nhập';

  @override
  String get enter_valid_email => 'Vui lòng nhập email';

  @override
  String get password_change_successful => 'Thay đổi mật khẩu thành công!';

  @override
  String password_must_be_at_least(int value) {
    return 'Mật khẩu phải dài ít nhất $value ký tự';
  }

  @override
  String get password_must_contain_at_least_one_capital_letter => 'Mật khẩu phải chứa ít nhất một chữ in hoa';

  @override
  String get theme_system => 'Hệ thống';

  @override
  String get theme_light => 'Sáng';

  @override
  String get theme_dark => 'Tối';

  @override
  String get forgot_password_message => 'Vui lòng nhập Tên đăng nhập hoặc Email của bạn để đặt lại mật khẩu';

  @override
  String enter_otp_message(String maskMail) {
    return 'Enter the 6-digit code we sent you at Email $maskMail ';
  }

  @override
  String get enter_message => 'Vui lòng nhập Tên đăng nhập hoặc Email của bạn để đặt lại mật khẩu';

  @override
  String get resend => 'Gửi lại';

  @override
  String get otp_expire_message => 'Tin nhắn OTP đã hết hạn';

  @override
  String get starts => 'Bắt Đầu';

  @override
  String get notifications => 'Thông báo';

  @override
  String get markAllAsRead => 'Đánh dấu tất cả là đã đọc';

  @override
  String get noNotifications => 'Không có thông báo nào';

  @override
  String get justNow => 'Vừa xong';

  @override
  String minutesAgo(int minutes) {
    return '$minutes phút trước';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours giờ trước';
  }

  @override
  String get timeFormat => 'dd/MM/yyyy HH:mm';

  @override
  String get follow => 'Theo dõi';

  @override
  String get share => 'Chia sẻ';

  @override
  String get post => 'Bài viết';

  @override
  String get reply => 'Trả lời';

  @override
  String get repost => 'Chia sẻ lại';

  @override
  String get camera => 'Máy ảnh';

  @override
  String get change_theme => 'Đổi chủ đề giao diện';

  @override
  String get change_language => 'Đổi ngôn ngữ';

  @override
  String get change_password => 'Đổi mật khẩu';

  @override
  String get support_center => 'Trung tâm hỗ trợ';

  @override
  String get feedback_for_developers => 'Góp ý cho nhà phát triển';

  @override
  String get delete_account => 'Xóa tài khoản';

  @override
  String get sign_out => 'Đăng xuất';

  @override
  String get see_your_personal_page => 'Xem trang cá nhân của bạn!';

  @override
  String get try_again => 'Thử lại';

  @override
  String get no_messages => 'Không có tin nhắn';

  @override
  String get click_to_try_again => 'Nhấn để thử lại';

  @override
  String get calender_format_month => 'Tháng';

  @override
  String get calender_format_2_week => '2 Tuần';

  @override
  String get calender_format_week => 'Tuần';

  @override
  String get the_day_before => 'ngày trước';

  @override
  String get the_time_before => 'giờ trước';

  @override
  String get the_muniest_before => 'phút trước';

  @override
  String get just_finished => 'Vừa xong';

  @override
  String get all => 'Tất cả';

  @override
  String get unread => 'Chưa đọc';

  @override
  String get system => 'Hệ thống';

  @override
  String get messages => 'Tin nhắn';

  @override
  String get groups => 'Nhóm';

  @override
  String get schedule => 'Lịch học';

  @override
  String get screen_not_found => 'Không tìm thấy';

  @override
  String get screen_not_found_oh_no => 'Ôi không!';

  @override
  String get screen_not_found_message => 'Không tìm thấy';

  @override
  String get screen_not_found_back => 'Quay lại';

  @override
  String question_value(String value) {
    return 'Câu hỏi $value';
  }

  @override
  String question_count(int value) {
    return '$value câu hỏi';
  }

  @override
  String duration_minutes(int value) {
    return '$value phút';
  }

  @override
  String credits(int value) {
    return '$value tín chỉ';
  }

  @override
  String get congratulation => 'Chúc mừng bạn!';

  @override
  String get youHaveCompletedQuiz => 'Bạn đã hoàn thành bài kiểm tra';

  @override
  String get score => 'Điểm số';

  @override
  String get testTime => 'Thời gian làm bài';

  @override
  String get backToHomepage => 'Về trang chủ';

  @override
  String get quizDetailTitle => 'Tiêu đề bài kiểm tra';

  @override
  String get shuffleQuestions => 'Trộn câu hỏi';

  @override
  String get shuffleAnswers => 'Trộn câu trả lời';

  @override
  String get startQuiz => 'Bắt đầu bài kiểm tra';
}
