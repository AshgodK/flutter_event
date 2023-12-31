import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'event.dart';

class EventForm extends StatefulWidget {
  const EventForm({Key? key}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TextEditingController _eventLocationController = TextEditingController();
  TextEditingController _eventOrganizerController = TextEditingController();
  var imageForSendToAPI;
  var img;
  var tempp;

  Future<void> _imgFromGallery() async {
    final temp = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    print(temp);
    imageForSendToAPI = await temp?.readAsBytes();
    //print(imageForSendToAPI);
    setState(() {
      tempp = temp;
      img = imageForSendToAPI;
    });
  }

  Future<void> _addEventToDatabase(Event newEvent) async {
    final String apiUrl = 'http://localhost:5001/api/events/add-event';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      request.fields['title'] = newEvent.title;
      request.fields['description'] = newEvent.description;
      request.fields['date'] = newEvent.date.toIso8601String();
      request.fields['location'] = newEvent.location;
      request.fields['organizer'] = newEvent.organizer;
      request.fields['image'] = newEvent.image;

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding event to the database: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(labelText: 'Event Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _eventDescriptionController,
                decoration: InputDecoration(labelText: 'Event Description'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text('Select Event Date'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Selected Date: ${_selectedDate.toLocal()}'.split(' ')[0],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _eventLocationController,
                decoration: InputDecoration(labelText: 'Event Location'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _eventOrganizerController,
                decoration: InputDecoration(labelText: 'Event Organizer'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: _imgFromGallery,
                child: Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(width: 8),
                    Text('Select Event Image'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              imageForSendToAPI != null
                  ? Image.memory(imageForSendToAPI)
                  : Container(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Event newEvent = Event(
                      title: _eventNameController.text,
                      description: _eventDescriptionController.text,
                      date: _selectedDate,
                      location: _eventLocationController.text,
                      organizer: _eventOrganizerController.text,
                      image: img.toString(),
                    );

                    await _addEventToDatabase(newEvent);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Event added: ${newEvent.title} on ${newEvent.date}'),
                      ),
                    );
                  }
                },
                child: Text('Add Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
