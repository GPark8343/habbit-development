class IUser {
  String? uid;
  String? nickname;
  String? thumbnail;
  String? description;
  List numberOfReward;
  IUser(
      {this.uid,
      this.nickname,
      this.thumbnail,
      this.description,
      required this.numberOfReward});

  factory IUser.fromJson(Map<String, dynamic> json) {
    return IUser(
      uid: json['uid'] == null ? '' : json['uid'] as String,
      nickname: json['nickname'] == null ? '' : json['nickname'] as String,
      thumbnail: json['thumbnail'] == null ? '' : json['thumbnail'] as String,
      description:
          json['description'] == null ? '' : json['description'] as String,
      numberOfReward: json['number_of_reward'] == null
          ? []
          : json['number_of_reward'] as List,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'thumbnail': thumbnail,
      'description': description,
      'number_of_reward': numberOfReward,
    };
  }

  IUser copyWith({
    String? uid,
    String? nickname,
    String? thumbnail,
    String? description,
    List? numberOfReward,
  }) {
    return IUser(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      numberOfReward: numberOfReward ?? this.numberOfReward,
    );
  }
}
