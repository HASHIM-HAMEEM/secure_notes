import 'package:flutter/foundation.dart';

class Note {
  final int? id;
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

  Note copy({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? modifiedAt,
    int? colorIndex,
    bool? isPinned,
    List<String>? tags,
    List<String>? attachments,
    bool? isLocked,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt,
        colorIndex: colorIndex ?? this.colorIndex,
        isPinned: isPinned ?? this.isPinned,
        tags: tags ?? this.tags,
        attachments: attachments ?? this.attachments,
        isLocked: isLocked ?? this.isLocked,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'modified_at': modifiedAt.toIso8601String(),
      'color_index': colorIndex,
      'is_pinned': isPinned ? 1 : 0,
      'tags': tags.join(','),
      'attachments': attachments?.join(','),
      'is_locked': isLocked ? 1 : 0,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      modifiedAt: DateTime.parse(map['modified_at'] as String),
      colorIndex: map['color_index'] as int? ?? 6,
      isPinned: (map['is_pinned'] as int?) == 1,
      tags: map['tags'] != null && map['tags'].toString().isNotEmpty
          ? (map['tags'] as String).split(',')
          : [],
      attachments:
          map['attachments'] != null && map['attachments'].toString().isNotEmpty
              ? (map['attachments'] as String).split(',')
              : null,
      isLocked: (map['is_locked'] as int?) == 1,
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
