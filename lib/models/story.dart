import 'dart:io';

class Story {
  final String id;
  final String title;
  final String description;
  final File image;
  final String createdAt;
  final String category;
  final String folderId;

  Story({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.category,
    required this.folderId
  });
}
