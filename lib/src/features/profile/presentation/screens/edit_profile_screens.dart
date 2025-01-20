// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
// import 'package:hubtsocial_mobile/src/core/app/providers/user_provider.dart';
// import 'package:provider/provider.dart';


// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   late TextEditingController firstNameController;
//   late TextEditingController lastNameController;
//   late TextEditingController emailController;
//   late TextEditingController phoneController;
//   late TextEditingController dateOfBirthController;
//   String selectedGender = 'Male';

//   @override
//   void initState() {
//     super.initState();
//     final user = context.read<UserProvider>().user;
//     firstNameController = TextEditingController(text: user?.firstName);
//     lastNameController = TextEditingController(text: user?.lastName);
//     emailController = TextEditingController(text: user?.email);
//     phoneController = TextEditingController(text: user?.phone);
//     dateOfBirthController = TextEditingController(text: user?.dateOfBirth);
//   }

//   @override
//   void dispose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     dateOfBirthController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = context.read<UserProvider>().user;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Edit Profile',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 20.h),
//               // Profile Image
//               Center(
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         final imageProvider = user?.avatarUrl != null
//                             ? NetworkImage(user!.avatarUrl)
//                             : const AssetImage('assets/icons/app_icon.png') as ImageProvider;
                        
//                         Navigator.push(
// context,
//                           MaterialPageRoute(
//                             builder: (context) => FullScreenImage(
//                               imageProvider: imageProvider,
//                               heroTag: 'profile-image',
//                             ),
//                           ),
//                         );
//                       },
//                       child: Hero(
//                         tag: 'profile-image',
//                         child: CircleAvatar(
//                           radius: 40.r,
//                           backgroundColor: Colors.blue[100],
//                           backgroundImage: user?.avatarUrl != null
//                               ? NetworkImage(user!.avatarUrl)
//                               : const AssetImage('assets/icons/app_icon.png')
//                                   as ImageProvider,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//                     Text(
//                       'Change photo',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 14.sp,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 24.h),
//               // Form Fields
//               _buildTextField(
//                 controller: firstNameController,
//                 label: 'First name *',
//                 hint: 'Enter first name',
//               ),
//               _buildTextField(
//                 controller: lastNameController,
//                 label: 'Last name *',
//                 hint: 'Enter last name',
//               ),
//               _buildDropdownField(
//                 label: 'Gender',
//                 value: selectedGender,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedGender = value!;
//                   });
//                 },
//               ),
//               _buildTextField(
//                 controller: dateOfBirthController,
//                 label: 'Date of birth',
//                 hint: 'dd/mm/yyyy',
//                 readOnly: true,
//                 onTap: () async {
//                   final date = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime.now(),
//                   );
//                   if (date != null) {
//                     dateOfBirthController.text =
//                         "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
//                   }
//                 },
//               ),
//               _buildTextField(
//                 controller: phoneController,
//                 label: 'Phone number *',
//                 hint: 'Enter phone number',
//                 keyboardType: TextInputType.phone,
//               ),
//               _buildTextField(
//                 controller: emailController,