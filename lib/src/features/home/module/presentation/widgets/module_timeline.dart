import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class ModuleTimeline extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const ModuleTimeline({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  State<ModuleTimeline> createState() => _ModuleTimelineState();
}

class _ModuleTimelineState extends State<ModuleTimeline> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          // leading: GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       _isExpanded = !_isExpanded;
          //     });
          //   },
          //   child: AnimatedRotation(
          //     turns: _isExpanded ? 0.5 : 0.0,
          //     duration: const Duration(milliseconds: 200),
          //     child: const Icon(Icons.expand_more),
          //   ),
          // ),

          leading: Stack(
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

          title: Text(widget.title),
          onTap: _expanded,
        ),
        if (_isExpanded)
          Container(
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
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
                SizedBox(
                  width: 16.w,
                ),
                Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Card(
                    elevation: 2,
                    color: context.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text(widget.title)],
                    ),
                  ),
                ),
              ],
            ),
          )
        // Padding(
        //   padding: EdgeInsets.only(left: 16.w),
        //   child: Column(children: widget.children),
        // ),
      ],
    );
  }

  void _expanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
