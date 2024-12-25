import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/api/api_request.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../main_wrapper/ui/widgets/main_app_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
      final response = await APIRequest.get(
          url:
              "https://jsonplaceholder.typicode.com/posts?_limit=20&_page=$pageKey");

      if (response.statusCode == 200) {
        final List newItems = json.decode(response.body);

        List<String> items = [];

        items.addAll(newItems.map<String>((item) {
          final id = item['id'];
          return 'Item $id';
        }).toList());

        _pagingController.appendPage(items, pageKey + 1);
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
          title: context.loc.chat,
        )
      ],
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Text("data"),
            ),
            PagedSliverList(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<String>(
                animateTransitions: true,
                transitionDuration: const Duration(milliseconds: 500),
                itemBuilder: (context, item, index) => ListTile(
                  title: Text(item),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
