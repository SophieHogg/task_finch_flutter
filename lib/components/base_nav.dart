import 'package:flutter/material.dart';
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
  final void Function(int) onSelectIndex;

  BaseNav({super.key, this.selectedIndex = null, required this.onSelectIndex});

  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final List<NavItem> navDestinations = [
      NavItem(
        icon: Icon(Icons.home_filled),
        label: 'Home',
        action: (BuildContext context) => onSelectIndex(0),
      ),
      NavItem(
        icon: Icon(Icons.check),
        label: 'Completed',
        action: (BuildContext context) => onSelectIndex(1),
      ),
      NavItem(
        // SEARCH IS NOT CURRENTLY FUNCTIONAL
        icon: Icon(Icons.search),
        label: 'Search',
        action: (BuildContext context) => onSelectIndex(2),
      ),
    ];

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
                    () => navDestination.action(context),
                icon: navDestination.icon,
              ),
            ),
        ],
      ),
    );
  }
}
