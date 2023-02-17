import 'dart:convert';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/design_course_app_theme.dart';

class StoreDetailsScreen extends StatefulWidget {
  final String productName;
  final String productId;
  final String productCategory;
  final int productPrice;
  //final Map<String, dynamic>? poll;
  final List<dynamic>? images;
  final List<dynamic>? options;

  const StoreDetailsScreen({
    Key? key,
    required this.productName,
    required this.productId,
    required this.productCategory,
    required this.productPrice,
    required this.images,
    required this.options,
  }) : super(key: key);

  @override
  _StoreDetailsScreenState createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;

  AnimationController? animationController;
  TextEditingController justificationController = TextEditingController();
  Animation<double>? animation;
  dynamic pollValue;
  bool voted = false;
  int selectedIndex = 0;
  List<PlatformFile>? _files;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  int quantityCounter = 1;

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
                        itemCount: widget.images!.length,
                        itemBuilder: (context, index) {
                          return FullScreenWidget(
                            backgroundIsTransparent: true,
                            disposeLevel: DisposeLevel.High,
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Image.network(
                                'https://api.irisje.tn/products/${widget.images![index]}',
                                headers: const {
                                  'Connection': 'keep-alive',
                                  'Keep-alive': 'timeout=5, max=1000',
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: (MediaQuery.of(context).size.width / 1.2),
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
                                  '${widget.productName}  -  ${widget.productPrice.toString()} DT',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    fontFamily: 'Montserrat',
                                    color: DesignCourseAppTheme.IrisBlue,
                                  ),
                                ),
                              ),
                              //Text('data'),
                              SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 8, top: 16),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      child: Row(
                                        children: <Widget> [
                                         widget.options != null  ? Container(
                                            width: MediaQuery.of(context).size.width - 48,
                                            height: MediaQuery.of(context).size.height * 0.5,
                                            child: ListView.builder(
                                                itemCount: widget.options?.length,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                          selectedIndex=index;
                                                        });
                                                      },
                                                      child: getTimeBoxUI(widget.options?[index],'',index)
                                                  );
                                                }
                                            ),
                                          ) : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Row(
                                  children:  [
                                    InkWell(
                                      onTap: () => decrementCounter(),
                                      child: const Icon(
                                        Icons.remove,
                                        color: DesignCourseAppTheme.IrisBlue,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                    Text(quantityCounter.toString()),
                                    const SizedBox(width: 20,),
                                    InkWell(
                                      onTap: () => incrementCounter(),
                                      child: const Icon(
                                        Icons.add,
                                        color: DesignCourseAppTheme.IrisBlue,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: opacity2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18, right: 16, top: 20, bottom: 8),
                                    child: Text(
                                      'Total price : ${widget.productPrice*quantityCounter} DT',
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat",
                                        fontSize: 18,
                                        letterSpacing: 0.27,
                                        color: DesignCourseAppTheme.IrisBlue,
                                      ),
                                      maxLines: 30,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).padding.bottom,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (MediaQuery.of(context).size.width / 1.2) - 35,
                right: 35,
                child: ScaleTransition(
                  alignment: Alignment.center,
                  scale: CurvedAnimation(
                      parent: animationController!,
                      curve: Curves.fastOutSlowIn),
                  child: InkWell(
                    onTap: () {
                      confirmOrderProduct(widget.productName, widget.productPrice, widget.options?[selectedIndex], quantityCounter,widget.productId);
                    },
                    child: Card(
                      color: DesignCourseAppTheme.IrisSecondBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      elevation: 10.0,
                      child: Container(
                        width: 60,
                        height: 60,
                        child: const Center(
                          child: Icon(
                            Icons.shopping_cart_checkout_outlined,
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

  Widget getTimeBoxUI(String text1, String txt2,int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: selectedIndex==index ? Colors.grey[200] : DesignCourseAppTheme.nearlyWhite,
          borderRadius:  BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
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
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.IrisBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void incrementCounter(){
    setState(() {
      quantityCounter++;
    });
  }
  void decrementCounter(){
    setState(() {
      if(quantityCounter>1){
        quantityCounter--;
      }
    });
  }

  confirmOrderProduct(productName,productPrice,options,quantity,productId) async {
    print(widget.productId);
    // show dialog to confirm order
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: const Text('Confirmation Order',style: TextStyle(color: DesignCourseAppTheme.IrisBlue),),
            content:  Text('Your order contains : \n\n Product:  $productName \n\n Quantity: $quantity \n\n ${options!=null?'Options: $options \n\n':''} Total: ${productPrice * quantity} DT',style: TextStyle(color: DesignCourseAppTheme.IrisBlue),),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  orderProduct(productId,productPrice,options,quantity);
                  Navigator.of(context).pop();
                  // order product
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        });
  }

  orderProduct(productId,productPrice,options,quantity) async {
    // get user id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getInt('eagleId').toString();
    // send order to server
    var response = await http.post(Uri.parse('https://api.irisje.tn/api/order/$productId/$quantity/$userId/$options'));
    if(response.statusCode == 200){
      // order success
      // show dialog
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: const Text('Order Success',style: TextStyle(color: DesignCourseAppTheme.IrisBlue),),
              content:  const Text('Your order has been sent successfully \n\n You can check it\'s status in your Profile -> Orders section',style: TextStyle(color: DesignCourseAppTheme.IrisBlue),),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });
  }
    else{
      // order failed
      // show dialog
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: const Text('Order Failed',style: TextStyle(color: DesignCourseAppTheme.IrisBlue),),
              content:  const Text('Your order has been failed',style: TextStyle(color: DesignCourseAppTheme.IrisBlue),),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });
      print(jsonDecode(response.body));
    }

}
}

