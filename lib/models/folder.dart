class Folder {
  final String id;
  final String title;
  final String description;
  final String createdAt;
  final String category;
  final int days;

  Folder({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.category,
    required this.days,
  });

  Folder copyWith(
      {String? id,
      String? title,
      String? description,
      String? createdAt,
      String? category,
      int? days}) {
    return Folder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      days: days ?? this.days,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt,
      'category': category,
      'days': days
    };
  }
}
