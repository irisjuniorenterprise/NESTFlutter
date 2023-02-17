import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../themes/design_course_app_theme.dart';

class ChatUi extends StatefulWidget {
  const ChatUi({Key? key}) : super(key: key);

  @override
  State<ChatUi> createState() => _ChatUiState();
}

class _ChatUiState extends State<ChatUi> {
  List eagles = [];
  bool isLoading = true;

  @override
  void initState() {
    getEagles();
    super.initState();
  }
  getEagles() async{
    var url = Uri.parse('https://api.irisje.tn/api/eagleimagephone');
    var response = await http.get(url);
    if(response.statusCode == 200) {
      print('true');
      var body = response.body;
      var items = jsonDecode(body);
      print(items);
      setState(() {
        eagles = items;
        isLoading = false;
      });
    }else{
      print(response.statusCode);
      eagles = [];

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
        title: Center(child: Text('IRIS Eagles Contact')),
      ),
      backgroundColor: DesignCourseAppTheme.nearlyWhite,
      body: isLoading ?
      Center(child: CircularProgressIndicator())
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: ListView.builder(
                      itemCount: eagles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xFF565973), width: 1.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0.0, 6.0, 16.0, 6.0),
                                    child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'https://api.irisje.tn/${eagles[index]['img'].toString()}'
                                            ),
                                            fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              '${eagles[index]['lName']}' + ' ' + '${eagles[index]['fName']}'.toUpperCase(),
                                              style: TextStyle(
                                                color: DesignCourseAppTheme.IrisBlue,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          '${eagles[index]['department']['name']}',
                                          style: TextStyle(
                                            color: DesignCourseAppTheme.nearlyBlack,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 42.0,
                                        height: 42.0,
                                        decoration: BoxDecoration(
                                          color: DesignCourseAppTheme.IrisBlue,
                                          borderRadius: BorderRadius.circular(50.0),
                                        ),
                                        child: IconButton(
                                          color: DesignCourseAppTheme.IrisOrange,
                                          icon: Icon(Icons.call),
                                          onPressed: () => launch('tel:' + '${eagles[index]['phone']}'),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Container(
                                        width: 42.0,
                                        height: 42.0,
                                        decoration: BoxDecoration(
                                          color: DesignCourseAppTheme.IrisBlue,
                                          borderRadius: BorderRadius.circular(50.0),
                                        ),
                                        child: IconButton(
                                          color: DesignCourseAppTheme.IrisOrange,
                                          icon: Icon(Icons.mail_outline_outlined),
                                          onPressed: () => launch('mailto:' + '${eagles[index]['email']}'),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
