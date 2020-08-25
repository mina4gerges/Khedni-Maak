import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:khedni_maak/test_widgets/posts_model.dart';

class HttpService {
  final String baseUrl;

  HttpService({@required this.baseUrl});

  Future<List<Post>> getPosts() async {
    Response res = await get(baseUrl);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Post> posts = body
          .map(
            (dynamic item) => Post.fromJson(item),
          )
          .toList();

      return posts;
    } else {
      throw "Can't get posts.";
    }
  }

  Future<void> deletePost(int id) async {
    Response res = await delete("$baseUrl/$id");

    if (res.statusCode == 200) {
      print("DELETED");
    } else {
      throw "Can't delete post.";
    }
  }
}
