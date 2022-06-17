import 'dart:async';

import 'package:exp_flutter_sqlite_crud/db/notes_database.dart';
import 'package:exp_flutter_sqlite_crud/model/note.dart';
import 'package:exp_flutter_sqlite_crud/page/edit_note_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note notes;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    this.notes = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [ editButton(), deleteButton() ]),
      body:
      /* Padding(
        padding: EdgeInsets.all(12.0),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: [
            Text(
              notes.title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(height: 8.0),

            Text(
              DateFormat.yMMMd().format(notes.createdTime),
              style: TextStyle(color: Colors.white38),
            ),

            SizedBox(height: 8.0),

            Text(
              notes.description,
              style: TextStyle(color: Colors.white70, fontSize: 18.0),
            )
          ],
        ),
      ) */

      isLoading
          ?  Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(12.0),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: [
            Text(
              notes.title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(height: 8.0),

            Text(
              DateFormat.yMMMd().format(notes.createdTime),
              style: TextStyle(color: Colors.white38),
            ),

            SizedBox(height: 8.0),

            Text(
              notes.description,
              style: TextStyle(color: Colors.white70, fontSize: 18.0),
            )
          ],
        ),
      ), /* */
    );
  }

  Widget editButton() => IconButton(
    icon: Icon(Icons.edit_outlined),
    onPressed: () async {
      print(">>> EDIT BUTTON WAS CLICKED");

      // if (isLoading) return; // isLoading WAS A BIT BUGGY

      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: notes)
      ));

      refreshNotes();
      print(">>> REFRESH NOTES WAS REACHED");
    },
  );

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete),
    onPressed: () async {
      await NotesDatabase.instance.delete(widget.noteId);
      Navigator.of(context).pop();
    },
  );
}
