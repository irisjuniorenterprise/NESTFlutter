import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iris_nest_app/themes/design_course_app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'navigation_home_screen.dart';

class LoginEaglePage extends StatefulWidget {
  //static final String path = "lib/src/pages/login/login7.dart";
  @override
  _LoginEaglePageState createState() => _LoginEaglePageState();
}

class _LoginEaglePageState extends State<LoginEaglePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  bool rememberMe = false;
  bool hidePassword = true;
  bool isLoggingIn = false;
  var fcmToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    _firebaseMessaging.getToken().then((token) {
      print(token);
      print('*********');
      setState(() {
        fcmToken = token;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              // image
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/introduction_animation/nest2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Material(
                  elevation: 2.0,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: TextFormField(
                    controller: emailController,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "Please enter an email";
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,5}').hasMatch(input)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String value){},
                    cursorColor: DesignCourseAppTheme.IrisOrange,
                    decoration: const InputDecoration(
                        hintText: "Email",
                        prefixIcon: Material(
                          elevation: 0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Icon(
                            Icons.email,
                            color: DesignCourseAppTheme.IrisOrange,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Material(
                  elevation: 2.0,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: TextFormField(
                    obscureText: hidePassword,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "Please enter a password";
                      }
                      return null;
                    },
                    controller: passwordController,
                    onChanged: (String value){},
                    cursorColor: DesignCourseAppTheme.IrisOrange,
                    decoration: InputDecoration(
                       suffixIcon: IconButton(
                          onPressed: () {
                          setState(() {
                          hidePassword = !hidePassword;
                          });
                          },
                          color:
                          Theme.of(context).focusColor.withOpacity(0.4),
                          icon: Icon(hidePassword
                          ? Icons.visibility_off
                              : Icons.visibility),
                          ),
                        hintText: const Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                          ),
                        ).data,
                        prefixIcon: const Material(
                          elevation: 0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Icon(
                            Icons.lock,
                            color: DesignCourseAppTheme.IrisOrange,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Row(
                    children: [
                      Checkbox(
                          value: rememberMe,
                          onChanged: (value){
                            setState(() {
                              rememberMe = value!;
                            });
                          }
                      ),
                      const Text(
                          'Remember me',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                height: 25,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.37,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: DesignCourseAppTheme.IrisBlue),
                    child: Row(
                      children: [
                        FlatButton(
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          onPressed: () async {
                            print(isLoggingIn);
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                isLoggingIn = true;
                              });
                              print(isLoggingIn);
                            }
                            if(rememberMe == true){
                              rememberEagle();
                              loginEagle();
                            }else{loginEagle();}
                          },
                        ),
                        isLoggingIn
                            ? const Padding(
                              padding: EdgeInsets.only(right: 1.5),
                              child:  CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                            )
                            :
                        const Icon(Icons.arrow_forward_ios_outlined,
                            color: Colors.white),
                      ],
                    ),
                  )),
              const SizedBox(height: 20,),
            ],),
          ),
          /* Center(
            child: Text("FORGOT PASSWORD ?", style: TextStyle(color:Colors.red,fontSize: 12 ,fontWeight: FontWeight.w700),),
          ), */
          const SizedBox(height: 40,),
          /*
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Don't have an Account ? ", style: TextStyle(color:Colors.black,fontSize: 12 ,fontWeight: FontWeight.normal),),
              Text("Sign Up ", style: TextStyle(color:Colors.red, fontWeight: FontWeight.w500,fontSize: 12, decoration: TextDecoration.underline )),

            ],
          ),*/
        ],
      ),
    );
  }

  void loginEagle() async{
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        isLoggingIn = false;
      });
      return;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final body = jsonEncode({
      'email': emailController.text.toLowerCase(),
      'password': passwordController.text,
      'fcmtoken': fcmToken,
    });
    final url = Uri.parse('https://api.irisje.tn/api/tokens');
    final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
        body: body
    );
    print('response.body');
    print(response.body);
    final responseData = json.decode(response.body);
    final statusCode = response.statusCode;
    print(statusCode);
    print(responseData['message']);
    if(responseData['message'] == 'User not found'){
      setState(() {
        isLoggingIn = false;
      });
      Get.snackbar('Access denied', 'Sorry, Please check your email or password!',
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: DesignCourseAppTheme.IrisBlue,
        icon: const Icon(FontAwesomeIcons.ban, color: DesignCourseAppTheme.IrisBlue,),
      );
      return;
    }
    if(responseData['message'] == 'Wrong password'){
      setState(() {
        isLoggingIn = false;
      });
      Get.snackbar('Access denied', 'Sorry, Please check your email or password!',
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: DesignCourseAppTheme.IrisBlue,
        icon: const Icon(FontAwesomeIcons.ban, color: DesignCourseAppTheme.IrisBlue,),
      );
      return;
    }
    if(responseData['user']['email'] == emailController.text) {
      preferences.setBool('EagleLoggedIn', true);
      preferences.setString('token', responseData['token']);
      preferences.setInt('eagleId', responseData['user']['id']);
      preferences.setString('eagleEmail', responseData['user']['email']);
      //preferences.setString('eagleRoles', responseData['user']['roles']['role']);
      preferences.setString('eagleFName', responseData['user']['fName']);
      preferences.setString('eagleLName', responseData['user']['lName']);
      preferences.setString('eagleLName', responseData['user']['lName']);
      preferences.setString('eaglePhone', responseData['user']['phone']);
      preferences.setString('eagleBirthday', responseData['user']['birthday']);
      preferences.setString('eagleAddress', responseData['user']['adress']);
      preferences.setString('eagleImg', responseData['user']['img']);
      preferences.setString('eagleUniversity', responseData['user']['university']['name']);
      preferences.setString('eagleStudyField', responseData['user']['studyField']['field']);
      preferences.setString('eagleDepartment', responseData['user']['department']['name']);
      Navigator.of(context).popUntil((route) => route.isFirst);

      // Push the home page onto the navigation stack
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => NavigationHomeScreen(),
        ),
      );
      //Get.pop(NavigationHomeScreen());
    }
  }

  void rememberEagle() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('Remember me', rememberMe);
  }

}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}