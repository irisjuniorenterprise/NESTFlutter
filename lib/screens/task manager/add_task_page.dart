import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../themes/design_course_app_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/input_field.dart';
import 'package:http/http.dart' as http;
import '../profile_screen.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = '9:00 PM';
  int selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    30,
    60,
  ];
  String selectedRepeat = 'Never';
  List<String> repeatList = [
    'Never',
    'Daily',
    'Weekly',
    'Monthly',
  ];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Add Task',
                    style: headingStyle,
                  ),
                  InputField(title: 'Title', hint: 'Enter your title', controller: _titleController),
                  InputField(title: 'Note', hint: 'Enter your note', controller: _noteController),
                  InputField(
                      title: 'Date',
                      hint: DateFormat.yMd().format(_selectedDate),
                    widget: IconButton(
                        onPressed: () {
                          print('date');
                          _getDateFromUser();
                        },
                        icon: const Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                  Row(
                    children: [
                        Expanded(
                          child: InputField(
                            title: 'Start Time',
                            hint: _startTime,
                            widget: IconButton(
                              onPressed: () {
                                print('time');
                                _getTimeFromUser(isStartTime: true);
                              },
                              icon: const Icon(Icons.access_time_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InputField(
                            title: 'End Time',
                            hint: _endTime,
                            widget: IconButton(
                              onPressed: () {
                                _getTimeFromUser(isStartTime: false);
                              },
                              icon: const Icon(Icons.access_time_outlined),
                            ),
                          ),
                        ),
                    ],
                  ),
                    InputField(
                    title: 'Remind',
                    hint: '$selectedRemind minutes before',
                    widget: DropdownButton(
                      value: selectedRemind,
                      items: remindList.map((int value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList(),
                      underline: Container(width: 0,),
                      onChanged: (int? value) {
                        setState(() {
                          selectedRemind = value!;
                        });
                      },
                    ),
                  ),
                  InputField(
                    title: 'Repeat',
                    hint: selectedRepeat=='Never'? 'Do Not Repeat' :'Repeat $selectedRepeat',
                    widget: DropdownButton(
                      value: selectedRepeat,
                      items: repeatList.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      underline: Container(width: 0,),
                      onChanged: (String? value) {
                        setState(() {
                          selectedRepeat = value!;
                        });
                      },
                    ),
                  ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPalette(),
                    Button(label: 'Create Task', onTap: (){
                      Get.snackbar('Create Action', 'Creating Your Task!',
                        duration: const Duration(seconds: 2),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.white,
                        colorText: DesignCourseAppTheme.IrisBlue,
                        icon: const Icon(Icons.delete_outline_rounded, color: DesignCourseAppTheme.IrisBlue,),
                      );
                      _validateTaskForm();
                      //Get.to(mainPageTask());
                     // Navigator.of(context).push(new MaterialPageRoute(
                       //   builder: (context) => mainPageTask())).whenComplete(_validateTaskForm);
                      Navigator.of(context).pop(MaterialPageRoute(builder: (context) => ProfileScreen()));
                    }),
                  ],
                ),
          ]),
        ),
      ),
    );
  }


  _validateTaskForm() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addNewTask();
      Get.snackbar('Create Action', 'Your Task Created Successfully!',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: DesignCourseAppTheme.IrisBlue,
        icon: const Icon(Icons.delete_outline_rounded, color: DesignCourseAppTheme.IrisBlue,),
      );
    }
    if (_titleController.text.isEmpty) {
      Get.snackbar('Required', 'Title field is required',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
        colorText: Colors.pink,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.pink,),
      );
    } else if (_noteController.text.isEmpty) {
      Get.snackbar('Required', 'Note field is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.pink,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.pink,),
      );
    }
  }

  _addNewTask() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final body = jsonEncode({
      'title': _titleController.text,
      'note': _noteController.text,
      'date': _selectedDate.toString().split('.')[0],
      'startTime': _startTime,
      'endTime': _endTime,
      'remind': selectedRemind,
      'repetition': selectedRepeat,
      'color': _selectedColor,
      'eagleId': preferences.getInt('eagleId'),
    });
    final url = Uri.parse('https://api.irisje.tn/api/task/add');
    final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
        body: body
    );
    final responseData = json.decode(response.body);
    print(responseData);
  }
  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color',
          style: titleStyle,
        ),
        const SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(
            3,
                (int index){
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index==0? Colors.red : index==1? Colors.green : Colors.blue,
                    child: Icon(
                      Icons.done,
                      color: _selectedColor==index? Colors.white : Colors.transparent,
                      size: 16,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
  _appBar() {
    return AppBar(
      elevation: 25,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
      ),
      backgroundColor: DesignCourseAppTheme.IrisBlue,
      title: Center(child: const Text('Add Task')),
    );
  }

  _getDateFromUser() async {
    DateTime? _datePicker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2222),
    );

    if (_datePicker != null) {
      setState(() {
        _selectedDate = _datePicker;
      });
    } else {
      print('Date should not be null');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print('Time should not be null');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formattedTime;
        print(_startTime);
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker() async {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(':')[0]),
          minute: int.parse(_startTime.split(':')[1].split(' ')[0])),
    );
  }
}
