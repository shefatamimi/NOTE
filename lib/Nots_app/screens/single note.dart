import 'package:flutter/material.dart';
class SingleNote extends StatefulWidget {

  const SingleNote({super.key,
    required this.title, required this.description, required this.selectedDate,
    });

  @override
  State<SingleNote> createState() => _SingleNoteState();
  final String title;
  final String description;
  final DateTime selectedDate;
}


class _SingleNoteState extends State<SingleNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('My Notes'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Text('${widget.title}'),
          Text('${widget.description}'),
          Text('${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}'),
          SizedBox(height: 100,),



        ]



      )


    );

  }
}
