import 'package:cloud_firestore/cloud_firestore.dart';

class Listen {
  final String? userId;
  final String? trackId;

  Listen({
    this.userId,
    this.trackId,
  });

  factory Listen.fromDoc(DocumentSnapshot doc) {
    // logger.i(doc);
    return Listen(
      userId: doc['userId'],
      trackId: doc['trackId'],
    );
  }
}
