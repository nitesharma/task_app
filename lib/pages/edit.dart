import 'package:flutter/material.dart';
import 'package:task/model/model.dart';

import '../const.dart';

class EditTask extends StatefulWidget {
  const EditTask({Key? key, required this.task}) : super(key: key);

  final TaskModel task;

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final List dropList = ["Work", "Home"];
  List<DropdownMenuItem<String>> dropDownCat = [];
  TextEditingController? titleController;
  TextEditingController dateController = TextEditingController();
  TextEditingController? noteController;

  String selectedCat = "";
  bool addTask = false;
  String title = '';
  DateTime selectedDate = DateTime.now();
  String dateSel = "";
  int catIndex = 0;
  late bool isComplete;
  List<String> subTaskList = [];
  String note = "";

  convertMonth(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "August";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "";
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var month = convertMonth(selectedDate.month);

        dateController.text = "$month ${selectedDate.day} ${selectedDate.year}";
      });
    }
  }

  DropdownMenuItem<String> buildCityItems(String item) => DropdownMenuItem(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: (item == 'Work') ? Colors.blue : Colors.red),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              item,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        value: item,
      );

  editStatus(TaskModel taskModel, bool status) {
    taskModel.isComplete = status;
    taskModel.save();
    setState(() {});
  }

  getTasks() {
    titleController = TextEditingController(text: widget.task.title);
    for (int i = 0; i < dropList.length; i++) {
      if (widget.task.category == dropList[i]) {
        catIndex = i;
        selectedCat = dropList[i];
      }
    }
    isComplete = widget.task.isComplete;
    dateController.text = widget.task.date;

    noteController = TextEditingController(text: widget.task.note);
    // subTaskList = widget.task.subTaskList;
  }

  void deleteTask(TaskModel taskModel) {
    taskModel.delete();
  }

  void editTask({
    required TaskModel taskModel,
    required String title,
    required String date,
    required String category,
    required String notes,
    required List<String> subtask,
  }) {
    taskModel.title = title;
    taskModel.category = category;
    taskModel.date = date;
    taskModel.note = notes;
    // taskModel.subTaskList = subtask;
    taskModel.save();
  }

  @override
  void initState() {
    getTasks();
    super.initState();
  }

  @override
  void dispose() {
    titleController!.dispose();
    noteController!.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.cancel_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      isComplete = !isComplete;
                      editStatus(widget.task, isComplete);
                      setState(() {});
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: kSecondry,
                          borderRadius: BorderRadius.circular(12)),
                      child: (widget.task.isComplete)
                          ? const Icon(Icons.check)
                          : null,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kSecondry,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: MediaQuery.of(context).size.width - 100,
                    child: TextFormField(
                      controller: titleController,
                      onChanged: (val) {
                        title = val;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Task title',
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        decoration: (widget.task.isComplete)
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.22,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: kSecondry,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: kSecondry,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                offset: const Offset(-6.0, -6.0),
                                blurRadius: 16.0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(6.0, 6.0),
                                blurRadius: 16.0,
                              ),
                            ],
                          ),
                          width: 120,
                          // height: 60,

                          child: DropdownButtonFormField(
                              value: dropList[catIndex],
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: InputBorder.none,
                              ),
                              items: dropList
                                  .map((e) => buildCityItems(e))
                                  .toList(),
                              onChanged: (val) {
                                selectedCat = val.toString();
                              }),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Due Date",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 14),
                          decoration: BoxDecoration(
                            color: kSecondry,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                offset: const Offset(-6.0, -6.0),
                                blurRadius: 16.0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(6.0, 6.0),
                                blurRadius: 16.0,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          width: 120,
                          // height: 60,

                          child: TextFormField(
                            onTap: () {
                              _selectDate(context);
                              setState(() {});
                            },
                            controller: dateController,
                            // initialValue: selectedDate.toString(),
                            readOnly: true,
                            onChanged: (val) {
                              dateSel = val;
                            },
                            keyboardType: TextInputType.none,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Select a date'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: kpink,
                ),
                child: TextFormField(
                  controller: noteController,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabled: true,
                      hintText: "Write a note...",
                      hintStyle: TextStyle(color: Colors.orange)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              (subTaskList.isNotEmpty)
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height*0.02,
                      child: ListView.builder(
                        shrinkWrap: true,
                        // scrollDirection: A,
                        itemCount: subTaskList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: kSecondry),
                                  ),
                                  const SizedBox(width: 30),
                                  Text(
                                    subTaskList[index],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ));
                        },
                      ),
                    )
                  : const SizedBox(),
              (addTask)
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          suffix: const Icon(Icons.check),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        addTask = !addTask;
                        setState(() {});
                      },
                      child: (addTask)
                          ? const Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : const Text(
                              "+ Add a subtask",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              // Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      deleteTask(widget.task);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: kpink,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (title.isEmpty) {
                        title = titleController!.text;
                      }
                      if (dateSel.isEmpty) {
                        dateSel = dateController.text;
                      }
                      if (note.isEmpty) {
                        note = noteController!.text;
                      }

                      editTask(
                        taskModel: widget.task,
                        title: title,
                        date: dateSel,
                        category: selectedCat,
                        notes: note,
                        subtask: subTaskList,
                      );
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: kSecondry,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
