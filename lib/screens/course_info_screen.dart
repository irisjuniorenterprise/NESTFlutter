import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iris_nest_app/screens/posts_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:get/get.dart';

import '../themes/design_course_app_theme.dart';
import 'comments_screen.dart';

class CourseInfoScreen extends StatefulWidget {
  final String postName;
  final String postId;
  final String postPlace;
  final String postTargets;
  final DateTime postDate;
  final Map<String, dynamic>? poll;
  final Map<String, dynamic>? engagementPost;
  final Map<String, dynamic>? announcement;
  final List<dynamic>? comments;
  final List<dynamic>? trainers;

  const CourseInfoScreen({
    Key? key,
    required this.postName,
    required this.postPlace,
    required this.postTargets,
    required this.postDate,
    required this.poll,
    required this.engagementPost,
    required this.announcement,
    required this.comments,
    required this.postId,
    required this.trainers
  }) : super(key: key);

  @override
  _CourseInfoScreenState createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;

  AnimationController? animationController;
  TextEditingController justificationController = TextEditingController();
  Animation<double>? animation;
  dynamic pollValue;
  bool voted = false;
  List<PlatformFile>? _files;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  Future<void> setData() async {
    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    if (widget.announcement == null && widget.poll == null) {
      // here we return engagement post data
     if (widget.engagementPost?['training'] == null) {
       if (widget.engagementPost?['workPost']?['workshop'] == null) {
         // meeting data
         // done
         return Container(
           color: DesignCourseAppTheme.nearlyWhite,
           child: Scaffold(
             backgroundColor: Colors.transparent,
             body: Stack(
               children: <Widget>[
                 Column(
                   children: <Widget>[
                     AspectRatio(
                       aspectRatio: 1.2,
                       child: Image.asset('assets/images/meeting.png',fit: BoxFit.cover,),
                     ),
                   ],
                 ),
                 Positioned(
                   top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
                   bottom: 0,
                   left: 0,
                   right: 0,
                   child: SingleChildScrollView(
                     child: Container(
                       decoration: BoxDecoration(
                         color: DesignCourseAppTheme.nearlyWhite,
                         borderRadius: const BorderRadius.only(
                             topLeft: Radius.circular(32.0),
                             topRight: Radius.circular(32.0)),
                         boxShadow: <BoxShadow>[
                           BoxShadow(
                               color: DesignCourseAppTheme.grey.withOpacity(0.2),
                               offset: const Offset(1.1, 1.1),
                               blurRadius: 10.0),
                         ],
                       ),
                       child: Padding(
                         padding: const EdgeInsets.only(left: 5, right: 8),
                         child: SingleChildScrollView(
                           child: Container(
                             constraints: BoxConstraints(
                                 minHeight: infoHeight,
                                 maxHeight: tempHeight > infoHeight
                                     ? tempHeight
                                     : infoHeight),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Padding(
                                   padding: const EdgeInsets.only(
                                       top: 32.0, left: 18, right: 16),
                                   child: Text(
                                     widget.postName,
                                     textAlign: TextAlign.left,
                                     style: const TextStyle(
                                       fontWeight: FontWeight.w600,
                                       fontSize: 18,
                                       fontFamily: 'Montserrat',
                                       letterSpacing: 0.27,
                                       color: DesignCourseAppTheme.IrisBlue,
                                     ),
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.only(
                                       left: 16, right: 16, bottom: 8, top: 16),
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment.spaceBetween,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: <Widget>[
                                       Container(
                                         child: Row(
                                           children: const <Widget>[],
                                         ),
                                       )
                                     ],
                                   ),
                                 ),
                                 AnimatedOpacity(
                                   duration: const Duration(milliseconds: 500),
                                   opacity: opacity1,
                                   child: Padding(
                                     padding: const EdgeInsets.only(top: 8,bottom: 8),
                                     child: Row(
                                       children: <Widget>[
                                         getTimeBoxUI(
                                             'Date',
                                             DateFormat('dd-MM-yyyy').format(
                                                 DateTime.parse(widget
                                                     .engagementPost?['start']))),
                                         getTimeBoxUI(
                                             'Time',
                                             DateFormat('kk:mm').format(
                                                 DateTime.parse(widget
                                                     .engagementPost?['start']))),
                                         getTimeBoxUI('Place', widget.postPlace),
                                       ],
                                     ),
                                   ),
                                 ),
                                 Row(
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(left: 15),
                                       child: Container(
                                         child: const Text(
                                           'Link:  ',
                                           style: TextStyle(
                                             fontWeight: FontWeight.w400,
                                             fontSize: 16,
                                             fontFamily: 'Montserrat',
                                             letterSpacing: 0.27,
                                             color:
                                             DesignCourseAppTheme.nearlyBlack,
                                           ),
                                         ),
                                       ),
                                     ),
                                     Container(
                                       child: RichText(
                                         text: TextSpan(
                                             style: const TextStyle(
                                               color:
                                               DesignCourseAppTheme.nearlyBlue,
                                             ),
                                             recognizer: TapGestureRecognizer()
                                               ..onTap = () async {
                                                 await launchUrl(Uri.parse( widget
                                                     .engagementPost!['link']));
                                               },
                                             text:
                                             widget
                                                 .engagementPost!['link'] ?? 'No Attached Link'),
                                       ),
                                     ),
                                   ],
                                 ),
                                 Expanded(
                                   child: AnimatedOpacity(
                                     duration: const Duration(milliseconds: 500),
                                     opacity: opacity2,
                                     child: Padding(
                                       padding: const EdgeInsets.only(
                                           left: 16,
                                           right: 16,
                                           top: 8,
                                           bottom: 20),
                                       child: SizedBox(
                                         width: MediaQuery.of(context).size.width,
                                         child: ListView.builder(
                                             itemCount: 1,
                                             itemBuilder: (context, index) {
                                               return ExpandableText(
                                                 'Type: ${widget.engagementPost!['workPost']?['meeting']['type']}',
                                                 textAlign: TextAlign.justify,
                                                 style: const TextStyle(
                                                   fontWeight: FontWeight.w200,
                                                   fontSize: 14,
                                                   fontFamily: 'Montserrat',
                                                   letterSpacing: 0.27,
                                                   color: DesignCourseAppTheme.grey,
                                                   overflow: TextOverflow.ellipsis,
                                                 ),
                                                 maxLines: 4,
                                                 //overflow: TextOverflow.ellipsis,
                                                 expandText: 'Show more',
                                                 collapseText: 'Show less',
                                               );
                                             }
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                                 AnimatedOpacity(
                                   duration: const Duration(milliseconds: 500),
                                   opacity: opacity3,
                                   child: Padding(
                                     padding: const EdgeInsets.only(
                                         left: 16, bottom: 16, right: 16),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment:
                                       CrossAxisAlignment.center,
                                       children: <Widget>[
                                         Container(
                                           width:
                                           (MediaQuery.of(context).size.width /
                                               2.4),
                                           height: 48,
                                           child: InkWell(

                                             onTap: () =>  compareDates() ?
                                             Get.snackbar('', '',
                                               duration: const Duration(seconds: 4),
                                               snackPosition: SnackPosition.BOTTOM,
                                               backgroundColor: Colors.white,
                                               titleText: const Text('Absence Confirmation', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                                               messageText: const Text('Sorry, 24 hours have passed and the deadline for disapproval has expired!', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat'),),
                                               colorText: DesignCourseAppTheme.IrisBlue,
                                               icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                             ) :
                                             _showModalDisapproval(),
                                             child: Container(
                                               decoration: BoxDecoration(
                                                 color: compareDates() ? Colors.grey : Colors.red,
                                                 borderRadius:
                                                 const BorderRadius.all(
                                                   Radius.circular(16.0),
                                                 ),
                                                 border: Border.all(
                                                     color: DesignCourseAppTheme
                                                         .grey
                                                         .withOpacity(0.2)),
                                               ),
                                               child: const Center(
                                                 child: Text(
                                                   'I\'m absent',
                                                   textAlign: TextAlign.left,
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.w600,
                                                     fontSize: 15,
                                                     fontFamily: 'Montserrat',
                                                     letterSpacing: 0.0,
                                                     color: DesignCourseAppTheme
                                                         .nearlyWhite,
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ),
                                         ),
                                         const SizedBox(
                                           width: 16,
                                         ),
                                         Expanded(
                                           child: InkWell(
                                             onTap: () async {
                                               if (compareDatesForPresence()) {
                                                 Get.snackbar('', '',
                                                   duration: const Duration(seconds: 4),
                                                   snackPosition: SnackPosition.BOTTOM,
                                                   backgroundColor: Colors.white,
                                                   titleText: const Text('Presence Confirmation', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                                                   messageText: const Text('Sorry, the event has started!', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat'),),
                                                   colorText: DesignCourseAppTheme.IrisBlue,
                                                   icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                                 );
                                                 return;
                                               }
                                               SharedPreferences preferences = await SharedPreferences.getInstance();
                                               var eagleId = preferences.getInt('eagleId').toString();
                                               var url = Uri.parse('https://api.irisje.tn/api/approve');
                                               var  body = jsonEncode({
                                                 'eagleId': eagleId,
                                                 'engagementPost': widget.engagementPost!['id'].toString(),
                                               });
                                               var response = await http.post(url, body: body);
                                               if (response.statusCode == 200 || response.statusCode == 201) {
                                                 print('worked');
                                                 const SnackBar(
                                                   content: Text('Approval sent'),
                                                   duration: Duration(milliseconds: 3000),
                                                   shape: StadiumBorder(),
                                                   elevation: 50,
                                                   behavior: SnackBarBehavior.floating,
                                                 );
                                               }
                                               if (response.statusCode == 400) {
                                                 Get.snackbar('', '',
                                                   duration: const Duration(seconds: 4),
                                                   snackPosition: SnackPosition.BOTTOM,
                                                   backgroundColor: Colors.white,
                                                   titleText: const Text('Presence Confirmation', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                                                   messageText: const Text('Sorry, you have already approved/disapproved your presence!', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat'),),
                                                   colorText: DesignCourseAppTheme.IrisBlue,
                                                   icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                                 );
                                                 print('already approved');
                                               }
                                             },
                                             child: Container(
                                               height: 48,
                                               decoration:  BoxDecoration(
                                                 color: compareDatesForPresence() ? Colors.grey : DesignCourseAppTheme
                                                     .IrisThirdBlue,
                                                 borderRadius:
                                                 const BorderRadius.all(
                                                   Radius.circular(16.0),
                                                 ),
                                               ),
                                               child: const Center(
                                                 child: Text(
                                                   'I\'m present',
                                                   textAlign: TextAlign.left,
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.w600,
                                                     fontSize: 15,
                                                      fontFamily: 'Montserrat',
                                                     letterSpacing: 0.0,
                                                     color: DesignCourseAppTheme
                                                         .nearlyWhite,
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ),
                                         )
                                       ],
                                     ),
                                   ),
                                 ),
                                 SizedBox(
                                   height: MediaQuery.of(context).padding.bottom,
                                 )
                               ],
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),
                 ),
                 Positioned(
                   top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
                   right: 35,
                   child: ScaleTransition(
                     alignment: Alignment.center,
                     scale: CurvedAnimation(
                         parent: animationController!,
                         curve: Curves.fastOutSlowIn),
                     child: InkWell(
                       onTap: () {
                         Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (BuildContext context) => CommentsScreen(
                                   postId: widget.postId,
                                 )));
                       },
                       child: Card(
                         color: DesignCourseAppTheme.IrisThirdBlue,
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(50.0)),
                         elevation: 10.0,
                         child: Container(
                           width: 60,
                           height: 60,
                           child: const Center(
                             child: Icon(
                               Icons.announcement,
                               color: DesignCourseAppTheme.nearlyWhite,
                               size: 30,
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),
                 ),
                 Padding(
                   padding:
                   EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                   child: SizedBox(
                     width: AppBar().preferredSize.height,
                     height: AppBar().preferredSize.height,
                     child: Material(
                       color: Colors.transparent,
                       child: InkWell(
                         borderRadius:
                         BorderRadius.circular(AppBar().preferredSize.height),
                         child: const Icon(
                           Icons.arrow_back_ios,
                           color: DesignCourseAppTheme.nearlyBlack,
                         ),
                         onTap: () {
                           Navigator.pop(context);
                         },
                       ),
                     ),
                   ),
                 )
               ],
             ),
           ),
         );
       } 
       if (widget.engagementPost?['workPost']?['meeting'] == null) {
         // workShop data
         // done
         return Container(
           color: DesignCourseAppTheme.nearlyWhite,
           child: Scaffold(
             backgroundColor: Colors.transparent,
             body: Stack(
               children: <Widget>[
                 Column(
                   children: <Widget>[
                     AspectRatio(
                       aspectRatio: 1.3,
                       child: Image.asset('assets/images/workshop.png',fit: BoxFit.cover,),
                     ),
                   ],
                 ),
                 Positioned(
                   top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
                   bottom: 0,
                   left: 0,
                   right: 0,
                   child: SingleChildScrollView(
                     child: Container(
                       decoration: BoxDecoration(
                         color: DesignCourseAppTheme.nearlyWhite,
                         borderRadius: const BorderRadius.only(
                             topLeft: Radius.circular(32.0),
                             topRight: Radius.circular(32.0)),
                         boxShadow: <BoxShadow>[
                           BoxShadow(
                               color: DesignCourseAppTheme.grey.withOpacity(0.2),
                               offset: const Offset(1.1, 1.1),
                               blurRadius: 10.0),
                         ],
                       ),
                       child: Padding(
                         padding: const EdgeInsets.only(left: 8, right: 8),
                         child: SingleChildScrollView(
                           child: Container(
                             constraints: BoxConstraints(
                                 minHeight: infoHeight,
                                 maxHeight: tempHeight > infoHeight
                                     ? tempHeight
                                     : infoHeight),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Padding(
                                   padding: const EdgeInsets.only(
                                       top: 32.0, left: 18, right: 16),
                                   child: Text(
                                     widget.postName,
                                     textAlign: TextAlign.left,
                                     style: const TextStyle(
                                       fontWeight: FontWeight.w600,
                                       fontSize: 18,
                                       fontFamily: 'Montserrat',
                                       letterSpacing: 0.27,
                                       color: DesignCourseAppTheme.IrisBlue,
                                     ),
                                   ),
                                 ),
                                 AnimatedOpacity(
                                   duration: const Duration(milliseconds: 500),
                                   opacity: opacity1,
                                   child: Padding(
                                     padding: const EdgeInsets.all(8),
                                     child: Row(
                                       children: <Widget>[
                                         getTimeBoxUI(
                                             'Date',
                                             DateFormat('dd-MM-yyyy').format(
                                                 DateTime.parse(widget
                                                     .engagementPost!['date']))),
                                         getTimeBoxUI(
                                             'Time',
                                             DateFormat('kk:mm').format(
                                                 DateTime.parse(widget
                                                     .engagementPost!['date']))),
                                         getTimeBoxUI('Place', widget.postPlace),
                                       ],
                                     ),
                                   ),
                                 ),
                                 Row(
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(left: 15),
                                       child: Container(
                                         child: widget
                                             .engagementPost!['link'] != null ? const Text(
                                           'Link :  ',
                                           style: TextStyle(
                                             fontWeight: FontWeight.w400,
                                             fontSize: 16,
                                             fontFamily: 'Montserrat',
                                             letterSpacing: 0.27,
                                             color:
                                             DesignCourseAppTheme.nearlyBlack,
                                           ),
                                         ) : Text(''),
                                       ),
                                     ),
                                     Container(
                                       child: RichText(
                                         text: TextSpan(
                                             style: const TextStyle(
                                               color:
                                               DesignCourseAppTheme.nearlyBlue,
                                             ),
                                             recognizer: TapGestureRecognizer()
                                               ..onTap = () async {
                                                 await launchUrl(Uri.parse(widget
                                                     .engagementPost!['link']));
                                               },
                                             text:
                                             widget
                                                 .engagementPost!['link'] ?? 'No Attached Link'),
                                       ),
                                     ),
                                   ],
                                 ),
                                 const SizedBox(
                                   height: 30,
                                 ),
                                  Padding(
                                   padding: EdgeInsets.all(12.0),
                                   child: widget
                                       .engagementPost!['workPost']?['workshop']?['biblioIRIS']?['files'] != null ? const Text('Attached links: ',
                                       style: TextStyle(
                                         fontWeight: FontWeight.w400,
                                         fontSize: 16,
                                         fontFamily: 'Montserrat',
                                         letterSpacing: 0.27,
                                         color: DesignCourseAppTheme.nearlyBlack,
                                       )) : const Text('No attached links ',
                                       style: TextStyle(
                                         fontWeight: FontWeight.w400,
                                         fontSize: 16,
                                         fontFamily: 'Montserrat',
                                         letterSpacing: 0.27,
                                         color: DesignCourseAppTheme.nearlyBlack,
                                       )),
                                 ),
                                 Container(
                                   height: 150,
                                   child: ListView.builder(
                                     itemCount: widget
                                         .engagementPost!['workPost']?['workshop']?['biblioIRIS']?['files']!
                                         .length ?? 0,
                                       itemBuilder: (context, index) {
                                       print(index);
                                         return Link(
                                             uri: Uri.parse(widget.engagementPost!['workPost']['workshop']['biblioIRIS']?['files'][index]),
                                             target: LinkTarget.blank,
                                             builder: (context, followLink) => GestureDetector(
                                               onTap: followLink,
                                               child: Container(
                                                 margin: const EdgeInsets.only(
                                                     left: 10, right: 10),
                                                 child: SingleChildScrollView(
                                                   scrollDirection: Axis.horizontal,
                                                   child: Row(
                                                     children: [
                                                       const Icon(
                                                         Icons.link,
                                                         color: DesignCourseAppTheme
                                                             .nearlyBlue,
                                                       ),
                                                       const SizedBox(
                                                         width: 10,
                                                       ),
                                                       Text(
                                                         widget
                                                             .engagementPost!['workPost']['workshop']['biblioIRIS']['files'][index],
                                                         style: const TextStyle(
                                                           fontWeight: FontWeight.w400,
                                                           fontSize: 16,
                                                           fontFamily: 'Montserrat',
                                                           letterSpacing: 0.27,
                                                           color: DesignCourseAppTheme
                                                               .nearlyBlack,
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                               ),
                                         ));
                                       },
                                   ),
                                 ),
                                 Expanded(
                                   child: AnimatedOpacity(
                                     duration: const Duration(milliseconds: 500),
                                     opacity: opacity2,
                                     child: const Padding(
                                       padding: EdgeInsets.only(
                                           left: 16, right: 16, top: 8, bottom: 8),
                                     ),
                                   ),
                                 ),
                                 AnimatedOpacity(
                                   duration: const Duration(milliseconds: 500),
                                   opacity: opacity3,
                                   child: Padding(
                                     padding: const EdgeInsets.only(
                                         left: 16, bottom: 16, right: 16),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment:
                                       CrossAxisAlignment.center,
                                       children: <Widget>[
                                         Container(
                                           width:
                                           (MediaQuery.of(context).size.width /
                                               2.4),
                                           height: 48,
                                           child: InkWell(
                                             onTap: () =>  compareDates() ?
                                             Get.snackbar('', '',
                                               duration: const Duration(seconds: 4),
                                               snackPosition: SnackPosition.BOTTOM,
                                               backgroundColor: Colors.white,
                                               titleText: const Text('Absence Confirmation', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                                               messageText: const Text('Sorry, 24 hours have passed and the deadline for disapproval has expired!', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat'),),
                                               colorText: DesignCourseAppTheme.IrisBlue,
                                               icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                             )
                                                 :
                                             _showModalDisapproval(),
                                             child: Container(
                                               decoration: BoxDecoration(
                                                 color: compareDates() ? Colors.grey : Colors.red,
                                                 borderRadius:
                                                 const BorderRadius.all(
                                                   Radius.circular(16.0),
                                                 ),
                                                 border: Border.all(
                                                     color: DesignCourseAppTheme
                                                         .grey
                                                         .withOpacity(0.2)),
                                               ),
                                               child: const Center(
                                                 child: Text(
                                                   'I\'m absent',
                                                   textAlign: TextAlign.left,
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.w600,
                                                     fontSize: 15,
                                                     fontFamily: 'Montserrat',
                                                     letterSpacing: 0.0,
                                                     color: DesignCourseAppTheme
                                                         .nearlyWhite,
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ),
                                         ),
                                         const SizedBox(
                                           width: 16,
                                         ),
                                         Expanded(
                                           child: InkWell(
                                             onTap: () async {
                                               if (compareDatesForPresence()) {
                                                 Get.snackbar('', '',
                                                   duration: const Duration(seconds: 4),
                                                   snackPosition: SnackPosition.BOTTOM,
                                                   backgroundColor: Colors.white,
                                                   titleText: const Text('Presence Confirmation', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                                                   messageText: const Text('Sorry, the event has started!', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat'),),
                                                   colorText: DesignCourseAppTheme.IrisBlue,
                                                   icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                                 );
                                                 return;
                                               }
                                               SharedPreferences preferences = await SharedPreferences.getInstance();
                                               var eagleId = preferences.getInt('eagleId').toString();
                                               var url = Uri.parse('https://api.irisje.tn/api/approve');
                                               var  body = jsonEncode({
                                                 'eagleId': eagleId,
                                                 'engagementPost': widget.engagementPost!['id'].toString(),
                                               });
                                               var response = await http.post(url, body: body);
                                               if (response.statusCode == 200 || response.statusCode == 201) {
                                                  Get.snackbar('', '',
                                                    duration: const Duration(seconds: 4),
                                                    snackPosition: SnackPosition.BOTTOM,
                                                    backgroundColor: Colors.white,
                                                    titleText: const Text('Presence Confirmation', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                                                    messageText: const Text('Your presence has been confirmed!', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat'),),
                                                    colorText: DesignCourseAppTheme.IrisBlue,
                                                    icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                                  );
                                                 print('worked');
                                               }
                                               if (response.statusCode == 400) {
                                                   Get.snackbar('', '',
                                                     duration: const Duration(seconds: 4),
                                                     snackPosition: SnackPosition.BOTTOM,
                                                     backgroundColor: Colors.white,
                                                     titleText: const Text('Presence Confirmation', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                                                     messageText: const Text('Sorry, you have already approved/disapproved your presence!', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat'),),
                                                     colorText: DesignCourseAppTheme.IrisBlue,
                                                     icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                                   );
                                                 print('already approved');
                                               }
                                             },
                                             child: Container(
                                               height: 48,
                                               decoration:  BoxDecoration(
                                                 color: compareDatesForPresence() ? Colors.grey : DesignCourseAppTheme
                                                     .IrisThirdBlue,
                                                 borderRadius:
                                                 const BorderRadius.all(
                                                   Radius.circular(16.0),
                                                 ),
                                               ),
                                               child: const Center(
                                                 child: Text(
                                                   'I\'m present',
                                                   textAlign: TextAlign.left,
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.w600,
                                                     fontSize: 15,
                                                     fontFamily: 'Montserrat',
                                                     letterSpacing: 0.0,
                                                     color: DesignCourseAppTheme
                                                         .nearlyWhite,
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ),
                                         )
                                       ],
                                     ),
                                   ),
                                 ),
                                 SizedBox(
                                   height: MediaQuery.of(context).padding.bottom,
                                 )
                               ],
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),
                 ),
                 Positioned(
                   top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
                   right: 35,
                   child: ScaleTransition(
                     alignment: Alignment.center,
                     scale: CurvedAnimation(
                         parent: animationController!,
                         curve: Curves.fastOutSlowIn),
                     child: InkWell(
                       onTap: () {
                         Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (BuildContext context) => CommentsScreen(
                                   postId: widget.postId,
                                 )));
                       },
                       child: Card(
                         color: DesignCourseAppTheme.IrisThirdBlue,
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(50.0)),
                         elevation: 10.0,
                         child: Container(
                           width: 60,
                           height: 60,
                           child: const Center(
                             child: Icon(
                               Icons.announcement,
                               color: DesignCourseAppTheme.nearlyWhite,
                               size: 30,
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),
                 ),
                 Padding(
                   padding:
                   EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                   child: SizedBox(
                     width: AppBar().preferredSize.height,
                     height: AppBar().preferredSize.height,
                     child: Material(
                       color: Colors.transparent,
                       child: InkWell(
                         borderRadius:
                         BorderRadius.circular(AppBar().preferredSize.height),
                         child: const Icon(
                           Icons.arrow_back_ios,
                           color: DesignCourseAppTheme.nearlyBlack,
                         ),
                         onTap: () {
                           Navigator.pop(context);
                         },
                       ),
                     ),
                   ),
                 )
               ],
             ),
           ),
         );
       }  
     }
     if (widget.engagementPost?['workPost'] == null) {
       // training
       // done
       return Container(
         color: DesignCourseAppTheme.nearlyWhite,
         child: Scaffold(
           backgroundColor: Colors.transparent,
           body: Stack(
             children: <Widget>[
               Column(
                 children: <Widget>[
                   AspectRatio(
                     aspectRatio: 1.2,
                     child: Image.asset('assets/images/training.png',fit: BoxFit.cover,),
                   ),
                 ],
               ),
               Positioned(
                 top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
                 bottom: 0,
                 left: 0,
                 right: 0,
                 child: SingleChildScrollView(
                   child: Container(
                     decoration: BoxDecoration(
                       color: DesignCourseAppTheme.nearlyWhite,
                       borderRadius: const BorderRadius.only(
                           topLeft: Radius.circular(32.0),
                           topRight: Radius.circular(32.0)),
                       boxShadow: <BoxShadow>[
                         BoxShadow(
                             color: DesignCourseAppTheme.grey.withOpacity(0.2),
                             offset: const Offset(1.1, 1.1),
                             blurRadius: 10.0),
                       ],
                     ),
                     child: Padding(
                       padding: const EdgeInsets.only(left: 8, right: 8),
                       child: SingleChildScrollView(
                         child: Container(
                           constraints: BoxConstraints(
                               minHeight: infoHeight,
                               maxHeight: tempHeight > infoHeight
                                   ? tempHeight
                                   : infoHeight),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: <Widget>[
                               Padding(
                                 padding: const EdgeInsets.only(
                                     top: 32.0, left: 18, right: 16),
                                 child: Text(
                                   widget.postName,
                                   textAlign: TextAlign.left,
                                   style: const TextStyle(
                                     fontWeight: FontWeight.w600,
                                     fontSize: 18,
                                     fontFamily: 'Montserrat',
                                     letterSpacing: 0.27,
                                     color: DesignCourseAppTheme.IrisBlue,
                                   ),
                                 ),
                               ),
                               Padding(
                                 padding: const EdgeInsets.only(
                                     left: 16, right: 16, bottom: 8, top: 16),
                                 child: Row(
                                   mainAxisAlignment:
                                   MainAxisAlignment.spaceBetween,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: <Widget>[
                                     Container(
                                       child: Row(
                                         children: const <Widget>[],
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                               AnimatedOpacity(
                                 duration: const Duration(milliseconds: 500),
                                 opacity: opacity1,
                                 child: Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: Row(
                                     children: <Widget>[
                                       getTimeBoxUI(
                                           'Date',
                                           DateFormat('dd-MM-yyyy').format(
                                               DateTime.parse(widget
                                                   .engagementPost!['date']))),
                                       getTimeBoxUI(
                                           'Time',
                                           DateFormat('kk:mm').format(
                                               DateTime.parse(widget
                                                   .engagementPost!['date']))),
                                       getTimeBoxUI('Place', widget.postPlace),
                                     ],
                                   ),
                                 ),
                               ),
                               Row(
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.only(left: 15),
                                     child: Container(
                                       child: const Text(
                                         'Link:  ',
                                         style: TextStyle(
                                           fontWeight: FontWeight.w400,
                                           fontSize: 16,
                                           letterSpacing: 0.27,
                                           fontFamily: 'Montserrat',
                                           color:
                                           DesignCourseAppTheme.nearlyBlack,
                                         ),
                                       ),
                                     ),
                                   ),
                                   Container(
                                     child: RichText(
                                       text: TextSpan(
                                           style: const TextStyle(
                                             color:
                                             DesignCourseAppTheme.nearlyBlue,
                                             fontFamily: 'Montserrat',
                                           ),
                                           recognizer: TapGestureRecognizer()
                                             ..onTap = () async {
                                               await launchUrl(Uri.parse(widget
                                                   .engagementPost!['link']));
                                             },
                                           text:
                                           widget
                                               .engagementPost!['link'] ?? 'No Attached Link'),
                                     ),
                                   ),
                                 ],
                               ),
                               Expanded(
                                 child: AnimatedOpacity(
                                   duration: const Duration(milliseconds: 500),
                                   opacity: opacity2,
                                   child: Padding(
                                     padding: const EdgeInsets.only(
                                         left: 16,
                                         right: 16,
                                         top: 8,
                                         bottom: 20),
                                     child: SizedBox(
                                       width: MediaQuery.of(context).size.width,
                                       child: ListView.builder(
                                         itemCount: widget.trainers!.length,
                                           itemBuilder: (context, index) {
                                           return ExpandableText(
                                             'Trainer : ${widget.trainers?[index]['fName']} ${widget.trainers?[index]['lName']}',
                                             textAlign: TextAlign.justify,
                                             style: const TextStyle(
                                               fontWeight: FontWeight.w300,
                                               fontSize: 14,
                                               fontFamily: 'Montserrat',
                                               letterSpacing: 0.27,
                                               color: DesignCourseAppTheme.grey,
                                               overflow: TextOverflow.ellipsis,
                                             ),
                                             maxLines: 4,
                                             //overflow: TextOverflow.ellipsis,
                                             expandText: 'Show more',
                                             collapseText: 'Show less',
                                           );
                                           }
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                               AnimatedOpacity(
                                 duration: const Duration(milliseconds: 500),
                                 opacity: opacity3,
                                 child: Padding(
                                   padding: const EdgeInsets.only(
                                       left: 16, bottom: 16, right: 16),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment:
                                     CrossAxisAlignment.center,
                                     children: <Widget>[
                                       Container(
                                         width:
                                         (MediaQuery.of(context).size.width /
                                             2.4),
                                         height: 48,
                                         child: InkWell(

                                           onTap: () =>  compareDates()  ?
                                           Get.snackbar('', '',
                                             duration: const Duration(seconds: 4),
                                             snackPosition: SnackPosition.BOTTOM,
                                             backgroundColor: Colors.white,
                                             titleText: const Text('Absence Confirmation', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                                             messageText: const Text('Sorry, 24 hours have passed and the deadline for disapproval has expired!', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat'),),
                                             colorText: DesignCourseAppTheme.IrisBlue,
                                             icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                           ) :
                                           _showModalDisapproval(),
                                           child: Container(
                                             decoration: BoxDecoration(
                                               color: compareDates() ? Colors.grey : Colors.red,
                                               borderRadius:
                                               const BorderRadius.all(
                                                 Radius.circular(16.0),
                                               ),
                                               border: Border.all(
                                                   color: DesignCourseAppTheme
                                                       .grey
                                                       .withOpacity(0.2)),
                                             ),
                                             child: const Center(
                                               child: Text(
                                                 'I\'m absent',
                                                 textAlign: TextAlign.left,
                                                 style: TextStyle(
                                                   fontWeight: FontWeight.w600,
                                                   fontSize: 15,
                                                   fontFamily: 'Montserrat',
                                                   letterSpacing: 0.0,
                                                   color: DesignCourseAppTheme
                                                       .nearlyWhite,
                                                 ),
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                       const SizedBox(
                                         width: 16,
                                       ),
                                       Expanded(
                                         child: InkWell(
                                           onTap: () async {
                                             if (compareDatesForPresence()) {
                                               Get.snackbar('', '',
                                                 duration: const Duration(seconds: 4),
                                                 snackPosition: SnackPosition.BOTTOM,
                                                 backgroundColor: Colors.white,
                                                 titleText: const Text('Presence Confirmation', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                                                 messageText: const Text('Sorry, the event has started!', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat'),),
                                                 colorText: DesignCourseAppTheme.IrisBlue,
                                                 icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                               );
                                               return;
                                             }
                                             SharedPreferences preferences = await SharedPreferences.getInstance();
                                             var eagleId = preferences.getInt('eagleId').toString();
                                             var url = Uri.parse('https://api.irisje.tn/api/approve');
                                             var  body = jsonEncode({
                                               'eagleId': eagleId,
                                               'engagementPost': widget.engagementPost!['id'].toString(),
                                             });
                                             var response = await http.post(url, body: body);
                                             if (response.statusCode == 200 || response.statusCode == 201) {
                                               print('worked');
                                             }
                                             if (response.statusCode == 400) {
                                               Get.snackbar('', '',
                                                 duration: const Duration(seconds: 4),
                                                 snackPosition: SnackPosition.BOTTOM,
                                                 backgroundColor: Colors.white,
                                                 titleText: const Text('Presence Confirmation', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                                                 messageText: const Text('Sorry, you have already approved/disapproved your presence!', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat'),),
                                                 colorText: DesignCourseAppTheme.IrisBlue,
                                                 icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                               );
                                               print('already approved');
                                             }
                                           },
                                           child: Container(
                                             height: 48,
                                             decoration:  BoxDecoration(
                                               color: compareDatesForPresence() ? Colors.grey : DesignCourseAppTheme
                                                   .IrisThirdBlue,
                                               borderRadius:
                                               const BorderRadius.all(
                                                 Radius.circular(16.0),
                                               ),
                                             ),
                                             child: const Center(
                                               child: Text(
                                                 'I\'m present',
                                                 textAlign: TextAlign.left,
                                                 style: TextStyle(
                                                   fontWeight: FontWeight.w600,
                                                   fontSize: 15,
                                                    fontFamily: 'Montserrat',
                                                   letterSpacing: 0.0,
                                                   color: DesignCourseAppTheme
                                                       .nearlyWhite,
                                                 ),
                                               ),
                                             ),
                                           ),
                                         ),
                                       )
                                     ],
                                   ),
                                 ),
                               ),
                               SizedBox(
                                 height: MediaQuery.of(context).padding.bottom,
                               )
                             ],
                           ),
                         ),
                       ),
                     ),
                   ),
                 ),
               ),
               Positioned(
                 top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
                 right: 35,
                 child: ScaleTransition(
                   alignment: Alignment.center,
                   scale: CurvedAnimation(
                       parent: animationController!,
                       curve: Curves.fastOutSlowIn),
                   child: InkWell(
                     onTap: () {
                       Navigator.push(
                           context,
                           MaterialPageRoute(
                               builder: (BuildContext context) => CommentsScreen(
                                 postId: widget.postId,
                               )));
                     },
                     child: Card(
                       color: DesignCourseAppTheme.IrisThirdBlue,
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(50.0)),
                       elevation: 10.0,
                       child: Container(
                         width: 60,
                         height: 60,
                         child: const Center(
                           child: Icon(
                             Icons.announcement,
                             color: DesignCourseAppTheme.nearlyWhite,
                             size: 30,
                           ),
                         ),
                       ),
                     ),
                   ),
                 ),
               ),
               Padding(
                 padding:
                 EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                 child: SizedBox(
                   width: AppBar().preferredSize.height,
                   height: AppBar().preferredSize.height,
                   child: Material(
                     color: Colors.transparent,
                     child: InkWell(
                       borderRadius:
                       BorderRadius.circular(AppBar().preferredSize.height),
                       child: const Icon(
                         Icons.arrow_back_ios,
                         color: DesignCourseAppTheme.nearlyBlack,
                       ),
                       onTap: () {
                         Navigator.pop(context);
                       },
                     ),
                   ),
                 ),
               )
             ],
           ),
         ),
       );
     }
    }
    if (widget.poll == null && widget.engagementPost == null) {
      // here we return announcement post data
      // done
      return Container(
        color: DesignCourseAppTheme.nearlyWhite,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.467,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.announcement!['images'].length,
                        itemBuilder: (context, index) {
                          print('********************************');
                          print(widget.announcement!['images'][index]['imageName']);
                          return Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Image.network(
                              'https://api.irisje.tn/uploads/announcement/${widget.announcement!['images'][index]['imageName']}',
                              headers: const {
                                'Connection': 'keep-alive',
                                'Keep-alive': 'timeout=5, max=1000',
                              },
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
                bottom: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: DesignCourseAppTheme.nearlyWhite,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32.0),
                          topRight: Radius.circular(32.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: DesignCourseAppTheme.grey.withOpacity(0.2),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: SingleChildScrollView(
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: infoHeight,
                              maxHeight: tempHeight > infoHeight
                                  ? tempHeight
                                  : infoHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 32.0, left: 18, right: 16),
                                child: Text(
                                  widget.postName,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    letterSpacing: 0.27,
                                    fontFamily: 'Montserrat',
                                    color: DesignCourseAppTheme.IrisBlue,
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: opacity1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: const <Widget>[
                                      //getTimeBoxUI('Place', widget.postPlace),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    child: RichText(
                                      text: TextSpan(
                                          style: const TextStyle(
                                            color:
                                            DesignCourseAppTheme.nearlyBlue,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = (){},
                                          text:''),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: opacity2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        '${widget.announcement!['content']}',
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 14,
                                          fontFamily: 'Montserrat',
                                          letterSpacing: 0.27,
                                          color: DesignCourseAppTheme.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).padding.bottom,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
                right: 35,
                child: ScaleTransition(
                  alignment: Alignment.center,
                  scale: CurvedAnimation(
                      parent: animationController!,
                      curve: Curves.fastOutSlowIn),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => CommentsScreen(
                                postId: widget.postId,
                              )));
                    },
                    child: Card(
                      color: DesignCourseAppTheme.IrisThirdBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      elevation: 10.0,
                      child: Container(
                        width: 60,
                        height: 60,
                        child: const Center(
                          child: Icon(
                            Icons.announcement,
                            color: DesignCourseAppTheme.nearlyWhite,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: SizedBox(
                  width: AppBar().preferredSize.height,
                  height: AppBar().preferredSize.height,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: DesignCourseAppTheme.nearlyBlack,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
    if (widget.engagementPost == null && widget.announcement == null) {
      // here we return poll post data
      // done
      return Container(
        color: DesignCourseAppTheme.nearlyWhite,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Image.asset('assets/images/poll.png',fit: BoxFit.cover,),
                  ),
                ],
              ),
              Positioned(
                top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
                bottom: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: DesignCourseAppTheme.nearlyWhite,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32.0),
                          topRight: Radius.circular(32.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: DesignCourseAppTheme.grey.withOpacity(0.2),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: SingleChildScrollView(
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: infoHeight,
                              maxHeight: tempHeight > infoHeight
                                  ? tempHeight
                                  : infoHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 32.0, left: 18, right: 16),
                                child: Text(
                                  widget.postName,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    fontFamily: 'Montserrat',
                                    letterSpacing: 0.27,
                                    color: DesignCourseAppTheme.IrisBlue,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 8, top: 16),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: const <Widget>[],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: opacity1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: const <Widget>[

                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Please choose your answer',
                                        style: TextStyle(
                                            color: DesignCourseAppTheme.IrisBlue,
                                            fontSize: 16,
                                        )),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: opacity2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    child: ListView.builder(
                                      itemCount: widget.poll!['pollOptions'].length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children:[
                                              Radio(
                                                  value: '${widget.poll!['pollOptions'][index]['id']}',
                                                  groupValue: pollValue,
                                                  fillColor: MaterialStateProperty.all(DesignCourseAppTheme.IrisBlue),
                                                  activeColor: DesignCourseAppTheme.IrisBlue,
                                                  onChanged: (value){
                                                    setState(() {
                                                      pollValue = value;
                                                      print(pollValue);
                                                    });
                                                  }
                                              ),
                                              Text(
                                                '${widget.poll!['pollOptions'][index]['value']} (${(widget.poll!['pollOptions'][index]['pollings'].length * 100 / widget.poll!['pollings'].length)} %)',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22,
                                                    fontFamily: 'Montserrat',
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme
                                                        .IrisBlue),
                                              ),
                                            ],
                                          );
                                        }
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: opacity3,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, bottom: 16, right: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[

                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: ()  async{
                                            if (compareDatesPoll()) {
                                              Get.snackbar('', '',
                                                duration: const Duration(seconds: 4),
                                                snackPosition: SnackPosition.BOTTOM,
                                                titleText: const Text('Submitting Poll',
                                                    style: TextStyle(
                                                        color: DesignCourseAppTheme.IrisBlue,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.bold)),
                                                messageText: const Text('Sorry, But The Time Is Out To Poll!', style: TextStyle(
                                                    color: DesignCourseAppTheme.IrisBlue,
                                                    fontFamily: 'Montserrat',)),
                                                backgroundColor: Colors.white,
                                                colorText: DesignCourseAppTheme.IrisBlue,
                                                icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                              );
                                              return;
                                            }
                                            if(pollValue == null){
                                              Get.snackbar('', '',
                                                duration: const Duration(seconds: 4),
                                                snackPosition: SnackPosition.BOTTOM,
                                                titleText: const Text('Submitting Poll',
                                                    style: TextStyle(
                                                        color: DesignCourseAppTheme.IrisBlue,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.bold)),
                                                messageText: const Text('You Should Choose One Answer!', style: TextStyle( color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat',)),
                                                backgroundColor: Colors.white,
                                                colorText: DesignCourseAppTheme.IrisBlue,
                                                icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                              );
                                              return;
                                            }else{
                                              Get.snackbar('', '',
                                                duration: const Duration(seconds: 3),
                                                snackPosition: SnackPosition.BOTTOM,
                                                titleText: const Text('Submitting Poll',
                                                    style: TextStyle(
                                                        color: DesignCourseAppTheme.IrisBlue,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.bold)),
                                                messageText: const Text('Submitting your choice!', style: TextStyle( color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat',)),
                                                backgroundColor: Colors.white,
                                                colorText: DesignCourseAppTheme.IrisBlue,
                                                icon: const Icon(Icons.poll_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                              );
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              var response = await http.post(
                                                  Uri.parse('https://api.irisje.tn/api/postpolling'),
                                                  body: json.encode({
                                                    'pollId': widget.poll!['id'].toString(),
                                                    'pollOptionId': pollValue.toString(),
                                                    'eagleId': prefs.getInt('eagleId').toString(),
                                                  }),
                                              );
                                              print(response.statusCode);
                                              if(response.statusCode == 201){
                                                pollValue = null;
                                                Get.to(() =>  PostsScreen());
                                                print(response.body);
                                                Get.snackbar('', '',
                                                  duration: const Duration(seconds: 3),
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  titleText: const Text('Submitting Poll',
                                                      style: TextStyle(
                                                          color: DesignCourseAppTheme.IrisBlue,
                                                          fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.bold)),
                                                  messageText: const Text('Your Choice Has Been Submitted!', style: TextStyle( color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat',)),
                                                  backgroundColor: Colors.white,
                                                  colorText: DesignCourseAppTheme.IrisBlue,
                                                  icon: const Icon(Icons.poll_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                                );
                                                Get.back();
                                                Get.back();
                                              }
                                              if(response.statusCode == 400){
                                                pollValue = null;
                                                Get.snackbar('', '',
                                                  duration: const Duration(seconds: 3),
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  titleText: const Text('Submitting Poll',
                                                      style: TextStyle(
                                                          color: DesignCourseAppTheme.IrisBlue,
                                                          fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.bold)),
                                                  messageText: const Text('You have already polled!', style: TextStyle( color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat',)),
                                                  backgroundColor: Colors.white,
                                                  colorText: DesignCourseAppTheme.IrisBlue,
                                                  icon: const Icon(Icons.poll_outlined, color: DesignCourseAppTheme.IrisBlue,),
                                                );
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: 48,
                                            decoration: const BoxDecoration(
                                              color: DesignCourseAppTheme
                                                  .IrisThirdBlue,
                                              borderRadius:
                                              BorderRadius.all(
                                                Radius.circular(16.0),
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Submit your poll choice',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  letterSpacing: 0.0,
                                                  color: DesignCourseAppTheme
                                                      .nearlyWhite,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).padding.bottom,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
                right: 35,
                child: ScaleTransition(
                  alignment: Alignment.center,
                  scale: CurvedAnimation(
                      parent: animationController!,
                      curve: Curves.fastOutSlowIn),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => CommentsScreen(
                                postId: widget.postId,
                              )));
                    },
                    child: Card(
                      color: DesignCourseAppTheme.IrisThirdBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      elevation: 10.0,
                      child: Container(
                        width: 60,
                        height: 60,
                        child: const Center(
                          child: Icon(
                            Icons.announcement,
                            color: DesignCourseAppTheme.nearlyWhite,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: SizedBox(
                  width: AppBar().preferredSize.height,
                  height: AppBar().preferredSize.height,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: DesignCourseAppTheme.nearlyBlack,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text('No Post\'s data'),
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignCourseAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  color: DesignCourseAppTheme.IrisThirdBlue,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  color: DesignCourseAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showModalDisapproval() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.85,
            builder: (_, controller) => Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Absence Justification',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          letterSpacing: 0.27,
                          color: DesignCourseAppTheme.IrisBlue),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, left: 10, right: 10),
                    child: TextFormField(
                      controller: justificationController,
                      maxLines: 5,
                      minLines: 2,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Enter your justification here',
                        hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Montserrat'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            _files = (await FilePicker.platform.pickFiles(
                              type: FileType.any,
                              allowMultiple: false,
                            ))!
                                .files;
                            print('name is ${_files!.first.name}');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: DesignCourseAppTheme.IrisThirdBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            elevation: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                 Icon(Icons.attach_file),
                                SizedBox(width: 10),
                                Text('Attach File',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontSize: 16)),],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_files == null && justificationController.text == '') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Error',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.red,
                                          fontSize: 16)),
                                  content: const Text('Please fill all the fields',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
                                          fontSize: 16)),
                                  actions: [
                                    FlatButton(
                                      child: const Text('OK',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.blue,
                                              fontSize: 16)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              });
                          return null;
                        }
                        if (_files == null) {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          var uri = Uri.parse(
                              'https://api.irisje.tn/api/disapprove');
                          final body = jsonEncode({
                            'justification': justificationController.text,
                            'engagementPost': widget.engagementPost!['id'],
                            'eagle': preferences.getInt('eagleId'),
                          });
                          var response = await http.post(uri, body: body);
                          if (response.statusCode == 400) {
                            Navigator.of(context).pop();
                            Get.snackbar('', '',
                              duration: const Duration(seconds: 4),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white,
                              titleText: const Text('Absence Confirmation', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                              messageText: const Text('Your have already approved/disapproved your presence!', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat'),),
                              colorText: DesignCourseAppTheme.IrisBlue,
                              icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                            );
                            justificationController.clear();
                          }
                          if (response.statusCode == 201) {
                            Navigator.of(context).pop();
                            Get.snackbar('', '',
                              duration: const Duration(seconds: 4),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white,
                              titleText: const Text('Absence Confirmation', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                              messageText: const Text('Your absence has been confirmed successfully!', style: TextStyle(color: DesignCourseAppTheme.IrisBlue, fontFamily: 'Montserrat'),),
                              colorText: DesignCourseAppTheme.IrisBlue,
                              icon: const Icon(Icons.timer_outlined, color: DesignCourseAppTheme.IrisBlue,),
                            );
                          }
                          print(response.statusCode);
                          justificationController.clear();
                        } else {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          Map<String, String> headers = {
                            "eagleId": preferences.getInt('eagleId').toString(),
                            "engagementPostId":
                                widget.engagementPost!['id'].toString(),
                            'justification': justificationController.text
                          };
                          var uri =
                              Uri.parse('https://api.irisje.tn/api/img');
                          var request = http.MultipartRequest('POST', uri);
                          request.headers.addAll(headers);
                          request.files.add(await http.MultipartFile.fromPath(
                              'file', _files!.first.path.toString()));
                          var response = await request.send();

                          print(response.statusCode);
                          print(response.stream.toString());
                          Navigator.pop(context);
                          _files!.clear();
                          justificationController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: DesignCourseAppTheme.IrisThirdBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 10.0,
                      ),
                      child: const Text('Send',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 16))),
                ],
              ),
            ),
          );
        });
  }

  bool compareDates(){
    if (DateTime.now().isAfter(DateTime.parse(widget.engagementPost!['start']).subtract(const Duration(hours: 24)))) {
        return true;
    }else{
      return false;
    }
  }
  bool compareDatesForPresence(){
    if (DateTime.now().isAfter(DateTime.parse(widget.engagementPost!['start']))) {
        return true;
    }else{
      return false;
    }
  }
  bool compareDatesPoll(){
    if (voted || DateTime.now().subtract(const Duration(hours: 24)) == DateTime.parse(widget.poll!['end']) || DateTime.now().isAfter(DateTime.parse(widget.poll!['end']))) {
        return true;
    }else{
      return false;
    }
  }
}

