// event_list_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'event.dart';
import 'dart:typed_data';

import 'event_details_screen.dart';

class EventListScreen extends StatelessWidget {
  final List<Event> events;

  Uint8List convert(String img) {
    List<dynamic> decodedList = jsonDecode(img);
    Uint8List image = Uint8List.fromList(decodedList.cast<int>());

    //print(imageForSendToAPI);
    return image;
  }

  EventListScreen({required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          Event event = events[index];

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(event.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${event.date.toLocal()}'),
                  Text('Location: ${event.location}'),
                  Text('Organizer: ${event.organizer}'),
                  Text('Description: ${event.description}'),
                  SizedBox(height: 8),
                  // Display the image if available
                  if (event.image.isNotEmpty)
                    Image.memory(
                      convert(event.image),
                      width: 150,
                    ),
                ],
              ),
              onTap: () {
                // TODO: Implement action when tapping on an event
                // You might want to navigate to a detailed view or perform other actions
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsScreen(event: event),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
