import 'package:flutter/foundation.dart';

class Banner {
  final int userId;
  final int id;
  final String title;
  final String image;

  Banner({
    required this.userId,
    required this.id,
    required this.title,
    required this.image,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
    );
  }
}
