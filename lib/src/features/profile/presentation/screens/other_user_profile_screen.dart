import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/theme/utils/change_theme_bottom_sheet.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final String? userName;
  const OtherUserProfileScreen({super.key, this.userName});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  // late TabController _tabController;

  @override
  void initState() {
    context.read<ProfileBloc>().add(GetUserProfile(widget.userName ?? ""));

    super.initState();
    // _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        title: Text(
          context.loc.profile,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineMedium?.copyWith(
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final userProfile = state.userProfile;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.shadow.withOpacity(0.3),
                            blurRadius: 10.r,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userProfile.fullname,
                                  style: context.textTheme.headlineMedium,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 8.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.w),
                                  child: Text(
                                    '@${userProfile.userName}',
                                    style:
                                        context.textTheme.labelLarge?.copyWith(
                                      color:
                                          context.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  userProfile.email ?? 'No email available',
                                  style: context.textTheme.labelLarge?.copyWith(
                                    color: context.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          GestureDetector(
                            onTap: () {
                              if (userProfile.avatarUrl.isNotEmpty) {
                                navigatorKey.currentContext?.push(
                                  AppRoute.fullProfile.path,
                                  extra: {
                                    'imageUrl': userProfile.avatarUrl,
                                    'heroTag': 'profile-image',
                                  },
                                );
                              }
                            },
                            child: Hero(
                              tag: 'profile-image',
                              child: CircleAvatar(
                                radius: 48.r,
                                backgroundImage: (userProfile
                                        .avatarUrl.isNotEmpty)
                                    ? NetworkImage(userProfile.avatarUrl)
                                    : const AssetImage(
                                            'assets/images/default_avatar.png')
                                        as ImageProvider,
                                onBackgroundImageError:
                                    (exception, stackTrace) => CircleAvatar(
                                  radius: 42.r,
                                  backgroundImage: AssetImage(
                                      'assets/images/default_avatar.png'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: context.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: context.colorScheme.shadow
                                      .withOpacity(0.3),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data: userProfile.userName,
                              version: QrVersions.auto,
                              size: 280.r,
                              backgroundColor: context.colorScheme.surface,
                              eyeStyle: QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: context.colorScheme.primary,
                              ),
                              dataModuleStyle: QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: context.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: context.colorScheme.shadow
                                      .withOpacity(0.3),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: userProfile.userName,
                              width: 280.w,
                              height: 100.h,
                              drawText: true,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              // Initial state or unexpected state
              return const Center(child: Text('Select a user to view profile'));
            }
          },
        ),
      ),
    );
  }

  void showThemeBottomSheet() {
    InkWell(
      onTap: () => ThemeUtils.showThemeBottomSheet(
          navigatorKey.currentContext ?? context),
    );
  }
}
