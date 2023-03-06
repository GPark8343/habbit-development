import 'dart:io';

class Story {
  final String id;
  final String title;
  final String description;
  final File image;
  final String createdAt;
  final String category;
  final String folderId;
  final int isUploaded;

  Story({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.category,
    required this.folderId,
    required this.isUploaded
  });

   Story copyWith({
    String? id,
    String? title,
    String? description,
    File? image,
    String? createdAt,
    String? category,
    String? folderId,
    int? isUploaded,
  }) {
    return Story(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      folderId: folderId ?? this.folderId,
      isUploaded: isUploaded ?? this.isUploaded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image.path,
      'created_at': createdAt,
      'category': category,
      'folder_id': folderId,
      'is_uploaded': isUploaded
    };
  }
  Map<String, dynamic> toMapImageUrl(String imageUrl) {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': imageUrl,
      'created_at': createdAt,
      'category': category,
      'folder_id': folderId,
      'is_uploaded': isUploaded
    };
  }
}
