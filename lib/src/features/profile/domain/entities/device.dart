import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
part 'device.g.dart';
@HiveType(typeId: 4)
class Device extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String token;
  const Device({
    required this.id,
    required this.token,
  });

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id];
  @override
  String toString() {
    return 'Device{id: $id, token: $token}';
  }
}
