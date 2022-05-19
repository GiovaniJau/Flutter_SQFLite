import 'package:flutter/material.dart';
import 'package:flutter_sqflite/database/notes_db.dart';
import 'package:flutter_sqflite/model/note.dart';
import 'package:flutter_sqflite/ui/note_detail_page.dart';
import 'package:flutter_sqflite/widget/note_card_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DataSearch extends SearchDelegate<String> {
  late final List<Note> notes;

  DataSearch(this.notes);

  Future refreshNotes() async {
    notes = await NotesDatabase.instance.readAllNotes();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, '');
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList = query.isEmpty
        ? notes
        : notes.where((p) => p.title.contains(RegExp(query, caseSensitive: false))).toList();

    return MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        padding: const EdgeInsets.all(8),

        itemCount: suggestionList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoteDetailPage(noteId: suggestionList[index].id!),
            ));

            refreshNotes();
          },
          child: NoteCardWidget(note: suggestionList[index], index: index),
        )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? notes
        : notes.where((p) => p.title.contains(RegExp(query, caseSensitive: false))).toList();

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.all(8),

      itemCount: suggestionList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoteDetailPage(noteId: suggestionList[index].id!),
            ));

            refreshNotes();
          },
          child: NoteCardWidget(note: suggestionList[index], index: index),
        )
    );
  }
}