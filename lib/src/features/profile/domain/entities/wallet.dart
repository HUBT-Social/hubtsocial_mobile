import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
part 'wallet.g.dart';
@HiveType(typeId: 3)
class Wallet extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int balance;
  const Wallet({
    required this.id,
    required this.balance,
  });

  @override
  List<Object> get props => [id, balance];

  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'Wallet{id: $id, balance: $balance}';
  }
}
