import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_provider.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/theme/utils/change_theme_bottom_sheet.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:provider/provider.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/features/profile/presentation/widgets/profile_action_buttons.dart';

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
          Positioned(
            top: 2,
            left: 2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colorScheme.onPrimary,
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: context.colorScheme.onPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: context.colorScheme.onPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: context.colorScheme.onPrimary,
                          shape: BoxShape.circle,
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    final user = userProvider.user;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () =>
                                  AboutProfileUtils.showAboutProfileBottomSheet(
                                      navigatorKey.currentContext ?? context),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          user!.fullname,
                                          style:
                                              context.textTheme.headlineMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Padding(
                              padding: EdgeInsets.only(left: 18),
                              child: Text(
                                '@${user.userName}',
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            // TODO: Implement status feature when User model is updated
                            // ProfileStatus(
                            //   status: user?.status ?? '',
                            //   onTap: () {
                            //     debugPrint('Tap on status');
                            //   },
                            // ),
                            Text(
                              'status...', // Temporary static text
                              style: context.textTheme.labelLarge?.copyWith(
                                color: context.colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            if (user.avatarUrl.isNotEmpty) {
                              navigatorKey.currentContext?.push(
                                AppRoute.fullProfile.path,
                                extra: {
                                  'imageUrl': user.avatarUrl,
                                  'heroTag': 'profile-image',
                                },
                              );
                            }
                          },
                          child: Hero(
                            tag: 'profile-image',
                            child: CircleAvatar(
                              radius: 42,
                              backgroundImage: user.avatarUrl.isNotEmpty
                                  ? NetworkImage(user.avatarUrl)
                                  : const AssetImage(
                                          'assets/images/default_avatar.png')
                                      as ImageProvider,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 32),
                const ProfileActionButtons(),
              ],
            ),
          ),
          SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            labelColor: context.colorScheme.onSurface,
            unselectedLabelColor: context.colorScheme.onSurface,
            indicatorColor: context.colorScheme.onSurface,
            tabs: [
              Tab(text: context.loc.post),
              Tab(text: context.loc.reply),
              Tab(text: context.loc.repost),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 110 / 160,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final colors = [
                      const Color(0xFFFFB6B6),
                      const Color(0xFFFF0000),
                      const Color(0xFF90EE90),
                      const Color(0xFF4B0082),
                      const Color(0xFFFFE4E1),
                      const Color(0xFFFFDAB9),
                    ];
                    return Container(
                      decoration: BoxDecoration(
                        color: colors[index],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.surface,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Center(child: Text(context.loc.reply)),
                Center(child: Text(context.loc.repost)),
              ],
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
