import 'dart:convert';

import 'package:equatable/equatable.dart';

class ForgotPasswordResponseModel extends Equatable {
  const ForgotPasswordResponseModel({
    required this.email,
    required this.message,
  });

  final String? email;
  final String? message;

  ForgotPasswordResponseModel copyWith({
    String? email,
    String? message,
  }) {
    return ForgotPasswordResponseModel(
      email: email ?? this.email,
      message: message ?? this.message,
    );
  }

  factory ForgotPasswordResponseModel.fromMap(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      email: json["email"],
      message: json["message"],
    );
  }

  factory ForgotPasswordResponseModel.fromJson(String source) =>
      ForgotPasswordResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
        "email": email,
        "message": message,
      };

  @override
  String toString() {
    return "$email, $message, ";
  }

  @override
  List<Object?> get props => [
        email,
        message,
      ];
}
