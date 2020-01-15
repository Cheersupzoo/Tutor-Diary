import 'package:equatable/equatable.dart';
import 'package:tutor_helper/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CoursesState extends Equatable {
  CoursesState([List props = const []]) : super(props);
}

class CoursesLoading extends CoursesState {
  @override
  String toString() => 'CoursesLoading';
}

class CoursesLoaded extends CoursesState {
  final List<CourseModel> courses;

  CoursesLoaded([this.courses = const []]) : super([courses]);

  @override
  String toString() {
    //print('state load');
    return 'CoursesLoaded { courses : $courses }';}
}

class CoursesNotLoaded extends CoursesState {
  @override
  String toString() => 'CoursesNotLoaded';
}