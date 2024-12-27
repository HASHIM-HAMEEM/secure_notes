import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int colorIndex;
  final bool isPinned;
  final List<String> tags;
  final List<String>? attachments;
  final bool isLocked;

  Note({
    this.id,
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? modifiedAt,
    this.colorIndex = 6,
    this.isPinned = false,
    this.tags = const [],
    this.attachments,
    this.isLocked = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        modifiedAt = modifiedAt ?? DateTime.now();

  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      isPinned: data['isPinned'] ?? false,
      colorIndex: data['colorIndex'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      modifiedAt:
          (data['modifiedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      tags: data['tags'] != null ? List<String>.from(data['tags']) : [],
      attachments: data['attachments'] != null
          ? List<String>.from(data['attachments'])
          : null,
      isLocked: data['isLocked'] ?? false,
    );
  }

  Note copy({
    String? id,
    String? title,
    String? content,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? modifiedAt,
    int? colorIndex,
    List<String>? tags,
    List<String>? attachments,
    bool? isLocked,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      colorIndex: colorIndex ?? this.colorIndex,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'colorIndex': colorIndex,
      'isPinned': isPinned,
      'tags': tags,
      'attachments': attachments,
      'isLocked': isLocked,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      modifiedAt: DateTime.parse(map['modifiedAt'] as String),
      colorIndex: map['colorIndex'] as int? ?? 6,
      isPinned: map['isPinned'] as bool? ?? false,
      tags: map['tags'] != null ? List<String>.from(map['tags']) : [],
      attachments: map['attachments'] != null
          ? List<String>.from(map['attachments'])
          : null,
      isLocked: map['isLocked'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          createdAt == other.createdAt &&
          modifiedAt == other.modifiedAt &&
          colorIndex == other.colorIndex &&
          isPinned == other.isPinned &&
          listEquals(tags, other.tags) &&
          listEquals(attachments, other.attachments) &&
          isLocked == other.isLocked;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      createdAt.hashCode ^
      modifiedAt.hashCode ^
      colorIndex.hashCode ^
      isPinned.hashCode ^
      tags.hashCode ^
      attachments.hashCode ^
      isLocked.hashCode;

  String get preview {
    if (content.isEmpty) return '';
    return content.length > 100 ? '${content.substring(0, 100)}...' : content;
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(modifiedAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${modifiedAt.day}/${modifiedAt.month}/${modifiedAt.year}';
    }
  }
}
