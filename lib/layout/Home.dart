import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:todo/Cubit/bloc.dart';
import 'package:todo/Cubit/states.dart';
import 'package:todo/layout/Screens/donetasks.dart';
import 'package:todo/layout/Screens/newtasks.dart';
import 'package:todo/layout/Screens/startasks.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> l = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  var kayscaffold = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  int index = 0;
  bool isshow = false;
  IconData fab = Icons.edit;
  FlutterLocalNotificationsPlugin? localnotification;
  TimeOfDay? tt;
  DateTime? date;

  @override
  void initState() {
    super.initState();
    var androidInit = new AndroidInitializationSettings('ic_launcher');
    var iosInit = new IOSInitializationSettings();
    var init = new InitializationSettings(android: androidInit, iOS: iosInit);
    localnotification = new FlutterLocalNotificationsPlugin();
    localnotification!.initialize(init);
  }

  Future _showNotification() async {
    var android = new AndroidNotificationDetails(
      'channelId',
      'channelName',
      'channelDescription',
    );
    var ios = new IOSNotificationDetails();
    var general = new NotificationDetails(
      android: android,
      iOS: ios,
    );
    var time = DateTime(date!.year,date!.month,date!.day,tt!.hour,tt!.minute);

    // ignore: deprecated_member_use
    localnotification!.schedule(1, titlecontroller.text, 'It\'s time to work hard 💪️', time, general);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0.0,
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: TextStyle(
                  color: HexColor('#060930'),
                ),
              ),
              backgroundColor: Colors.white,
            ),
            key: kayscaffold,
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (isshow) {
                  if (formkey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titlecontroller.text,
                      time: timecontroller.text,
                      date: datecontroller.text,
                    );
                    Navigator.pop(context);
                    isshow = false;
                    _showNotification();
                  }
                  setState(() {
                    fab = Icons.edit;
                  });
                } else {
                  isshow = true;
                  setState(() {
                    fab = Icons.add;
                  });
                  kayscaffold.currentState!
                      .showBottomSheet(
                        (context) => Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: titlecontroller,
                                  validator: (s) {
                                    if (s!.isEmpty) {
                                      return 'Title can\'t be emty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Title',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  controller: timecontroller,
                                  validator: (s) {
                                    if (s!.isEmpty) {
                                      return 'time can\'t be emty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Time',
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) { timecontroller.text =
                                        value!.format(context).toString();
                                        tt=value;
                                        });
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  controller: datecontroller,
                                  validator: (s) {
                                    if (s!.isEmpty) {
                                      return 'Date can\'t be emty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Date',
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2030-12-30'))
                                        .then(
                                      (value) { datecontroller.text =
                                          DateFormat.yMMMd().format(value!);
                                          date=value;
                                       } );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    setState(() {
                      fab = Icons.edit;
                    });
                    isshow = false;
                  });
                }
              },
              child: Icon(fab),
              backgroundColor: Colors.pink,
              foregroundColor: HexColor('#060930'),
            ),
            bottomNavigationBar: FluidNavBar(
              icons: [
                FluidNavBarIcon(
                  icon: Icons.add_circle_outline,
                  backgroundColor: Colors.pink,
                ),
                FluidNavBarIcon(
                  icon: Icons.check_circle_outline,
                  backgroundColor: Colors.pink,
                ),
                FluidNavBarIcon(
                  icon: Icons.star_border_outlined,
                  backgroundColor: Colors.pink,
                ),
              ],
              onChange: (i) {
                cubit.changeIndex(i);
              },
              style: FluidNavBarStyle(
                barBackgroundColor: HexColor('#060930'),
                iconBackgroundColor: Colors.white,
                iconSelectedForegroundColor: HexColor('#060930'),
                iconUnselectedForegroundColor: HexColor('#060930'),
              ),
            ),
          );
        },
      ),
    );
  }
}
