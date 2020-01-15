import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tutor_helper/providers/providers.dart';

part 'course.g.dart';

@JsonSerializable()
class CourseList {
  final List<CourseModel> courses;

  CourseList(this.courses);

  factory CourseList.fromJson(Map<String, dynamic> json) =>
      _$CourseListFromJson(json);

  Map<String, dynamic> toJson() => _$CourseListToJson(this);
}

@immutable
@JsonSerializable()
class CourseModel extends Equatable {
  final bool complete;
  final String id;
  final String title;
  final List<String> students;
  final DateTime start;
  final DateTime end;
  final DateTime created;
  final double totalHour;
  final double targetHour;
  final double price;
  final List<TimeStampModel> timestamps;
  final List<PaymentModel> payments;
  final double paidPrice;

  CourseModel(
      {this.title,
      String id,
      DateTime start,
      DateTime end,
      DateTime created,
      this.totalHour = 0,
      this.price = 0,
      this.students = const [],
      this.timestamps = const [],
      this.complete = false,
      this.targetHour = 0,
      this.payments = const[],
      this.paidPrice = 0.0})
      : this.id = id ?? Uuid().generateV4(),
        this.start = start ?? DateTime(0),
        this.end = end ?? DateTime(0),
        this.created = created ?? DateTime.now(),
        super([
          title,
          id,
          start,
          end,
          created,
          totalHour,
          price,
          students,
          timestamps,
          complete,
          targetHour,
          payments,
          paidPrice
        ]);

  CourseModel copyWith(
      {bool complete,
      String id,
      String title,
      List<String> students,
      DateTime start,
      DateTime end,
      DateTime created,
      double totalHour,
      double targetHour,
      double price,
      List<TimeStampModel> timestamps,
      List<PaymentModel> payments,
      double paidPrice}) {
    return CourseModel(
        title: title ?? this.title,
        complete: complete ?? this.complete,
        id: id ?? this.id,
        students: students ?? this.students,
        start: start ?? this.start,
        end: end ?? this.end,
        created: created ?? this.created,
        totalHour: totalHour ?? this.totalHour,
        price: price ?? this.price,
        targetHour: targetHour ?? this.targetHour,
        timestamps: timestamps ?? this.timestamps,
        payments: payments ?? this.payments,
        paidPrice: paidPrice ?? this.paidPrice);
  }

  @override
  String toString() {
    return 'Course { title: $title, complete: $complete, id: $id, students: $students, start: $start, end: $end, created:$created, totalHour:$totalHour, price:$price, timestamps:$timestamps , payment:$payments, paidPrice: $paidPrice}';
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseModelToJson(this);
}

@immutable
@JsonSerializable()
class TimeStampModel extends Equatable {
  final DateTime start;
  final DateTime end;
  final double totalHour;
  final List<String> topicCover;
  final String note;
  final String tid;

  TimeStampModel(
      {this.start,
      String tid,
      this.end,
      double totalHour,
      this.topicCover,
      this.note})
      : this.tid = tid ?? Uuid().generateV1(),
        this.totalHour = totalHour ?? 0,
        super([ start, tid ,end, totalHour,  topicCover,note]);

  TimeStampModel copyWith(
      {DateTime start,
      DateTime end,
      double totalHour,
      List<String> topicCover,
      String note}) {
    return TimeStampModel(
        start: start ?? this.start,
        end: end ?? this.end,
        totalHour: totalHour ?? this.totalHour,
        topicCover: topicCover ?? this.topicCover,
        note: note ?? this.note,
        tid: tid ?? this.tid);
  }

/*   TimeStampModel.fromJson(Map<String, dynamic> json)
      : start = json['start'],
        end = json['end'],
        totalHour = json['totalHour'],
        topicCover = json['topicCouver'],
        note = json['note'];

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'totalHour': totalHour,
      'topicCover': topicCover,
      'note': note,
    };
  } */

  factory TimeStampModel.fromJson(Map<String, dynamic> json) =>
      _$TimeStampModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimeStampModelToJson(this);
}


@immutable
@JsonSerializable()
class PaymentModel extends Equatable {
  final DateTime paid;
  final double price;
  final bool complete;
  final String note;
  final String pid;

  PaymentModel(
      {this.paid,
      String pid,
      double price,
      bool complete,
      this.note})
      : this.pid = pid ?? Uuid().generateV1(),
        this.price = price ?? 0.0,
        this.complete = complete ?? false,
        super([ paid, pid ,price, complete, note]);

  PaymentModel copyWith(
      {DateTime paid,
      double price,
      bool complete,
      String pid,
      String note}) {
    return PaymentModel(
        paid: paid ?? this.paid,
        price: price ?? this.price,
        complete: complete ?? this.complete,
        note: note ?? this.note,
        pid: pid ?? this.pid);
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
