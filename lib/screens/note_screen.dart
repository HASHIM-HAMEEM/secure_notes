import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';
import '../constants/colors.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  const NoteScreen({super.key, this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late int _colorIndex;
  late bool _isPinned;
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
    _colorIndex = widget.note?.colorIndex ?? 6;
    _isPinned = widget.note?.isPinned ?? false;

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isEdited = true;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_isEdited) return true;

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return true;

    final note = Note(
      id: widget.note?.id,
      title: title.isEmpty ? 'Untitled' : title,
      content: content,
      isPinned: _isPinned,
      colorIndex: _colorIndex,
      createdAt: widget.note?.createdAt,
      modifiedAt: DateTime.now(),
    );

    try {
      if (widget.note == null) {
        await Provider.of<NoteProvider>(context, listen: false).addNote(note);
      } else {
        await Provider.of<NoteProvider>(context, listen: false)
            .updateNote(note);
      }
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving note: $e')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.noteColors[_colorIndex],
        appBar: AppBar(
          backgroundColor: AppColors.noteColors[_colorIndex],
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              onPressed: () {
                setState(() {
                  _isPinned = !_isPinned;
                  _isEdited = true;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.palette_outlined),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _buildColorPicker(),
                );
              },
            ),
            if (widget.note != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Note'),
                      content: const Text(
                          'Are you sure you want to delete this note?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    if (!mounted) return;
                    await Provider.of<NoteProvider>(context, listen: false)
                        .deleteNote(widget.note!.id!);
                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                },
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  style: const TextStyle(fontSize: 16),
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Note content',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppColors.noteColors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _colorIndex = index;
                _isEdited = true;
              });
              Navigator.pop(context);
            },
            child: Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.noteColors[index],
                border: Border.all(
                  color: _colorIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  width: _colorIndex == index ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          );
        },
      ),
    );
  }
}
