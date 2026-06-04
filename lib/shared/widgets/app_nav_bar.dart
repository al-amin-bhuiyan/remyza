import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/custom_assets.dart';

class AppNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AppNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 6,
            offset: Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _NavBarItem(
              label: 'Home',
              iconPath: CustomAssets.homeNavBar,
              activeIconPath: CustomAssets.homeNavBarHover,
              isSelected: selectedIndex == 0,
              onTap: () => onItemTapped(0),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              label: 'Contacts',
              iconPath: CustomAssets.contactsNavBar,
              activeIconPath: CustomAssets.contactsNavBarHover,
              isSelected: selectedIndex == 1,
              onTap: () => onItemTapped(1),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              label: 'Leads',
              iconPath: CustomAssets.leadsNavBar,
              activeIconPath: CustomAssets.leadsNavBarHover,
              isSelected: selectedIndex == 2,
              onTap: () => onItemTapped(2),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              label: 'Message',
              iconPath: CustomAssets.messageNavBar,
              activeIconPath: CustomAssets.meassageNavBarHover,
              isSelected: selectedIndex == 3,
              onTap: () => onItemTapped(3),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              label: 'Settings',
              iconPath: CustomAssets.settingsNavBar,
              activeIconPath: CustomAssets.settingsNavBarHover,
              isSelected: selectedIndex == 4,
              onTap: () => onItemTapped(4),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String label;
  final String iconPath;
  final String activeIconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.label,
    required this.iconPath,
    required this.activeIconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: Duration(milliseconds: isSelected ? 300 : 0),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFEAECF2) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.r),
          ),
          shadows: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: SvgPicture.asset(
                isSelected ? activeIconPath : iconPath,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? AppColors.primary : const Color(0xFF949CA9),
                fontSize: 10.sp,
                fontFamily: 'Poppins',
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                height: 1.20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
