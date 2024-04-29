// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotesAdapter extends TypeAdapter<Notes> {
  @override
  final int typeId = 0;

  @override
  Notes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Notes(
      category: fields[4] as String?,
      colorAlpha: fields[3] as int?,
      day: fields[6] as int?,
      description: fields[2] as String?,
      done: fields[5] as bool?,
      hour: fields[9] as int?,
      id: fields[0] as String?,
      minute: fields[10] as int?,
      month: fields[7] as int?,
      title: fields[1] as String?,
      weekDay: fields[11] as int?,
      year: fields[8] as int?,
      colorRed: fields[12] as int?,
      colorBlue: fields[14] as int?,
      colorGreen: fields[13] as int?,
      image: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Notes obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.colorAlpha)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.done)
      ..writeByte(6)
      ..write(obj.day)
      ..writeByte(7)
      ..write(obj.month)
      ..writeByte(8)
      ..write(obj.year)
      ..writeByte(9)
      ..write(obj.hour)
      ..writeByte(10)
      ..write(obj.minute)
      ..writeByte(11)
      ..write(obj.weekDay)
      ..writeByte(12)
      ..write(obj.colorRed)
      ..writeByte(13)
      ..write(obj.colorGreen)
      ..writeByte(14)
      ..write(obj.colorBlue)
      ..writeByte(15)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoriesAdapter extends TypeAdapter<Categories> {
  @override
  final int typeId = 1;

  @override
  Categories read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Categories(
      name: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Categories obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoriesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileDataAdapter extends TypeAdapter<ProfileData> {
  @override
  final int typeId = 2;

  @override
  ProfileData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileData(
      name: fields[0] as String?,
      number: fields[1] as String?,
      image: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
