
import 'package:tutor_helper/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ShowState extends Equatable {
  ShowState([List props = const []]) : super(props);
}

class ShowLoading extends ShowState{
  @override
  String toString() => 'ShowLoading';
}

class ShowLoaded extends ShowState{
  final List<CourseModel> showCourses;

  ShowLoaded(this.showCourses): super([showCourses]);

  @override
  String toString() {
    return 'ShowLoaded { showCourses: $showCourses}';
  }

}
