import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_provider.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:provider/provider.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/features/profile/presentation/widgets/profile_action_buttons.dart';
import 'package:hubtsocial_mobile/src/features/profile/presentation/widgets/profile_status.dart';

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
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colorScheme.onPrimary,
                  width: 2.w,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 3.w,
                        height: 3.h,
                        decoration: BoxDecoration(
                          color: context.colorScheme.onPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        width: 3.w,
                        height: 3.h,
                        decoration: BoxDecoration(
                          color: context.colorScheme.onPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        width: 3.w,
                        height: 3.h,
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
            padding: EdgeInsets.all(16.r),
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
                            Row(
                              children: [
                                Text(
                                  user!.fullname,
                                  style: context.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: context.colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                              ],
                            ),
                            SizedBox(height: 11.h),
                            Text(
                              '@${user.lastName}',
                              style: context.textTheme.labelLarge?.copyWith(
                                color: context.colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 8.h),
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
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: context.colorScheme.surface,
                                    spreadRadius: 2.r,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 42.r,
                                backgroundImage: NetworkImage(user.avatarUrl),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.all(4.r),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: context.colorScheme.onPrimary,
                                    width: 2.w,
                                  ),
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: context.colorScheme.onPrimary,
                                  size: 12.r,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 32.h),
                const ProfileActionButtons(),
              ],
            ),
          ),
          SizedBox(height: 16.h),
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
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.surface,
                            blurRadius: 4.r,
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
}
