import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../themes/design_course_app_theme.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
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
        title: const Center(child: Text('Contact IRIS')),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ContactUs(
          companyFontSize: 30,
          logo: const AssetImage('assets/images/iris.jpg'),
          email: 'administration@irisje.com',
          companyName: 'IRIS Junior Enterprise',
          phoneNumber: '+225 00 00 00 00',
          website: 'https://www.irisje.com',
          githubUserName: 'irisje',
          linkedinURL: 'https://www.linkedin.com/company/iris-junior-enterprise/',
          tagLine: '#ToTheNextLevel',
          twitterHandle: '@irisje',
          instagram: '@irisje',
          facebookHandle: '@irisje',
          taglineColor: Colors.blue,
          dividerColor: DesignCourseAppTheme.IrisBlue,
          textColor: DesignCourseAppTheme.IrisBlue,
          cardColor: DesignCourseAppTheme.nearlyWhite,
          companyColor: DesignCourseAppTheme.IrisBlue,
        ),
      ),
    );
  }
}
