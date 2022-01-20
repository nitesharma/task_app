import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:task/const.dart';
import 'package:task/model/model.dart';

import '../boxes.dart';
import 'add_task.dart';
import 'edit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isComplete = false;
  @override
  void initState() {
    super.initState();
  }

  editStatus(TaskModel taskModel, bool status) {
    taskModel.isComplete = status;
    taskModel.save();
    setState(() {});
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Tasks",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ValueListenableBuilder<Box<TaskModel>>(
        valueListenable: Boxes.getTransactions().listenable(),
        builder: (BuildContext context, box, Widget? child) {
          final tasks = box.values.toList().cast<TaskModel>();

          return (tasks.isNotEmpty)
              ? ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          tasks[index].delete();
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Task Deleted")));
                      },
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.green,
                        child: const Icon(Icons.archive_sharp,
                            color: Colors.white, size: 32),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete,
                            color: Colors.white, size: 32),
                      ),
                      key: ValueKey<int>(tasks.length),
                      child: Container(
                          //  color: kSecondry,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  isComplete = !isComplete;
                                  editStatus(tasks[index], isComplete);
                                  setState(() {});
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: kSecondry),
                                  child: (tasks[index].isComplete)
                                      ? const Icon(Icons.check)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 30),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => EditTask(
                                            task: tasks[index],
                                          )));
                                },
                                child: Text(
                                  tasks[index].title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: (tasks[index].isComplete)
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    );
                  },
                )
              : Center(
                  child: LottieBuilder.network(
                    'https://assets7.lottiefiles.com/packages/lf20_mf5j5kua.json',
                    // fit: BoxFit.cover,
                  ),
                  // child: Text("No Task"),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AddTask()));
        },
        backgroundColor: kSecondry,
        elevation: 4,
        splashColor: kpink,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
