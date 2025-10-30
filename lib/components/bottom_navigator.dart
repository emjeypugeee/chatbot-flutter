import 'package:chatbot/components/dot_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigator extends StatefulWidget {
  final Widget child;
  const BottomNavigator({super.key, required this.child});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _currentIndex = 0;

  // Map of routes corresponding to each bottom nav item
  final List<String> _routes = [
    '/home',
    '/savings',
    '/notification',
    '/settings',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update current index based on current route
    final currentLocation = GoRouterState.of(context).uri.toString();

    for (int i = 0; i < _routes.length; i++) {
      if (currentLocation.contains(_routes[i])) {
        if (_currentIndex != i) {
          setState(() {
            _currentIndex = i;
          });
        }
        break;
      }
    }
  }

  void _navigateToRoute(int index) {
    setState(() {
      _currentIndex = index;
    });
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your FAB action here
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        elevation: 8,
        child: Icon(
          Icons.add,
          size: 30,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        shape: CircularNotchedRectangle(), // This creates the curve around FAB
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home
            BottomNavItem(
              icon: Icons.home,
              isActive: _currentIndex == 0,
              onPressed: () => _navigateToRoute(0),
            ),
            // Savings
            BottomNavItem(
              icon: Icons.money,
              isActive: _currentIndex == 1,
              onPressed: () => _navigateToRoute(1),
            ),
            // Empty space for FAB - this is crucial for the curve
            const SizedBox(width: 60),
            // Notifications
            BottomNavItem(
              icon: Icons.notifications,
              isActive: _currentIndex == 2,
              onPressed: () => _navigateToRoute(2),
            ),
            // Settings
            BottomNavItem(
              icon: Icons.settings,
              isActive: _currentIndex == 3,
              onPressed: () => _navigateToRoute(3),
            ),
          ],
        ),
      ),
    );
  }
}
