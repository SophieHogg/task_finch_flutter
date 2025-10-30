import 'package:flutter/material.dart';
import 'package:task_finch/screens/completed_screen.dart';
import 'package:task_finch/theming/constants.dart';

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
      icon: Icon(Icons.check),
      label: 'Completed',
      action:
          (BuildContext context) => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => CompletedScreen())),
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
                  backgroundColor:
                      selectedIndex == null || selectedIndex != index
                          ? WidgetStatePropertyAll(Colors.transparent)
                          : WidgetStatePropertyAll(secondaryColour),
                ),
                color:
                    selectedIndex == null || selectedIndex != index
                        ? Colors.black
                        : Colors.white,
                onPressed:
                    selectedIndex == null || selectedIndex != index
                        ? () => navDestination.action(context)
                        : (null),
                icon: navDestination.icon,
              ),
            ),
        ],
      ),
    );
  }
}
