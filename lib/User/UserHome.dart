import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'MyTicket.dart';
import 'Search.dart';
import 'UserMainPage/UserMainPage.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int selectedIndex = 1;
  PageController? pageController;
  List<Widget> page = [
    const MyTicket(),
    const UserMainPage(),
    //  Search(), 
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
        unselectedItemColor: Colors.grey[600],
        currentIndex: selectedIndex,
        onTap: onTabTapped,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.analytics_rounded),
            title: const Text("My Ticket"),
            selectedColor: Colors.brown[600],
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.green[600],
          ),

          /// Search
          // SalomonBottomBarItem(
          //   icon: const Icon(Icons.search),
          //   title: const Text("Search"),
          //   selectedColor: Colors.brown[600],
          // ),

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
