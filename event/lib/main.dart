// main.dart

import 'package:flutter/material.dart';
import 'event_form.dart';
import 'event_list_screen.dart';
import 'server.dart'; // Import the fetchEvents function
import 'event.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event App',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EarthWise"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the EventForm screen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventForm()),
                );
              },
              child: Text('Add Event'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Fetch events when navigating to the EventListScreen
                List<Event> events = await fetchEvents();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventListScreen(events: events)),
                );
              },
              child: Text('View Events'),
            ),
          ],
        ),
      ),
    );
  }
}
