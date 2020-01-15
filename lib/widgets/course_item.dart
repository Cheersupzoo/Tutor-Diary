import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tutor_helper/models/models.dart';
import 'package:intl/intl.dart';

class CourseItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final bool showCheckbox;
  final bool onCheckboxChange;
  final CourseModel course;
  const CourseItem(
      {Key key,
      @required this.onTap,
      @required this.showCheckbox,
      @required this.onCheckboxChange,
      @required this.course})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailTheme = TextStyle(fontSize: 17, fontWeight: FontWeight.w300);
    final headDetailTheme = TextStyle(
        fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4);
    final student = course.students.join(', ');
    final complete = course.complete == false
        ? TextDecoration.none
        : TextDecoration.lineThrough;
    final startdate = DateFormat("dd/MM/yy").format(course.start);
    final createdate = DateFormat('dd/MM/yy').format(course.created);
    final double cardHeight = 110.0;
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: GestureDetector(
        child: Hero(
          tag:course.id,
                child: Card(
              color: course.complete == false ? Colors.white : Colors.grey[350],
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  clipBehavior:Clip.antiAlias,
              elevation: 8.0,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  height: cardHeight,
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                  //constraints: BoxConstraints(minHeight: 0.0),
                  child: Row(
                    crossAxisAlignment : CrossAxisAlignment.center,
                    children: <Widget>[
                      showCheckbox == true
                          ? Icon(Icons.check_box_outline_blank)
                          : Container(),
                      showCheckbox == true
                          ? Container(
                              height: 60,
                              child: VerticalDivider(
                                width: 30,
                                color: Colors.black45,
                              ))
                          : Container(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment : CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${course.title}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    
                                    letterSpacing: 0.8,
                                    color: Color(0xffee604e)),
                              ),
                              course.complete
                                  ? Text(
                                      ' complete',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.black87),
                                    )
                                  : Container()
                            ],
                          ),
                          Row(crossAxisAlignment : CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'STUDENT  ',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    
                                    color: Colors.grey[500]),
                              ),
                              Text(
                                '$student',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    
                                    color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      showCheckbox == false
                          ? Icon(Icons.keyboard_arrow_down)
                          : Container()
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
