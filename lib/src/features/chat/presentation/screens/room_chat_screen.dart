import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/api_request.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/local_storage/local_storage_key.dart';
import '../../../main_wrapper/ui/widgets/main_app_bar.dart';

class RoomChatScreen extends StatefulWidget {
  const RoomChatScreen({required this.id, required this.title, super.key});
  final String id;
  final String title;

  @override
  State<RoomChatScreen> createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  final _pagingController = PagingController<int, String>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var tokenBox = Hive.box(LocalStorageKey.token);
      if (tokenBox.isEmpty ||
          !tokenBox.containsKey(LocalStorageKey.userToken)) {
      } else if (tokenBox.isNotEmpty &&
          tokenBox.containsKey(LocalStorageKey.userToken)) {
        UserToken token = tokenBox.get(LocalStorageKey.userToken);

        final response = await APIRequest.get(
            url:
                "https://hubt-social-develop.onrender.com/api/chat/user/get-rooms",
            token: token.accessToken.toString());

        if (response.statusCode == 200) {
          final List newItems = json.decode(response.body);

          List<String> items = [];

          items.addAll(newItems.map<String>((item) {
            final id = item['id'];
            return 'Item $id';
          }).toList());

          if (items.isEmpty) {
            _pagingController.error = "items isEmpty";
          } else {
            _pagingController.appendPage(items, pageKey + 1);
          }
        }
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        MainAppBar(
          title: widget.title,
        )
      ],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100.h,
            ),
          ),
        ],
      ),
    );
  }
}
