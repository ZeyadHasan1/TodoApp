import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo/layout/Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
        Duration(seconds: 10),
        () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return Home();
                },
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset('lottie/Splash.json',
                width: MediaQuery.of(context).size.width * .7,
                height: MediaQuery.of(context).size.height * .7),
          ),
          Center(
            child: Text('Wait some Seconds Please ...',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
