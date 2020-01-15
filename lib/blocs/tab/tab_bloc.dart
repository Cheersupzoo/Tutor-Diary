import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tutor_helper/blocs/tab/tab_event.dart';
import 'package:tutor_helper/models/app_tab.dart';
import 'package:tutor_helper/blocs/blocs.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {

  @override
  AppTab get initialState => AppTab.courses;

  @override
  Stream<AppTab> mapEventToState(
    TabEvent event,
  ) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}