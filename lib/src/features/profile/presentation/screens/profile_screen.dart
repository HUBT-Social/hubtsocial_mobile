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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.loc.profile,
          style: context.textTheme.headlineMedium?.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto'),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.r),
            child: Container(
              width: 8.w,
              height: 8.h,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
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
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4CAF50),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 11.h),
                            Text(
                              '@${user?.lastName ?? ''}',
                              style: context.textTheme.labelLarge?.copyWith(
                                  color: context.colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto'),
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
                            const Text(
                              'status...', // Temporary static text
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
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
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 42,
                                backgroundImage: user?.avatarUrl != null
                                    ? NetworkImage(user!.avatarUrl)
                                    : const AssetImage(
                                            'assets/icons/app_icon.png')
                                        as ImageProvider,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 16.h),
                const SizedBox(height: 16),
                const ProfileActionButtons(),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
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
                  padding: EdgeInsets.all(8.r),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
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
                        borderRadius: BorderRadius.circular(8),
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
