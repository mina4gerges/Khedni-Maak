import 'package:flutter/foundation.dart';

class Post {
  final int id;
  final String title;
  final String body;
  final String image;

  Post({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.image,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      image: json['image'] as String,
    );
  }
}
