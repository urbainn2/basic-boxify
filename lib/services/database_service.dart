// import 'package:sqflite/sqflite.dart';

// class DatabaseService {
//   late Database db;

//   Future<void> initializeDb() async {
//     db = await openDatabase(
//       'my_database.db',
//       onCreate: (db, version) {
//         // If the table does not exist, create a table for tracks with a downloaded column
//         return db.execute(
//           'CREATE TABLE tracks(id TEXT PRIMARY KEY, downloaded INTEGER)',
//         );
//       },
//       version: 1,
//     );
//   }

//   Future<void> markTrackAsDownloaded(String trackId) async {
//     await db.insert(
//       'tracks',
//       {'id': trackId, 'downloaded': 1},
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<bool> isTrackDownloaded(String trackId) async {
//     final List<Map<String, dynamic>> maps = await db.query(
//       'tracks',
//       columns: ['downloaded'],
//       where: 'id = ?',
//       whereArgs: [trackId],
//     );

//     if (maps.isNotEmpty) {
//       // Assume 0 is not downloaded, 1 is downloaded
//       return maps.first['downloaded'] == 1;
//     }
//     return false;
//   }
// }
