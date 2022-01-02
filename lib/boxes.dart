import 'package:hive/hive.dart';
import 'package:task/model/model.dart';

class Boxes {
  static Box<TaskModel> getTransactions() => Hive.box<TaskModel>('task');
}
