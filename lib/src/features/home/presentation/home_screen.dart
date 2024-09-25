import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
        SliverAppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          floating: true,
          snap: true,
          title: Text(
            AppLocalizations.of(context)!.home,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w900),
          ),
        )
      ],
      body: ListView(
        children: [
          Text("aaaaaaa"),
          Text("aaaaaaa"),
          Text("aaaaaaa"),
          Text("aaaaaaa"),
          Container(
            height: 500,
            width: 100,
            color: Colors.amber,
          ),
          Container(
            height: 500,
            width: 100,
            color: Colors.red,
          ),
          Container(
            height: 500,
            width: 100,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
