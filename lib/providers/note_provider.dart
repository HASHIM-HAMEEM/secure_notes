import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../utils/database_helper.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  List<Note> get pinnedNotes => _notes.where((note) => note.isPinned).toList();
  List<Note> get unpinnedNotes =>
      _notes.where((note) => !note.isPinned).toList();
  bool get isLoading => _isLoading;

  NoteProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notes = await DatabaseHelper.instance.getAllNotes();
    } catch (e) {
      debugPrint('Error loading notes: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    try {
      final newNote = await DatabaseHelper.instance.create(note);
      _notes.insert(0, newNote);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding note: $e');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await DatabaseHelper.instance.update(note);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating note: $e');
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await DatabaseHelper.instance.delete(id);
      _notes.removeWhere((note) => note.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting note: $e');
    }
  }

  Future<void> togglePinNote(Note note) async {
    final updatedNote = note.copy(isPinned: !note.isPinned);
    await updateNote(updatedNote);
  }

  List<Note> searchNotes(String query) {
    return _notes.where((note) {
      final titleLower = note.title.toLowerCase();
      final contentLower = note.content.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) ||
          contentLower.contains(searchLower);
    }).toList();
  }
}
