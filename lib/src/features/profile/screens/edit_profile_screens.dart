import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/features/profile/presentation/widgets/edit_profile_form.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_provider.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:image_picker/image_picker.dart';
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

    final double screenHeight = MediaQuery.of(context).size.height;
    final double greenAreaHeight = screenHeight * 0.28;
    final double avatarRadius = 50.r;
    final double borderRadius = 32.r;

    final double whiteAreaTop = greenAreaHeight;
    final double avatarTop = greenAreaHeight - (4 / 3) * avatarRadius;
    final double formPaddingTop =
        (avatarTop + 2 * avatarRadius) - whiteAreaTop + 20.h;

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserProfileLoading) {
          AppDialog.showLoadingDialog(message: 'Updating profile...');
        } else if (state is UserProfileLoaded) {
          AppDialog.closeDialog();

          if (_selectedImage == null) {
            context.showSnackBarMessage('Profile updated successfully');
            Navigator.pop(context);
          } else {
            // For avatar updates
            context.showSnackBarMessage('Avatar updated successfully');
            setState(() => _selectedImage = null);
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
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            context.loc.edit_profile,
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: greenAreaHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background_green.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: whiteAreaTop,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: formPaddingTop,
                    left: 16.w,
                    right: 16.w,
                    bottom: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      EditProfileForm(
                        user: user,
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        formKey: _formKey,
                      ),
                      SizedBox(height: 24.h),
                      Center(
                        child: ElevatedButton(
                          onPressed: _updateName,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colorScheme.primary,
                            foregroundColor: context.colorScheme.onPrimary,
                            minimumSize: Size(300.w, 38.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                          ),
                          child: Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: avatarTop,
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
                          backgroundColor: context.colorScheme.onPrimary,
                          child: Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: context.colorScheme.onSurface,
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
