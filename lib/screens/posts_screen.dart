import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:iris_nest_app/widgets/icon_progress_indicator.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import '../themes/app_theme.dart';
import '../themes/design_course_app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/hotel_app_theme.dart';
import 'course_info_screen.dart';
import 'home_design_course.dart';
import 'package:get/get.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  Animation<double>? animation;
  CategoryType categoryType = CategoryType.ui;
  VoidCallback? callback;
  List posts = [];
  final _connect = GetConnect();

  @override
  void initState() {
    super.initState();
    this.getPosts('');
  }
  bool isLoading = true;
  getPosts(type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var target = preferences.getString('eagleDepartment');
    var url = Uri.parse('https://api.irisje.tn/api/post/${target}');
    var response = await http.get(url, headers: {
      'type': '$type',
    });
    print(type);
    //var response = await _connect.get('https://api.irisje.tn/api/post/${target}');
    print(' body is ${response.body}');
    print(' status is ${response.statusCode}');
    if (response.statusCode == 200) {
      print('true');
      //jsonDecode(response.body);
      //var items = json.decode(response.body);
      var body = response.body;
      var items = jsonDecode(body);
      print(items);
      setState(() {
        posts = items;
        isLoading = false;
      });
    } else {
      posts = [];
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        backgroundColor: DesignCourseAppTheme.IrisBlue,
        title: const Center(child: Text('IRIS Posts',style: TextStyle(fontFamily: 'Montserrat',fontSize: 18),)),
      ),
      body: isLoading == true
          ?  Center(
              child: IconProgressIndicator(
                isLoading: isLoading,
              ),
            )
          : Column(
            children: [
              const SizedBox(height: 10,),
              Container(
                height: MediaQuery.of(context).size.height*0.1,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          const SizedBox(width: 15,),
                          InkWell(
                            onTap: () {
                              _snackBarLoading();
                              getPosts('all');
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                    child: const Icon(
                                      Icons.clear_all,
                                      color: DesignCourseAppTheme.IrisBlue,
                                      size: 30,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  const Text(
                                    "All",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        color: DesignCourseAppTheme.IrisBlue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          InkWell(
                            onTap: () {
                              _snackBarLoading();
                              getPosts('workshop');
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                    child: const Icon(
                                      Icons.computer_outlined,
                                      color: DesignCourseAppTheme.IrisBlue,
                                      size: 30,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  const Text(
                                    "Workshop",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        color: DesignCourseAppTheme.IrisBlue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          InkWell(
                            onTap: () {
                              _snackBarLoading();
                              getPosts('meeting');
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                    child: const Icon(
                                      Icons.groups_outlined,
                                      color: DesignCourseAppTheme.IrisBlue,
                                      size: 30,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  const Text(
                                    "Meeting",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        color: DesignCourseAppTheme.IrisBlue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          InkWell(
                            onTap: () {
                              _snackBarLoading();
                              getPosts('training');
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                    child: const Icon(
                                      Icons.workspace_premium_outlined,
                                      color: DesignCourseAppTheme.IrisBlue,
                                      size: 30,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  const Text(
                                    "Training",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        color: DesignCourseAppTheme.IrisBlue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          InkWell(
                            onTap: () {
                              _snackBarLoading();
                              getPosts('announcement');
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                    child: const Icon(
                                      Icons.newspaper_outlined,
                                      color: DesignCourseAppTheme.IrisBlue,
                                      size: 30,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  const Text(
                                    "Announcement",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        color: DesignCourseAppTheme.IrisBlue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          InkWell(
                            onTap: () async {
                              _snackBarLoading();
                              await getPosts('poll');
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                    child: const Icon(
                                      Icons.bar_chart_outlined,
                                      color: DesignCourseAppTheme.IrisBlue,
                                      size: 30,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  const Text(
                                    "Poll",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        color: DesignCourseAppTheme.IrisBlue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: DesignCourseAppTheme.IrisBlue,thickness: 1),
              Container(
                height: MediaQuery.of(context).size.height*0.67,
                child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      Size size = MediaQuery.of(context).size;
                      return SizedBox(
                        height: size.height - 250,
                        width: size.width,
                        child: Scaffold(
                          body: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, right: 24, top: 25),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              CourseInfoScreen(
                                            postName: getPostName(posts[index]),
                                            postPlace: getPostPlace(posts[index]),
                                            postTargets: getPostTargets(posts[index]),
                                            postDate: getPostDate(posts[index]),
                                            poll: getPoll(posts[index]),
                                            engagementPost:
                                                getEngagementPost(posts[index]),
                                            announcement:
                                                getAnnouncement(posts[index]),
                                            comments: getComments(posts[index]),
                                            postId: getPostId(posts[index]),
                                            trainers: getTrainers(posts[index]),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16.0)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            offset: const Offset(2, 2),
                                            blurRadius: 12,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16.0)),
                                        child: Stack(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                AspectRatio(
                                                  aspectRatio: 2.5,
                                                  child: getAnnouncement(posts[index]) != null
                                                    ? Image.asset(
                                                      'assets/images/announcement.png',
                                                      fit: BoxFit.cover,
                                                    )
                                                    : getPoll(posts[index]) != null
                                                      ? Image.asset(
                                                    'assets/images/poll.png',
                                                        fit: BoxFit.cover,
                                                      )
                                                      : getEngagementPost(posts[index])?['training'] != null
                                                        ? Image.asset(
                                                          'assets/images/training.png',
                                                          fit: BoxFit.cover,
                                                        )
                                                        : getEngagementPost(posts[index])?['workPost']?['meeting'] != null
                                                      ? Image.asset(
                                                    'assets/images/meeting.png',
                                                    fit: BoxFit.cover,
                                                  )
                                                      : Image.asset(
                                                    'assets/images/workshop.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Container(
                                                  color:
                                                      HotelAppTheme.buildLightTheme()
                                                          .backgroundColor,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                    left: 16,
                                                                    top: 8,
                                                                    bottom: 8),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Text(
                                                                  '${getPostName(posts[index])}',
                                                                  textAlign:
                                                                      TextAlign.left,
                                                                  style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 18,
                                                                    color: DesignCourseAppTheme.IrisBlue,
                                                                    fontFamily: "Montserrat",
                                                                  ),
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: <Widget>[
                                                                    const Icon(
                                                                      FontAwesomeIcons
                                                                          .calendar,
                                                                      size: 12,
                                                                      color: DesignCourseAppTheme.IrisOrange,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Text(
                                                                      DateFormat(
                                                                          'dd-MM-yyyy kk:mm')
                                                                          .format(getPostDate(
                                                                          posts[
                                                                          index])),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          14,
                                                                          fontFamily: "Montserrat",
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(
                                                                              0.8)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                right: 16, top: 15),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.center,
                                                          children: const <Widget>[
                                                            Icon(
                                                              Icons.arrow_forward_ios_outlined,
                                                              color: DesignCourseAppTheme.IrisOrange,
                                                              size: 28,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            /* Positioned(
                                               top: 8,
                                               right: 8,
                                               child: Material(
                                                 color: Colors.transparent,
                                                 child: InkWell(
                                                   borderRadius: const BorderRadius.all(
                                                     Radius.circular(32.0),
                                                   ),
                                                   onTap: () {},
                                                   child: Padding(
                                                     padding: const EdgeInsets.all(8.0),
                                                     child: Icon(
                                                       Icons.favorite_border,
                                                       color: HotelAppTheme.buildLightTheme()
                                                           .primaryColor,
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                             ) */
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      );
                    }),
              ),
            ],
          ),
    );
  }

  _snackBarLoading()
  {
    setState(() {
      isLoading = true;
    });
    return IconProgressIndicator(isLoading: isLoading);
  }
  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0), //here
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Explore',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.favorite_border),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.mapMarkerAlt),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getPostName(index) {
    print("index is is : $index");
    var name = index['name'];
    return name;
  }

  String getPostId(index) {
    var id = index['id'].toString();
    return id;
  }

  String getPostPlace(index) {
    if (index['engagementPost'] == null) {
      return '';
    } else {
      var place = index['engagementPost']['place'];
      return place;
    }
  }

  String getPostTargets(index) {
    var targets = index['targets'];
    return targets;
  }

  DateTime getPostDate(index) {
    return DateTime.parse(index['publishDate']);
  }

  Map<String, dynamic>? getAnnouncement(index) {
    return index['announcement'];
  }

  Map<String, dynamic>? getPoll(index) {
    return index['poll'];
  }

  Map<String, dynamic>? getEngagementPost(index) {
    return index['engagementPost'];
  }

  List<dynamic>? getComments(index) {
    return index['comments'];
  }

  List<dynamic>? getTrainers(index) {
    if (index['engagementPost'] == null) {
      return [];
    } else {
      return index['engagementPost']['training']?['trainers'];
    }
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.ui == categoryTypeData) {
      txt = 'Ui/Ux';
    } else if (CategoryType.coding == categoryTypeData) {
      txt = 'Coding';
    } else if (CategoryType.basic == categoryTypeData) {
      txt = 'Basic UI';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? DesignCourseAppTheme.nearlyBlue
                : DesignCourseAppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? DesignCourseAppTheme.nearlyWhite
                        : DesignCourseAppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 10.0, left: 18, right: 16),
          child: Text(
            '',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: Row(
            children: <Widget>[
              getButtonUI(CategoryType.ui, categoryType == CategoryType.ui),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.coding, categoryType == CategoryType.coding),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.basic, categoryType == CategoryType.basic),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        //CategoryListView(
        //callBack: () {
        //moveTo();
        //},
        //),
      ],
    );
  }
}

Widget _buildComposer() {
  return Padding(
    padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
    child: Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              offset: const Offset(4, 4),
              blurRadius: 8),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
          color: AppTheme.white,
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
            child: TextField(
              maxLines: null,
              onChanged: (String txt) {},
              style: const TextStyle(
                fontFamily: AppTheme.fontName,
                fontSize: 16,
                color: AppTheme.dark_grey,
              ),
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Enter your feedback...'),
            ),
          ),
        ),
      ),
    ),
  );
}
