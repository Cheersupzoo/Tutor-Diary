// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseList _$CourseListFromJson(Map<String, dynamic> json) {
  return CourseList((json['courses'] as List)
      ?.map((e) =>
          e == null ? null : CourseModel.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$CourseListToJson(CourseList instance) =>
    <String, dynamic>{'courses': instance.courses};

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) {
  return CourseModel(
      title: json['title'] as String,
      id: json['id'] as String,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      totalHour: (json['totalHour'] as num)?.toDouble(),
      price: (json['price'] as num)?.toDouble(),
      students: (json['students'] as List)?.map((e) => e as String)?.toList(),
      timestamps: (json['timestamps'] as List)
          ?.map((e) => e == null
              ? null
              : TimeStampModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      complete: json['complete'] as bool,
      targetHour: (json['targetHour'] as num)?.toDouble(),
      payments: (json['payments'] as List)
          ?.map((e) => e == null
              ? null
              : PaymentModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      paidPrice: (json['paidPrice'] as num)?.toDouble());
}

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'complete': instance.complete,
      'id': instance.id,
      'title': instance.title,
      'students': instance.students,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'created': instance.created?.toIso8601String(),
      'totalHour': instance.totalHour,
      'targetHour': instance.targetHour,
      'price': instance.price,
      'timestamps': instance.timestamps,
      'payments': instance.payments,
      'paidPrice': instance.paidPrice
    };

TimeStampModel _$TimeStampModelFromJson(Map<String, dynamic> json) {
  return TimeStampModel(
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      tid: json['tid'] as String,
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      totalHour: (json['totalHour'] as num)?.toDouble(),
      topicCover:
          (json['topicCover'] as List)?.map((e) => e as String)?.toList(),
      note: json['note'] as String);
}

Map<String, dynamic> _$TimeStampModelToJson(TimeStampModel instance) =>
    <String, dynamic>{
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'totalHour': instance.totalHour,
      'topicCover': instance.topicCover,
      'note': instance.note,
      'tid': instance.tid
    };

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return PaymentModel(
      paid:
          json['paid'] == null ? null : DateTime.parse(json['paid'] as String),
      pid: json['pid'] as String,
      price: (json['price'] as num)?.toDouble(),
      complete: json['complete'] as bool,
      note: json['note'] as String);
}

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'paid': instance.paid?.toIso8601String(),
      'price': instance.price,
      'complete': instance.complete,
      'note': instance.note,
      'pid': instance.pid
    };
