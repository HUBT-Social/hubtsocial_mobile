import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/module_response_model.dart';

class ModuleCard extends StatefulWidget {
  const ModuleCard({
    super.key,
    required this.item,
  });
  final ModuleResponseModel item;

  @override
  State<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      child: Card(
        elevation: 2,
        color: context.colorScheme.surfaceContainerLow,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: IntrinsicHeight(
            child: Row(
              children: [Text("data"), Text("data")],
            ),
          ),
        ),
      ),
    );
  }
}
