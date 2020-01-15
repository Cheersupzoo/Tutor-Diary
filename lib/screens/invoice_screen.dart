import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tutor_helper/blocs/blocs.dart';
import 'package:tutor_helper/models/models.dart';
import 'package:tutor_helper/providers/providers.dart';

class InvoiceScreen extends StatelessWidget {
  final String id;
  final String pid;

  const InvoiceScreen({Key key, @required this.id, @required this.pid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesBloc = BlocProvider.of<CoursesBloc>(context);
    final GlobalKey previewContainer = new GlobalKey();
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder(
          bloc: coursesBloc,
          builder: (BuildContext context, CoursesState state) {
            final course = (state as CoursesLoaded)
                .courses
                .firstWhere((course) => course.id == id, orElse: () => null);
            final payment =
                course.payments.firstWhere((payment) => payment.pid == pid);

            final student = course.students.join(' ');

            return Scaffold(
              body: SafeArea(
                              child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(children: <Widget>[
                        RepaintBoundary(
                          key: previewContainer,
                          child: new InvoicePartScreenshot(
                            student: student,
                            id: id,
                            course: course,
                            pid: pid,
                            payment: payment,
                          ),
                        ),
                        InvoicePart(
                          student: student,
                          id: id,
                          course: course,
                          pid: pid,
                          payment: payment,
                          previewContainer: previewContainer,
                        )
                      ]),
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 50.0, right: 50.0),
                          child: InkWell(
                            splashColor: Colors.red,
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 300.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                      color: Colors.indigo[700], width: 1.5),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                      color: Colors.indigo[700], fontSize: 15.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class InvoicePart extends StatelessWidget {
  const InvoicePart({
    Key key,
    @required this.student,
    @required this.id,
    @required this.course,
    @required this.pid,
    @required this.payment,
    @required this.previewContainer,
  }) : super(key: key);

  final String student;
  final String id;
  final CourseModel course;
  final String pid;
  final PaymentModel payment;
  final GlobalKey<State<StatefulWidget>> previewContainer;

  @override
  Widget build(BuildContext context) {
    final leftTheme = TextStyle(fontWeight: FontWeight.w600, fontSize: 14);

    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            ClipPath(
              clipper: OrangeClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 250.0,
                decoration: BoxDecoration(
                  color: Color(0xFFFDFA4C),
                ),
              ),
            ),
            ClipPath(
              clipper: BlackClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width - 230.0,
                height: MediaQuery.of(context).size.height - 250.0,
                decoration: BoxDecoration(
                  color: Color(0xFF0a585e),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: Material(
                  elevation: 30.0,
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(18.0),
                  child: Container(
                    width: 320.0,
                    height: 530.0,
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(18.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: ClipPath(
                      clipper: ZigZagClipper(),
                      child: Container(
                        width: 330.0,
                        height: 560.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18.0)),
                        child: Column(
                          children: <Widget>[
                            Divider(
                              color: Colors.transparent,
                              height: 30,
                            ),
                            Icon(
                              Icons.radio_button_checked,
                              color: Colors.amberAccent[700],
                              size: 35,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text('Invoice',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text('$student', 
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                  DateFormat('dd/MM/yy - hh:mm')
                                      .format(DateTime.now()),
                                  style: TextStyle(fontSize: 15.0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text('ref: $id',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.grey[700])),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Container(
                                width: 300.0,
                                height: 250.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0)),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                        Icons.assessment,
                                        color: Colors.green,
                                        size: 35.0,
                                      ),
                                      title: Text(
                                        '${course.title}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                      ),
                                      subtitle: Text(
                                        'ID: $pid',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0),
                                      ),
                                      trailing: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          '${course.targetHour} hr',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Payment Option',
                                                style: leftTheme,
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.transparent,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text('Prompay'),
                                              Spacer(),
                                              Text('555-666-7777')
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                  'Bank Account'),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Spacer(),
                                              Text('111-222222-6')
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[

                                              Spacer(),
                                              Text('Mr Smith')
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                'Total Amount',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${NumberFormat.simpleCurrency(name: '').format(payment.price)} ฿',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () => {
                        Screenshot(previewContainer: previewContainer, id: id)
                            .takeScreenShot()
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.0),
                                    color: Colors.indigo[700]),
                                child: Center(
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                              Text(
                                'Share',
                                style: TextStyle(
                                    color: Colors.indigo[700], fontSize: 12.0),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvoicePartScreenshot extends StatelessWidget {
  const InvoicePartScreenshot({
    Key key,
    @required this.student,
    @required this.id,
    @required this.course,
    @required this.pid,
    @required this.payment,
  }) : super(key: key);

  final String student;
  final String id;
  final CourseModel course;
  final String pid;
  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final leftTheme = TextStyle(fontWeight: FontWeight.w600, fontSize: 14);

    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 650,
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            ClipPath(
              clipper: OrangeClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 250.0,
                decoration: BoxDecoration(
                  color: Color(0xFFFDFA4C),
                ),
              ),
            ),
            ClipPath(
              clipper: BlackClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width - 230.0,
                height: MediaQuery.of(context).size.height - 250.0,
                decoration: BoxDecoration(
                  color: Color(0xFF0a585e),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: Material(
                  elevation: 30.0,
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(18.0),
                  child: Container(
                    width: 320.0,
                    height: 560.0,
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(18.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: ClipPath(
                      clipper: ZigZagClipper(),
                      child: Container(
                        width: 330.0,
                        height: 590.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18.0)),
                        child: Column(
                          children: <Widget>[
                            Divider(
                              color: Colors.transparent,
                              height: 30,
                            ),
                            Icon(
                              Icons.radio_button_checked,
                              color: Colors.amberAccent[700],
                              size: 35,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text('Invoice',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text('$student',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                  DateFormat('dd/MM/yy - hh:mm')
                                      .format(DateTime.now()),
                                  style: TextStyle(fontSize: 15.0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text('ref: $id',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.grey[700])),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Container(
                                width: 300.0,
                                height: 250.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0)),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                        Icons.assessment,
                                        color: Colors.green,
                                        size: 35.0,
                                      ),
                                      title: Text(
                                        '${course.title}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                      ),
                                      subtitle: Text(
                                        'ID: $pid',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0),
                                      ),
                                      trailing: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          '${course.targetHour} hr',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Payment Option',
                                                style: leftTheme,
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.transparent,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text('Prompay'),
                                              Spacer(),
                                              Text('555-666-7777')
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                  'Bank Account'),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Spacer(),
                                              Text('111-222222-3')
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Spacer(),
                                              Text('Mr Smith')
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Text(
                                'Total Amount',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${NumberFormat.simpleCurrency(name: '').format(payment.price)} ฿',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(3.0, size.height - 10.0);

    var firstControlPoint = Offset(23.0, size.height - 40.0);
    var firstEndPoint = Offset(38.0, size.height - 5.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(58.0, size.height - 40.0);
    var secondEndPoint = Offset(75.0, size.height - 5.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    var thirdControlPoint = Offset(93.0, size.height - 40.0);
    var thirdEndPoint = Offset(110.0, size.height - 5.0);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    var fourthControlPoint = Offset(128.0, size.height - 40.0);
    var fourthEndPoint = Offset(150.0, size.height - 5.0);
    path.quadraticBezierTo(fourthControlPoint.dx, fourthControlPoint.dy,
        fourthEndPoint.dx, fourthEndPoint.dy);

    var fifthControlPoint = Offset(168.0, size.height - 40.0);
    var fifthEndPoint = Offset(185.0, size.height - 5.0);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy,
        fifthEndPoint.dx, fifthEndPoint.dy);

    var sixthControlPoint = Offset(205.0, size.height - 40.0);
    var sixthEndPoint = Offset(220.0, size.height - 5.0);
    path.quadraticBezierTo(sixthControlPoint.dx, sixthControlPoint.dy,
        sixthEndPoint.dx, sixthEndPoint.dy);

    var sevenControlPoint = Offset(240.0, size.height - 40.0);
    var sevenEndPoint = Offset(255.0, size.height - 5.0);
    path.quadraticBezierTo(sevenControlPoint.dx, sevenControlPoint.dy,
        sevenEndPoint.dx, sevenEndPoint.dy);

    var eightControlPoint = Offset(275.0, size.height - 40.0);
    var eightEndPoint = Offset(290.0, size.height - 5.0);
    path.quadraticBezierTo(eightControlPoint.dx, eightControlPoint.dy,
        eightEndPoint.dx, eightEndPoint.dy);

    var ninthControlPoint = Offset(310.0, size.height - 40.0);
    var ninthEndPoint = Offset(330.0, size.height - 5.0);
    path.quadraticBezierTo(ninthControlPoint.dx, ninthControlPoint.dy,
        ninthEndPoint.dx, ninthEndPoint.dy);

    path.lineTo(size.width, size.height - 10.0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BlackClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width / 2, size.height - 50.0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class OrangeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width - 250.0, size.height - 50.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
