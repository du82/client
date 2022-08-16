import 'package:easy_localization/easy_localization.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wordpress_app/config/server_config.dart';

class Article {
  final int? id;
  final String? title;
  final String? content;
  final String? excerpt;
  final String? image;
  final String? video;
  final String? author;
  final String? avatar;
  final String? category;
  final String? date;
  final String? timeAgo;
  final String? link;
  final String? type;
  final int? catId;
  final List? tags;

  Article(
      {this.id,
      this.title,
      this.content,
      this.excerpt,
      this.image,
      this.video,
      this.author,
      this.avatar,
      this.category,
      this.date,
      this.timeAgo,
      this.link,
      this.type,
      this.catId,
      this.tags});


  factory Article.fromJson(Map<String, dynamic> json){
    return Article(
      id: json['id'] ?? 0,
      title: json['title']['rendered'] ?? '',
      content: json['content']['rendered'] ?? '',
      excerpt: json['content']['rendered'] ?? '',
      image: json['custom']["featured_image"] != ""
        ? json['custom']["featured_image"]
        : WpConfig.randomPostFeatureImage,
      video: json['custom']['td_video'] ?? '',
      author: json['custom']['author']['name'] ?? '',
      avatar: json['custom']['author']['avatar'] ?? 'https://icon-library.com/images/avatar-icon/avatar-icon-27.jpg',
      date: DateFormat('dd MMMM, yyyy', 'en_US')
        .format(DateTime.parse(json["date"]))
        .toString(),
      timeAgo: Jiffy(json['date']).fromNow(),
      link: json['link'] ?? 'empty',
      type: json['type'] ?? 'empty',
      category: json["custom"]["categories"][0]["name"] ?? '',
      catId: json["custom"]["categories"][0]["cat_ID"] ?? 0,
      tags: json['tags']

    );
  }
}