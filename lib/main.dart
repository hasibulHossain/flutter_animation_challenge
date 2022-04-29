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

  bool _canBeDragged = false;

  AnimationController? _controller;

  Animation<double>? _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeInOut,
      ),
    );
  }

  void toggle() {
    _controller!.isDismissed ? _controller?.forward() : _controller!.reverse();
  }

  void _onDragStart(DragStartDetails details) {
    print('${details.globalPosition.dx}');
    double minDragStartEdge = 200;
    double maxDragStartEdge = 200;

    bool isDragOpenFromLeft = _controller!.isDismissed && details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight = _controller!.isCompleted && details.globalPosition.dx > maxDragStartEdge;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }
  
  void _onDragUpdate(DragUpdateDetails details, double sw) { 
    if(_canBeDragged) {
      double delta = details.primaryDelta! / sw;
      _controller!.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details, double screenWith) {
    if(_controller!.isDismissed || _controller!.isCompleted) return;
    if(details.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / screenWith;
      _controller!.fling(velocity: visualVelocity);
    } else if(_controller!.value < 5.0) {
      toggle();
    } else {
      toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: toggle,
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: (details) => _onDragUpdate(details, sw),
        onHorizontalDragEnd: (details) => _onDragEnd(details, sw),
        child: Container(
          color: Colors.red,
          child: AnimatedBuilder(
            animation: _animation!,
            builder: (context, child) {
              double slide = _animation!.value * sw / 2;
              double scale = 1 - (_animation!.value * 0.5);
              return Stack(
                children: [
                  Container(
                    height: sh,
                    width: sw,
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Text('App Drawer', style: Theme.of(context).textTheme.headline3,),
                    ),
                  ),
                  Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()
                      ..translate(slide)
                      ..scale(scale),
                    child: Container(
                      height: sh,
                      width: sw,
                      color: Colors.pink,
                      child: Center(
                        child: Text(
                          'Tap Here\nApp Screen',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
