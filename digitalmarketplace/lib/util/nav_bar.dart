import 'package:digitalmarketplace/pages/app_screens/add_product_screen.dart';
import 'package:digitalmarketplace/pages/app_screens/home_screen.dart';
import 'package:digitalmarketplace/pages/app_screens/notifications_screen.dart';
import 'package:digitalmarketplace/pages/app_screens/profile_screen.dart';
import 'package:digitalmarketplace/pages/app_screens/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late PersistentTabController _controller;
  late List<Color> _iconColors;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _iconColors = List.generate(5, (index) => CupertinoColors.systemGrey); // Initialize icon colors
  }

  void _onTabChanged(int index) {
    setState(() {
      // Update icon colors on tab change
      for (int i = 0; i < _iconColors.length; i++) {
        _iconColors[i] = (i == index) ? CupertinoColors.activeBlue : CupertinoColors.systemGrey;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      hideNavigationBarWhenKeyboardAppears: true,
      stateManagement: true,
      resizeToAvoidBottomInset: true,
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      backgroundColor: Colors.grey.shade900, // Navigation bar background color
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(15.0),
        colorBehindNavBar: Colors.white,
      ),
      onWillPop: (context) async {
        return Future.value(true);
      },
      navBarStyle: NavBarStyle.style15, // Use Style 15 here
      onItemSelected: _onTabChanged, // Listen for tab changes
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const SearchScreen(),
      const AddProductScreen(),
      const NotificationsScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedHome01,
          color: _iconColors[0], // Dynamically set color
          size: 27.0,
        ),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedSearch01,
          color: _iconColors[1], // Dynamically set color
          size: 27.0,
        ),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedAdd01,
          color: _iconColors[2], // Dynamically set color
          size: 27.0,
        ),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedNotification02,
          color: _iconColors[3], // Dynamically set color
          size: 27.0,
        ),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedUser,
          color: _iconColors[4], // Dynamically set color
          size: 27.0,
        ),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
