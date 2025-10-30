import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/base_nav.dart';
import 'package:task_finch/main.dart';
import 'package:task_finch/screens/completed_screen.dart';

class MainScreen extends HookWidget {
  const MainScreen();

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState<int>(0);
    final pageController = usePageController();
    final homeKey = useMemoized(() => GlobalKey<NavigatorState>());
    final completedKey = useMemoized(() => GlobalKey<NavigatorState>());
    final searchKey = useMemoized(() => GlobalKey<NavigatorState>());
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex.value,
        children: [
          Navigator(
            key: homeKey,
            onGenerateRoute:
                (route) =>
                    MaterialPageRoute(settings: route, builder: (_) => Home()),
          ),
          Navigator(
            key: completedKey,
            onGenerateRoute:
                (route) => MaterialPageRoute(
                  settings: route,
                  builder: (_) => CompletedScreen(),
                ),
          ),
          Navigator(
            key: searchKey,
            onGenerateRoute:
                (route) => MaterialPageRoute(
                  settings: route,
                  builder: (_) => Placeholder(),
                ),
          ),
        ],
      ),
      bottomNavigationBar: BaseNav(
        onSelectIndex: (newIndex) {
          if (newIndex == selectedIndex.value) {
            switch (newIndex) {
              case 0: homeKey.currentState?.popUntil((route) => route.isFirst);
              case 1: completedKey.currentState?.popUntil((route) => route.isFirst);
              case 2: searchKey.currentState?.popUntil((route) => route.isFirst);
            }
          }
          selectedIndex.value = newIndex;
        },
        selectedIndex: selectedIndex.value,
      ),
    );
  }
}
