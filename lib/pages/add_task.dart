import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:task/boxes.dart';
import 'package:task/const.dart';
import 'package:task/model/model.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final List dropList = ["Work", "Home", "No List"];
  List<DropdownMenuItem<String>> dropDownCat = [];
  String selectedCat = "";
  bool addTask = false;
  String title = '';
  DateTime selectedDate = DateTime.now();
  String dateSel = "";
  String note = '';
  List<String> subTaskList = [];

  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController subTaskController = TextEditingController();

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

  Future add(
      {required String title,
      required String category,
      required String date,
      required bool status,
      required List<String> subList,
      required String notes}) async {
    final task = TaskModel()
      ..title = title
      ..category = category
      ..date = date
      ..isComplete = status
      ..note = notes;
    // ..subTaskList = subList;

    final box = Boxes.getTransactions();
    box.add(task);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    noteController.dispose();
    titleController.dispose();
    subTaskController.dispose();

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
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: kSecondry,
                        borderRadius: BorderRadius.circular(12)),
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
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
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
                  onChanged: (val) {
                    note = val;
                  },
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
                        controller: subTaskController,
                        // onChanged: (val) => subTaskList!.add(val),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          suffix: IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              subTaskList.add(subTaskController.text);
                              subTaskController.clear();
                              FocusScope.of(context).unfocus();
                              setState(() {});
                            },
                          ),
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
                        "Cancel",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      dateSel = dateController.text;

                      add(
                          title: title,
                          category: selectedCat,
                          date: dateSel,
                          notes: note,
                          status: false,
                          subList: subTaskList);
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
