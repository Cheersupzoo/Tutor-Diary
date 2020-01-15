import 'package:equatable/equatable.dart';
import 'package:tutor_helper/models/models.dart';
import 'package:meta/meta.dart';


@immutable
abstract class CoursesEvent extends Equatable {
  CoursesEvent([List props = const []]) : super(props);
}

class LoadCourses extends CoursesEvent {
  @override
  String toString() => 'LoadCourses';
}

class AddCourses extends CoursesEvent {
  final CourseModel course;

  AddCourses(this.course) : super([course]);

  @override
  String toString() => 'AddCourses { course: $course }';
}

class UpdateCourses extends CoursesEvent {
  final CourseModel updatedCourse;

  UpdateCourses(this.updatedCourse) : super([updatedCourse]);

  @override
  String toString() => 'UpdateCourses { updatedCourse: $updatedCourse }';

}

class DeleteCourses extends CoursesEvent {
  final CourseModel deleteCourse;

  DeleteCourses(this.deleteCourse) : super([deleteCourse]);

  @override
  String toString() => 'DeleteCourses { deleteCourse: $deleteCourse }';

}

