import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris_nest_app/screens/Iris_biblio.dart';
import 'package:iris_nest_app/screens/blame_screen.dart';
import 'package:iris_nest_app/screens/contact_screen.dart';
import 'package:iris_nest_app/screens/home_drawer.dart';
import 'package:iris_nest_app/screens/posts_screen.dart';
import 'package:iris_nest_app/screens/profile_screen.dart';
import 'package:iris_nest_app/screens/shop_screen.dart';
import 'package:iris_nest_app/screens/store_details_screen.dart';
import 'package:iris_nest_app/themes/app_theme.dart';
import 'package:iris_nest_app/themes/design_course_app_theme.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;
  int currentIndex = 2;
  final screens = [
    IrisBiblioScreen(),
    BlameScreen(),
    PostsScreen(),
    //LoginEaglePage(),
    //ContactScreen(),
    ShopScreen(),
    //mainPageTask(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = PostsScreen();
    //screenView = PostsScreen();
    super.initState();
  }
  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Column(
        children: const [
          Icon(Icons.menu_book_outlined, size: 30),
          Text(
            'Library',
            style:
            TextStyle(fontSize: 13, color: DesignCourseAppTheme.IrisBlue,fontFamily: 'Montserrat'),
          )
        ],
      ),
      Column(
        children: const [
          Icon(Icons.error_outline_outlined, size: 30),
          Text(
            'Blame',
            style:
            TextStyle(fontSize: 13, color: DesignCourseAppTheme.IrisBlue,fontFamily: 'Montserrat'),
          )
        ],
      ),
      Column(
        children:  [
          Icon(Icons.home_outlined, size: 30),
          Text(
            'Home',
            style:
            TextStyle(fontSize: 13, color: DesignCourseAppTheme.IrisBlue,fontFamily: GoogleFonts.montserrat().fontFamily),
          )
        ],
      ),
      Column(
        children: const [
          Icon(Icons.contact_page_outlined, size: 30),
          Text(
            'Contact',
            style:
                TextStyle(fontSize: 13, color: DesignCourseAppTheme.IrisBlue,fontFamily: 'Montserrat'),
          )
        ],
      ),
      Column(
        children: const [
          Icon(Icons.perm_identity_outlined, size: 30),
          Text(
            'Profile',
            style:
                TextStyle(fontSize: 13, color: DesignCourseAppTheme.IrisBlue,fontFamily: "Montserrat"),
          )
        ],
      ),
    ];
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: ClipRect(
          child: Scaffold(
            backgroundColor: AppTheme.nearlyWhite,
            body: screens[currentIndex],
            bottomNavigationBar: BubbleBottomBar(
              opacity: .2,
              onTap: changePage,
              currentIndex: currentIndex,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              elevation: 8,
              hasNotch: true,
              hasInk: true,
              inkColor: Colors.black12,
              items: const <BubbleBottomBarItem> [
                BubbleBottomBarItem(backgroundColor: DesignCourseAppTheme.IrisBlue, icon: Icon(Icons.menu_book_outlined, color: DesignCourseAppTheme.IrisBlue,), activeIcon: Icon(Icons.menu_book_outlined, color: DesignCourseAppTheme.IrisBlue,), title: Text("Library",style: TextStyle(fontFamily: "Montserrat",color: DesignCourseAppTheme.IrisBlue),)),
                BubbleBottomBarItem(backgroundColor: DesignCourseAppTheme.IrisBlue, icon: Icon(Icons.warning_amber_outlined, color: DesignCourseAppTheme.IrisBlue,), activeIcon: Icon(Icons.warning_amber_outlined, color: DesignCourseAppTheme.IrisBlue,), title: Text("Blame",style: TextStyle(fontFamily: "Montserrat",color: DesignCourseAppTheme.IrisBlue),)),
                BubbleBottomBarItem(backgroundColor: DesignCourseAppTheme.IrisBlue, icon: Icon(Icons.home_outlined, color: DesignCourseAppTheme.IrisBlue,), activeIcon: Icon(Icons.home_outlined, color: DesignCourseAppTheme.IrisBlue,), title: Text("Home",style: TextStyle(fontFamily: "Montserrat",color: DesignCourseAppTheme.IrisBlue),)),
                BubbleBottomBarItem(backgroundColor: DesignCourseAppTheme.IrisBlue, icon: Icon(Icons.shopping_bag_outlined, color: DesignCourseAppTheme.IrisBlue,), activeIcon: Icon(Icons.shopping_bag_outlined, color: DesignCourseAppTheme.IrisBlue,), title: Text("Store",style: TextStyle(fontFamily: "Montserrat",color: DesignCourseAppTheme.IrisBlue),)),
                BubbleBottomBarItem(backgroundColor: DesignCourseAppTheme.IrisBlue, icon: Icon(Icons.perm_identity_outlined, color: DesignCourseAppTheme.IrisBlue,), activeIcon: Icon(Icons.perm_identity_outlined, color: DesignCourseAppTheme.IrisBlue,), title: Text("Profile",style: TextStyle(fontFamily: "Montserrat",color: DesignCourseAppTheme.IrisBlue),)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = PostsScreen();
            //screenView = PostsScreen();
          });
          break;
        case DrawerIndex.Library:
          setState(() {
            screenView = IrisBiblioScreen();
          });
          break;
        case DrawerIndex.Blame:
          setState(() {
            screenView = BlameScreen();
          });
          break;
        case DrawerIndex.Contact:
          setState(() {
            screenView = ShopScreen();
          });
          break;
        default:
          break;
      }
    }
  }
}
