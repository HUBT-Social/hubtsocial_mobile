import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/features/home/presentation/screens/teacher_screen.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

// Lớp dữ liệu giảng viên
class Teacher {
  final String code;
  final String name;
  final String department;
  final String gender;
  final String birthDate;

  Teacher({
    required this.code,
    required this.name,
    required this.department,
    required this.gender,
    required this.birthDate,
  });
}

// Dữ liệu giảng viên giả lập
final Map<String, Teacher> dummyTeachers = {
  'GV001': Teacher(
      code: 'GV001',
      name: 'Trần Quang Hưng',
      department: 'Khoa Công nghệ Thông tin',
      gender: 'Nam',
      birthDate: '3/20/1987'),
  'GV002': Teacher(
      code: 'GV002',
      name: 'Nguyễn Văn Ninh',
      department: 'Khoa Công nghệ Thông tin',
      gender: 'Nam',
      birthDate: '1/4/1984'),
  'GV003': Teacher(
      code: 'GV003',
      name: 'Đào Thị Phượng',
      department: 'Khoa Công nghệ Thông tin',
      gender: 'Nữ',
      birthDate: '11/3/1987'),
  'GV004': Teacher(
      code: 'GV004',
      name: 'Bùi Văn Duy',
      department: 'Khoa Công nghệ Thông tin',
      gender: 'Nam',
      birthDate: '8/22/1980'),
  'GV005': Teacher(
      code: 'GV005',
      name: 'Phạm Thị Ngừng',
      department: 'Khoa Công nghệ Thông tin',
      gender: 'Nữ',
      birthDate: '12/20/1986'),
  'GV006': Teacher(
      code: 'GV006',
      name: 'Mai Xuân Hà',
      department: 'Khoa Công nghệ Thông tin',
      gender: 'Nữ',
      birthDate: '4/25/1979'),
  // Thêm các giảng viên khác từ ảnh vào đây
  'GV007': Teacher(
      code: 'GV007',
      name: 'Dương Quỳnh Nga',
      department: 'Khoa Công nghệ Thông tin',
      gender: 'Nữ',
      birthDate: '1/29/1982'),
  'GV008': Teacher(
      code: 'GV008',
      name: 'Phan Thành Vinh',
      department: 'Khoa Công nghệ Thông tin',
      gender: 'Nam',
      birthDate: '10/21/1981'),
  'GV009': Teacher(
      code: 'GV009',
      name: 'Hoàng Thu Phượng',
      department: 'Khoa Công nghệ Thông tin',
      gender: 'Nữ',
      birthDate: '9/13/1982'),
  'GV010': Teacher(
      code: 'GV010',
      name: 'Trần Đức Thịnh',
      department: 'Khoa Công nghệ Thông tin',
      gender: 'Nam',
      birthDate: '9/29/1984'),
};

class TeacherCodeInputScreen extends StatelessWidget {
  final TextEditingController _codeController = TextEditingController();

  TeacherCodeInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(context.loc.teacherCodeInputTitle),
        backgroundColor: context.colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100.h),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.loc.teacherEvaluationTitle,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        context.loc.enterTeacherCodeInstruction,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: context.loc.teacherCodeLabel,
                          hintText: context.loc.teacherCodeHint,
                          prefixIcon: Icon(Icons.person_search,
                              color: context.colorScheme.primary),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.h, horizontal: 16.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide:
                                BorderSide(color: context.colorScheme.primary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                                color: context.colorScheme.primary
                                    .withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide:
                                BorderSide(color: context.colorScheme.primary),
                          ),
                          filled: true,
                          fillColor: context.colorScheme.surface,
                        ),
                        style: context.textTheme.bodyLarge,
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final enteredCode = _codeController.text.trim();
                            final teacher = dummyTeachers[enteredCode];

                            if (teacher != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TeacherEvaluationScreen(teacher: teacher),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.loc.invalidTeacherCode),
                                  backgroundColor: context.colorScheme.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colorScheme.primary,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            context.loc.continue_text,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onPrimary,
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
      ),
    );
  }
}
