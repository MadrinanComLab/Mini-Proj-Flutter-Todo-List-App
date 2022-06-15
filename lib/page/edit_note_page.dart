import 'package:exp_flutter_sqlite_crud/db/notes_database.dart';
import 'package:exp_flutter_sqlite_crud/model/note.dart';
import 'package:exp_flutter_sqlite_crud/widget/note_form_widget.dart';
import 'package:flutter/material.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? "";
    description = widget.note?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [buildButton()]),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          isImportant: isImportant,
          number: number,
          title: title,
          description: description,
          onChangedImportant: (isImportant) => setState(() => this.isImportant = isImportant),
          onChangedNumber: (number) => setState(() => this.number = number),
          onChangedTitle: (title) => setState(() => this.title = title),
          onChangedDescription: (description) => setState(() => this.description = description)
        ),
      ),
    );
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: isFormValid ? null : Colors.grey.shade700
        ),

        onPressed: addOrUpdateNote,
        child: Text("Save"),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;
      if (isUpdating) { updateNote(); }
      else { await addNote(); }
      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportatnt: isImportant,
      number: number,
      title: title,
      description: description
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: isImportant,
      number: number,
      description: description,
      createdTime: DateTime.now()
    );

    await NotesDatabase.instance.create(note);
  }
}
