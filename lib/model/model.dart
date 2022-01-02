import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late bool isComplete = false;

  @HiveField(2)
  late String note;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late String date;

  @HiveField(5)
  late String subTask;
}
