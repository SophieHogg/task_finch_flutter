import 'package:flutter/material.dart';

class NavItem {
  final Widget icon;
  final String label;
  final Function action;

  const NavItem({
    required this.icon,
    required this.label,
    required this.action,
  });
}

class BaseNav extends StatelessWidget {
  BaseNav({super.key, this.selectedIndex = null});

  final int? selectedIndex;
  final List<NavItem> navDestinations = [
    NavItem(
      icon: Icon(Icons.home_filled),
      label: 'Home',
      action:
          (BuildContext context) => Navigator.popUntil(
            context,
            ModalRoute.withName(Navigator.defaultRouteName),
          ),
    ),
    NavItem(
      // SEARCH IS NOT CURRENTLY FUNCTIONAL
      icon: Icon(Icons.search),
      label: 'Search',
      action:
          (BuildContext context) => Navigator.popUntil(
            context,
            ModalRoute.withName(Navigator.defaultRouteName),
          ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final (index, navDestination) in navDestinations.indexed)
            Tooltip(
              message: navDestination.label,
              child: IconButton.filled(
                disabledColor: Colors.white,
                style: ButtonStyle(
                  backgroundColor: selectedIndex == null || selectedIndex != index ? WidgetStatePropertyAll(Colors.transparent) : WidgetStatePropertyAll(Color(0xFF5F4D9D))
                ),
                color: selectedIndex == null || selectedIndex != index ? Colors.black : Colors.white,
                onPressed: selectedIndex == null || selectedIndex != index ? () => navDestination.action(context) : (null),
                icon: navDestination.icon,
              ),
            ),
        ],
      ),
    );
  }
}
