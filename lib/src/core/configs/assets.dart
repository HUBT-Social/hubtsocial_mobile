// ignore_for_file: prefer_interpolation_to_compose_strings

const String assetsPart = "assets/";
const String imagesPart = assetsPart + "images/";
const String iconsPart = assetsPart + "icons/";

class Assets {
  Assets._();

  // static const String noInternet = imagesPart + "no_internet.png";
  // static const String logo = imagesPart + "logo.png";
  static const String appIcon = "assets/icons/app_icon.png";
  static const String startedBg = "assets/images/started_bg.jpg";

  static const String localizationVi = "assets/icons/localization_vi.png";
  static const String localizationEn = "assets/icons/localization_en.png";

  static const String themeSystem = "assets/icons/theme_system.svg";
  static const String themeLight = "assets/icons/theme_light.svg";
  static const String themeDark = "assets/icons/theme_dark.svg";

  static const screenNotFound = 'assets/lottie/screen_not_found.json';
  static const passwordSuccessful = 'assets/lottie/password_successful.json';
  static const verificationWaiting = 'assets/lottie/verification.json';
  static const success = 'assets/lottie/success.json';
  static const wrongInput = 'assets/lottie/wrong.json';
  static const writeInput = 'assets/lottie/write_form.json';
  static const paidSuccess = 'assets/lottie/wallet_paid_success.json';
  static const paidFailed = 'assets/lottie/wallet_paid_failed.json';
}

class AppIcons {
  AppIcons._();

  // static const back = iconsPart + "arrow-left.svg";
}
