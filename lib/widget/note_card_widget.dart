import 'package:exp_flutter_sqlite_crud/model/note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class NoteCardWidget extends StatelessWidget {
  final Note note;
  final int index;

  const NoteCardWidget({
    Key? key,
    required this.note,
    required this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PICK COLORS FROM ACCENT COLORS BASED ON INDEX
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(note.createdTime);
    final minHeight = getHeight(index);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time, style: TextStyle(color: Colors.grey.shade700)),
            SizedBox(height: 4.0),
            Text(
                note.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                ),
            )
          ],
        ),
      ),
    );
  }

  // TO RETURN DIFFERENT HEIGHT FOR DIFFERENT WIDGETS
  double getHeight(int index) {
    switch (index % 4)
    {
      case 0: return 100.0;
      case 1: return 150.0;
      case 2: return 150.0;
      case 3: return 100.0;
      default: return 100.0;
    }
  }
}
