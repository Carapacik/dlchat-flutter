import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/color.dart';
import 'package:flutter/material.dart';

class const MainNavigationBar({
  required final int selectedIndex,
  required final ValueChanged<int> onDestinationSelected,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const svgColorFilter = ColorFilter.mode(AppColors.iconPrimary, BlendMode.srcIn);
    const svgColorFilterSelected = ColorFilter.mode(AppColors.iconMain1, BlendMode.srcATop);
    final navBarItems = [
      BottomNavigationBarItem(
        icon: Assets.svg.navbarHome.svg(height: 56, colorFilter: svgColorFilter),
        activeIcon: Assets.svg.navbarHome.svg(height: 56, colorFilter: svgColorFilterSelected),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Assets.svg.navbarChat.svg(height: 56, colorFilter: svgColorFilter),
        activeIcon: Assets.svg.navbarChat.svg(height: 56, colorFilter: svgColorFilterSelected),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Assets.svg.navbarSettings.svg(height: 56, colorFilter: svgColorFilter),
        activeIcon: Assets.svg.navbarSettings.svg(height: 56, colorFilter: svgColorFilterSelected),
        label: '',
      ),
    ];

    return SizedBox(
      height: 60 + MediaQuery.paddingOf(context).bottom,
      child: BottomNavigationBar(
        items: navBarItems,
        currentIndex: selectedIndex,
        showUnselectedLabels: true,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        onTap: onDestinationSelected,
      ),
    );
  }
}
