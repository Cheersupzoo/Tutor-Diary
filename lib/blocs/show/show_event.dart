

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tutor_helper/models/course.dart';

@immutable
abstract class ShowEvent extends Equatable {
  ShowEvent([List props = const []]) : super(props);
}

class UpdateShow extends ShowEvent {
  final List<CourseModel> courses;

  UpdateShow(this.courses): super([courses]);

  @override
  String toString() => 'UpdateShow {courses : $courses}';
}
