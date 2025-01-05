import 'package:boxify/app_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:app_core/app_core.dart';  //

class Rating {
  Rating({this.userId, this.trackUuid, this.value, this.updated});
  final String? userId;
  final String? trackUuid;
  double? value;
  final DateTime? updated;

  // copywith
  Rating copyWith({
    String? userId,
    String? trackUuid,
    double? value,
    DateTime? updated,
  }) {
    return Rating(
      userId: userId ?? this.userId,
      trackUuid: trackUuid ?? this.trackUuid,
      value: value ?? this.value,
      updated: updated ?? this.updated,
    );
  }

  static Future<Rating?> fromDoc(DocumentSnapshot doc) async {
    var trackUuid;

    if (!doc.exists) {
      // Document does not exist
      logger.e("Document does not exist");
    } else {
      try {
        trackUuid = doc.get('trackUuid');
        if (trackUuid == null || trackUuid.isEmpty) {
          logger.e("The field trackUuid is either null or empty");
          logger.e(doc.data().toString());
          return null; // Early return if trackUuid is critical and missing
        }
      } catch (e) {
        // The 'trackUuid' field does not exist
        logger.e(e.toString());
        return null; // Early return if trackUuid is critical and missing
      }
    }

    return Rating(
      userId: doc['userId'],
      trackUuid: trackUuid,
      value: doc['value'].toDouble(),
      updated: doc['updated'] != null
          ? (doc['updated'] as Timestamp).toDate()
          : null,
    );
  }

// Create a Rating instance from a JSON object
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      userId: json['userId'],
      trackUuid: json['trackUuid'],
      value: json['value'] != null ? json['value'].toDouble() : null,
      updated: json['updated'] != null
          ? DateTime.parse(json['updated'])
          // Alternatively, if storing milliseconds since epoch
          // ? DateTime.fromMillisecondsSinceEpoch(json['updated'])
          : null,
    );
  }

// Convert the Rating instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'trackUuid': trackUuid,
      'value': value,
      // Convert DateTime to a string or milliseconds since epoch
      'updated': updated?.toIso8601String(),
      // Alternatively, use milliseconds since epoch
      // 'updated': updated?.millisecondsSinceEpoch,
    };
  }
}
