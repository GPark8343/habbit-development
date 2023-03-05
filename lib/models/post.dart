import 'package:habbit/models/i_user.dart';

class Post {
  final String? title;
  final String? userId;
  final String? thumbnail;
  final String? description;
  final int? likeCount;
  final IUser? userInfo;
  final String? uid;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? category;

  Post({
    this.title,
    this.userId,
    this.thumbnail,
    this.description,
    this.likeCount,
    this.userInfo,
    this.uid,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.category,
  });

  factory Post.init(IUser userInfo) {
    var time = DateTime.now();
    return Post(
      title: '',
      thumbnail: '',
      userInfo: userInfo,
      uid: userInfo.uid,
      description: '',
      createdAt: time,
      updatedAt: time,
      category: '',
    );
  }

  factory Post.fromJson(String docId, Map<String, dynamic> json) {
    return Post(
      title: json['title'] == null ? '' : json['title'] as String,
      userId: json['userId'] == null ? '' : json['userId'] as String,
      thumbnail: json['thumbnail'] == null ? '' : json['thumbnail'] as String,
      description:
          json['description'] == null ? '' : json['description'] as String,
      likeCount: json['likeCount'] == null ? 0 : json['likeCount'] as int,
      userInfo:
          json['userInfo'] == null ? null : IUser.fromJson(json['userInfo']),
      uid: json['uid'] == null ? '' : json['uid'] as String,
      createdAt: json['created_at'] == null
          ? DateTime.now()
          : json['created_at'].toDate(),
      updatedAt: json['updated_at'] == null
          ? DateTime.now()
          : json['updated_at'].toDate(),
      deletedAt:
          json['deleted_at'] == null ? null : json['deleted_at'].toDate(),
      category: json['category'] == null ? '' : json['category'] as String,
    );
  }

  Post copyWith({
    String? title,
    String? userId,
    String? thumbnail,
    String? description,
    int? likeCount,
    IUser? userInfo,
    String? uid,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? category,
  }) {
    return Post(
      title: title ?? this.title,
      userId: userId ?? this.userId,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      likeCount: likeCount ?? this.likeCount,
      userInfo: userInfo ?? this.userInfo,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'userId': userId,
      'thumbnail': thumbnail,
      'description': description,
      'likeCount': likeCount,
      'userInfo': userInfo!.toMap(),
      'uid': uid,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'category': category,
    };
  }
}
