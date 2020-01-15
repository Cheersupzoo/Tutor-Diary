import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_helper/blocs/blocs.dart';
import 'package:tutor_helper/screens/screens.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    BlocProvider(
      builder: (context) {
        return CoursesBloc()..dispatch(LoadCourses());
      },
      child: TutorDiaryApp(),
    ),
  );
}

class TutorDiaryApp extends StatelessWidget {
  //final CoursesBloc _coursesBloc = CoursesBloc();

  @override
  Widget build(BuildContext context) {
    final coursesBloc = BlocProvider.of<CoursesBloc>(context);
    //final tabBloc = BlocProvider.of<TabBloc>(context);
    return MaterialApp(
      title: 'Tutor Diary',
      theme: ThemeData(fontFamily: 'Kanit'),
      routes: {
        '/': (context) {
          return BlocProviderTree(
            blocProviders: <BlocProvider>[
              BlocProvider<TabBloc>(
                builder: (BuildContext context) => TabBloc(),
              ),
              BlocProvider<CoursesBloc>(
                builder: (BuildContext context) => CoursesBloc(),
              ),
              BlocProvider<ShowBloc>(
                builder: (context) => ShowBloc(coursesBloc: coursesBloc),
              ),
            ],
            child: HomeScreen(),
          );
        },
        '/addeditDetail': (context) {
          return DetailsScreen(
            isEditing: true,
            onSave: (course, newCourse) {
              if(newCourse) {
              coursesBloc.dispatch(AddCourses(course));
              }else {
                coursesBloc.dispatch(UpdateCourses(course));
              }

            },
          );
        }
      },
    );
  }
}
