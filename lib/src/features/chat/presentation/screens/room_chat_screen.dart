import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/presentation/widget/url_image.dart';

import 'data.dart';

class RoomChatScreen extends StatefulWidget {
  const RoomChatScreen(
      {required this.id,
      required this.title,
      required this.avatarUrl,
      super.key});
  final String id;
  final String title;
  final String avatarUrl;

  @override
  State<RoomChatScreen> createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  final _chatController = ChatController(
    initialMessageList: Data.messageList,
    scrollController: ScrollController(),
    currentUser: ChatUser(
      id: '1',
      name: 'Flutter',
      profilePhoto: Data.profileImage,
    ),
    otherUsers: [
      ChatUser(
        id: '2',
        name: 'Simform',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '3',
        name: 'Jhon',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '4',
        name: 'Mike',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '5',
        name: 'Rich',
        profilePhoto: Data.profileImage,
      ),
    ],
  );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
        chatController: _chatController,
        onSendTap: _onSendTap,
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Row(
            children: [
              UrlImage.circle(widget.avatarUrl, size: 36.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: context.textTheme.labelLarge
                          ?.copyWith(color: context.colorScheme.onPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "online",
                      style: context.textTheme.labelSmall
                          ?.copyWith(color: context.colorScheme.onPrimary),
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
              tooltip: 'Simulate Message receive',
              onPressed: receiveMessage,
              icon: Icon(
                Icons.supervised_user_circle,
                color: context.colorScheme.onPrimary,
              ),
            ),
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
          textFieldBackgroundColor: context.colorScheme.surfaceContainerHighest,
          textFieldConfig: TextFieldConfiguration(
            onMessageTyping: (status) {
              /// Do with status
              logger.d(status.toString());
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
            receiptsWidgetConfig:
                const ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
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
          buttonTextStyle: TextStyle(color: context.colorScheme.onSurface),
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
            margin: EdgeInsets.symmetric(horizontal: 12.r, vertical: 15.r),
            shareIconConfig: ShareIconConfiguration(
              defaultIconBackgroundColor: context.colorScheme.surfaceContainer,
              defaultIconColor: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        profileCircleConfig: const ProfileCircleConfiguration(
          profileImageUrl: Data.profileImage,
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
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: context.colorScheme.outline,
              ),
            ),
            textStyle: TextStyle(
              color: context.colorScheme.onSurface,
            ),
          ),
          onTap: (item) =>
              _onSendTap(item.text, const ReplyMessage(), MessageType.text),
        ),
      ),
    );
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    _chatController.addMessage(
      Message(
        id: DateTime.now().toString(),
        createdAt: DateTime.now(),
        message: message,
        sentBy: _chatController.currentUser.id,
        replyMessage: replyMessage,
        messageType: messageType,
      ),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatController.initialMessageList.last.setStatus =
          MessageStatus.undelivered;
    });
    Future.delayed(const Duration(seconds: 1), () {
      _chatController.initialMessageList.last.setStatus = MessageStatus.read;
    });
  }
}
