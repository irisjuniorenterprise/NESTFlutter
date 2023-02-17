import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iris_nest_app/widgets/icon_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../themes/design_course_app_theme.dart';

class IrisBiblioScreen extends StatefulWidget {
  const IrisBiblioScreen({Key? key}) : super(key: key);

  @override
  State<IrisBiblioScreen> createState() => _IrisBiblioScreenState();
}



class _IrisBiblioScreenState extends State<IrisBiblioScreen> {
  void initState() {
    super.initState();
    getResources();
  }
  List resources = [];
  bool isLoading = true;
  getResources() async{
    var url = Uri.parse('https://api.irisje.tn/api/irisbiblio');
    var response = await http.get(url);
    if(response.statusCode == 200) {
      print('true');
      //jsonDecode(response.body);
      //var items = json.decode(response.body);
      var body = response.body;
      var items = jsonDecode(body);
      print(items);
      setState(() {
        resources = items;
        isLoading = false;
      });
    }else{
      resources = [];

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
        title: const Center(child: Text('IRIS Library',style: TextStyle(fontFamily: 'Montserrat',fontSize: 18),)),
      ),
      body: isLoading == true ? Center(child: IconProgressIndicator(isLoading: isLoading,)) :
      ListView.builder(
        itemCount: resources.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ExpansionTile(
                      title: Text(resources[index]['content'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: DesignCourseAppTheme.IrisBlue,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      leading: const Icon(Icons.link_outlined),
                      trailing: const Icon(Icons.keyboard_arrow_down_outlined),
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            resources[index]['training'] == null && resources[index]['workshop'] == null ? const Text('') :
                            resources[index]['training'] == null ?
                            Text('Related to : ${resources[index]?['workshop']?['workPost']['engagementPost']['post']['name']}',style: const TextStyle(
                              fontSize: 15,
                              fontFamily: "Montserrat",
                            ),)
                                : Text('Related to : ${resources[index]?['training']?['engagementPost']!['post']['name']}',style: const TextStyle(
                              fontSize: 15,
                              fontFamily: "Montserrat",
                            ),),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: ListView.builder(
                                itemCount: resources[index]['files'].length,
                                  itemBuilder: (context, index) {
                                    return  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: RichText(
                                          text: TextSpan(
                                              style: const TextStyle(
                                                color:
                                                DesignCourseAppTheme.nearlyBlue,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  await launchUrl(Uri.parse(resources[index]['files'][index]));
                                                },
                                              text: resources[0]['files'][index]
                                              ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ),
                          ],
                        ),
                      ],
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}
