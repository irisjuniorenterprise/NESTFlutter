import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iris_nest_app/screens/orders_list_screen.dart';
import 'package:iris_nest_app/screens/task%20manager/taskManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../introduction_animation/introduction_animation_screen.dart';
import '../themes/design_course_app_theme.dart';
import '../widgets/icon_progress_indicator.dart';
import 'eagle_contact_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  List data = [];


  getEagleData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      data = [
        preferences.getString('eagleEmail'),
        preferences.getString('eaglePhone'),
        preferences.getString('eagleBirthday'),
        preferences.getString('eagleAddress'),
        preferences.getString('eagleUniversity'),
        preferences.getString('eagleDepartment'),
        preferences.getString('eagleImg'),
        preferences.getString('eagleFName'),
        preferences.getString('eagleLName'),
      ];
      isLoading = false;
    });
    print(data);
  }

  @override
  void initState() {
    super.initState();
    getEagleData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == false ?  Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/introduction_animation/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                   Container(
                            height: 150,
                            width: 150,
                            margin: const EdgeInsets.only(
                              top: 70,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 10,
                                ),
                              ],
                              image: DecorationImage(
                                  image: NetworkImage(
                                  'https://api.irisje.tn/${data[6]}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    Text(
                      data[7].toString().toUpperCase() + ' ' + data[8].toString().toUpperCase(),
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        color: DesignCourseAppTheme.IrisBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${data[5].toString().toUpperCase()} Department",
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        color: DesignCourseAppTheme.IrisBlue,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 24,
                        right: 24,
                        bottom: 45,
                      ),
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 10,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "PROFILE",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              color: DesignCourseAppTheme.IrisBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          listProfile(Icons.person, "Full Name",
                              data[7].toString().toUpperCase() + ' ' + data[8].toString().toUpperCase()),
                          listProfile(Icons.email_outlined, "Email", data[0]),
                          listProfile(Icons.date_range, "Date of Birth",
                              DateFormat.yMMMd().format(DateTime.parse(data[2]))),
                          listProfile(Icons.location_pin, "Location", data[3]),
                          listProfile(Icons.apartment_outlined, "University",
                              data[4].toString().toUpperCase()),
                          listProfile(Icons.phone, "Phone Number", data[1]),
                          /*SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => mainPageTask(),
                                              ),
                                            ),
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    "Task Manager",
                                                    style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: DesignCourseAppTheme.IrisBlue,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: SvgPicture.asset(
                                                      "assets/images/schedule-icon.svg",
                                                      color: DesignCourseAppTheme.IrisBlue,
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    onPressed: () {Get.to(mainPageTask());},
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]
                                      ),
                                    )
                                  ]
                                ),
                              ),
                            ),
                          ),*/
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () => logout(),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.exit_to_app,
                                                color: DesignCourseAppTheme.IrisBlue,
                                              ),
                                              onPressed: () {},
                                            ),
                                            const Text(
                                              "Logout",
                                              style: TextStyle(
                                                fontFamily: "Montserrat",
                                                color: DesignCourseAppTheme.IrisBlue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const OrdersListScreen(),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.shopping_cart,
                                                color: DesignCourseAppTheme.IrisBlue,
                                              ),
                                              onPressed: () {},
                                            ),
                                            const Text(
                                              "Orders",
                                              style: TextStyle(
                                                fontFamily: "Montserrat",
                                                color: DesignCourseAppTheme.IrisBlue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    /*InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatUi(),
                                        ),
                                      ),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Eagles",
                                              style: TextStyle(
                                                fontFamily: "Montserrat",
                                                color: DesignCourseAppTheme.IrisBlue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            IconButton(
                                              icon: SvgPicture.asset(
                                                "assets/images/eagle.svg",
                                                color: DesignCourseAppTheme.IrisBlue,
                                                height: 20,
                                                width: 20,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    )*/
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ) :  Center(child: IconProgressIndicator(isLoading: isLoading,));
  }

  Widget listProfile(IconData icon, String text1, String text2) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: DesignCourseAppTheme.IrisBlue,
            size: 20,
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: const TextStyle(
                  color: DesignCourseAppTheme.IrisBlue,
                  fontFamily: "Montserrat",
                  fontSize: 14,
                ),
              ),
              Text(
                text2,
                style: const TextStyle(
                  color: DesignCourseAppTheme.IrisBlue,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => IntroductionAnimationScreen(),
        ),
        (Route<dynamic> route) => false
    );
  }
}


