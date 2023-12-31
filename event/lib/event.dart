// event.dart

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Event {
  final String? id; // Add the id property

  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String organizer;
  final String image;
  List<int>? imageBytes;

  Event({
    this.id, // Include id in the constructor
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.organizer,
    required this.image,
    this.imageBytes,
  });

  // Factory method to create an Event from JSON data
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      organizer: json['organizer'],
      image: json['image'],
    );
  }
}
