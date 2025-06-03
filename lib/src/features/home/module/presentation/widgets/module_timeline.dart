import 'package:flutter/material.dart';

class ModuleTimeline extends StatefulWidget {
  final String title;
  final Widget? leading;
  final Widget? customIcon;
  final List<Widget> children;

  const ModuleTimeline({
    super.key,
    required this.title,
    this.leading,
    this.customIcon,
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
          leading: widget.leading,
          title: Text(widget.title),
          trailing: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: widget.customIcon ?? const Icon(Icons.expand_more),
            ),
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(children: widget.children),
          ),
      ],
    );
  }
}
