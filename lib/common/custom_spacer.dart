import 'package:flutter/material.dart';

class CustomSpacer extends StatelessWidget {
  final bool? horizontal;
  final double? flex;

  const CustomSpacer({
    super.key,
    this.horizontal = false,
    this.flex = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: !horizontal! ? 5 * flex! : 0,
      width: horizontal! ? 5 * flex! : 0,
    );
  }
}
