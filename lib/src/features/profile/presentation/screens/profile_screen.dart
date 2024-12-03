import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/app/providers/user_provider.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/presentation/bloc/user_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider value, Widget? child) {
          if (value.user != null) {
            User user = value.user!;
            return Scaffold(
              appBar: AppBar(
                title: Text(user.lastName),
              ),
              body: Text(user.lastName),
            );
          } else {
            return Text("2");
          }
        },
      ),
    );
  }
}
