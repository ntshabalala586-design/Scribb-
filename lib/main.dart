import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Notes', 
      home: const NotesPage(), 
      debugShowCheckedModeBanner: false
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<String> notes = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => notes = prefs.getStringList('notes')?? []);
  }

  _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notes', notes);
  }

  _addNote() {
    if (_controller.text.isNotEmpty) {
      setState(() => notes.add(_controller.text));
      _controller.clear();
      _saveNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Notes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0), 
            child: Row(children: [
              Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Write a note...'))),
              IconButton(onPressed: _addNote, icon: const Icon(Icons.add))
          ])),
          Expanded(child: ListView.builder(
            itemCount: notes.length, 
            itemBuilder: (context, index) => ListTile(
              title: Text(notes[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete), 
                onPressed: () {
                  setState(() => notes.removeAt(index));
                  _saveNotes();
                }
              ),
            )
          )),
        ],
      ),
    );
  }
}
