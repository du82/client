import 'dart:convert';
import 'package:flutter/material.dart';
import '../config/server_config.dart';
import '../models/article.dart';
import 'package:http/http.dart' as http;

class LatestArticlesBloc extends ChangeNotifier {

  int _page = 1;
  int get page => _page;

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  bool _loading = false;
  bool get loading => _loading;

  int _postAmountPerLoad = 10;



  Future fetchData() async {

    var response = WpConfig.blockedCategoryIds.isEmpty
      ? await http.get(Uri.parse("${WpConfig.apiUrl}/wp-json/wp/v2/posts/?page=$_page&per_page=$_postAmountPerLoad&_fields=id,date,title,content,custom,link,tags"))
      : await http.get(Uri.parse("${WpConfig.apiUrl}/wp-json/wp/v2/posts/?page=$_page&per_page=$_postAmountPerLoad&_fields=id,date,title,content,custom,link,tags&categories_exclude=" + WpConfig.blockedCategoryIds));
    if (response.statusCode == 200) {
      List decodedData = jsonDecode(response.body);
      _articles.addAll(decodedData.map((m) => Article.fromJson(m)).toList());
    }
    notifyListeners();
  }



  setLoading (bool value){
    _loading = value;
    notifyListeners();
  }


  pageIncreament (){
    _page += 1;
    notifyListeners();
  }

  onReload () async{
    _articles.clear();
    _page = 1;
    notifyListeners();
    fetchData();
  }


  
}
