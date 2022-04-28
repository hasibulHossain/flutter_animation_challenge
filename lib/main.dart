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
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // SingleTickerProviderStateMixin adds functionality for animation to run. Its Like a ticker which tick for every update 60 frames a second.

  /// For controlling explicit animation.
  AnimationController? _controller;

  /// Animation let us access to manipulate our animation to what and how we want to animate.
  /// And we can set type of animation. ex: double, offset, color
  Animation<double>? _animation;

  bool isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //
    _controller = AnimationController(
      vsync: this, // for SingleTickerProviderStateMixin;
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeInOut,
      ),
    );

    _controller?.addListener(() {
      print(_controller?.value);
      print(_animation?.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller!,
        builder: (_, __) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  if (isVisible) {
                    _controller?.reverse();
                  } else {
                    _controller?.forward();
                  }
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: Opacity(
                  opacity: _animation!.value,
                  child: const Icon(
                    CupertinoIcons.heart_fill,
                    size: 30,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Text(
              'Tap the icon to toggle opacity',
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      ),
    );
  }
}
