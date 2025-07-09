import 'package:flutter/material.dart';
import 'package:weather_app/Model/weather_model.dart';
import 'package:weather_app/View/home_screen.dart';
import 'package:weather_app/View/search_screen.dart';

class NavBar extends StatefulWidget {
  final List<WeatherModel> weatherModel;

  const NavBar({required this.weatherModel});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  late List<Widget> pages;

  @override
  void initState() {
    pages = [
      HomeScreen(weatherModel: widget.weatherModel.first),
      SearchScreen(weatherModel: widget.weatherModel),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff060720),
        body: pages.elementAt(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xff060720),
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/home_unselected.png',
                height: myHeight * 0.03,
                color: Colors.grey.withValues(alpha: 0.5),
              ),
              label: '',
              activeIcon: Image.asset(
                'assets/icons/home_selected.png',
                height: myHeight * 0.03,
                color: Colors.white,
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/search_unselected.png',
                height: myHeight * 0.03,
                color: Colors.grey.withValues(alpha: 0.5),
              ),
              label: '',
              activeIcon: Image.asset(
                'assets/icons/search_selected.png',
                height: myHeight * 0.03,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}