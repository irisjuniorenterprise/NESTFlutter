import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../themes/design_course_app_theme.dart';
import '../../services/notification_services.dart';
import 'package:get/get.dart';
import '../../widgets/button.dart';
import '../../widgets/task_tile.dart';
import 'add_task_page.dart';

class mainPageTask extends StatefulWidget {
  const mainPageTask({Key? key}) : super(key: key);

  @override
  State<mainPageTask> createState() => _mainPageTaskState();

}

class _mainPageTaskState extends State<mainPageTask> {
  List tasks = [];
  bool isLoading = true;
DateTime _selectedDate = DateTime.now();
  var notifyHelper;
  @override
  void initState() {
    super.initState();
    /*notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();*/
    this.getTasks();
  }

  getTasks() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getInt('eagleId');
    var url = Uri.parse('https://api.irisje.tn/api/task/get/${id}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('true task');
      var body = response.body;
      var items = jsonDecode(body);
      print(items);
      setState(() {
        tasks = items;
        isLoading = false;
      });
    } else {
      print(response.body);
      tasks = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 25,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        backgroundColor: DesignCourseAppTheme.IrisBlue,
        title: const Center(child: Text('Task Manager')),
      ),
      body: Column(
        children: [
          _addTask(),
          _dateBar(),
          const SizedBox(height: 10),
          _taskList(),
        ],
      ),
    );
  }

  _taskList() {
    return Expanded(
      child:  ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            var startTime = tasks[index]['startTime'].toString().split('T')[1].split(':00+')[0];
            print(tasks[index]['startTime'].toString().split('T')[1].split(':00+')[0]);
            if (tasks[index]['repetition']=='Daily') {
              notifyHelper.scheduledNotification(
                int.parse(startTime.split(':')[0]),
                int.parse(startTime.split(':')[1]),
                tasks[index]['id'],
                tasks[index]['title'],
                tasks[index]['note'],
              );
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(tasks[index]);
                          },
                          child: TaskTile(
                            title: _getTaskTitle(tasks[index]),
                            note: _getTaskNote(tasks[index]),
                            color: _getTaskColor(tasks[index]),
                            isCompleted: _getTaskStatus(tasks[index]),
                            startTime: _getTaskStartTime(tasks[index]),
                            endTime: _getTaskEndTime(tasks[index]),
                            isPersonal: _getTaskPersonal(tasks[index]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }  
            if (DateFormat('yMd').format(DateTime.parse(tasks[index]['date']))==DateFormat('yMd').format(DateTime.parse(_selectedDate.toString()))) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(tasks[index]);
                          },
                          child: TaskTile(
                            title: _getTaskTitle(tasks[index]),
                            note: _getTaskNote(tasks[index]),
                            color: _getTaskColor(tasks[index]),
                            isCompleted: _getTaskStatus(tasks[index]),
                            startTime: _getTaskStartTime(tasks[index]),
                            endTime: _getTaskEndTime(tasks[index]),
                            isPersonal: _getTaskPersonal(tasks[index]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      );
  }

  String _getTaskTitle(index) {
    var title = index['title'];
    return title;
  }
  String _getTaskNote(index) {
    return index['note'];
  }
  String _getTaskColor(index) {
    return index['color'];
  }
  bool _getTaskStatus(index) {
    return index['isCompleted'];
  }
  bool _getTaskPersonal(index) {
    return index['isPersonal'];
  }
  DateTime _getTaskStartTime(index) {
    return DateTime.parse(index['startTime']);
  }
  DateTime _getTaskEndTime(index) {
    return DateTime.parse(index['endTime']);
  }
  _dateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 15),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: DesignCourseAppTheme.IrisBlue,
        selectedTextColor: Colors.white,
        dateTextStyle:  const TextStyle(
            fontSize: 20,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          fontFamily: 'Montserrat',
          ),
        dayTextStyle: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          fontFamily: 'Montserrat',
          ),
        monthTextStyle: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          fontFamily: 'Montserrat',
          ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }
  _addTask() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat().add_yMMMd().format(DateTime.now()),
                      style: subHeadingStyle,
                    ),
                    Text("Today",
                      style: headingStyle,
                    ),
                  ]
              ),
            ),
            Button(label: '+ Add Task', onTap: ()=>Get.to(const AddTaskPage()))
          ]
      ),
    );
  }
  _showBottomSheet(index) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: (index['isCompleted']==false && index['isPersonal']==true)?
        MediaQuery.of(context).size.height * 0.35:
        MediaQuery.of(context).size.height * 0.24,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 5,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 20),
            index['isCompleted']==false?
            _bottomSheetButton(label: 'Mark As Completed', color: DesignCourseAppTheme.IrisBlue, textColor: Colors.white, onTap: ()async{
              Get.back();
              Get.snackbar('Updating Action', 'Marking Your Task As Completed!',
                duration: const Duration(seconds: 2),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.white,
                colorText: DesignCourseAppTheme.IrisBlue,
                icon: const Icon(Icons.delete_outline_rounded, color: DesignCourseAppTheme.IrisBlue,),
              );
              _markAsCompleted(index['id']);
              await getTasks();
            }):
                Container(),
            index['isPersonal']==true?
            _bottomSheetButton(label: 'Delete Task', color: Colors.red, textColor: Colors.white, onTap: ()async{
              Get.back();
              Get.snackbar('Delete Action', 'Deleting Your Task!',
                duration: const Duration(seconds: 2),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.white,
                colorText: DesignCourseAppTheme.IrisBlue,
                icon: const Icon(Icons.delete_outline_rounded, color: DesignCourseAppTheme.IrisBlue,),
              );
              _deleteTask(index['id']);
              await getTasks();
            }) :
            Container(),
            const SizedBox(height: 5),
            _bottomSheetButton(label: 'Close', color: Colors.transparent, textColor: Colors.black, onTap: (){Get.back();}, isClose: true),
          ],
        ),
      ),
    );
  }

  _markAsCompleted(id)async{
    var url = Uri.parse('https://api.irisje.tn/api/task/completed/${id}');
    var response = await http.put(url);
    if (response.statusCode == 200)
    {
      Get.snackbar('Updating Action', 'Task Completed!',
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: DesignCourseAppTheme.IrisBlue,
        icon: const Icon(Icons.done_outlined, color: DesignCourseAppTheme.IrisBlue,),
      );
    }
  }
  _deleteTask(id) async{
    var url = Uri.parse('https://api.irisje.tn/api/task/delete/${id}');
    var response = await http.delete(url);
    if (response.statusCode == 200)
      {
        Get.snackbar('Delete Action', 'Task Deleted!',
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: DesignCourseAppTheme.IrisBlue,
          icon: const Icon(Icons.delete_outline_rounded, color: DesignCourseAppTheme.IrisBlue,),
        );
      }
  }
  _bottomSheetButton({
    required String label,
    required Color color,
    required Color textColor,
    required Function onTap,
    bool isClose=false,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: isClose ? Border.all(color: Colors.grey[400]!) : null,
        ),
        child: Center(
          child: Text(
            label,
            style:  TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
          ),
        ),
      ),
    );
  }
}