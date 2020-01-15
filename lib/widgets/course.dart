import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_helper/blocs/blocs.dart';
import 'package:tutor_helper/screens/details_screen.dart';
import 'package:tutor_helper/widgets/loading_indicator.dart';
import 'package:tutor_helper/widgets/widgets.dart';

class Courses extends StatefulWidget {
 const Courses({Key key}) : super(key: key);

  _CoursesState createState() => _CoursesState();
}


class _CoursesState extends State<Courses> {


  @override
  Widget build(BuildContext context) {
    final coursesBloc = BlocProvider.of<CoursesBloc>(context);
    final showBloc = BlocProvider.of<ShowBloc>(context);
    return BlocBuilder(
      bloc: showBloc,
      builder: (BuildContext context, ShowState state) {
        //print('from page: ${state}');
        if (state is ShowLoading) {
          return LoadingIndicator(key: Key('__coursesLoading'));
        } else if (state is ShowLoaded) {
          final courses = state.showCourses;
          return Column(
            children: <Widget>[
              
              new Expanded(
                child: ListView.builder(
                  key: Key('__ListCourses__'),
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,5),
                  itemCount: courses.length,
                  itemBuilder: (BuildContext context, int index) {
                    final course = courses[index];
                    return CourseItem(
                      course: course,
                      onTap: () async {
                        final removedCourse = await Navigator.of(context)
                            .push(FadePageRoute(builder: (_) {
                          return DetailsScreen(id: course.id, isEditing: false,onSave: (course, newCourse) {
              coursesBloc.dispatch(UpdateCourses(course));
            });
                        }));
                        if (removedCourse != null){
                        }
                      },
                      showCheckbox: false,
                      onCheckboxChange: false,
                    );
                  },
                ),
              ),
            ],
          );
          //11*

        }
      },
    );

  }
}
