import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class NoteProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Note> _notes = [];
  bool _isLoading = false;

  // Pagination
  static const int _limit = 15;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  List<Note> get notes => _notes;
  List<Note> get pinnedNotes => _notes.where((note) => note.isPinned).toList();
  List<Note> get unpinnedNotes =>
      _notes.where((note) => !note.isPinned).toList();
  bool get isLoading => _isLoading;

  NoteProvider() {
    loadNotes();
  }

  Future<void> loadNotes({bool refresh = false}) async {
    if (_isLoading) return;
    if (refresh) {
      _lastDocument = null;
      _notes.clear();
      _hasMore = true;
    }
    if (!_hasMore) return;

    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user != null) {
        var query = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .orderBy('createdAt', descending: true)
            .limit(_limit);

        if (_lastDocument != null) {
          query = query.startAfterDocument(_lastDocument!);
        }

        final snapshot = await query.get();

        if (snapshot.docs.isEmpty) {
          _hasMore = false;
        } else {
          _lastDocument = snapshot.docs.last;
          final newNotes =
              snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
          _notes.addAll(newNotes);
        }
      }
    } catch (e) {
      debugPrint('Error loading notes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(Note note) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docRef = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .add({
          'title': note.title,
          'content': note.content,
          'isPinned': note.isPinned,
          'colorIndex': note.colorIndex,
          'createdAt': FieldValue.serverTimestamp(),
          'modifiedAt': FieldValue.serverTimestamp(),
        });

        final newNote = note.copy(id: docRef.id);
        _notes.insert(0, newNote);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding note: $e');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      final user = _auth.currentUser;
      if (user != null && note.id != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .doc(note.id)
            .update({
          'title': note.title,
          'content': note.content,
          'isPinned': note.isPinned,
          'colorIndex': note.colorIndex,
          'modifiedAt': FieldValue.serverTimestamp(),
        });

        final index = _notes.indexWhere((n) => n.id == note.id);
        if (index != -1) {
          _notes[index] = note;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error updating note: $e');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .doc(id)
            .delete();

        _notes.removeWhere((note) => note.id == id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error deleting note: $e');
    }
  }

  Future<void> togglePinNote(Note note) async {
    final updatedNote = note.copy(isPinned: !note.isPinned);
    await updateNote(updatedNote);
  }

  List<Note> searchNotes(String query) {
    final searchLower = query.toLowerCase();
    return _notes.where((note) {
      final titleLower = note.title.toLowerCase();
      final contentLower = note.content.toLowerCase();
      return titleLower.contains(searchLower) ||
          contentLower.contains(searchLower);
    }).toList();
  }
}
