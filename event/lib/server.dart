// server.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:bson/bson.dart';

import 'event.dart'; // Import the Event class

Future<List<Event>> fetchEvents() async {
  final response = await http
      .get(Uri.parse('http://localhost:5001/api/events/get-all-events'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON
    final List<dynamic> data = json.decode(response.body);
    // Convert the dynamic list to a list of Event objects
    List<Event> events = data.map((event) => Event.fromJson(event)).toList();

    return events;
  } else {
    // If the server did not return a 200 OK response, throw an exception
    throw Exception('Failed to load events');
  }
}

Future<void> deleteEvent(String? eventId) async {
  print(eventId);
  if (eventId == null) {
    print("null");
    // Handle the case where eventId is null (or throw an exception)
    throw Exception('Event ID is required for deletion');
  }

  final response = await http.post(
    Uri.parse('http://localhost:5001/api/events/delete-event'),
    body: {'eventId': eventId},
  );
  print("after" + eventId);

  if (response.statusCode == 200) {
    print('Event deleted successfully');
  } else {
    print(response.statusCode);
    // If the server did not return a 200 OK response, throw an exception
    throw Exception('Failed to delete event');
  }
}
