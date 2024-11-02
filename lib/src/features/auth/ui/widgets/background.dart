import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/configs/assets.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(
        Assets.startedBg,
        fit: BoxFit.cover,
      ),
    );
  }
}
