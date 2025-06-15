import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/module_response_model.dart';

import '../../data/models/course_model.dart';

class ModuleTimeline extends StatefulWidget {
  final ModuleResponseModel moduleModel;

  const ModuleTimeline({
    super.key,
    required this.moduleModel,
  });

  @override
  State<ModuleTimeline> createState() => _ModuleTimelineState();
}

class _ModuleTimelineState extends State<ModuleTimeline> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: _expanded,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    width: 24.w,
                    // height: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 12.w,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: _isExpanded ? null : 0,
                            child: Column(
                              children: [
                                Flexible(child: Container()),
                                Flexible(
                                  child: Container(
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _expanded,
                          child: Container(
                            alignment: Alignment.center,
                            width: 24.r,
                            height: 24.r,
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            child: AnimatedRotation(
                              turns: _isExpanded ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: _isExpanded
                                  ? Icon(
                                      Icons.remove,
                                      color: context.colorScheme.onPrimary,
                                      size: 18.r,
                                    )
                                  : Icon(
                                      Icons.add,
                                      color: context.colorScheme.onPrimary,
                                      size: 18.r,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      child: Text(
                        widget.moduleModel.year ?? 'No Year',
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isExpanded)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.moduleModel.courses.length,
            itemBuilder: (context, index) {
              return CoursesCard(
                courses: widget.moduleModel.courses[index],
              );
            },
          ),
        if (_isExpanded)
          Container(
            margin: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24.w,
                  height: 12.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 12.w,
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  void _expanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}

class CoursesCard extends StatelessWidget {
  const CoursesCard({
    super.key,
    required this.courses,
  });

  final CourseModel courses;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: 24.w,
              // height: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 12.w,
                    // height: double.infinity,
                    color: context.colorScheme.primary,
                  ),
                  Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 8.w, right: 16.w, top: 8.h, bottom: 8.h),
                child: Card(
                  elevation: 2,
                  color: context.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          courses.subjectName.toString(),
                          style: context.textTheme.titleSmall,
                        ),
                        Text(
                          context.loc.credits(
                            courses.subjectCredit ?? 0,
                          ),
                          style: context.textTheme.titleSmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
