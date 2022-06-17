import 'package:exp_flutter_sqlite_crud/db/notes_database.dart';
import 'package:exp_flutter_sqlite_crud/model/note.dart';
import 'package:exp_flutter_sqlite_crud/page/edit_note_page.dart';
import 'package:exp_flutter_sqlite_crud/widget/note_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:exp_flutter_sqlite_crud/page/note_detail_page.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    // TODO: implement dispose
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    this.notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    /* print(">>> note_page.dart: " + (isLoading
        ? CircularProgressIndicator()
        : notes.isEmpty
        ? Text(
        "No Notes",
        style: TextStyle(color: Colors.white, fontSize: 24.0))
        : buildNotes()).toString()
    ); */

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes", style: TextStyle(fontSize: 24.0)),
        actions: [ Icon(Icons.search), SizedBox(width: 12.0) ],
      ),

      body: Center(
        /* child: notes.isEmpty
            ? Text(
            "No Notes",
            style: TextStyle(color: Colors.white, fontSize: 24.0))
            : buildNotes(), */
        child: isLoading
            ? CircularProgressIndicator()
            : notes.isEmpty
            ? Text(
              "No Notes",
              style: TextStyle(color: Colors.white, fontSize: 24.0))
            : buildNotes(), /* */
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditNotePage())
          );

          refreshNotes();
        },
      ),
    );
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    padding: EdgeInsets.all(8.0),
    itemCount: notes.length,
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final note = notes[index];

      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoteDetailPage(noteId: note.id!)
          ));

          refreshNotes();
        },

        child: NoteCardWidget(note: note, index: index),
      );
    },
  );
}
