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
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 2, right: 12),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(3, (_) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: context.colorScheme.onPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                ],
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
                              // Use nonNullUser
                              navigatorKey.currentContext?.push(
                                AppRoute.fullProfile.path,
                                extra: {
                                  'imageUrl':
                                      nonNullUser.avatarUrl, // Use nonNullUser
                                  'heroTag': 'profile-image',
                                },
                              );
                            }
                          },
                          child: Hero(
                            tag: 'profile-image',
                            child: CircleAvatar(
                              radius: 42,
                              backgroundImage: nonNullUser
                                      .avatarUrl.isNotEmpty // Use nonNullUser
                                  ? NetworkImage(
                                      nonNullUser.avatarUrl) // Use nonNullUser
                                  : const AssetImage(
                                          'assets/images/default_avatar.png')
                                      as ImageProvider,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const ProfileActionButtons(),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
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
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                            offset: const Offset(0, 4),
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
