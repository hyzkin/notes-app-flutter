import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/components/drawer.dart';
import 'package:notes/components/note_tile.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  // create a note
  void createNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              content: TextField(
                controller: _controller,
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    context.read<NoteDatabase>().addNote(_controller.text);

                    _controller.clear();

                    Navigator.pop(context);
                  },
                  child: const Text('Create'),
                ),
              ],
            ));
  }

  // read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // update a note
  void updateNote(Note note) {
    _controller.text = note.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              content: TextField(
                controller: _controller,
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    context
                        .read<NoteDatabase>()
                        .updateNote(note.id, _controller.text);

                    _controller.clear();

                    Navigator.pop(context);
                  },
                  child: const Text('Update'),
                ),
              ],
            ));
  }

  // delete a note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();

    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        // backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: createNote,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              'Notes',
              style: TextStyle(
                fontFamily: GoogleFonts.dmSerifText().fontFamily,
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  final note = currentNotes[index];

                  return NoteTile(
                      text: note.text,
                      onEdit: () {
                        updateNote(note);
                      },
                      onDelete: () {
                        deleteNote(note.id);
                      });
                }),
          ),
        ],
      ),
    );
  }
}
