import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:intl/intl.dart';
import 'package:iris_nest_app/widgets/icon_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../themes/design_course_app_theme.dart';

class BlameScreen extends StatefulWidget {
  @override
  _BlameScreenState createState() => _BlameScreenState();
}

class _BlameScreenState extends State<BlameScreen> {
  List blames = [];
  int indexBlame = 1;
  bool isLoading = true;
  final _connect = GetConnect();

  @override
  void initState() {
    getBlamesList();
    super.initState();
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
          title: const Center(child: Text('Blames',style: TextStyle(fontFamily: 'Montserrat',fontSize: 18),)),
        ),
        body: isLoading == true ? Center(child: IconProgressIndicator(isLoading: isLoading,))
            : ListView.builder(
              itemCount: blames.length,
              itemBuilder: (context, index) {
                print(blames[index]);
              return ListTile(
                leading: const Icon(Icons.error),
                title: Text(
                  'Blamed at ${DateFormat('E dd-MM-yyyy').format(DateTime.parse(blames[index]['date']))}',
                  style: const TextStyle(fontFamily: 'Montserrat',fontSize: 16),
                ),
                onTap: () => _showModalBlame(index),
              );
            }),
      );


  }

  getBlamesList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getInt('eagleId');
    var url = Uri.parse('https://api.irisje.tn/api/blame/${id}');
    /*var response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });*/
    var response = await http.get(url);
    print(' body is ${response.body}');
    print(' status is ${response.statusCode}');
    if (response.statusCode == 200) {
      print('true');
      var items = jsonDecode(response.body.toString());
      print(items);
      setState(() {
        blames = items;
        isLoading = false;
      });
    } else {
      blames = [];
    }
  }

  void _showModalBlame(index) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            builder: (_, controller) => Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Blame reason',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.27,
                          fontFamily: 'Montserrat',
                          color: Colors.blueAccent),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, left: 10, right: 10),
                    child: Text(
                      DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(blames[index]['date'])),
                      style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          fontFamily: 'Montserrat',),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: Text(
                            blames[index]['reason'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                                letterSpacing: 0.27,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
