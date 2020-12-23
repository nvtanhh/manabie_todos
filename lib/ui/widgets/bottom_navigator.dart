import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todos/core/providers/tab_index_provider.dart';
import 'package:todos/locator.dart';

class MyBottomNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey[400],
      onTap: onTabTapped,
      currentIndex: locator.get<TabIndexProvider>().index,
      fixedColor: Theme.of(context).primaryColor.withOpacity(.8),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: new Icon(FontAwesomeIcons.solidCalendarCheck),
            label: "Complete"),
        BottomNavigationBarItem(
            icon: new Icon(FontAwesomeIcons.solidListAlt), label: "All"),
        BottomNavigationBarItem(
            icon: new Icon(FontAwesomeIcons.solidCalendarTimes),
            label: "Incomplete")
      ],
    );
  }

  void onTabTapped(int value) {
    locator.get<TabIndexProvider>().setCurrentIndex(value);
  }
}
