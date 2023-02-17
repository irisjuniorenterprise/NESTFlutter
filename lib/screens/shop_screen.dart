import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:iris_nest_app/screens/store_details_screen.dart';
import '../themes/app_theme.dart';
import '../themes/design_course_app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/hotel_app_theme.dart';
import '../widgets/icon_progress_indicator.dart';
import 'course_info_screen.dart';
import 'home_design_course.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  Animation<double>? animation;
  CategoryType categoryType = CategoryType.ui;
  VoidCallback? callback;
  List products = [];
  List categories = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCategories();
    this.getProducts('All');
  }

  getProducts(category) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var target = preferences.getString('eagleDepartment');
    var url = Uri.parse('https://api.irisje.tn/api/products/${category}');
    var response = await http.get(url, headers: {
      'category': '$category',
    });
    if (response.statusCode == 200) {
      print('truehh');
      var body = response.body;
      var items = jsonDecode(body);
      print(items);
      setState(() {
        products = items;
        isLoading = false;
      });
    } else {
      products = [];
    }
  }
  getCategories() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var target = preferences.getString('eagleDepartment');
    var url = Uri.parse('https://api.irisje.tn/api/categories');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('true');
      //jsonDecode(response.body);
      //var items = json.decode(response.body);
      var body = response.body;
      var items = jsonDecode(body);
      print(items);
      setState(() {
        categories = items;
        isLoading = false;
      });
    } else {
      categories = [];
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
        title: const Center(
            child: Text(
          'IRIS Store',
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
        )),
      ),
      body: isLoading == true ? Center(child: IconProgressIndicator(isLoading: isLoading,))
          : Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                          itemCount: categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      IconProgressIndicator(isLoading: isLoading);
                                      getProducts(categories[index]['name']);
                                      print('is clicked ${isLoading}');
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 1,
                                            ),
                                            Text(
                                              categories[index]['name'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10,
                                                  fontFamily: "Montserrat",
                                                  color: DesignCourseAppTheme.IrisBlue),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                    color: DesignCourseAppTheme.IrisBlue, thickness: 1),
                Container(
                  height: MediaQuery.of(context).size.height * 0.67,
                  child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        Size size = MediaQuery.of(context).size;
                        return SizedBox(
                          height: size.height - 250,
                          width: size.width,
                          child: Scaffold(
                            body: ListView.builder(
                                itemCount: products.length,
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
                                                StoreDetailsScreen(
                                              productName: getProductName(products[index.toInt()]),
                                              productPrice: getProductPrice(products[index.toInt()]),
                                              images: getProductImages(products[index.toInt()]),
                                              productCategory: getProductCategory(products[index.toInt()]),
                                              productId: getProductId(products[index.toInt()]),
                                                  options: getProductOptions(products[index.toInt()]),
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
                                              color:
                                                  Colors.grey.withOpacity(0.4),
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
                                                    aspectRatio: 1,
                                                    child: Image.asset(
                                                      'assets/images/product.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    color: HotelAppTheme
                                                            .buildLightTheme()
                                                        .backgroundColor,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 16,
                                                                      top: 8,
                                                                      bottom:
                                                                          8),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    '${getProductName(products[index])}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          18,
                                                                      color: DesignCourseAppTheme
                                                                          .IrisBlue,
                                                                      fontFamily:
                                                                          "Montserrat",
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      const Icon(
                                                                        FontAwesomeIcons
                                                                            .dollarSign,
                                                                        size:
                                                                            12,
                                                                        color: DesignCourseAppTheme
                                                                            .IrisOrange,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Text(
                                                                        '${getProductPrice(products[index])} DT',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                "Montserrat",
                                                                            color: DesignCourseAppTheme.IrisOrange,
                                                                        fontWeight: FontWeight.bold),
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
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 16,
                                                                  top: 15),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: const <
                                                                Widget>[
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_ios_outlined,
                                                                color: DesignCourseAppTheme
                                                                    .IrisOrange,
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

  _snackBarLoading() {
    return Scaffold.of(context).showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 250, left: 150, right: 150),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 500),
      backgroundColor: DesignCourseAppTheme.IrisBlue,
      elevation: 60,
      content: const Padding(
            padding: EdgeInsets.only(left: 1),
            child: CircularProgressIndicator(),
          ),

    ));
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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

  String getProductName(index) {
    print('index is: $index');
    var name = index['name'];
    return name;
  }
  int getProductPrice(index) {
    var price = index['price'];
    return price;
  }

  String getProductId(index) {
    var id = index['id'].toString();
    return id;
  }

  String getProductCategory(index) {
    return index['category']['name'];
  }
  List<dynamic>? getProductImages(index) {
    return index['imgs'];
  }
  List<dynamic>? getProductOptions(index) {
    return index['options'];
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
