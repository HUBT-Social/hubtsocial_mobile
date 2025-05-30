import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/features/profile/presentation/widgets/edit_profile_form.dart';
import 'package:hubtsocial_mobile/src/features/profile/presentation/widgets/edit_profile_header.dart';
import 'package:provider/provider.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_provider.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hubtsocial_mobile/src/features/user/data/repos/user_repo_impl.dart';
import 'package:get_it/get_it.dart';
import 'dart:io';
import 'package:hubtsocial_mobile/src/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/presentation/dialog/app_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      // Update avatar immediately when image is selected
      final user = context.read<UserProvider>().user;
      if (user != null) {
        context.read<UserBloc>().add(
              UpdateUserAvatarEvent(
                newImage: _selectedImage!,
              ),
            );
      }
    }
  }

  Future<void> _updateName() async {
    if (!_formKey.currentState!.validate()) return;

    final user = context.read<UserProvider>().user;
    if (user == null) return;

    context.read<UserBloc>().add(
          UpdateUserNameEvent(
            userId: user.userName,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Define sizes and positions based on design images
    // Approximate values based on visual inspection and provided dimensions (360x372 for form/button area)
    final double screenHeight = MediaQuery.of(context).size.height;
    final double greenAreaHeight =
        screenHeight * 0.28; // Adjusted based on visual
    final double avatarRadius = 50.r;
    final double borderRadius = 32.r; // Radius of the rounded corners
    // The white area should start so that the avatar is centered vertically on the overlap
    // Avatar center is at greenAreaHeight - overlapHeight / 2
    // Avatar top is at greenAreaHeight - overlapHeight / 2 - avatarRadius
    // Avatar bottom is at greenAreaHeight - overlapHeight / 2 + avatarRadius
    // Let's assume the white area starts around avatar center - a bit
    final double whiteAreaTop = greenAreaHeight -
        avatarRadius; // Start white area around avatar bottom position
    final double formPaddingTop =
        avatarRadius + 20.h; // Padding inside white area to clear avatar

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserProfileLoading) {
          AppDialog.showLoadingDialog(message: 'Updating profile...');
        } else if (state is UpdatedUserProfile) {
          AppDialog.closeDialog();
          if (_selectedImage == null) {
            // Only show success message and pop for name updates
            Navigator.pop(context);
            context.showSnackBarMessage('Profile updated successfully');
          } else {
            // For avatar updates, just show success message and refresh user data
            context.showSnackBarMessage('Avatar updated successfully');
            setState(() => _selectedImage = null);
            // Dispatch event to refresh user data after avatar update
            context.read<UserBloc>().add(const InitUserProfileEvent());
          }
        } else if (state is UserProfileError) {
          AppDialog.closeDialog();
          context.showSnackBarMessage(
              'Failed to update profile: ${state.message}',
              isError: true);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                Navigator.pop(context), // Assuming back button functionality
          ),
          title: Text(
            context.loc.edit_profile, // Use localized string for title
            style: context.textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            // Green Area with potential background image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: greenAreaHeight,
                decoration: BoxDecoration(
                  color: Colors
                      .green, // Replace with actual green color from design
                  // Comment out or remove if using a background image
                  // image: DecorationImage(
                  //   image: AssetImage('assets/images/background_green.png'),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
            ),
            // White Form Area (Scrollable) with rounded top corners
            Positioned(
              top: whiteAreaTop, // Position white area
              left: 0,
              right: 0,
              bottom: 0, // Extend to the bottom
              child: Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.surface, // White background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: formPaddingTop, // Padding to push content below avatar
                    left: 16.w,
                    right: 16.w,
                    bottom: 16.h, // Padding at the bottom of the scroll view
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Edit Profile Form Widget
                      EditProfileForm(
                        user: user,
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        formKey: _formKey, // Pass form key
                      ),
                      SizedBox(height: 24.h), // Space before button
                      // Save Changes Button
                      ElevatedButton(
                        onPressed: _updateName, // Use update name function
                        child: Text('Save Changes'), // Localize this text
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity,
                              48.h), // Adjusted height based on design look
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Avatar with camera icon (Positioned)
            Positioned(
              top: greenAreaHeight -
                  avatarRadius, // Position avatar relative to green area bottom
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                        radius: avatarRadius,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (user.avatarUrl.isNotEmpty
                                ? NetworkImage(user.avatarUrl)
                                : const AssetImage(
                                        'assets/images/default_avatar.png')
                                    as ImageProvider)),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 16.r,
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
      ),
    );
  }
}
