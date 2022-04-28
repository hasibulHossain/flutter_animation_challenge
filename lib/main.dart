import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final double translateTo = 200.0;

  AnimationController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  void toggle() {
    _controller!.isDismissed ? _controller?.forward() : _controller!.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: toggle,
        child: AnimatedBuilder(
          animation: _controller!,
          builder: (context, child) {
            double slide = _controller!.value * translateTo;
            double scale = 1 - (_controller!.value * 0.5);
            return Stack(
              children: [
                Container(
                  color: Colors.blue,
                ),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slide)
                    ..scale(scale),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    color: Colors.amber,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
