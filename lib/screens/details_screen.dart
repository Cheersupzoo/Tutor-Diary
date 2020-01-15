import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tutor_helper/blocs/blocs.dart';
import 'package:tutor_helper/models/models.dart';
import 'package:tutor_helper/providers/providers.dart';
import 'package:tutor_helper/screens/screens.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tutor_helper/widgets/widgets.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:tutor_helper/widgets/widgets.dart';

typedef OnSaveCallback = Function(CourseModel courseSave, bool newCourse);

class DetailsScreen extends StatefulWidget {
  final String id;
  final bool isEditing;
  final OnSaveCallback onSave;
  final CourseModel courseSave;

  const DetailsScreen(
      {Key key,
      this.id,
      @required this.isEditing,
      @required this.onSave,
      this.courseSave})
      : super(key: key ?? const Key('__courseDetailsScreen__'));

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with TickerProviderStateMixin {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PassStringRef _title = PassStringRef('');
  PassStringRef _student = PassStringRef('');
  PassStringRef _targetHour = PassStringRef('');
  PassStringRef _price = PassStringRef('');
  String id;
  bool isEditing;
  DateTime _startTimeStamp;
  DateTime _endTimeStamp;
  double indexPage;
  // Local animation
  PageController pageViewController;
  AnimationController _cardAnimationController;
  Animation<double> cardHeight;
  Animation<double> offsetHeight;
  Animation<double> offsetBin;
  Animation<double> offsetCheck;
  // Page Transition
  AnimationController _pageAnimationController;
  Animation<double> offsetPage;
  Animation<double> offsetArrow;
  Animation<Offset> offsetCheckTrans;

  @override
  void initState() {
    indexPage = 1.0;
    id = widget.id;
    isEditing = widget.isEditing;

    pageViewController = PageController(initialPage: indexPage.toInt());
    pageViewController
        .addListener(() => updateIndexPage(pageViewController.page));
    _cardAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 450)) // 450
      ..addListener(() {
        setState(() {});
      });

    _pageAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 450)) // 450
      ..addListener(() {
        setState(() {});
      });

    curveInit();

    _pageAnimationController.forward();

    if (id == null) _cardAnimationController.forward(from: 1.0);
    super.initState();
  }

  void curveInit() {
    cardHeight = Tween<double>(begin: 110.0, end: 195.0).animate(
        CurvedAnimation(
            parent: _cardAnimationController, curve: Curves.easeInOut));
    offsetHeight = Tween<double>(begin: 0.0, end: 20.0).animate(CurvedAnimation(
        parent: _cardAnimationController, curve: Curves.easeInOut));
    offsetBin = Tween<double>(begin: 35.0, end: 0.0).animate(CurvedAnimation(
        parent: _cardAnimationController,
        curve: Interval(0.6, 0.95, curve: Curves.easeOutQuad)));
    offsetCheck = Tween<double>(begin: 60.0, end: 0.0).animate(CurvedAnimation(
        parent: _cardAnimationController, curve: Curves.easeInOutQuad));
    offsetPage = Tween<double>(begin: 250.0, end: 0.0).animate(CurvedAnimation(
        parent: _pageAnimationController, curve: Interval(0.1, 1.0, curve: Curves.easeInOut)));
    offsetArrow = Tween<double>(begin: -40.0, end: 0.0).animate(CurvedAnimation(
        parent: _pageAnimationController, curve: Interval(0.1, 1.0, curve: Curves.easeInOut)));
    offsetCheckTrans =
        Tween<Offset>(begin: Offset(60.0, 60.0), end: Offset(0.0, 0.0)).animate(
            CurvedAnimation(
                parent: _pageAnimationController, curve: Interval(0.1, 1.0, curve: Curves.easeInOutQuad)));
  }

  void updateIndexPage(newindex) {
    setState(() {
      indexPage = newindex;
    });
  }

  @override
  void dispose() {
    pageViewController.dispose();
    _pageAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coursesBloc = BlocProvider.of<CoursesBloc>(context);
    

    return BlocBuilder(
        bloc: coursesBloc,
        builder: (BuildContext context, CoursesState state) {
          final course = (state as CoursesLoaded)
              .courses
              .firstWhere((course) => course.id == id, orElse: () => null);
          String students;
          String startdate;
          String enddate;
          String createdate;
          double targethour;
          double totalhour;
          double price;
          List<TimeStampModel> timestamps;

          //print(course);
          if (course != null) {
            students = course.students.join(' ');
            startdate = DateFormat("dd MMM yy").format(course.start);
            enddate = DateFormat("dd MMM yy").format(course.end);
            createdate = DateFormat('dd MMM yy').format(course.created);
            targethour = course.targetHour;
            totalhour = course.totalHour;
            price = course.price;
            timestamps = course.timestamps;
          } else {
            students = '';
            startdate = '';
            enddate = '';
            createdate = '';
            targethour = 0;
            totalhour = 0;
            price = 0;
            timestamps = [];
            indexPage = 0.0;
            id = 'nullid';
          }

          return WillPopScope(
            onWillPop: () {
              _pageAnimationController.reverse();
              return Future.value(true);
            },
            child: Form(
              key: _formKey,
              child: Scaffold(
                resizeToAvoidBottomPadding: false,
                appBar: buildAppBar(course, coursesBloc),
                body: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5),
                            child: Hero(
                              tag: id,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..setEntry(1, 2, 0.2)
                                  ..rotateX(
                                      pi * (_cardAnimationController.value)),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 8.0,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 30,
                                        right: 30,
                                        top: 20,
                                        bottom: 20),
                                    height: cardHeight.value,
                                    child: _cardAnimationController.value > 0.52
                                        ? buildCardTextField(
                                            course, students, targethour, price)
                                        : buildCardDetail(course, students),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 0.3,
                          color: Colors.black38,
                        ),
                        _cardAnimationController.value < 0.7
                            ? Expanded(
                                child: AnimatedOpacity(
                                  opacity: _pageAnimationController.value,
                                  duration: Duration(milliseconds: 0),
                                  child: Transform.translate(
                                    offset: Offset(0.0, offsetPage.value),
                                    child: AnimatedOpacity(
                                      curve: Curves.easeOut,
                                      opacity: isEditing ? 0.0 : 1.0,
                                      duration: Duration(milliseconds: 400),
                                      child: Transform.translate(
                                        offset: Offset(0.0, offsetHeight.value),

                                        /// [PageView]
                                        child: PageView(
                                            controller: pageViewController,
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            children: <Widget>[
                                              returnDetailShow(
                                                  startdate,
                                                  enddate,
                                                  totalhour,
                                                  targethour,
                                                  createdate,
                                                  price),
                                              TimeStampWidget(
                                                  course: course,
                                                  bloc: coursesBloc),
                                              PaymentListWidget(
                                                  course: course,
                                                  coursesBloc: coursesBloc)
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                    _cardAnimationController.value < 0.7
                        ? AnimatedOpacity(
                            curve: Curves.easeOut,
                            opacity: isEditing ? 0.0 : 1.0,
                            duration: Duration(milliseconds: 400),
                            child: buildDotPage())
                        : SizedBox(),
                    Transform.translate(
                      offset: offsetCheckTrans.value,
                      child: Stack(
                        children: <Widget>[
                          Transform.translate(
                            offset: Offset(
                                60 - offsetCheck.value, 60 - offsetCheck.value),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEditing = true;
                                });

                                _cardAnimationController.forward();
                              },
                              child: iconBottomRight(
                                  Icons.edit, Colors.black, Colors.grey[500]),
                            ),
                          ),
                          Transform.rotate(
                              alignment: Alignment.bottomRight,
                              angle: indexPage < 1
                                  ? pi / 2 * (-indexPage + 1)
                                  : 0.0,
                              child: GestureDetector(
                                onTap: () async {
                                  TimeStampModel timestamp =
                                      await showModalBottomSheetCustom(
                                          context: context,
                                          builder: (context) {
                                            return ModalTimeStamp();
                                          });
                                  //print(timestamp.toJson());
                                  if (timestamp != null) {
                                    List<TimeStampModel> updateTimestamp =
                                        List.from(course.timestamps);
                                    updateTimestamp.add(timestamp);
                                    CourseModel toSave = course.copyWith(
                                        timestamps: updateTimestamp);
                                    //print(updateTimestamp);
                                    //print(course.timestamps);
                                    coursesBloc.dispatch(UpdateCourses(toSave));
                                    setState(() {});
                                  }
                                },
                                child: iconBottomRight(
                                    Icons.add, Colors.black, Colors.grey[400]),
                              )),
                          Transform.rotate(
                              alignment: Alignment.bottomRight,
                              angle: pi / 2 * (-indexPage + 2),
                              child: GestureDetector(
                                onTap: () async {
                                  PaymentModel payment =
                                      await showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return ModalPayment();
                                          });
                                  //print(timestamp.toJson());
                                  if (payment != null) {
                                    List<PaymentModel> updatePayment;
                                    print(course.payments.toString());
                                    updatePayment = course.payments;
                                    if (course.payments != null) {
                                      if (course.payments.length != 0) {
                                        updatePayment = List.from(
                                            course.payments..add(payment));
                                      } else {
                                        updatePayment = [payment];
                                      }
                                    } else {
                                      updatePayment = [payment];
                                    }

                                    CourseModel toSave = course.copyWith(
                                        payments: updatePayment);
                                    //print(updateTimestamp);
                                    //print(course.timestamps);
                                    coursesBloc.dispatch(UpdateCourses(toSave));
                                    setState(() {});
                                  }
                                },
                                child: iconBottomRight(Icons.note_add,
                                    Colors.black, Colors.grey[200]),
                              )),
                          //add button when edit/add new course
                          _cardAnimationController.value > 0.01
                              ? GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      if (course == null) {
                                        print(_title.val + '-' + _student.val);
                                        CourseModel toSave = CourseModel(
                                            title: _title.val,
                                            created: DateTime.now(),
                                            price: _price.val != ''
                                                ? double.parse(_price.val)
                                                : 0,
                                            students: [_student.val],
                                            timestamps: [],
                                            complete: false,
                                            targetHour: _targetHour.val != ''
                                                ? double.parse(_targetHour.val)
                                                : 0);
                                        coursesBloc
                                            .dispatch(AddCourses(toSave));
                                        //widget.onSave(toSave,true);
                                        Navigator.pop(context);
                                      } else {
                                        _cardAnimationController.reverse();
                                        CourseModel toSave = course.copyWith(
                                          title: _title.val,
                                          price: _price.val != ''
                                              ? double.parse(_price.val)
                                              : 0,
                                          targetHour: _targetHour.val != ''
                                              ? double.parse(_targetHour.val)
                                              : 0,
                                          students: [_student.val],
                                        );
                                        coursesBloc
                                            .dispatch(UpdateCourses(toSave));
                                        setState(() {
                                          isEditing = !isEditing;
                                          updatePageViewController();
                                        });
                                        //widget.onSave(toSave,false);
                                      }
                                    }
                                  },
                                  child: Transform.translate(
                                    offset: Offset(
                                        offsetCheck.value, offsetCheck.value),
                                    child: iconBottomRight(Icons.check,
                                        Colors.black, Colors.grey[400]),
                                  ))
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Transform buildCardTextField(
      CourseModel course, String students, double targethour, double price) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateX(pi * (1.0)),
      child: ListView(
        children: <Widget>[
          buildTitleTextField(course),
          buildTextField(
              course, students, 'STUDENT  ', "Student's name", _student),
          buildTextField(course, targethour.toString(), 'TARGET HOUR  ',
              "Intended total hour", _targetHour,
              endText: ' hr'),
          buildTextField(course, price.toString(), 'PRICE  ', "Pricing", _price,
              endText: ' ฿'),
        ],
      ),
    );
  }

  void updatePageViewController() {
    pageViewController = PageController(initialPage: indexPage.toInt());
    pageViewController
        .addListener(() => updateIndexPage(pageViewController.page));
  }

  Container buildTitleTextField(CourseModel course) {
    return Container(
      height: 30.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            'COURSE  ',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey[500]),
          ),
          Expanded(
            child: TextFormField(
              initialValue: course == null ? '' : course.title,
              style: TextStyle(
                  fontSize: 20,
                  height: 0.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8),
              decoration: InputDecoration(
                hintText: 'Please name title',
              ),
              validator: (val) {
                return val.isEmpty == true ? 'Please put some title!' : null;
              },
              onSaved: (value) => _title = PassStringRef(value),
            ),
          ),
        ],
      ),
    );
  }

  Column buildTextField(CourseModel course, String initialValue, String title,
      String hintText, PassStringRef updateVal,
      {String endText}) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 8.0,
        ),
        Container(
          height: 30.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500]),
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    
                  ),
                  initialValue: course == null ? '' : initialValue,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      height: 0.0,
                      color: Colors.grey[900]),
                  onSaved: (value) => updateVal.val = value,
                ),
              ),
              endText != null
                  ? Text(
                      endText,
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500]),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  Column buildCardDetail(CourseModel course, String students) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    style: TextStyle(fontSize: 11, color: Colors.black87),
                  )
                : Container()
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'STUDENT  ',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500]),
            ),
            Text(
              '${students}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500]),
            ),
          ],
        ),
      ],
    );
  }

  AppBar buildAppBar(CourseModel course, CoursesBloc coursesBloc) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.black),
      leading: InkWell(
          onTap: () {
            if (!(isEditing == true && course != null)) {
              _pageAnimationController.reverse();
              Navigator.of(context).pop();
            } else
              setState(() {
                isEditing = !isEditing;
                updatePageViewController();
                _cardAnimationController.reverse();
              });
          },
          child: Transform.translate(
            offset: Offset(offsetArrow.value, 0),
            child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(1, 2, 0.2)
                  ..rotateX(pi * (_cardAnimationController.value)),
                child: Icon(_cardAnimationController.value > 0.52
                    ? Icons.close
                    : Icons.arrow_back)),
          )),
      actions: <Widget>[
        _cardAnimationController.value < 0.05
            ? SizedBox()
            : InkWell(
                onTap: () async {
                  final confirmDelete = await _confirmDelete(context);
                  if (confirmDelete != null) {
                    if (confirmDelete) {
                      coursesBloc.dispatch(DeleteCourses(course));
                      Navigator.pop(context, course);
                    }
                  }
                },
                child: Transform.translate(
                    offset: Offset(offsetBin.value, 0.0),
                    child: Transform.rotate(
                        origin: Offset(0, -10),
                        angle: pi /
                            18 *
                            sin(pi *
                                2 *
                                1 *
                                CurveTween(
                                        curve: Interval(0.5, 0.98,
                                            curve: Curves.easeInOutCubic))
                                    .animate(_cardAnimationController)
                                    .value),
                        alignment: Alignment.bottomCenter,
                        child: Icon(Icons.delete)))),
        SizedBox(
          width: 16.0,
        )
      ],
    );
  }

  Stack buildDotPage() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: DotsIndicator(
              dotsCount: 3,
              position: indexPage,
              decorator: DotsDecorator(
                activeColor: Color(0xff061022),
                color: Colors.grey[400],
                size: const Size.square(9.0),
                activeSize: const Size(24.0, 9.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 28.0),
              child: Card(
                  color: Color(0xff061022),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                      width: indexPage < 1
                          ? 65.0 + indexPage * 20.0
                          : 85 - (indexPage - 1) * 5, //65 85 80
                      height: 23.0,
                      child: Stack(
                        children: <Widget>[
                          Transform.translate(
                            offset: Offset(-indexPage * 75, 0),
                            child: Center(
                                child: Text(
                              'Detail',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[100]),
                            )),
                          ),
                          Transform.translate(
                            offset: Offset(-(indexPage - 1) * 75, 0),
                            child: Center(
                                child: Text(
                              'Teaching',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[100]),
                            )),
                          ),
                          Transform.translate(
                            offset: Offset(-(indexPage - 2) * 75, 0),
                            child: Center(
                                child: Text(
                              'Payment',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[100]),
                            )),
                          ),
                        ],
                      )))),
        ),
      ],
    );
  }

  Align iconBottomRight(IconData icon, Color iconColor, Color bgColor) {
    return Align(
      alignment: Alignment.bottomRight,
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(60.0)),
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(color: bgColor, boxShadow: [
            BoxShadow(
              color: Colors.grey[800],
              blurRadius: 15.0,
              spreadRadius: 7.0,
              offset: Offset(
                12.0, // Move to right 10  horizontally
                12.0, // Move to bottom 10 Vertically
              ),
            ),
          ]),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Icon(
              icon,
              size: 28,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }

  Container returnDetailShow(String startdate, String enddate, double totalhour,
      double targethour, String createdate, double price) {
    return Container(
      padding: EdgeInsets.only(
        top: 16.0,
        left: 25,
        right: 25,
      ),
      child: Column(
        children: <Widget>[
          HeadItem(
            title: 'Started',
            detail: startdate,
          ),
          HeadItem(title: 'Ended', detail: enddate),
          HeadItem(title: 'Total Hour', detail: '${totalhour.toStringAsFixed(1)} hr'),
          HeadItem(title: 'Target Hour', detail: '${targethour.toStringAsFixed(1)} hr'),
          HeadItem(title: 'Created', detail: createdate),
          HeadItem(
            title: 'Price',
            detail: '${NumberFormat.simpleCurrency(name: '').format(price)}฿',
          )
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    // flutter defined function
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are you sure you want to delete?"),
          content: new Text("This cannot be restore."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new FlatButton(
              child: new Text("Delete"),
              textColor: Colors.red,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
  }
}

class PassStringRef {
  String val;
  PassStringRef(this.val);
}

class HeadItem extends StatelessWidget {
  final String title;
  final String detail;
  final int flext;
  final int flexd;
  final String tag;

  HeadItem({
    Key key,
    @required this.title,
    @required this.detail,
    this.flext = 15,
    this.flexd = 15,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textThemeO = TextStyle(
        fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400);
    var textThemeTopic = TextStyle(
        fontSize: 14, color: Color(0xffffa500), fontWeight: FontWeight.w500);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        Expanded(
          flex: flext,
          child: Padding(
            padding: const EdgeInsets.only(right:56.0),
            child: Text(
              '$title',
              style: textThemeTopic,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Expanded(
          flex: flexd,
          child: Text(
            '$detail',
            style: textThemeO,
          ),
        )
      ]),
    );
  }
}
