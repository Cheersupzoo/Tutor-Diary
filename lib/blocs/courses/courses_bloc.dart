import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tutor_helper/blocs/courses/courses_event.dart';
import 'package:tutor_helper/blocs/courses/courses_state.dart';
import 'package:tutor_helper/models/models.dart';
import 'package:meta/meta.dart';
import 'package:tutor_helper/providers/providers.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  @override
  CoursesState get initialState {
    return CoursesLoading();
  }

  @override
  Stream<CoursesState> mapEventToState(
    CoursesEvent event,
  ) async* {
    if (event is LoadCourses) {
      yield* _mapLoadCoursesToState();
    } else if (event is AddCourses) {
      yield* _mapAddCoursesToState(event);
    } else if (event is UpdateCourses) {
      yield* _mapUpdateCoursesToState(event);
    } else if (event is DeleteCourses) {
      yield* _mapDeleteCoursesToState(event);
    }
  }

  Stream<CoursesState> _mapLoadCoursesToState() async* {
    try {
      final courses = await FileStorage().loadCourses();
      yield CoursesLoaded(courses);
    } catch (_) {
      yield CoursesNotLoaded();
    }
  }

  Stream<CoursesState> _mapAddCoursesToState(AddCourses event) async* {
    if (currentState is CoursesLoaded) {
      final List<CourseModel> updatedCourses = List.from((currentState as CoursesLoaded).courses);
          updatedCourses.add(event.course);
      yield CoursesLoaded(updatedCourses);
      _saveCourses(updatedCourses);
    }
  }

  Stream<CoursesState> _mapUpdateCoursesToState(UpdateCourses event) async* {
    if (currentState is CoursesLoaded) {
      List<TimeStampModel> timestampsList = event.updatedCourse.timestamps;
      double totalHour = 0.0;
      DateTime start;
      DateTime end;
      List<PaymentModel> paymentsList = event.updatedCourse.payments;
      double paidPrice = 0.0;
      int paymentLen = paymentsList != null ? paymentsList.length : 0;
      for (var i = 0; i < timestampsList.length; i++) {
        totalHour += timestampsList[i].totalHour;
      }
      if (timestampsList.length != 0) {
        start = timestampsList[0].start;
        end = timestampsList[timestampsList.length - 1].end;
      }

      for (var i = 0; i < paymentLen; i++) {
        paidPrice +=
            paymentsList[i].complete == true ? paymentsList[i].price : 0.0;
      }

      bool complete = event.updatedCourse.targetHour != 0.0 ? totalHour >= event.updatedCourse.targetHour : false;

      CourseModel updateCourse = event.updatedCourse.copyWith(
          totalHour: totalHour, start: start, end: end, paidPrice: paidPrice,complete: complete);

      final List<CourseModel> updatedCourses =
          (currentState as CoursesLoaded).courses.map((course) {
        return course.id == updateCourse.id ? updateCourse : course;
      }).toList();
      //print(updatedCourses);
      yield CoursesLoaded(updatedCourses);
      //print('bf save file');
      _saveCourses(updatedCourses);
    }
  }

  Stream<CoursesState> _mapDeleteCoursesToState(DeleteCourses event) async* {
    if (currentState is CoursesLoaded) {
      final List<CourseModel> updatedCourses = (currentState as CoursesLoaded)
          .courses
          .where((course) => course.id != event.deleteCourse.id)
          .toList();
      yield CoursesLoaded(updatedCourses);
      _saveCourses(updatedCourses);
    }
  }

  Future _saveCourses(List<CourseModel> courses) {
    return FileStorage().saveCourses(courses);
  }
}
