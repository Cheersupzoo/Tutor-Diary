import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:tutor_helper/models/models.dart';
//import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as p;

class FileStorage {
  final String tag = '__tutorHelper__';

  Future<File> _getLocalFile() async {
    final dir = await getDirectory();

    return File('${dir.path}/ArchSampleStorage__$tag.json');
  }

  Future<File> _getExternalFile() async {
    final dir = await getDirectoryGolbal();
    //print(dir.path);
    final filePath = p.join(dir.path, 'simple_tutor.json');
    return File(filePath);
  }

  Future<List<CourseModel>> loadCourses() async {
    try {
      final file = await _getLocalFile();
      final string = await file.readAsString();
      final json = await jsonDecode(string);
      final courses = CourseList.fromJson(json);
      return courses.courses;
    } catch (e) {
      print('not init');
      return CourseList([
        CourseModel(
            title: 'Welcome to Tutor Diary', students: ['Anyone!!'], id: '123'),
        CourseModel(
            title: 'Ongoing Course',
            students: ['David'],
            id: '456-4521',
            targetHour: 10.0,
            totalHour: 2.0,
            start: DateTime.utc(2019, 12, 12, 18, 0, 0),
            end: DateTime.utc(2019, 12, 12, 20, 0, 0),
            timestamps: [
              TimeStampModel(
                  topicCover: ['Calculus 1'],
                  note: '',
                  start: DateTime.utc(2019, 12, 12, 18, 0, 0),
                  end: DateTime.utc(2019, 12, 12, 20, 0, 0),
                  totalHour: 2.0)
            ],
            paidPrice: 700.0,
            payments: [
              PaymentModel(
                  paid: DateTime.utc(2019, 12, 12, 18, 0, 0),
                  price: 700,
                  complete: false)
            ]),
        CourseModel(
            title: 'Ended Course',
            students: ['Takeshi'],
            id: '456-5647',
            complete: true,
            targetHour: 4.0,
            totalHour: 4.0,
            start: DateTime.utc(2019, 12, 4, 18, 0, 0),
            end: DateTime.utc(2019, 12, 6, 20, 0, 0),
            timestamps: [
              TimeStampModel(
                  topicCover: ['Statistic 1'],
                  note: 'HW on exercise 2',
                  start: DateTime.utc(2019, 12, 4, 18, 0, 0),
                  end: DateTime.utc(2019, 12, 4, 20, 0, 0),
                  totalHour: 2.0),
              TimeStampModel(
                  topicCover: ['Statistic 2'],
                  note: '',
                  start: DateTime.utc(2019, 12, 6, 18, 0, 0),
                  end: DateTime.utc(2019, 12, 6, 20, 0, 0),
                  totalHour: 2.0),
              TimeStampModel(
                  topicCover: ['Statistic 2'],
                  note: '',
                  start: DateTime.utc(2019, 12, 6, 18, 0, 0),
                  end: DateTime.utc(2019, 12, 6, 20, 0, 0),
                  totalHour: 2.0),
              TimeStampModel(
                  topicCover: ['Statistic 2'],
                  note: '',
                  start: DateTime.utc(2019, 12, 6, 18, 0, 0),
                  end: DateTime.utc(2019, 12, 6, 20, 0, 0),
                  totalHour: 2.0),
              TimeStampModel(
                  topicCover: ['Statistic 2'],
                  note: '',
                  start: DateTime.utc(2019, 12, 6, 18, 0, 0),
                  end: DateTime.utc(2019, 12, 6, 20, 0, 0),
                  totalHour: 2.0),
              TimeStampModel(
                  topicCover: ['Statistic 2'],
                  note: '',
                  start: DateTime.utc(2019, 12, 6, 18, 0, 0),
                  end: DateTime.utc(2019, 12, 6, 20, 0, 0),
                  totalHour: 2.0),
              TimeStampModel(
                  topicCover: ['Statistic 2'],
                  note: '',
                  start: DateTime.utc(2019, 12, 6, 18, 0, 0),
                  end: DateTime.utc(2019, 12, 6, 20, 0, 0),
                  totalHour: 2.0),
              TimeStampModel(
                  topicCover: ['Statistic 2'],
                  note: '',
                  start: DateTime.utc(2019, 12, 6, 18, 0, 0),
                  end: DateTime.utc(2019, 12, 6, 20, 0, 0),
                  totalHour: 2.0),
              TimeStampModel(
                  topicCover: ['Statistic 2'],
                  note: '',
                  start: DateTime.utc(2019, 12, 6, 18, 0, 0),
                  end: DateTime.utc(2019, 12, 6, 20, 0, 0),
                  totalHour: 2.0),
              TimeStampModel(
                  topicCover: ['Statistic 2'],
                  note: '',
                  start: DateTime.utc(2019, 12, 6, 18, 0, 0),
                  end: DateTime.utc(2019, 12, 6, 20, 0, 0),
                  totalHour: 2.0),
            ],
            paidPrice: 1500.0,
            payments: [
              PaymentModel(
                  paid: DateTime.utc(2019, 12, 6, 18, 0, 0),
                  price: 1400,
                  complete: true)
            ])
      ]).courses;
    }
  }

  Future<File> saveCourses(List<CourseModel> courses) async {
    final file = await _getLocalFile();
    CourseList temp = CourseList(courses);
    return file.writeAsString(jsonEncode(temp));
  }

  Future<File> backupCourses(List<CourseModel> courses) async {
    final file = await _getExternalFile();
    //print(file.toString());
    CourseList temp = CourseList(courses);
    return file.writeAsString(jsonEncode(temp));
  }

  Future<File> restoreCourses() async {
    try {
      final file = await _getExternalFile();
      final fileT = await _getLocalFile();
      final string = await file.readAsString();
      return fileT.writeAsString(string);
    } catch (e) {
      print('unable to restore!');
      return null;
    }
  }
}

Future<Directory> getDirectory() async {
  Directory path = await getApplicationDocumentsDirectory();
  if (path == null) {
    return null;
  }
  return path;
}

Future<Directory> getDirectoryGolbal() async {
  Directory path = await getExternalStorageDirectory();
  if (path == null) {
    return null;
  }
  return path;
}
