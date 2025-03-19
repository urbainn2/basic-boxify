// import 'package:app_core/app_core.dart';  //
import 'package:boxify/app_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Bundle extends Equatable {
  final String? id;
  final String? revenueCatId;
  final String? link;
  final String? downloadLink;
  final String? directory;
  final DateTime? date;
  final String? image;
  final String? title;
  final String? preview;
  final String? description;
  final String? songList;
  final int? length;
  final String? localpath;
  final String? years;
  final int? sortOrder;
  final bool? available;
  final bool? isNew;
  final String? priceString;
  int? count;
  final String? category;

  Bundle({
    this.id,
    this.revenueCatId,
    this.link,
    this.downloadLink,
    this.directory,
    this.date,
    this.title,
    this.preview,
    this.description,
    this.songList,
    this.image,
    this.length,
    this.localpath,
    this.years,
    this.sortOrder,
    this.available,
    this.isNew,
    this.priceString,
    this.count,
    this.category,
  });

  @override
  List<Object?> get props => [
        revenueCatId,
        image,
        link,
        downloadLink,
        date,
        title,
        preview,
        description,
        directory,
        image,
        songList,
        length,
        localpath,
        years,
        sortOrder,
        available,
        isNew,
        priceString,
        count,
        category,
      ];

  static Future<Bundle> fromDocument(DocumentSnapshot doc) async {
    final data = doc.data()! as Map<String, dynamic>;
    final imageUrl = Utils.getUrlFromData(data, 'image');

    return Bundle(
      id: doc.id,
      revenueCatId: data['revenue_cat_id'] as String?,
      image: imageUrl,
      title: data['title'] as String?,
      preview: data['preview'] as String?,
      description: data['description'] as String?,
      songList: data['song_list'] as String?,
      length: data['length'] as int?, //?? 0,
      years: data['years'] as String?, //?? '2000-test',
      available: data['available'] as bool?, // ?? false,
      isNew: data['new'] as bool?, // ?? false,
      priceString: data['price_string'] as String?, //?? '0',
      count: data['count'] as int?, // ?? 0,
      category: data['category'] as String?,
    );
  }

  // static Future<Bundle> fromDocument(DocumentSnapshot doc) async {
  //   // logger.i('Bundle fromDocument');

  //   final data = doc.data()! as Map<String, dynamic>;
  //   final imageUrl = Utils.getUrlFromData(data, 'image');

  //   return Bundle(
  //     id: doc.id,
  //     revenueCatId: data['revenue_cat_id'] as String,
  //     image: imageUrl,
  //     title: data['title'] as String,
  //     preview: data['preview'] as String,
  //     description: data['description'] as String,
  //     songList: data['songList'] as String,
  //     length: data['length'] as int, //?? 0,
  //     years: data['years'] as String, //?? '2000-test',
  //     available: data['available'] as bool, // ?? false,
  //     isNew: data['new'] as bool, // ?? false,
  //     priceString: data['price_string'] as String, //?? '0',
  //     count: data['count'] as int, // ?? 0,
  //     category: data['category'] as String,
  //   );
  // }

  static Bundle empty = Bundle(
    description: '',
  );

  /// This is the one you use in the android market
  static Bundle fromJson(dynamic data) {
    final imageUrl = Utils.getUrlFromData(data, 'image');

    return Bundle(
      id: data["id"] as String?,
      revenueCatId: data["revenue_cat_id"] as String?,
      image: imageUrl,
      title: data['title'] as String? ?? '',
      preview: data['preview'] as String? ?? '',
      description: data['description'] as String? ?? '',
      songList: data['song_list'] as String? ?? '',
      length: data['length'] as int? ?? 0,
      years: data['years'] as String? ?? '2000-test',
      available: data['available'] as bool? ?? false,
      isNew: data['new'] as bool? ?? false,
      priceString: data['price_string'] as String? ?? '0',
      count: data['count'] as int? ?? 0,
      category: data['category'] as String? ?? '',
    );
  }

  // /// This is the one you use in the android market
  // static Bundle fromJson(dynamic data) {
  //   // logger.idata["song_list"]);

  //   final imageUrl = Utils.getUrlFromData(data, 'image');

  //   return Bundle(
  //     id: data["id"],
  //     revenueCatId: data["revenue_cat_id"],
  //     image: imageUrl,
  //     title: (data['title'] ?? ''),
  //     preview: (data['preview'] ?? ''),
  //     description: (data['description'] ?? ''),
  //     songList: (data['song_list'] ?? ''),
  //     length: (data['length'] ?? 0),
  //     // localpath: (data['localpath'] ?? ''),
  //     years: (data['years'] ?? '2000-test'),
  //     // sortOrder: (data['sortOrder'] ?? 100),
  //     available: (data['available'] ?? false),
  //     isNew: (data['new'] ?? false),
  //     priceString: (data['price_string'] ?? 0),
  //     count: (data['count'] ?? 0),
  //     category: (data['category'] ?? ''),
  //   );
  // }

  // Used for saving cache
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'revenue_cat_id': revenueCatId,
      'image': image,
      'title': title,
      'preview': preview,
      'description': description,
      'song_list': songList,
      'length': length,
      'years': years,
      'available': available,
      'new': isNew,
      'price_string': priceString,
      'count': count,
      'category': category,
    };
  }

  Bundle copyWith({
    String? id, // Add this for each property in your class
    String? revenueCatId,
    String? link,
    String? downloadLink,
    String? directory,
    DateTime? date,
    String? image,
    String? title,
    String? preview,
    String? description,
    String? songList,
    int? length,
    String? localpath,
    String? years,
    int? sortOrder,
    bool? available,
    bool? isNew,
    String? priceString,
    int? count,
    String? category,
  }) {
    return Bundle(
      id: id ?? this.id, // Repeat this pattern for each property
      revenueCatId: revenueCatId ?? this.revenueCatId,
      link: link ?? this.link,
      downloadLink: downloadLink ?? this.downloadLink,
      directory: directory ?? this.directory,
      date: date ?? this.date,
      image: image ?? this.image,
      title: title ?? this.title,
      preview: preview ?? this.preview,
      description: description ?? this.description,
      songList: songList ?? this.songList,
      length: length ?? this.length,
      localpath: localpath ?? this.localpath,
      years: years ?? this.years,
      sortOrder: sortOrder ?? this.sortOrder,
      available: available ?? this.available,
      isNew: isNew ?? this.isNew,
      priceString: priceString ?? this.priceString,
      count: count ?? this.count,
      category: category ?? this.category,
    );
  }
}
