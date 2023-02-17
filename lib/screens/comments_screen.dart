import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iris_nest_app/widgets/icon_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/design_course_app_theme.dart';


class CommentsScreen extends StatefulWidget {
  final String postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();
  List? comments = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    this.getComments();
  }

  getComments() async {
    var url = Uri.parse('https://api.irisje.tn/api/post/comments/${widget.postId}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('true');
      //jsonDecode(response.body);
      //var items = json.decode(response.body);
      var body = response.body;
      var items = jsonDecode(body);
      print(items);
      setState(() {
        comments = items;
        isLoading = false;
      });
    } else {
      comments = null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          appBar: AppBar(
            elevation: 25,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
            backgroundColor: DesignCourseAppTheme.IrisBlue,
            title: const Center(child: Text('Comments', style: TextStyle(fontFamily: 'Montserrat'),)),
          ),
           body: isLoading == true ?  Center(child: IconProgressIndicator(isLoading: isLoading,)) :
           Stack(
            children: [
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              Positioned(
                bottom: 10,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText: '  Type your comment',
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: EdgeInsets.all(5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                           GestureDetector(
                            onTap: () {
                              print('comment');
                            },
                            child: const Icon(
                              Icons.send,
                              color: DesignCourseAppTheme.IrisBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ),
              (comments!.length == 0 && isLoading == false) ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: Text('No Comments To Show. Be the first to comment on this post!'),),
              ) :
              Positioned(
                top: 30,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 70,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commentsList(),
                          ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  commentsList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: comments!.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: SizedBox(
                child: CircleAvatar(
                  backgroundImage: NetworkImage('https://api.irisje.tn/${comments![index]['eagle']['img']}', scale: 1.0),
                ),
              ),
              title: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(comments![index]['eagle']['lName'] +
                      ' ' +
                      comments![index]['eagle']['fName'])),
              subtitle: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.grey[100],
                  child: Text(comments![index]['content'])),
            );
          }),
    );
  }
}
