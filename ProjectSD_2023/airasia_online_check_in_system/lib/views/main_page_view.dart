import 'package:airasia_online_check_in_system/main_page/history-page.dart';
import 'package:airasia_online_check_in_system/main_page/profile_page.dart';
import 'package:airasia_online_check_in_system/main_page/search_ticket_page.dart';
import 'package:flutter/material.dart';



class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
int curentPageIndex = 0;

void onTabTapped(int index) {
      setState(() {curentPageIndex = index;});
  }

final List <Widget> _pageOptions = [
  const SearchTicketTabPage(),
  const HistoryTabPage(),
  const ProfileTabPage()
];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('AirAsia Online Check-in System'),
            backgroundColor: Colors.red,
            automaticallyImplyLeading: false,
          ),
          bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.amber[800],
          selectedItemColor: Colors.blue, 
          currentIndex: curentPageIndex,
          onTap: onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search Ticket',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
          body: _pageOptions[curentPageIndex],
        ),
      ),
    );
  }
}

