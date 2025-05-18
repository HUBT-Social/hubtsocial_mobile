import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/extensions/string.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/chat_response_model.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';

import '../../../../core/presentation/widget/url_image.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({
    required this.chatModel,
    super.key,
  });
  final ChatResponseModel chatModel;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: ValueKey<String>(widget.chatModel.id.toString()),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: const [
            SlidableAction(
              onPressed: null,
              backgroundColor: Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archive',
            ),
            SlidableAction(
              flex: 2,
              onPressed: null,
              backgroundColor: Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: null,
              backgroundColor: Color(0xFF0392CF),
              foregroundColor: Colors.white,
              icon: Icons.save,
              label: 'Save',
            ),
            SlidableAction(
              onPressed: null,
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            AppRoute.roomChat
                .push(navigatorKey.currentContext!, queryParameters: {
              "id": widget.chatModel.id,
              "title": widget.chatModel.groupName,
              "avatarUrl": widget.chatModel.avatarUrl
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          UrlImage.circle(
                            widget.chatModel.avatarUrl,
                            size: 48.r,
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            height: 14.r,
                            width: 14.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.colorScheme.surface,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.chatModel.groupName,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.labelLarge?.copyWith(
                                    color: context.colorScheme.onSurface),
                              ),
                              Row(
                                children: [
                                  if (widget.chatModel.lassSender != null)
                                    Text(
                                      widget.chatModel.lassSender ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: context.textTheme.labelMedium
                                          ?.copyWith(
                                              color: context.colorScheme
                                                  .onSurfaceVariant),
                                    ),
                                  if (widget.chatModel.lassSender != null)
                                    Text(
                                      " : ",
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: context.textTheme.labelMedium
                                          ?.copyWith(
                                              color: context.colorScheme
                                                  .onSurfaceVariant),
                                    ),
                                  Flexible(
                                    child: Text(
                                      widget.chatModel.lastMessage!
                                          .decrypt(key: widget.chatModel.id),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: context.textTheme.labelMedium
                                          ?.copyWith(
                                              color: context.colorScheme
                                                  .onSurfaceVariant),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(),
                      Container(
                        height: 8.r,
                        width: 8.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colorScheme.tertiary,
                        ),
                      ),
                      Text(
                        widget.chatModel.lastInteractionTime ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelSmall
                            ?.copyWith(color: context.colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 18.w),
              ],
            ),
          ),
        ));
  }
}
