import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_helper/blocs/blocs.dart';
import 'package:tutor_helper/models/app_tab.dart';
import 'package:tutor_helper/models/models.dart';
import 'package:tutor_helper/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabBloc = BlocProvider.of<TabBloc>(context);

    return BlocBuilder(
      bloc: tabBloc,
      builder: (BuildContext context, AppTab activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Tutor Diary',
              style: TextStyle(color: Color(0xff0b0747), fontWeight: FontWeight.w600,fontSize: 22,letterSpacing: 0.6),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          body: activeTab == AppTab.courses ? Courses() : Stats(),
          floatingActionButton: activeTab == AppTab.courses ? HomeFAB() :null,
          
        );
      },
    );
  }
}
