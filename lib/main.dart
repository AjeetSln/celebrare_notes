import 'package:flutter/material.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interactive Notes App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const NotesHome(),
    );
  }
}

class NotesHome extends StatefulWidget {
  const NotesHome({super.key});

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  final List<Map<String, String>> _notes = [];
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredNotes = [];

  @override
  void initState() {
    super.initState();
    _filteredNotes = _notes;
  }

  void _addNote(String title, String description) {
    setState(() {
      _notes.add({'title': title, 'description': description});
      _filteredNotes = _notes;
    });
  }

  void _editNote(int index, String title, String description) {
    setState(() {
      _notes[index] = {'title': title, 'description': description};
      _filteredNotes = _notes;
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
      _filteredNotes = _notes;
    });
  }

  void _searchNotes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredNotes = _notes;
      } else {
        _filteredNotes = _notes
            .where((note) =>
                note['title']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.notes),
            SizedBox(width: 10),
            Text('My Notes'),
             
            
          ],
        ),
       
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearchDialog(context);
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _filteredNotes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'No notes yet. Add some!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                final note = _filteredNotes[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  shadowColor: Colors.blueAccent,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      note['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      note['description']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    trailing: Wrap(
                      spacing: 10,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            showNoteDialog(
                              context,
                              note['title']!,
                              note['description']!,
                              (title, description) =>
                                  _editNote(index, title, description),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteNote(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showNoteDialog(context, '', '', (title, description) {
            _addNote(title, description);
          });
        },
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
        tooltip: 'Create a new note',
      ),
    );
  }

  void showNoteDialog(BuildContext context, String initialTitle,
      String initialDescription, Function(String, String) onSave) {
    final titleController = TextEditingController(text: initialTitle);
    final descriptionController =
        TextEditingController(text: initialDescription);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add/Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();
              if (title.isNotEmpty && description.isNotEmpty) {
                onSave(title, description);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Notes'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(hintText: 'Search by title'),
          onChanged: (value) => _searchNotes(value),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              _searchNotes('');
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
