import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tutor_helper/blocs/blocs.dart';
import 'package:tutor_helper/models/models.dart';
import 'package:tutor_helper/providers/providers.dart';
import 'package:tutor_helper/widgets/widgets.dart';

class TimeStampWidget extends StatefulWidget {
  final CourseModel course;
  final CoursesBloc bloc;

  const TimeStampWidget({Key key, @required this.course, @required this.bloc})
      : super(key: key);

  @override
  _TimeStampWidgetState createState() => _TimeStampWidgetState();
}

class _TimeStampWidgetState extends State<TimeStampWidget> {
  bool showPopupMenu;
  TapDownDetails _tapDetail;
  Function _editFunc;
  Function _deleteFunc;
  @override
  void initState() {
    showPopupMenu = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<TimeStampModel> timestamps = widget.course.timestamps;

    var timeTheme = TextStyle(fontSize: 16);
    var timehTheme = TextStyle(fontSize: 12, color: Color(0xffffac00));
    return Stack(
      children: <Widget>[
        ListView.builder(
          physics: BouncingScrollPhysics(),
          key: Key('__detailLi__'),
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 1.0),
          itemCount: timestamps.length,
          itemBuilder: (BuildContext context, int index) {
            final timestamp = timestamps[index];
            final start = DateFormat("dd/MM/yy").format(timestamp.start);
            final showTime = start +
                ' ' +
                DateFormat("H:mm").format(timestamp.start) +
                ' - ' +
                DateFormat("H:mm").format(timestamp.end);
            final topic = timestamp.topicCover.join(', ');

            return InkWell(
              onTapDown: (tapDetail) {
                _tapDetail = tapDetail;
              },
              onLongPress: () async {
                setState(() {
                  showPopupMenu = true;
                  _editFunc = () async {
                    TimeStampModel timestampFuture =
                        await showModalBottomSheetCustom(
                            context: context,
                            builder: (context) {
                              return ModalTimeStamp(timestamp: timestamp);
                            });
                    //print(timestamp.toJson());
                    if (timestampFuture != null) {
                      List<TimeStampModel> updateTimestamp =
                          widget.course.timestamps.map((check) {
                        return check.tid == timestampFuture.tid
                            ? timestampFuture
                            : check;
                      }).toList();
                      CourseModel toSave =
                          widget.course.copyWith(timestamps: updateTimestamp);
                      //print(updateTimestamp);
                      //print(course.timestamps);
                      widget.bloc.dispatch(UpdateCourses(toSave));
                    }
                  };

                  _deleteFunc = () {
                    final tid = timestamp.tid;
                    //print(timestamps);
                    final List<TimeStampModel> updateTimestamp =
                        timestamps.where((check) => check.tid != tid).toList();
                    //print(updateTimestamp);
                    final CourseModel updateCourse =
                        widget.course.copyWith(timestamps: updateTimestamp);
                    widget.bloc.dispatch(UpdateCourses(updateCourse));
                  };
                });
              },
              child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.22,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(fontSize: 20,color: Colors.grey[800]),
                                    ))),
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Time   ', style: timehTheme),
                                      Text(
                                        '$showTime',
                                        style: timeTheme,
                                      ),
                                    ],
                                  ),
                                  topic == ''
                                      ? Container()
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                              Text('Topic  ',
                                                  style: timehTheme),
                                              Text('$topic', style: timeTheme)
                                            ]),
                                  timestamp.note != ''
                                      ? Divider(color: Colors.grey[600])
                                      : Container(),
                                  timestamp.note != ''
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                              Text('Note  ', style: timehTheme),
                                              Text('${timestamp.note}',
                                                  style: timeTheme)
                                            ])
                                      : Container()
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        '${timestamp.totalHour.toStringAsFixed(1)} h',
                                        style: TextStyle(fontSize: 20,color: Color(0xff6d6ab6))))),
                          ],
                        )),
                    Divider()
                  ],
                ),
              ),
            );
          },
        ),
        showPopupMenu ? buildPopupMenu(context) : SizedBox()
      ],
    );
  }

  GestureDetector buildPopupMenu(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showPopupMenu = false;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Positioned(
                left: _tapDetail.globalPosition.dx,
                top: _tapDetail.globalPosition.dy - 210.0,
                child: Card(
                  elevation: 8.0,
                  color: Color(0xfff9f9f9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    height: 90.3,
                    width: 90.0,
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              showPopupMenu = false;
                            });
                            _editFunc();
                          },
                          child: Container(
                              height: 45,
                              width: 90.0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 8.0),
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                      fontSize: 19, color: Colors.blue[600]),
                                ),
                              )),
                        ),
                        Container(
                          height: 0.3,
                          color: Colors.grey[500],
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showPopupMenu = false;
                            });
                            _deleteFunc();
                          },
                          child: Container(
                              height: 45,
                              width: 90.0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 8.0),
                                child: Text('Delete',
                                    style: TextStyle(
                                        fontSize: 19, color: Colors.red)),
                              )),
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class ModalTimeStamp extends StatefulWidget {
  final TimeStampModel timestamp;
  ModalTimeStamp({Key key, this.timestamp}) : super(key: key);

  _ModalTimeStampState createState() => _ModalTimeStampState();
}

class _ModalTimeStampState extends State<ModalTimeStamp> {
  TimeStampModel timestamp;
  DateTime _startTimeStamp;
  DateTime _endTimeStamp;
  String _topic;
  String _note;
  String _title;

  @override
  void initState() {
    timestamp = widget.timestamp;
    if (timestamp == null) {
      _title = 'New Timestamp';
      _startTimeStamp = DateTime.now();
      _endTimeStamp = DateTime.now();
      _topic = '';
      _note = '';
    } else {
      _title = 'Edit Timestamp';
      _startTimeStamp = timestamp.start;
      _endTimeStamp = timestamp.end;
      _topic = timestamp.topicCover.join(' ');
      _note = timestamp.note;
    }

    super.initState();
  }

  static final GlobalKey<FormState> _formTimestampKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Transform.translate(offset: Offset(0,  -MediaQuery.of(context).viewInsets.bottom*0.25),
          child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Container(
            height: 470 + MediaQuery.of(context).viewInsets.bottom*1,
            decoration: BoxDecoration(
              
        color: Color(0xff232e4c),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(45.0),
          topRight: const Radius.circular(45.0),
        ),
              ),
            
            child: _buildBottomNavigationMenu(),
          ),
      ),
    );
  }

  Widget _buildBottomNavigationMenu() {
    final style = TextStyle(
                              color: Colors.white, fontSize: 18.0,fontWeight: FontWeight.w500);
    final labelstyle = TextStyle(
                              color: Color(0xffd9dadd), fontSize: 18.0,fontWeight: FontWeight.w500);

    return Form(
      key: _formTimestampKey,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 22, 5, 0),
              child: ListTile(
                title: Text(
                  _title,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                trailing: InkWell(
                    child: Icon(Icons.add, color: Colors.white),
                    onTap: () {
                      if (_formTimestampKey.currentState.validate()) {
                        _formTimestampKey.currentState.save();
                        final _totalMinute = _endTimeStamp
                            .difference(_startTimeStamp)
                            .inMinutes;
                        final _totalHour = _totalMinute / 60;
                        TimeStampModel toSave;
                        if (timestamp == null) {
                          toSave = TimeStampModel(
                              tid: Uuid().generateV1(),
                              start: _startTimeStamp,
                              end: _endTimeStamp,
                              note: _note,
                              topicCover: [_topic],
                              totalHour: _totalHour);
                        } else {
                          toSave = timestamp.copyWith(
                              start: _startTimeStamp,
                              end: _endTimeStamp,
                              note: _note,
                              topicCover: [_topic],
                              totalHour: _totalHour);
                        }
                        //coursesBloc.dispatch(AddCourses(toSave));
                        //widget.onSave(toSave,true);
                        Navigator.pop(context, toSave);
                      }
                    }),
                onTap: () => {},
              ),
            ),
          ),
          Divider(
            height: 5,
            color: Colors.transparent,
            indent: 20,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 15.0, 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xff76787d), width: 1.2),
                          ),
                          labelText: 'Start Time',
                          labelStyle: labelstyle,),
                        style: style,
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              '${DateFormat('EEE, MMM d, h:mm a').format(_startTimeStamp)}'),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              DatePicker.showDateTimePicker(context,
                  currentTime: _startTimeStamp,
                  showTitleActions: true,
                  onChanged: (date) => onConfirm(date, true, false),
                  onConfirm: (date) => onConfirm(date, true, true));
            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 15.0, 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey[600], width: 1.0),
                          ),
                          labelText: 'End Time',labelStyle: labelstyle),
                              style: style,
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              '${DateFormat('EEE, MMM d, h:mm a').format(_endTimeStamp)}'),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              DatePicker.showDateTimePicker(context,
                  currentTime: _endTimeStamp,
                  showTitleActions: true,
                  onChanged: (date) => onConfirm(date, false, false),
                  onConfirm: (date) => onConfirm(date, false, true));
            },
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 15.0, 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[600], width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.amber[800], width: 1.0),
                        ),
                        labelStyle: labelstyle,
                        labelText: 'Topic'),
                        style: style,
                    enabled: true,
                    initialValue: _topic,
                    onSaved: (text) {
                      _topic = text;
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 15.0, 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    minLines: 2,
                    maxLines: 2,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[600], width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.amber[800], width: 1.0),
                        ),
                        labelStyle: labelstyle,
                        labelText: 'Notes'),
                        style: style,
                    enabled: true,
                    initialValue: _note,
                    onSaved: (text) {
                      _note = text;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onConfirm(DateTime date, bool isStart, bool confirm) {
    //print('confirm $date');
    setState(() {
      if (isStart) {
        if (date.millisecondsSinceEpoch >
                _endTimeStamp.millisecondsSinceEpoch &&
            confirm) {
          _endTimeStamp = date;
        }
        _startTimeStamp = date;
      } else {
        if (date.millisecondsSinceEpoch <
                _startTimeStamp.millisecondsSinceEpoch &&
            confirm) {
          _startTimeStamp = date;
        }
        _endTimeStamp = date;
      }
    });
  }
}
