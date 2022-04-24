import 'dart:convert';
import 'dart:io';
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/comment.dart';
import 'package:http/http.dart' as http;


class TenwanService {


  // Future<List<Article>?> fetchPostsByCategoryId(int categoryId, int contentAmount) async {
  //   final int _page = 1;
  //   List<Article>? _articles;
  //   var response = await http.get(Uri.parse(
  //       "${WpConfig.websiteUrl}/wp-json/wp/v2/posts/?categories[]=$categoryId&page=$_page&per_page=$contentAmount&_fields=id,date,title,content,custom,link,tags"));
  //   List? decodedData = jsonDecode(response.body);

  //   if (response.statusCode == 200) {
  //     _articles = decodedData!.map((m) => Article.fromJson(m)).toList();
  //   }
  //   return _articles;
  // }


  Future fetchPostsByCategoryIdExceptPostId(int? postId, int? catId, int contentAmount) async {
    var response = await http.get(Uri.parse(
        "${WpConfig.websiteUrl}/wp-json/wp/v2/posts?exclude=$postId&categories[]=$catId&per_page=$contentAmount"));
    List? decodedData = jsonDecode(response.body);
    List<Article>? articles;

    if (response.statusCode == 200) {
      articles = decodedData!.map((m) => Article.fromJson(m)).toList();
    }
    return articles;
  }

  // Future fetchPopularPosts(int postLimit) async {
  //   var response = await http.get(Uri.parse("${WpConfig.websiteUrl}/wp-json/wordpress-popular-posts/v1/popular-posts?limit=$postLimit"));
  //   List? decodedData = jsonDecode(response.body);
  //   List<Article>? articles;

  //   if (response.statusCode == 200) {
  //     articles = decodedData!.map((m) => Article.fromJson(m)).toList();
  //   }
  //   return articles;
  // }


  Future fetchPostsBySearch(String searchText) async {
    var response = WpConfig.blockedCategoryIds.isEmpty
     ? await http.get(Uri.parse("${WpConfig.websiteUrl}/wp-json/wp/v2/posts?per_page=30&search=$searchText"))
     : await http.get(Uri.parse("${WpConfig.websiteUrl}/wp-json/wp/v2/posts?per_page=30&search=$searchText&categories_exclude=" + WpConfig.blockedCategoryIds));
    List? decodedData = jsonDecode(response.body);
    List<Article>? articles;

    if (response.statusCode == 200) {
      articles = decodedData!.map((m) => Article.fromJson(m)).toList();
    }
    return articles;
  }



  Future fetchCommentsById(int? id) async {
    List<CommentModel> _comments = [];
    var response = await http.get(Uri.parse("${WpConfig.websiteUrl}/wp-json/wp/v2/comments?per_page=100&post=" + id.toString()));
    List? decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      _comments = decodedData!.map((m) => CommentModel.fromJson(m)).toList();
    }
    return _comments;
  }



  

  Future<bool> postComment(
    int? id, String? name, String email, String comment) async {
    try {
      var response = await http.post(Uri.parse("${WpConfig.websiteUrl}/wp-json/wp/v2/comments"), body: {
        "author_email": email.trim().toLowerCase(),
        "author_name": name,
        "content": comment,
        "post": id.toString()
      });

      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to post comment');
    }
  }


  Future<bool> deleteCommentById (String? _urlHeader, int? id) async {
    final StringBuffer url = new StringBuffer(WpConfig.websiteUrl + '/wp-json/wp/v2/comments' + '/$id');
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.deleteUrl(Uri.parse(url.toString()));
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    request.headers.set(HttpHeaders.acceptHeader, "application/json");
    request.headers.set('Authorization', "$_urlHeader");
    HttpClientResponse response = await request.close();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateCommentById (String? _urlHeader, int? id, String comment) async {
    final StringBuffer url = new StringBuffer(WpConfig.websiteUrl + '/wp-json/wp/v2/comments' + '/$id');
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url.toString()));
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    request.headers.set(HttpHeaders.acceptHeader, "application/json");
    request.headers.set('Authorization', "$_urlHeader");
    request.add(utf8.encode(json.encode({
      "content": comment,
    })));
    HttpClientResponse response = await request.close();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }
}
