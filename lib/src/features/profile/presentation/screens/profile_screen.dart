import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_provider.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/theme/utils/change_theme_bottom_sheet.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:provider/provider.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/features/profile/presentation/widgets/profile_action_buttons.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'about_profile_screens.dart';
import 'full_screen_image.dart';

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
            padding: const EdgeInsets.only(top: 2, left: 2, right: 12),
            child: GestureDetector(
              onTap: () {
                AppRoute.editProfile.push(context);
              },
              child: Container(
                width: 32,
                height: 32,
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
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (_) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Container(
                          width: 4,
                          height: 4,
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
            padding: const EdgeInsets.all(16),
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
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => AboutProfileUtils
                                    .showAboutProfileBottomSheet(
                                        navigatorKey.currentContext ?? context),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          nonNullUser
                                              .fullname, // Use nonNullUser
                                          style: context
                                              .textTheme.headlineMedium
                                              ?.copyWith(
                                            fontSize: (context
                                                        .textTheme
                                                        .headlineMedium
                                                        ?.fontSize ??
                                                    16) -
                                                4,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: Text(
                                  '@${nonNullUser.userName}', // Use nonNullUser
                                  style: context.textTheme.labelLarge?.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
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
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            if (nonNullUser.avatarUrl.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FullScreenImage(
                                    imageUrl: nonNullUser.avatarUrl,
                                    heroTag: 'profile-image',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Hero(
                            tag: 'profile-image',
                            child: CircleAvatar(
                              radius: 42,
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
                    const SizedBox(height: 32),
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
                                  color: Colors.white,
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
                                      backgroundColor: Colors.white,
                                      eyeStyle: QrEyeStyle(
                                        eyeShape: QrEyeShape.square,
                                        color:
                                            Color(0xFF4CAF50), // xanh lá mắt QR
                                      ),
                                      dataModuleStyle: QrDataModuleStyle(
                                        dataModuleShape:
                                            QrDataModuleShape.square,
                                        color: Colors.black,
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
                                  color: Colors.white,
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
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 12.h),
                                    BarcodeWidget(
                                      barcode: Barcode.code128(),
                                      data: userName,
                                      width: 260.w,
                                      height: 80.h,
                                      drawText: true,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600),
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
