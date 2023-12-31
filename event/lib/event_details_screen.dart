// event_details_screen.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:event/server.dart';
import 'package:flutter/material.dart';
import 'event.dart';
import 'dart:io';

import 'event_list_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;
  Uint8List convert(String img) {
    List<dynamic> decodedList = jsonDecode(img);
    Uint8List image = Uint8List.fromList(decodedList.cast<int>());

    //print(imageForSendToAPI);
    return image;
  }

  EventDetailsScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${event.title}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('id: ${event.id}'),
            Text('Date: ${event.date.toLocal()}'),
            Text('Location: ${event.location}'),
            Text('Organizer: ${event.organizer}'),
            Text('Description: ${event.description}'),
            SizedBox(height: 16),
            // Use Image.file to display the image
            if (event.image.isNotEmpty) Image.memory(convert(event.image)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Deletion'),
                          content: Text(
                              'Are you sure you want to delete this event?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                print("ddd$event.id");
                                await deleteEvent(event.id);
                                print(
                                    event.id); // Call the deleteEvent function
                                Navigator.pop(context); // Close the dialog
                                // TODO: Navigate back to the event list or perform other actions
                                List<Event> events = await fetchEvents();
                                Navigator.popUntil(
                                    context, ModalRoute.withName('/'));
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Delete'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement update action
                    // You might want to navigate to a screen for updating the event
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
