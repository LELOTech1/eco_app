import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(ColorWheelApp());
}

class ColorWheelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ColorWheelScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ColorWheelScreen extends StatefulWidget {
  @override
  _ColorWheelScreenState createState() => _ColorWheelScreenState();
}

class _ColorWheelScreenState extends State<ColorWheelScreen> {
  Color _selectedColor = Colors.red;
  Color _backgroundColor = Colors.white;
  int _selectedIndex = 0;
  int _clickCount = 0;
  bool _isLoading = false;

  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
  ];

  final List<String> _colorNames = [
    'Red',
    'Green',
    'Blue',
    'Yellow',
    'Orange',
  ];

  Future<void> _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _handleTapDown(TapDownDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);

    final double radians = atan2(localOffset.dy - box.size.height / 2,
        localOffset.dx - box.size.width / 2);
    final double hue = (radians + pi) / (2 * pi);

    final Random random = Random();
    final Color randomBackgroundColor = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );

    setState(() {
      _selectedColor = _colors[
          _clickCount % _colors.length]; // Change color based on click count
      _backgroundColor = randomBackgroundColor;
      _clickCount++;
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getSelectedColorDescription() => _selectedIndex > 0
      ? 'Selected Color: ${_colorNames[_selectedIndex - 1]}'
      : '';

  void _resetClicks() {
    setState(() {
      _clickCount = 0;
    });
    final snackBar = SnackBar(
      content: Text('Clicks Reset'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Wheel App'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Add your save functionality here
            },
          ),
        ],
      ),
      body: Container(
        color: _backgroundColor,
        child: Stack(
          children: [
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : (_selectedIndex == 0
                    ? Center(
                        child: GestureDetector(
                          onTapDown: _handleTapDown,
                          child: Container(
                            width: 200.0,
                            height: 200.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedColor,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getSelectedColorDescription(),
                              style: TextStyle(fontSize: 20.0),
                            ),
                            if (_selectedIndex ==
                                1) // Only show click count for 'Color Wheel' tab
                              Text(
                                'Click Count: $_clickCount',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.color_lens),
            label: 'Color Wheel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Description',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                _resetClicks();
              },
              child: Icon(Icons.arrow_back_ios),
            )
          : null,
    );
  }
}
