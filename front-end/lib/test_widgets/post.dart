import 'package:flutter/material.dart';
import 'package:khedni_maak/http_requests/http_service.dart';
import 'package:khedni_maak/test_widgets/posts_model.dart';

class PostsPage extends StatelessWidget {
  final HttpService httpService = HttpService(baseUrl: 'localhost:5000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Introduction screens"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await httpService.deletePost(2);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: httpService.getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasData) {
            List<Post> posts = snapshot.data;
            return ListView(
              children: posts
                  .map(
                    (Post post) => ListTile(
                        title: Text(post.title), subtitle: Text("${post.body}")),
                  )
                  .toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
