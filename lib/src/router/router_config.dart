enum Screen {
  splash,
  login,
  home,
  notifications,
  profile,
  error,
}

extension RouterConfig on Screen {
  String get screenPath {
    switch (this) {
      case Screen.splash:
        return "/";
      case Screen.home:
        return "/home";
      case Screen.notifications:
        return "/notifications";
      case Screen.profile:
        return "/profile";
      case Screen.login:
        return "/login";
      case Screen.error:
        return "/error";
      default:
        return "/404";
    }
  }
}
