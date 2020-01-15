import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tutor_helper/blocs/show/show_event.dart';
import 'package:tutor_helper/blocs/show/show_state.dart';
import 'package:tutor_helper/models/models.dart';
import 'package:tutor_helper/blocs/blocs.dart';

class ShowBloc extends Bloc<ShowEvent, ShowState> {
  final CoursesBloc coursesBloc;
  StreamSubscription coursesSubscription;

  ShowBloc({@required this.coursesBloc}) {
    coursesSubscription = coursesBloc.state.listen((state) {
      if (state is CoursesLoaded) {
        print('show load');
        dispatch(
            UpdateShow((coursesBloc.currentState as CoursesLoaded).courses));
      }
    });
  }

  @override
  ShowState get initialState {
    return coursesBloc.currentState is CoursesLoaded
        ? ShowLoaded((coursesBloc.currentState as CoursesLoaded).courses)
        : ShowLoading();
  }

  @override
  Stream<ShowState> mapEventToState(
    ShowEvent event,
  ) async* {
    if (event is UpdateShow) {
      yield* _mapUpdateShowtoState(event);
    }
  }

  Stream<ShowState> _mapUpdateShowtoState(UpdateShow event) async* {
    final List<CourseModel> rawCourse =
        (coursesBloc.currentState as CoursesLoaded).courses;
    final List<CourseModel> completeCourse =
        rawCourse.where((course) => course.complete == true).toList();
    final List<CourseModel> incompleteCourse =
        rawCourse.where((course) => course.complete == false).toList();
    final List<CourseModel> course = new List.from(incompleteCourse)
      ..addAll(completeCourse);
    yield ShowLoaded(course);
  }

  @override
  void dispose() {
    coursesSubscription.cancel();
    super.dispose();
  }
}
