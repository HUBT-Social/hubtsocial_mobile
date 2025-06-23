import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/main_wrapper/presentation/widgets/main_app_bar.dart';
import 'package:hubtsocial_mobile/src/features/home/presentation/bloc/student_list/student_list_bloc.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/studen_list_model.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:shimmer/shimmer.dart';

class StudentListScreen extends StatefulWidget {
  final String initialClassName;

  const StudentListScreen({super.key, this.initialClassName = ''});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late final TextEditingController _classController;

  @override
  void initState() {
    super.initState();
    _classController = TextEditingController(text: widget.initialClassName);
    if (widget.initialClassName.isNotEmpty) {
      context
          .read<StudentListBloc>()
          .add(GetStudentListEvent(widget.initialClassName));
    } else {
      context.read<StudentListBloc>().add(GetStudentListEvent(""));
    }
  }

  @override
  void dispose() {
    _classController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(context.loc.student_list),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       context.showSnackBarMessage('Lọc danh sách');
        //     },
        //     icon: Icon(
        //       Icons.filter_list,
        //       size: 24.r,
        //       color: context.colorScheme.onSurface,
        //     ),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _classController,
                    decoration: InputDecoration(
                      hintText: 'Nhập mã lớp (ví dụ: TH27.33)',
                      hintStyle: context.textTheme.bodySmall?.copyWith(
                        color:
                            context.colorScheme.onSurfaceVariant.withAlpha(192),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        context
                            .read<StudentListBloc>()
                            .add(GetStudentListEvent(value.trim()));
                      }
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    if (_classController.text.trim().isNotEmpty) {
                      context.read<StudentListBloc>().add(
                          GetStudentListEvent(_classController.text.trim()));
                    }
                  },
                  child: Icon(
                    Icons.search,
                    color: context.colorScheme.onPrimary,
                    size: 24.r,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<StudentListBloc, StudentListState>(
              builder: (context, state) {
                if (state is StudentListLoading) {
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 80.h),
                    itemCount: 5, // Shimmer for 5 items
                    itemBuilder: (context, index) =>
                        const StudentListItemShimmer(),
                  );
                } else if (state is StudentListLoaded) {
                  if (state.students.isEmpty) {
                    return Center(
                      child: Text(
                        'Không tìm thấy sinh viên nào cho lớp này.',
                        style: context.textTheme.bodyLarge,
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 80.h),
                    itemCount: state.students.length,
                    itemBuilder: (context, index) {
                      final student = state.students[index];
                      return StudentListItem(student: student);
                    },
                  );
                } else if (state is StudentListError) {
                  return Center(
                    child: Text(
                      'Lỗi: ${state.message}',
                      style: context.textTheme.bodyLarge
                          ?.copyWith(color: Colors.red),
                    ),
                  );
                } else {
                  // Trạng thái ban đầu: không hiển thị gì cả (trắng)
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StudentListItem extends StatelessWidget {
  final StudentListModel student;

  const StudentListItem({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: InkWell(
        onTap: () {
          AppRoute.userProfileDetails
              .push(navigatorKey.currentContext!, queryParameters: {
            'userName': student.userName,
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(20.r), // Adjust for desired roundness
                child: CachedNetworkImage(
                  imageUrl: student.avatarUrl,
                  placeholder: (context, url) =>
                      const CircleAvatar(child: Icon(Icons.person)),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(Icons.error)),
                  width: 40.r,
                  height: 40.r,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: context.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      student.userName,
                      style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentListItemShimmer extends StatelessWidget {
  const StudentListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: 100.w,
                      height: 14.h,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Container(
                width: 24.r,
                height: 24.r,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
