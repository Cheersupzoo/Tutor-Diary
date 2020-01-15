import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutor_helper/models/models.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  TabSelector({Key key, @required this.activeTab, @required this.onTabSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return BottomNavigationBar(
      key: const Key('__tabs__'),
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab == AppTab.courses ? Icons.list : Icons.show_chart,
            key: tab == AppTab.courses ? const Key('__courseTab__') : const Key('__statsTab__'),
          ),
          title: Text(tab == AppTab.courses ? 'Courses' : 'Stats')
        );
      }).toList(),
      selectedItemColor: Colors.amber[800],
    );
  }
}
