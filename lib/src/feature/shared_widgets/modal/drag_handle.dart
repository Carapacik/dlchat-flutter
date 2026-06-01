import 'package:dlchat/src/core/resources/color.dart';
import 'package:flutter/material.dart';

class const DragHandle({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 4,
        width: 40,
        child: DecoratedBox(
          decoration: ShapeDecoration(color: AppColors.gray500, shape: StadiumBorder()),
        ),
      ),
    );
  }
}
