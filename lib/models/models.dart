import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class Notes {
  Notes({
    required this.category,
    required this.colorAlpha,
    required this.day,
    required this.description,
    required this.done,
    required this.hour,
    required this.id,
    required this.minute,
    required this.month,
    required this.title,
    required this.weekDay,
    required this.year,
    required this.colorRed,
    required this.colorBlue,
    required this.colorGreen,
  });

  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  int? colorAlpha;
  @HiveField(4)
  String? category;
  @HiveField(5)
  bool? done;

  // time
  @HiveField(6)
  int? day;
  @HiveField(7)
  int? month;
  @HiveField(8)
  int? year;
  @HiveField(9)
  int? hour;
  @HiveField(10)
  int? minute;
  @HiveField(11)
  int? weekDay;
  @HiveField(12)
  int? colorRed;
  @HiveField(13)
  int? colorGreen;
  @HiveField(14)
  int? colorBlue;
}

@HiveType(typeId: 1)
class Categories {
  Categories({
    required this.name,
  });

  @HiveField(0)
  String? name;
}
