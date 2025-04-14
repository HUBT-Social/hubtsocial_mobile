import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/datasources/chat_hub_connection.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/chat_response_model.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/message_response_model.dart';
import 'package:hubtsocial_mobile/src/features/chat/presentation/widgets/chat_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:signalr_netcore/hub_connection.dart';
import '../../../main_wrapper/presentation/widgets/main_app_bar.dart';
import '../bloc/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int pageKey = 0;
  final _pagingController = PagingController<int, ChatResponseModel>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      this.pageKey = pageKey;
      context.read<ChatBloc>().add(FetchChatEvent(page: pageKey));
    });

    if (ChatHubConnection.chatHubConnection.state ==
        HubConnectionState.Connected) {
      ChatHubConnection.chatHubConnection.on("ReceiveChat", _handleReceiveChat);
    }
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    ChatHubConnection.chatHubConnection
        .off("ReceiveChat", method: _handleReceiveChat);
    super.dispose();
  }

  void _handleReceiveChat(List<Object?>? arguments) {
    final message =
        MessageResponseModel.fromJson(arguments![0] as Map<String, dynamic>);

    final currentItems = _pagingController.itemList ?? [];

    final index = currentItems.indexWhere(
      (chat) {
        return chat.id == message.groupId;
      },
    );

    if (index != -1) {
      final chat = currentItems.removeAt(index);

      final vietnamTime = DateFormat('hh:mm a').format(
        message.message.createdAt.toLocal(),
      );

      final newChat = ChatResponseModel(
          lastMessage: message.message.message,
          lastInteractionTime: vietnamTime,
          id: chat.id,
          avatarUrl: chat.avatarUrl,
          groupName: chat.groupName);

      currentItems.insert(0, newChat);
      _pagingController.itemList = List<ChatResponseModel>.from(currentItems);
    }
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
            onRefresh: () => Future.sync(() => _pagingController.refresh()),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                //     child: TextField(
                //       decoration: InputDecoration(
                //         hintText: "Search...",
                //         hintStyle: TextStyle(color: Colors.grey.shade600),
                //         prefixIcon: Icon(
                //           Icons.search,
                //           color: Colors.grey.shade600,
                //           size: 20,
                //         ),
                //         filled: true,
                //         fillColor: Colors.grey.shade100,
                //         contentPadding: EdgeInsets.all(8),
                //         enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(20),
                //           borderSide: BorderSide(color: Colors.grey.shade100),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                PagedSliverList(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<ChatResponseModel>(
                    firstPageErrorIndicatorBuilder: (context) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.loc.no_messages,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              context.loc.click_to_try_again,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 48,
                            ),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton.icon(
                                onPressed:
                                    _pagingController.retryLastFailedRequest,
                                icon: const Icon(Icons.refresh),
                                label: Text(
                                  context.loc.try_again,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    animateTransitions: true,
                    transitionDuration: const Duration(milliseconds: 500),
                    itemBuilder: (context, item, index) => ChatCard(
                      chatModel: item,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
