// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dailystat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyStatAdapter extends TypeAdapter<DailyStat> {
  @override
  final int typeId = 1;

  @override
  DailyStat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyStat(
      date: fields[0] as String,
      count: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyStat obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyStatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
