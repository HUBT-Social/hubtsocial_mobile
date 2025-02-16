import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class ContainerAuth extends StatefulWidget {
  const ContainerAuth({required this.children, super.key});
  final List<Widget> children;

  @override
  State<ContainerAuth> createState() => _ContainerAuthState();
}

class _ContainerAuthState extends State<ContainerAuth> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          padding: EdgeInsets.only(right: 24, left: 24, top: 24, bottom: 36),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.shadow.withAlpha(128),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
