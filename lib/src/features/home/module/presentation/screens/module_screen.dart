import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/extensions/string.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/presentation/widget/url_image.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/message_response_model.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/send_chat_request_model.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/datasources/chat_hub_connection.dart';
import 'package:hubtsocial_mobile/src/features/home/module/presentation/bloc/module_bloc.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:dio/dio.dart';
import 'package:hubtsocial_mobile/src/core/injections/injections.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({required this.id, super.key});
  final String id;

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  late final DioClient _dioClient;

  @override
  void initState() {
    super.initState();
    _dioClient = getIt<DioClient>();
    context.read<GetModuleBloc>().add(GetRoomMemberEvent(roomId: widget.id));

    ChatHubConnection.on("ReceiveChat", _handleReceiveChat);
    ChatHubConnection.on("ReceiveProcess", _handleReceiveProcess);
  }

  @override
  void dispose() {
    ChatHubConnection.off("ReceiveChat", method: _handleReceiveChat);
    ChatHubConnection.off("ReceiveProcess", method: _handleReceiveProcess);
    super.dispose();
  }

  late ChatController _chatController;

  void _showHideTypingIndicator() {
    _chatController.setTypingIndicator = !_chatController.showTypingIndicator;
  }

  void receiveMessage() async {
    _chatController.addMessage(
      Message(
        id: DateTime.now().toString(),
        message: 'I will schedule the meeting.',
        createdAt: DateTime.now(),
        sentBy: '2',
      ),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    _chatController.addReplySuggestions([
      const SuggestionItemData(text: 'Thanks.'),
      const SuggestionItemData(text: 'Thank you very much.'),
      const SuggestionItemData(text: 'Great.')
    ]);
  }

  bool _isLastPage = false;

  Future<void> loadMoreData() async {
    try {
      if (_isLastPage) return;

      final token = await ChatHubConnection.getAccessTokenFactory();

      final response = await _dioClient.get(
        EndPoint.roomHistory,
        queryParameters: {
          "ChatRoomId": widget.id,
          "CurrentQuantity": _chatController.initialMessageList.length,
          "Limit": 15,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        logger.e(
            'Failed to Fetch Module: statusCode: ${response.statusCode}: ${response.data.toString()}');
        throw ServerException(
          message: response.data.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      final List newItems = response.data;

      List<Message> items = [];

      var convertItems = newItems.map<Message>((item) {
        var message = Message.fromJson(item);
        var decryptMessage = message.message.decrypt(key: widget.id);
        var newMessage = message.copyWith(message: decryptMessage);
        return newMessage;
      }).toList();

      items.addAll(convertItems);

      if (items.isEmpty) {
        _isLastPage = true;
      } else {
        _chatController.loadMoreData(items);
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Failed to verify OTP password. Please try again later.',
        statusCode: '505',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetModuleBloc, GetModuleState>(
        builder: (context, state) {
          if (state is RoomMemberLoaded) {
            loadMoreData();
            _chatController = ChatController(
                initialMessageList: [],
                scrollController: ScrollController(),
                otherUsers: state.roomInfo.otherUsers,
                currentUser: state.roomInfo.currentUser);
            return ChatView(
              featureActiveConfig: const FeatureActiveConfig(
                enableSwipeToReply: false,
                enableSwipeToSeeTime: false,
                enableReactionPopup: false,
                enableTextField: true,
                enableCurrentUserProfileAvatar: false,
                enableOtherUserProfileAvatar: true,
                enableReplySnackBar: false,
                enablePagination: true,
                enableChatSeparator: true,
                enableDoubleTapToLike: false,
                lastSeenAgoBuilderVisibility: true,
                receiptsBuilderVisibility: true,
                enableOtherUserName: true,
                enableScrollToBottomButton: true,
              ),
              isLastPage: false, // Trạng thái trang cuối

              loadMoreData: loadMoreData,
              chatController: _chatController,
              onSendTap: _onSendTap,
              scrollToBottomButtonConfig: ScrollToBottomButtonConfig(
                backgroundColor: context.colorScheme.surfaceContainerLow,
                border: Border.all(color: Colors.transparent),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.colorScheme.primary,
                  weight: 10,
                  size: 30.r,
                ),
              ),
              chatViewState: ChatViewState.hasMessages,
              chatViewStateConfig: ChatViewStateConfiguration(
                loadingWidgetConfig: ChatViewStateWidgetConfiguration(
                  loadingIndicatorColor: context.colorScheme.primary,
                ),
                onReloadButtonTap: () {},
              ),
              typeIndicatorConfig: TypeIndicatorConfiguration(
                flashingCircleBrightColor: context.colorScheme.primaryFixedDim,
                flashingCircleDarkColor: context.colorScheme.primaryFixedDim,
              ),
              appBar: AppBar(
                toolbarHeight: 52.h,
                leadingWidth: 36.w,
                backgroundColor: context.colorScheme.primary,
                foregroundColor: context.colorScheme.onPrimary,
                title: Row(
                  children: [
                    UrlImage.circle(state.roomInfo.avatarUrl!, size: 36.r),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.roomInfo.title!,
                            style: context.textTheme.labelLarge?.copyWith(
                                color: context.colorScheme.onPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "online",
                            style: context.textTheme.labelSmall?.copyWith(
                                color: context.colorScheme.onPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    tooltip: 'Toggle TypingIndicator',
                    onPressed: _showHideTypingIndicator,
                    icon: Icon(
                      Icons.keyboard,
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Room Info',
                    onPressed: () {},
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                  // IconButton(
                  //   tooltip: 'Simulate Message receive',
                  //   onPressed: receiveMessage,
                  //   icon: Icon(
                  //     Icons.supervised_user_circle,
                  //     color: context.colorScheme.onPrimary,
                  //   ),
                  // ),
                ],
              ),
              chatBackgroundConfig: ChatBackgroundConfiguration(
                messageTimeIconColor: Colors.red,
                messageTimeTextStyle: TextStyle(color: Colors.blue),
                defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
                  textStyle: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                backgroundColor: context.colorScheme.surface,
              ),
              sendMessageConfig: SendMessageConfiguration(
                allowRecordingVoice: false,
                enableCameraImagePicker: false,
                enableGalleryImagePicker: false,
                imagePickerIconsConfig: ImagePickerIconsConfiguration(
                  cameraIconColor: context.colorScheme.primary,
                  galleryIconColor: context.colorScheme.primary,
                ),
                // micIconColor: context.colorScheme.primary,
                defaultSendButtonColor: context.colorScheme.primary,
                replyDialogColor: context.colorScheme.primaryContainer,
                replyTitleColor: context.colorScheme.onPrimaryContainer,
                replyMessageColor: context.colorScheme.onPrimaryContainer,
                closeIconColor: context.colorScheme.onSurface,
                textFieldBackgroundColor:
                    context.colorScheme.surfaceContainerHighest,
                textFieldConfig: TextFieldConfiguration(
                  onMessageTyping: (status) {
                    /// Do with status
                    // logger.d(status.toString());
                  },
                  compositionThresholdTime: const Duration(seconds: 1),
                  textStyle: context.textTheme.bodyLarge
                      ?.copyWith(color: context.colorScheme.onSurface),
                ),
                voiceRecordingConfiguration: VoiceRecordingConfiguration(
                  backgroundColor: context.colorScheme.surfaceContainerHighest,
                  recorderIconColor: context.colorScheme.primary,
                  waveStyle: WaveStyle(
                    showMiddleLine: false,
                    waveColor: context.colorScheme.primary,
                    extendWaveform: true,
                  ),
                ),
              ),
              chatBubbleConfig: ChatBubbleConfiguration(
                outgoingChatBubbleConfig: ChatBubble(
                  linkPreviewConfig: LinkPreviewConfiguration(
                    backgroundColor: context.colorScheme.surface,
                    bodyStyle: context.textTheme.bodyLarge,
                    titleStyle: context.textTheme.labelLarge,
                  ),
                  receiptsWidgetConfig: const ReceiptsWidgetConfig(
                      showReceiptsIn: ShowReceiptsIn.all),
                  color: context.colorScheme.primary,
                ),
                inComingChatBubbleConfig: ChatBubble(
                  linkPreviewConfig: LinkPreviewConfiguration(
                    linkStyle: TextStyle(
                      color: context.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                    backgroundColor: context.colorScheme.surfaceContainer,
                    bodyStyle: context.textTheme.bodyMedium,
                    titleStyle: context.textTheme.titleSmall,
                  ),
                  textStyle: TextStyle(color: context.colorScheme.onSurface),
                  onMessageRead: (message) {
                    /// send your message reciepts to the other client
                    logger.d('Message Read$message');
                  },
                  senderNameTextStyle:
                      TextStyle(color: context.colorScheme.onSurfaceVariant),
                  color: context.colorScheme.surfaceContainerLowest,
                ),
              ),
              replyPopupConfig: ReplyPopupConfiguration(
                backgroundColor: context.colorScheme.surfaceContainerHighest,
                buttonTextStyle:
                    TextStyle(color: context.colorScheme.onSurface),
                topBorderColor: context.colorScheme.outline,
              ),
              reactionPopupConfig: ReactionPopupConfiguration(
                shadow: BoxShadow(
                  color: context.colorScheme.shadow,
                  blurRadius: 20,
                ),
                backgroundColor: context.colorScheme.surfaceContainerHighest,
              ),
              messageConfig: MessageConfiguration(
                messageReactionConfig: MessageReactionConfiguration(
                  backgroundColor: context.colorScheme.surfaceContainer,
                  borderColor: context.colorScheme.surfaceContainer,
                  reactedUserCountTextStyle:
                      TextStyle(color: context.colorScheme.onSurfaceVariant),
                  reactionCountTextStyle:
                      TextStyle(color: context.colorScheme.onSurfaceVariant),
                  reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
                    backgroundColor: context.colorScheme.surfaceContainer,
                    reactedUserTextStyle: TextStyle(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    reactionWidgetDecoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                imageMessageConfig: ImageMessageConfiguration(
                  margin:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                  shareIconConfig: ShareIconConfiguration(
                    defaultIconBackgroundColor:
                        context.colorScheme.surfaceContainer,
                    defaultIconColor: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              profileCircleConfig: const ProfileCircleConfiguration(
                profileImageUrl:
                    "https://scontent.fhan14-1.fna.fbcdn.net/v/t39.30808-6/480816762_1043042661197757_4178065905203841065_n.jpg?_nc_cat=1&ccb=1-7&_nc_sid=127cfc&_nc_eui2=AeGY1ONKSThlkWPFuK6-YgFbkMe4D5ESGJmQx7gPkRIYmTmCeWWw9-NXDBPzbY-6gSFZWsTsucDsGvNdhIsianX5&_nc_ohc=BmXfOds6S_EQ7kNvgGhxaOZ&_nc_oc=AdhFqGP4O_ti8nmZIs4ffqHYykybTg-HpTkdV_K2m91u4d7N3ZVVIjsHOR4w0oviGiQ&_nc_zt=23&_nc_ht=scontent.fhan14-1.fna&_nc_gid=A-b297pL8lFHDcAq3RO1bvu&oh=00_AYC8ECbuAU8jXuhV9XnViL6glgovJj9pSm5Qr8NDHLahfA&oe=67C5DF6A",
              ),
              repliedMessageConfig: RepliedMessageConfiguration(
                backgroundColor: context.colorScheme.secondary,
                verticalBarColor: context.colorScheme.outline,
                repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
                  enableHighlightRepliedMsg: true,
                  highlightColor: context.colorScheme.primary,
                  highlightScale: 1.1,
                ),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.25,
                ),
                replyTitleTextStyle:
                    TextStyle(color: context.colorScheme.onSurfaceVariant),
              ),
              swipeToReplyConfig: SwipeToReplyConfiguration(
                replyIconColor: context.colorScheme.primary,
              ),
              replySuggestionsConfig: ReplySuggestionsConfig(
                itemConfig: SuggestionItemConfig(
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: context.colorScheme.outline,
                    ),
                  ),
                  textStyle: TextStyle(
                    color: context.colorScheme.onSurface,
                  ),
                ),
                onTap: (item) => _onSendTap(
                    item.text, const ReplyMessage(), MessageType.text),
              ),
            );
          } else if (state is ModuleProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ModuleLoadedError) {
            return Scaffold(
                appBar: AppBar(), body: Center(child: Text(state.message)));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) async {
    SendChatRequestModel sendChatRequestModel = SendChatRequestModel(
      groupId: widget.id,
      requestId: "message id ".generateRandomString(40),
      content: message.encrypt(key: widget.id),
      medias: null,
      files: null,
      replyToMessageId: replyMessage.messageId,
    );

    ChatHubConnection.invokeSendItemChat(sendChatRequestModel);

    // _chatController.addMessage(
    //   Message(
    //     id: sendChatRequestModel.requestId!,
    //     createdAt: DateTime.now(),
    //     message: sendChatRequestModel.content!,
    //     sentBy: _chatController.currentUser.id,
    //     replyMessage: replyMessage,
    //     messageType: messageType,
    //   ),
    // );
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   _chatController.initialMessageList.last.setStatus =
    //       MessageStatus.undelivered;
    // });
    // Future.delayed(const Duration(seconds: 1), () {
    //   _chatController.initialMessageList.last.setStatus = MessageStatus.read;
    // });
  }

  void _handleReceiveChat(List<Object?>? arguments) {
    final messageModel =
        MessageResponseModel.fromJson(arguments![0] as Map<String, dynamic>);
    if (widget.id == messageModel.groupId) {
      _chatController.addMessage(messageModel.message.copyWith(
          message: messageModel.message.message.decrypt(key: widget.id)));
    }
  }

  void _handleReceiveProcess(List<Object?>? arguments) {}
}
