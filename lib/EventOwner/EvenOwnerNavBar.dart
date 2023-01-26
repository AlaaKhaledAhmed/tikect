import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tikect/EventOwner/EventOwnerHome.dart';

import 'SoldOut.dart';

class EventNavBar extends StatefulWidget {
  const EventNavBar({Key? key}) : super(key: key);

  @override
  State<EventNavBar> createState() => _EventNavBarState();
}

class _EventNavBarState extends State<EventNavBar> {
  int selectedIndex = 1;
  PageController? pageController;
  List<Widget> page = [
    const SoldOut(),
    const EventOwnerHome(),
    const EventOwnerHome(),
  ];
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: page,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: selectedIndex,
        onTap: onTabTapped,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.group_add),
            title: const Text("Manage Ticket checker"),
            selectedColor: Colors.brown[600],
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Events"),
            selectedColor: Colors.green[600],
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.do_not_disturb_on),
            title: const Text("Sold Out"),
            selectedColor: Colors.brown[600],
          ),

          /// Profile
        ],
      ),
    );
  }

  //================================================================
  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController?.animateToPage(selectedIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastLinearToSlowEaseIn);
  }
}
