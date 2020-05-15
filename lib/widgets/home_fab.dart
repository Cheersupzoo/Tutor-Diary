import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_helper/blocs/blocs.dart';
import 'package:tutor_helper/screens/screens.dart';
import 'package:tutor_helper/widgets/widgets.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:tutor_helper/models/models.dart';

import 'package:tutor_helper/providers/providers.dart';

//bloc not need
import 'package:tutor_helper/blocs/blocs.dart';

// change permission handler
//import 'package:simple_permissions/simple_permissions.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeFAB extends StatefulWidget {
  _HomeFAB createState() => _HomeFAB();
}

class _HomeFAB extends State<HomeFAB> {
  @override
  Widget build(BuildContext context) {
    final coursesBloc = BlocProvider.of<CoursesBloc>(context);
    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "New Course",
        currentButton: FloatingActionButton(
          heroTag: "train",
          backgroundColor: Colors.redAccent,
          mini: true,
          child: Icon(Icons.note),
          onPressed: () {
            Navigator.of(context).push(FadePageRoute(builder: (_) {
              return DetailsScreen(
                id: null,
                isEditing: true,
                onSave: (course, newCourse) {
                  coursesBloc.dispatch(AddCourses(course));
                  
                },
              );
            }));
          },
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: 'Backup',
        currentButton: FloatingActionButton(
          heroTag: "list1",
          backgroundColor: Colors.green,
          mini: true,
          child: Icon(Icons.note_add),
          onPressed: () {
            _backup();
          },
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: 'Restore',
        currentButton: FloatingActionButton(
          heroTag: "list2",
          backgroundColor: Colors.yellowAccent[100],
          mini: true,
          child: Icon(Icons.note_add),
          onPressed: () {
            _restore();
          },
        )));

    return UnicornDialer(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0),
      parentButtonBackground: Colors.redAccent[400],
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.add,),
      childButtons: childButtons,
      animationDuration: 200,
    );
  }

  void _debugDefault() async {
    TimeStampModel var1 = TimeStampModel(
        start: DateTime(1),
        end: DateTime(2),
        totalHour: 2.5,
        topicCover: ['t1', 't2'],
        note: 'note');
    CourseModel var2 = CourseModel(
        title: '123',
        start: DateTime(1),
        end: null,
        created: DateTime(2),
        totalHour: 2,
        price: 500,
        students: ['name s'],
        timestamps: [var1],
        complete: true,
        targetHour: 20);
    var var3 = [
      var2.copyWith(complete: false),
      var2.copyWith(title: '11111', id: '002'),
      var2.copyWith(id: '003')
    ];
    final coursesBloc = CoursesBloc();
    //String json = jsonEncode(var3);
    //coursesBloc.dispatch(AddCourses(var2));
    //File status = await FileStorage().saveCourses(var3);
    final dir = await getDirectoryGolbal();
    print(dir.path);
    //print(var1);
    //print(DateTime(999).millisecondsSinceEpoch>DateTime(250).millisecondsSinceEpoch);
    //print(Uuid().generateV4());
  }

  void _backup() async {
    
    if (await Permission.storage.request().isGranted) {
      try {
        List<CourseModel> json = await FileStorage().loadCourses();
        //print(json);
        final save = await FileStorage().backupCourses(json);
        print('2');
        print(save);
      } catch (e) {
        print(e);
        print('not init yet');
      }
    }
  }

  void _restore() async {
    try {
      final restore = FileStorage().restoreCourses();
      print(restore);
      CoursesBloc()..dispatch(LoadCourses());
    } catch (e) {
      print('not init yet');
    }
  }
}
