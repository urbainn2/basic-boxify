// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackAdapter extends TypeAdapter<Track> {
  @override
  final int typeId = 0;

  @override
  Track read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Track(
      databaseId: fields[0] as String?,
      uuid: fields[1] as String?,
      bundleName: fields[4] as String?,
      link: fields[2] as String?,
      downloadedUrl: fields[3] as String?,
      title: fields[11] as String?,
      displayTitle: fields[12] as String,
      artist: fields[5] as String?,
      userId: fields[8] as String?,
      username: fields[9] as String?,
      primarySortValue: fields[10] as String?,
      imageUrl: fields[6] as String?,
      imageFilename: fields[7] as String?,
      lyrics: fields[15] as String?,
      sequence: fields[13] as int?,
      length: fields[14] as int?,
      localpath: fields[16] as String?,
      year: fields[17] as int?,
      bpm: fields[18] as double?,
      newRelease: fields[19] as bool?,
      available: fields[20] as bool?,
      explicit: fields[21] as bool?,
      album: fields[22] as String?,
      folder: fields[23] as String?,
      privateReleaseDate: fields[24] as String?,
      isRateable: fields[25] as bool,
      bundleId: fields[26] as String?,
      finalSongTitle: fields[27] as String?,
      fanRating: fields[28] as double?,
      fanRatingCount: fields[29] as int?,
      userRating: fields[30] as double?,
      backgroundColor: fields[31] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, Track obj) {
    writer
      ..writeByte(32)
      ..writeByte(0)
      ..write(obj.databaseId)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.link)
      ..writeByte(3)
      ..write(obj.downloadedUrl)
      ..writeByte(4)
      ..write(obj.bundleName)
      ..writeByte(5)
      ..write(obj.artist)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.imageFilename)
      ..writeByte(8)
      ..write(obj.userId)
      ..writeByte(9)
      ..write(obj.username)
      ..writeByte(10)
      ..write(obj.primarySortValue)
      ..writeByte(11)
      ..write(obj.title)
      ..writeByte(12)
      ..write(obj.displayTitle)
      ..writeByte(13)
      ..write(obj.sequence)
      ..writeByte(14)
      ..write(obj.length)
      ..writeByte(15)
      ..write(obj.lyrics)
      ..writeByte(16)
      ..write(obj.localpath)
      ..writeByte(17)
      ..write(obj.year)
      ..writeByte(18)
      ..write(obj.bpm)
      ..writeByte(19)
      ..write(obj.newRelease)
      ..writeByte(20)
      ..write(obj.available)
      ..writeByte(21)
      ..write(obj.explicit)
      ..writeByte(22)
      ..write(obj.album)
      ..writeByte(23)
      ..write(obj.folder)
      ..writeByte(24)
      ..write(obj.privateReleaseDate)
      ..writeByte(25)
      ..write(obj.isRateable)
      ..writeByte(26)
      ..write(obj.bundleId)
      ..writeByte(27)
      ..write(obj.finalSongTitle)
      ..writeByte(28)
      ..write(obj.fanRating)
      ..writeByte(29)
      ..write(obj.fanRatingCount)
      ..writeByte(30)
      ..write(obj.userRating)
      ..writeByte(31)
      ..write(obj.backgroundColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
