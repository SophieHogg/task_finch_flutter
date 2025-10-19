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
  BaseNav({super.key});

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
    return BottomNavigationBar(
      onTap: (index) => navDestinations[index].action(context),
      items: [
        for(final navDestination in navDestinations)
        BottomNavigationBarItem(icon: navDestination.icon, label: navDestination.label )
        // NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      ],
    );
  }
}
