import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

class const AnimatedHorizontalToggle({
  /// - Add here the names of the buttons
  required final List<String> taps,

  /// - Here you can control the width of the toggle
  required final double width,

  /// - Here you can control the height of the toggle
  required final double height,

  /// - From this handel the speed of moving when the toggle is changed
  required final Duration duration,

  /// - Here if you need to use specific icon before the text button name
  final List<Widget>? prefixIcons,

  /// - Here if you need to use specific icon after the text button name
  final List<Widget>? suffixIcons,

  /// - If this true the prefix icon will shown
  final bool showPrefixIcon = false,

  /// - If this true the prefix icon will shown
  final bool showSuffixIcon = false,

  /// - Handel the space between the prefix icon and the text
  final double spaceBetweenIconAndText = 8,

  /// - The start index for the toggle
  final int initialIndex = 0,

  /// - Toggle Background
  final Color background = Colors.grey,

  /// - Active button color
  final Color activeColor = Colors.indigo,

  /// - InActive button color
  final Color inActiveColor = Colors.transparent,

  /// - Text style for the active button
  final TextStyle activeTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white),

  /// - Text style for the inActive button
  final TextStyle inActiveTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.indigo),

  /// - The space between the buttons
  final double spaceBetween = 0,

  /// - Horizontal padding for the toggle
  final double horizontalPadding = 4,

  /// - Vertical padding for the toggle
  final double verticalPadding = 4,

  /// - Horizontal padding for the active button
  final double activeHorizontalPadding = 0,

  /// - Vertical padding for the active button
  final double activeVerticalPadding = 0,

  /// - This radius will use for the toggle
  final double radius = 16,

  /// - This radius will use for the active button
  final double activeButtonRadius = 12,

  /// - This radius will use for the inActive button
  final double inActiveButtonRadius = 0,

  /// - Control the underline height
  final double underLineHeight = 1,

  /// - Control the active underline height
  final double activeUnderLineHeight = 2,

  /// - OnChange function will give you stream of int number (currentIndex)
  /// - This number will change when the index change
  /// - If you press on the button number 3 and the index now is zero so the index will start from 0 and will be 1 and stop in 2 like this will give you the moving steps to make the moving smooth and the screen widgets changing with the moving for the toggle
  /// - And will give you targetIndex this the final number which the currentIndex will stop on it
  final void Function(int currentIndex, int targetIndex)? onChange,

  /// - The color of the underline
  final Color underLineColor = Colors.grey,

  /// - The color of the active underline
  final Color activeUnderLineColor = Colors.black,

  /// - If this true the underline will be active
  final bool showUnderLine = false,

  /// - If this true the active underline will be active
  final bool showActiveButtonColor = true,

  /// - Handle the border for active button
  final Border? activeBorder,

  /// - Handle the border for inActive button
  final Border? inActiveBorder,

  /// - Handle the shadow for active button
  final List<BoxShadow>? activeBoxShadow,

  /// - Handle the shadow for inActive button
  final List<BoxShadow>? inActiveBoxShadow,

  /// - If this 'en' the toggle will start from left to right and if this 'ar' the toggle will start from right to left
  final String local = 'en',
  super.key,
}) extends StatefulWidget {
  @override
  State<AnimatedHorizontalToggle> createState() => _AnimatedHorizontalToggleState();
}

class _AnimatedHorizontalToggleState() extends State<AnimatedHorizontalToggle> with TickerProviderStateMixin {
  Decimal decimalIndex = Decimal.parse('0');
  bool addInitialIndex = false;
  bool moving = false;

  @override
  Widget build(BuildContext context) {
    if (!addInitialIndex) {
      addInitialIndex = true;
      decimalIndex = widget.initialIndex.toDecimal();
    }
    return Container(
      decoration: BoxDecoration(color: widget.background, borderRadius: BorderRadius.circular(widget.radius)),
      height: widget.height,
      width: widget.width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (widget.showActiveButtonColor)
            AnimatedAlign(
              alignment: Alignment(
                ((widget.local == 'en' ? decimalIndex.toDouble() : (widget.taps.length - decimalIndex.toDouble() - 1)) /
                        (widget.taps.length - 1) *
                        (2 - ((widget.horizontalPadding) / 100))) -
                    1 +
                    ((widget.horizontalPadding / 2) / 100),
                0,
              ),
              duration: widget.duration,
              child: Container(
                width: ((widget.width - widget.spaceBetween) / widget.taps.length) - widget.horizontalPadding,
                margin: EdgeInsets.symmetric(
                  vertical: widget.activeVerticalPadding,
                  horizontal: widget.activeHorizontalPadding,
                ),
                decoration: BoxDecoration(
                  color: widget.activeColor,
                  borderRadius: BorderRadius.circular(widget.activeButtonRadius),
                  border: widget.activeBorder,
                  boxShadow: widget.activeBoxShadow,
                ),
              ),
            ),
          if (widget.showUnderLine) Container(height: widget.underLineHeight, color: widget.underLineColor),
          if (widget.showUnderLine)
            AnimatedAlign(
              alignment: Alignment(
                ((widget.local == 'en' ? decimalIndex.toDouble() : (widget.taps.length - decimalIndex.toDouble() - 1)) /
                        (widget.taps.length - 1) *
                        (2 - (widget.horizontalPadding / 100))) -
                    1 +
                    ((widget.horizontalPadding / 2) / 100),
                0,
              ),
              duration: widget.duration,
              child: Container(
                width: ((widget.width - widget.spaceBetween) / widget.taps.length) - widget.horizontalPadding,
                height: widget.activeUnderLineHeight,
                margin: EdgeInsets.only(top: widget.height - (widget.activeUnderLineHeight - widget.underLineHeight)),
                decoration: BoxDecoration(
                  color: widget.activeUnderLineColor,
                  //borderRadius: BorderRadius.circular(activeButtonRadius),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            child: buildButtons(),
          ),
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < widget.taps.length; i++)
          buildSwitchTab(
            isLeft:
                i == (i.toDecimal() < decimalIndex ? decimalIndex.toDouble().floor() : decimalIndex.toDouble().round()),
            title: widget.taps[i],
            prefixIcon: widget.prefixIcons != null ? widget.prefixIcons![i] : null,
            suffixIcon: widget.suffixIcons != null ? widget.suffixIcons![i] : null,
            style: i == decimalIndex.toDouble().round() ? widget.activeTextStyle : widget.inActiveTextStyle,
            toggleIndex: i,
            duration: widget.duration,
          ),
      ],
    );
  }

  Widget buildSwitchTab({
    required bool isLeft,
    required String title,
    required Widget? prefixIcon,
    required Widget? suffixIcon,
    required TextStyle style,
    required int toggleIndex,
    required Duration duration,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (!moving) {
          moving = true;
          moveToNewIndex(newIndex: toggleIndex, duration: duration);
        }
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: widget.horizontalPadding / 2, vertical: widget.verticalPadding),
        width:
            ((widget.width - widget.spaceBetween) / widget.taps.length) -
            (widget.horizontalPadding * widget.taps.length),
        decoration: BoxDecoration(
          color: (decimalIndex.round()) != toggleIndex.toDecimal() ? widget.inActiveColor : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.inActiveButtonRadius),
          border: (decimalIndex.round()) != toggleIndex.toDecimal() ? widget.inActiveBorder : null,
          boxShadow: (decimalIndex.round()) != toggleIndex.toDecimal() ? widget.inActiveBoxShadow : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.prefixIcons != null) ...[prefixIcon!, SizedBox(width: widget.spaceBetweenIconAndText)],
            AnimatedDefaultTextStyle(
              duration: duration,
              curve: Curves.easeInOut,
              style: style,
              child: Text(title, textAlign: TextAlign.center),
            ),
            if (widget.suffixIcons != null) ...[SizedBox(width: widget.spaceBetweenIconAndText), suffixIcon!],
          ],
        ),
      ),
    );
  }

  void moveToNewIndex({required int newIndex, required Duration duration}) {
    final oneSec = Duration(milliseconds: duration.inMilliseconds ~/ 5);
    Timer.periodic(oneSec, (timer) {
      setState(() {
        if (decimalIndex.toDouble() == newIndex) {
          timer.cancel();
        } else if (decimalIndex.toDouble() < newIndex) {
          decimalIndex += Decimal.parse('0.1');
        } else {
          decimalIndex -= Decimal.parse('0.1');
        }

        if (widget.onChange != null) {
          if (decimalIndex.toDouble() < newIndex) {
            widget.onChange!(decimalIndex.toDouble().floor(), newIndex);
          } else {
            widget.onChange!(decimalIndex.toDouble().ceil(), newIndex);
          }
        }

        if (!timer.isActive) {
          moving = false;
        }
      });
    });
  }
}
