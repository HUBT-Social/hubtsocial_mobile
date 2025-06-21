import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_provider.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/theme/utils/change_theme_bottom_sheet.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:provider/provider.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'about_profile_screens.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 2.h, left: 2.w, right: 12.w),
            child: GestureDetector(
              onTap: () {
                AppRoute.editProfile.push(context);
              },
              child: Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colorScheme.shadow.withOpacity(0.15),
                      blurRadius: 8,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (_) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Container(
                          width: 4.r,
                          height: 4.r,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                final user = userProvider.user;

                if (user == null) {
                  // Display a loading indicator or a placeholder if user is null
                  return const Center(child: CircularProgressIndicator());
                }

                // Create a local non-nullable variable
                final nonNullUser = user;

                // Now 'nonNullUser' is guaranteed to be non-null here
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(12.r),
                                onTap: () => AboutProfileUtils
                                    .showAboutProfileBottomSheet(
                                        navigatorKey.currentContext ?? context),
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 6.w),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          nonNullUser
                                              .fullname, // Use nonNullUser
                                          style:
                                              context.textTheme.headlineMedium,

                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Padding(
                                padding: EdgeInsets.only(left: 18.w),
                                child: Text(
                                  '@${nonNullUser.userName}', // Use nonNullUser
                                  style: context.textTheme.labelLarge?.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'status...', // Temporary static text
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: context.colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            if (nonNullUser.avatarUrl.isNotEmpty) {
                              navigatorKey.currentContext?.push(
                                AppRoute.fullProfile.path,
                                extra: {
                                  'imageUrl': nonNullUser.avatarUrl,
                                  'heroTag': 'profile-image',
                                },
                              );
                            }
                          },
                          child: Hero(
                            tag: 'profile-image',
                            child: CircleAvatar(
                              radius: 42.r,
                              backgroundImage: nonNullUser.avatarUrl.isNotEmpty
                                  ? NetworkImage(nonNullUser.avatarUrl)
                                  : const AssetImage(
                                          'assets/images/default_avatar.png')
                                      as ImageProvider,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        final user = userProvider.user;
                        if (user == null || user.userName.isEmpty) {
                          return Center(
                              child: Text('Không có username để tạo mã vạch!'));
                        }
                        final userName = user.userName;
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.surfaceBright,
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 10.r,
                                      offset: Offset(0, 4.h),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text('QR Code',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 12.h),
                                    QrImageView(
                                      data: userName,
                                      version: QrVersions.auto,
                                      size: 180.w,
                                      backgroundColor:
                                          context.colorScheme.surface,
                                      eyeStyle: QrEyeStyle(
                                        eyeShape: QrEyeShape.circle,
                                        color: context.colorScheme
                                            .primary, // xanh lá mắt QR
                                      ),
                                      dataModuleStyle: QrDataModuleStyle(
                                        dataModuleShape:
                                            QrDataModuleShape.square,
                                        color: context.colorScheme.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text('@$userName',
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 32.h),
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.surfaceBright,
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 10.r,
                                      offset: Offset(0, 4.h),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text('Barcode',
                                        style: context.textTheme.headlineSmall),
                                    SizedBox(height: 12.h),
                                    BarcodeWidget(
                                      barcode: Barcode.code128(),
                                      data: userName,
                                      width: 260.w,
                                      height: 80.h,
                                      drawText: true,
                                      backgroundColor:
                                          context.colorScheme.surfaceBright,
                                      color: context.colorScheme.onSurface,
                                      style:
                                          context.textTheme.bodyLarge?.copyWith(
                                        color: context.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
