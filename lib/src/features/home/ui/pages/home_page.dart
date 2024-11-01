import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

import '../../../../core/configs/assets.dart';
import '../../../main_wrapper/ui/widgets/main_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        MainAppBar(
          title: context.loc.home,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search_outlined,
                size: 18,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.message_rounded,
                size: 18,
              ),
            ),
          ],
        )
      ],
      body: ListView(
        // controller: scrollController,
        physics: const BouncingScrollPhysics(),
        children: [
          const Text("aaaaaaa"),
          const Text("aaaaaaa"),
          const Text("aaaaaaa"),
          const Text("aaaaaaa"),
          TextButton(
            onPressed: () {
              throw Exception();
            },
            child: Text("data"),
          ),
          Image.asset(
            Assets.appIcon,
            width: 120,
            height: 120,
          ),
          Container(
            height: 200,
            color: Colors.amber,
          ),
          Container(
            height: 500,
            color: Colors.red,
          ),
          Container(
            height: 800,
            color: Colors.blue,
          ),
          Container(
            height: 400,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
