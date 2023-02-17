import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iris_nest_app/widgets/icon_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../themes/design_course_app_theme.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({Key? key}) : super(key: key);

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}



class _OrdersListScreenState extends State<OrdersListScreen> {
  void initState() {
    super.initState();
    getOrders();
  }
  List orders = [];
  bool isLoading = true;
  getOrders() async{
    // get eagle id from shared preferences
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var eagleId = preferences.getInt('eagleId');
    var url = Uri.parse('https://api.irisje.tn/api/orders/${eagleId.toString()}');
    var response = await http.get(url);
    if(response.statusCode == 200) {
      print('true');
      //jsonDecode(response.body);
      //var items = json.decode(response.body);
      var body = response.body;
      var items = jsonDecode(body);
      print(items);
      setState(() {
        orders = items;
        isLoading = false;
      });
    }else{
      orders = [];

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
        title: const Center(child: Text('Orders',style: TextStyle(fontFamily: 'Montserrat',fontSize: 18),)),
      ),
      body: isLoading == true ?  Center(child: IconProgressIndicator(isLoading: isLoading,))
          :
      ListView.builder(
        itemCount: orders.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ExpansionTile(
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.centerLeft,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(' Order N°: ${orders[index]['id']}',
                            style: const TextStyle(
                                fontSize: 14,
                                color: DesignCourseAppTheme.IrisBlue,
                                fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: orders[index]['status'] == 'Pending' ? Colors.orange : orders[index]['status'] == 'Delivered' ? Colors.green : Colors.red,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 1.5),
                              child: Text(orders[index]['status'],
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      leading: const Icon(Icons.shopping_cart_outlined),
                      trailing: const Icon(Icons.keyboard_arrow_down_outlined),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Order Date: ${DateFormat('dd-MM-yyyy kk:mm').format(DateTime.parse(orders[index]['date']))}',
                                style: const TextStyle(
                                    fontSize: 15,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Text('Product name : ${orders[index]['product']['name']}', style: const TextStyle(
                                  fontSize: 15,
                                fontFamily: "Montserrat",
                              ),),
                              const SizedBox(height: 5,),
                              Text('Product price : ${orders[index]['product']['price']} DT', style: const TextStyle(
                                  fontSize: 15,
                                fontFamily: "Montserrat",
                              ),),
                              const SizedBox(height: 5,),
                              Text('Product quantity : ${orders[index]['qty']}', style: const TextStyle(
                                  fontSize: 15,
                                fontFamily: "Montserrat",
                              ),),
                              const SizedBox(height: 5,),
                              Text('Option : ${orders[index]['_option']}', style: const TextStyle(
                                  fontSize: 15,
                                fontFamily: "Montserrat",
                              ),),
                              const SizedBox(height: 5,),
                              Text('Total price : ${orders[index]['qty'] * orders[index]['product']['price']} DT', style: const TextStyle(
                                  fontSize: 15,
                                fontFamily: "Montserrat",
                              ),),
                              const SizedBox(height: 15,),
                              orders[index]['status']=='Pending'? InkWell(
                                onTap: () => cancelOrder(orders[index]['id'],orders[index]),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red,
                                  ),
                                  child: const Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: 8.0,vertical: 1.5),
                                    child:  Text('X Cancel',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  : Container(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
  cancelOrder(id,order) async {
    // show dialog to confirm cancel
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (DateTime.now().subtract(const Duration(hours: 48)).isAfter(DateTime.parse(order['date']))) {
          return  AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: const Text('Cancellation order',style: TextStyle(color: DesignCourseAppTheme.IrisBlue,fontFamily: 'Montserrat'),),
              content:  const Text('Unfortunately, it is no longer possible to cancel your order. Our policy states that orders can only be cancelled within 48 hours of being placed. We apologize for any inconvenience this may cause.',style: TextStyle(color: DesignCourseAppTheme.IrisBlue,fontFamily: 'Montserrat'),),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok',style: TextStyle(fontFamily: 'Montserrat'),),
                ),
              ],
            );
          }
          else{
          return  AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: const Text('Cancellation order',style: TextStyle(color: DesignCourseAppTheme.IrisBlue,fontFamily: 'Montserrat'),),
            content:  const Text('Are you sure you want to cancel this order?',style: TextStyle(color: DesignCourseAppTheme.IrisBlue,fontFamily: 'Montserrat'),),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No',style: TextStyle(fontFamily: 'Montserrat'),),
              ),
              TextButton(
                onPressed: () async {
                  var url = Uri.parse('https://api.irisje.tn/api/cancel/$id');
                  var response = await http.get(url);
                  if (response.statusCode == 200) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(32.0))),
                            title: const Text('Cancellation order',style: TextStyle(color: DesignCourseAppTheme.IrisBlue,fontFamily: 'Montserrat'),),
                            content:  const Text('Order cancelled successfully',style: TextStyle(color: DesignCourseAppTheme.IrisBlue,fontFamily: 'Montserrat'),),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  getOrders();
                                },
                                child: const Text('OK',style: TextStyle(color: DesignCourseAppTheme.IrisBlue,fontFamily: 'Montserrat'),),
                              ),
                            ],
                          );
                        });

                  }
                },
                child: const Text('Yes',style: TextStyle(fontFamily: 'Montserrat'),),
              ),
            ],
          );
          }
        });
  }
}
