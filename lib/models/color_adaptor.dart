import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = 1; // Choose a unique typeId for ColorAdapter

  @override
  Color read(BinaryReader reader) {
    final intValue = reader.readUint32();
    return Color(intValue);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeUint32(obj.value);
  }
}
