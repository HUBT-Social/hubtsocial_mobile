import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/features/profile/presentation/widgets/edit_profile_form.dart';
import 'package:hubtsocial_mobile/src/features/profile/presentation/widgets/save_button.dart';
import 'package:provider/provider.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_provider.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Nền xanh từ ảnh
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/background_green.png',
              height: screenHeight * 0.45,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Title và Form
          Column(
            children: [
              // Phần title chỉ có nút back
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Nút back
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Text "Cập nhật thông tin"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  context.loc.edit_profile,
                 style: context.textTheme.headlineMedium
                      ?.copyWith(color: context.colorScheme.onSurface),
                ),
              ),
              SizedBox(height: 50), // Khoảng trống cho avatar
              // Form trắng
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: screenWidth,
                    margin: EdgeInsets.only(bottom: 80),
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EditProfileForm(user: user),
                          const SizedBox(height: 16),
                          const SaveButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Avatar đè lên tất cả
          Positioned(
            top: 190,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.avatarUrl.isNotEmpty
                        ? NetworkImage(user.avatarUrl)
                        : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                  ),
                  // Biểu tượng máy ảnh
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // Logic thay đổi ảnh đại diện
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.green,
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
