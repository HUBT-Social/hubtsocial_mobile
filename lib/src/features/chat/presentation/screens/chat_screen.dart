import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/chat_response_model.dart';
import 'package:hubtsocial_mobile/src/features/chat/presentation/widgets/chat_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../../main_wrapper/ui/widgets/main_app_bar.dart';
import '../bloc/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final hubConnection = HubConnectionBuilder()
      .withUrl(
        "https://hubt-social-develop.onrender.com/chathub",
      )
      // .withHubProtocol()
      .withAutomaticReconnect()
      .build();

  int pageKey = 0;
  final _pagingController = PagingController<int, ChatResponseModel>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      this.pageKey = pageKey;
      context.read<ChatBloc>().add(FetchChatEvent(
            page: pageKey,
          ));
    });

    startHub();

    super.initState();
  }

  Future<void> startHub() async {
    await hubConnection.start();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (_, state) async {
        if (state is ChatError) {
          _pagingController.error = state.message;
        } else if (state is FetchChatSuccess) {
          if (state.listChat.isEmpty) {
            _pagingController.error = "items isEmpty";
          } else {
            pageKey++;
            _pagingController.appendPage(state.listChat, pageKey);
          }
        }
      },
      builder: (context, state) {
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
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 16.r, left: 16.r, right: 16.r),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                          size: 20.dg,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: EdgeInsets.all(8.r),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide:
                                BorderSide(color: Colors.grey.shade100)),
                      ),
                    ),
                  ),
                ),
                PagedSliverList(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<ChatResponseModel>(
                    animateTransitions: true,
                    transitionDuration: const Duration(milliseconds: 500),
                    itemBuilder: (context, item, index) => ChatCard(
                      chatModel: item,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100.h,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
