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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10,),
                Center(
                  child: Text('${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                    style: TextStyle(color: Colors.black54,fontSize: 15),),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${widget.title}',style:
                  TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${widget.description}'),
                ),




              ]



          ),
        )


    );

  }
}