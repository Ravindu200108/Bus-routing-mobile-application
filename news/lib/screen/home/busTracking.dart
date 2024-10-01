import 'package:flutter/material.dart';
import 'dart:async'; // For Timer

class BusTrackingScreen extends StatefulWidget {
  @override
  _BusTrackingScreenState createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends State<BusTrackingScreen> {
  double _markerX = 0.0; // X position of the marker
  double _markerY = 0.0; // Y position of the marker
  List<Offset> _userLocations = []; // List to store user marked locations

  @override
  void initState() {
    super.initState();
    _startMovingMarker();
  }

  // Simulate bus movement
  void _startMovingMarker() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        // Example logic to update marker position
        _markerX = (_markerX + 10) % MediaQuery.of(context).size.width;
        _markerY = (_markerY + 5) % MediaQuery.of(context).size.height;
      });
    });
  }

  // Handle user taps to add location markers
  void _addUserLocation(TapUpDetails details) {
    setState(() {
      _userLocations.add(details.localPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Tracking'),
        backgroundColor: Color.fromARGB(255, 0, 83, 125),
      ),
      body: GestureDetector(
        onTapUp: _addUserLocation,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/h.jpg', // Path to your image asset
                fit: BoxFit.cover, // Ensures the image covers the entire screen
              ),
            ),
            // Animated bus marker
            AnimatedPositioned(
              duration: Duration(milliseconds: 100),
              left: _markerX,
              top: _markerY,
              child: Icon(
                Icons.directions_bus,
                color: Colors.red,
                size: 40,
              ),
            ),
            // User location markers
            for (Offset location in _userLocations)
              Positioned(
                left: location.dx - 20, // Adjust for marker size
                top: location.dy - 20, // Adjust for marker size
                child: Icon(
                  Icons.location_pin,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
