import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tutor_helper/blocs/blocs.dart';
import 'package:tutor_helper/models/models.dart';
import 'package:tutor_helper/providers/providers.dart';
import 'package:tutor_helper/screens/invoice_screen.dart';
import 'package:tutor_helper/screens/screens.dart';

class PaymentListWidget extends StatefulWidget {
  const PaymentListWidget({
    Key key,
    @required this.course,
    @required this.coursesBloc,
  }) : super(key: key);

  final CourseModel course;
  final CoursesBloc coursesBloc;

  @override
  _PaymentListWidgetState createState() => _PaymentListWidgetState();
}

class _PaymentListWidgetState extends State<PaymentListWidget> {
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
    return Stack(
      children: <Widget>[
        ListView.builder(
            itemCount: widget.course.payments.length,
            itemBuilder: (BuildContext context, int index) {
              final PaymentModel payment = widget.course.payments[index];

              return Card(
                  child: InkWell(
                onTapDown: (tapDetail) {
                  _tapDetail = tapDetail;
                },
                onLongPress: () {
                  setState(() {
                    showPopupMenu = true;
                    _editFunc = () async {
                      PaymentModel paymentFuture = await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ModalPayment(
                              payment: payment,
                            );
                          });

                      if (paymentFuture != null) {
                        List<PaymentModel> updatePayments =
                            widget.course.payments.map((check) {
                          return check.pid == paymentFuture.pid
                              ? paymentFuture
                              : check;
                        }).toList();
                        CourseModel toSave =
                            widget.course.copyWith(payments: updatePayments);

                        widget.coursesBloc.dispatch(UpdateCourses(toSave));
                      }
                    };
                    _deleteFunc = () {
                      final pid = payment.pid;
                      //print(timestamps);
                      final List<PaymentModel> updatePayments = widget
                          .course.payments
                          .where((check) => check.pid != pid)
                          .toList();
                      //print(updateTimestamp);
                      final CourseModel updateCourse =
                          widget.course.copyWith(payments: updatePayments);
                      widget.coursesBloc.dispatch(UpdateCourses(updateCourse));
                    };
                  });
                },
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.22,
                  secondaryActions: <Widget>[
                    
                  ],
                  child: Row(children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      color: payment.complete == true
                          ? Colors.green[400]
                          : Colors.red[400],
                      child: InkWell(
                          onTap: () {
                            final updateComplete = !payment.complete;
                            final updatePayment =
                                payment.copyWith(complete: updateComplete);
                            List<PaymentModel> updatePayments =
                                widget.course.payments.map((check) {
                              return check.pid == updatePayment.pid
                                  ? updatePayment
                                  : check;
                            }).toList();

                            CourseModel toSave = widget.course
                                .copyWith(payments: updatePayments);
                            //print(updateTimestamp);
                            //print(course.timestamps);
                            widget.coursesBloc.dispatch(UpdateCourses(toSave));
                          },
                          child: Icon(
                            payment.complete == false
                                ? Icons.check_box_outline_blank
                                : Icons.check_box,
                            color: Colors.white70,
                          )),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Paid ${DateFormat('dd/MM/yy hh:mm').format(payment.paid)}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '${payment.price} ฿',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600]),
                                ),
                                Spacer(),
                                Text(
                                  'PID: ${payment.pid}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () async {
                          if (payment.complete) {
                            final returnError = await Navigator.of(context)
                                .push(CupertinoPageRoute(builder: (_) {
                              return ReceiptScreen(
                                id: widget.course.id,
                                pid: payment.pid,
                              );
                              /* ReceiptScreen(
                                id: course.id,
                                pid: payment.pid,
                              ); */
                            }));
                          } else {
                            final returnError = await Navigator.of(context)
                                .push(CupertinoPageRoute(builder: (_) {
                              return InvoiceScreen(
                                id: widget.course.id,
                                pid: payment.pid,
                              );
                            }));
                          }
                        },
                        child: Icon(
                          Icons.info,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ]),
                ),
              ));
            }),
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

class ModalPayment extends StatefulWidget {
  final PaymentModel payment;
  ModalPayment({Key key, this.payment}) : super(key: key);

  _ModalPaymentState createState() => _ModalPaymentState();
}

class _ModalPaymentState extends State<ModalPayment> {
  PaymentModel payment;
  DateTime _paid;
  double _price;
  bool _complete;
  String _note;
  String _title;

  @override
  void initState() {
    payment = widget.payment;
    if (payment == null) {
      _title = 'New Payment';
      _paid = DateTime.now();
      _complete = false;
      _note = '';
      _price = 0;
    } else {
      _title = 'Edit Payment';
      _paid = payment.paid;
      _complete = payment.complete;
      _note = payment.note;
      _price = payment.price;
    }
    super.initState();
  }

  static final GlobalKey<FormState> _formPaymentKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Container(
        color: Color(0xFF737373),
        child: Container(
          child: _buildBottomNavigationMenu(),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationMenu() {
    return Form(
      key: _formPaymentKey,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 2, 5, 0),
              child: ListTile(
                title: Text(
                  _title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[850]),
                ),
                trailing: InkWell(
                    child: Icon(Icons.add),
                    onTap: () {
                      if (_formPaymentKey.currentState.validate()) {
                        _formPaymentKey.currentState.save();

                        PaymentModel toSave;
                        if (payment == null) {
                          toSave = PaymentModel(
                              pid: Uuid().generateV1(),
                              paid: _paid,
                              price: _price,
                              note: _note,
                              complete: _complete);
                        } else {
                          toSave = payment.copyWith(
                              paid: _paid,
                              price: _price,
                              note: _note,
                              complete: _complete);
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
            color: Colors.grey[700],
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
                                BorderSide(color: Colors.grey[600], width: 1.0),
                          ),
                          labelText: 'Paid Time'),
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              '${DateFormat('EEE, MMM d, h:mm a').format(_paid)}'),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              DatePicker.showDateTimePicker(context,
                  currentTime: _paid,
                  showTitleActions: true,
                  onChanged: (date) => onConfirm(date, false),
                  onConfirm: (date) => onConfirm(date, true));
            },
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 15.0, 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[600], width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber[800], width: 1.0),
                        ),
                        labelText: 'Price'),
                    enabled: true,
                    initialValue: _price.toString(),
                    onSaved: (text) {
                      _price = text != '' ? double.parse(text) : 0;
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
                          borderSide:
                              BorderSide(color: Colors.amber[800], width: 1.0),
                        ),
                        labelText: 'Notes'),
                    enabled: true,
                    initialValue: _note,
                    onSaved: (text) {
                      _note = text;
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onConfirm(DateTime date, bool confirm) {
    //print('confirm $date');
    setState(() {
      _paid = date;
    });
  }
}
