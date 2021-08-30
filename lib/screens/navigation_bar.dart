import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'profile_screen.dart';
import 'ratings_screen.dart';
import 'earnings_screen.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);
  static const routeName = '/nav-bar';

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();

  int selectedIndex = 0;

  List<Widget> _pages = [
    HomeScreen(),
    EarningsScreen(),
    RatingsScreen(),
    ProfileScreen(),
  ];

  void onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      _pageController.animateToPage(
        selectedIndex,
        duration: Duration(microseconds: 160),
        curve: Curves.bounceIn,
      );
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (int index) => onItemClicked(index),
        children: _pages.map((page) => page).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Ratings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        unselectedItemColor:
            Theme.of(context).primaryColorLight.withOpacity(0.5),
        selectedItemColor: Theme.of(context).accentColor,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: (int index) => onItemClicked(index),
      ),
    );
  }
}
