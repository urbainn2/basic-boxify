import 'package:boxify/enums/enums.dart';
import 'package:flutter/material.dart';

class MyBadge {
  final String? title;
  final String? description;
  final String? powers;
  final Icon? icon;
  final BadgeType? type;
  final String? oldId;
  final Color? color;

  MyBadge(
      {this.title,
      this.description,
      this.powers,
      this.icon,
      this.type,
      this.oldId,
      this.color});

  static Future<MyBadge> fromDoc(Map doc) async {
    return MyBadge(
      title: doc['title'],
      description: doc['description'],
      powers: doc['powers'],
      icon: doc['icon'],
      type: doc['type'],
      oldId: doc['oldId'],
      color: doc['color'] ?? Colors.blueAccent,
    );
  }
}
