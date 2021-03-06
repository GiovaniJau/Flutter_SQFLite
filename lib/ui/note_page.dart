import 'package:flutter/material.dart';
import 'package:flutter_sqflite/database/notes_db.dart';
import 'package:flutter_sqflite/model/note.dart';
import 'package:flutter_sqflite/ui/search_note.dart';
import 'package:flutter_sqflite/widget/note_card_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'edit_note_page.dart';
import 'note_detail_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      backgroundColor: Colors.green.shade200,
      title: const Text(
        'Notes',
        style: TextStyle(fontSize: 24),
      ),

      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(notes));
            })
      ],

      /*actions: const [
        Icon(Icons.search),
        SizedBox(width: 12)
      ],*/


    ),
    body: Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : notes.isEmpty
          ? const Text(
        'No Notes',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )
          : buildNotes(),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.black,
      child: const Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddEditNotePage()),
        );

        refreshNotes();
      },
    ),
  );

  Widget buildNotes() => MasonryGridView.count(
    crossAxisCount: 2,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    padding: const EdgeInsets.all(8),
    itemCount: notes.length,
    itemBuilder: (context, index) {
      final note = notes[index];

      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteDetailPage(noteId: note.id!),
          ));

          refreshNotes();
        },
        child: NoteCardWidget(note: note, index: index),
      );
    },
  );
}