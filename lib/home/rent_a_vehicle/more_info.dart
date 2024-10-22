import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:carrental/backendcode/registerRentVehicle.dart';
import 'package:carrental/screens/all.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../backendcode/fetchUserData.dart';
import '../../backendcode/fetchVehicleData.dart';
class more_info extends StatefulWidget{
  final String ID;
  more_info(
      this.ID
      );
  @override
  State<more_info> createState() => _more_infoState();
}

class _more_infoState extends State<more_info> {
  List<DateTime?> _selectedDates = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 3))
  ];
  String firstDate = DateTime.now().toLocal().toString();
  String lastDate = DateTime.now().toLocal().add(Duration(days: 3)).toString();

  void showAlert(String result, Color displaycolor){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Center(
            child: texts(result, 18.sp,displaycolor, FontWeight.normal),

          ),
        ),
      );
    }) ;
  }

  final config = CalendarDatePicker2Config(
    calendarType: CalendarDatePicker2Type.range,
    selectedDayHighlightColor: Color.fromRGBO(228, 221, 205, 1),
    allowSameValueSelection: true,
    selectedRangeHighlightColor: Colors.white24,
      firstDate: DateTime.now(), // Past dates visible
      lastDate: DateTime(2100),
      selectableDayPredicate: (day) {
        DateTime today = DateTime.now();
        return day.isAfter(DateTime(today.year, today.month, today.day).subtract(Duration(days: 1)));
      },
      weekdayLabelTextStyle:
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    controlsTextStyle: TextStyle(color: Colors.white),
    dayTextStyle: TextStyle(color: Colors.white),
      animateToDisplayedMonthDate: true,
    selectedDayTextStyle: TextStyle(color: Colors.black),
    monthTextStyle: TextStyle(color: Colors.white),
    selectedMonthTextStyle:  TextStyle(color: Colors.black),
    yearTextStyle: TextStyle(color: Colors.white),
      selectedYearTextStyle:  TextStyle(color: Colors.black)
  );




  List<dynamic> vehicleInformation = [];
  List<dynamic> userInformation = [];

  @override
  void initState() {
    super.initState();
    _loadVehicleData();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  Future<void> _loadVehicleData() async {
    final data = await fetchVehicleData(widget.ID);
    if (data.isNotEmpty) {
      setState(() {
        vehicleInformation = data;
      });
      _loadUserData(vehicleInformation[0]['firebaseID'].toString());
    } else {
      print("Vehicle data is empty");
    }
  }

  Future<void> _loadUserData(String firebaseID) async {
    final udata = await fetchUserData(firebaseID);
    if (udata.isNotEmpty) {
      setState(() {
        userInformation = udata;
      });
    } else {
      print("User data is empty");
    }
  }

  Future<void> _saveRentingInfo() async{
    final renterFirebaseID = await FirebaseAuth.instance.currentUser!.uid.toString();
    final ownerFirebaseID = vehicleInformation[0]['firebaseID'].toString();
    final vehicleID = vehicleInformation[0]['_id'].toString();
    var bookedDate = DateTime.now().toIso8601String();
    var dateRentFrom = _selectedDates[0]!.toIso8601String();
    var dateRentTo = _selectedDates[1]!.toIso8601String();
    if(renterFirebaseID!=ownerFirebaseID) {
      var result = await registerRentVehicle(
          renterFirebaseID,
          ownerFirebaseID,
          vehicleID,
          bookedDate,
          dateRentFrom,
          dateRentTo);
      if(result==true){
        showAlert("The owner will connect with you soon!", Colors.green);
      }
      else{
        showAlert("Car not available on these dates! Choose another date", Colors.red);
      }
    }
    else{
      showAlert("Owner cannot rent his own vehicle", Colors.red);
    }
  }

  Razorpay razorpay = Razorpay();

  @override
  void dispose() {
    razorpay.clear(); // Clear razorpay listeners on dispose
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    showAlert("Payment Sucessfull!!\nBooking Confirmed", Colors.green);
    await _saveRentingInfo();
    print("Saved");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showAlert("Payment Unscessfull!!", Colors.red);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: vehicleInformation.isNotEmpty
            ?texts(vehicleInformation[0]['vehicleName'], 20.sp, Colors.white,FontWeight.w400): texts("Loading", 20.sp, Colors.white, FontWeight.w400),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundimg.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: vehicleInformation.isNotEmpty?SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30.h,
                              width:95.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Image.network(vehicleInformation[0]['vehicleImage'][0], fit: BoxFit.cover)),
                          SizedBox(height:3.h),
                            SingleChildScrollView(
                              child: Container(
                                width: 95.w,
                                color: Colors.transparent,
                                  child: Padding(
                                    padding: EdgeInsets.only(left:2.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(child: texts(vehicleInformation[0]['vehicleCompanyName']+" "+vehicleInformation[0]['vehicleName'], 22.sp, Colors.white,FontWeight.normal)),
                                            SizedBox(height: 5.h,),
                                            texts("Rent : "+vehicleInformation[0]['vehicleRent'].toString()+"/Day", 22.sp, Colors.white,FontWeight.normal),
                                            SizedBox(height: 2.h,),
                                            userInformation.isNotEmpty?texts("Renter : "+userInformation[0]['name'], 19.sp, Colors.white,FontWeight.normal)
                                            :texts('Loading..', 19.sp, Colors.white, FontWeight.normal),
                                            SizedBox(height: 2.h,),
                                            userInformation.isNotEmpty?texts("PhoneNo : "+int.parse(userInformation[0]['phone']).toString(), 19.sp, Colors.white,FontWeight.normal)
                                                :texts('Loading..', 19.sp, Colors.white, FontWeight.normal),
                                            SizedBox(height: 2.h,),
                                            texts("Location: "+vehicleInformation[0]['vehicleLocation'], 19.sp, Colors.white, FontWeight.normal),
                                            SizedBox(height: 2.h,),
                                            texts("Description: "+vehicleInformation[0]['vehicleDescription'], 19.sp, Colors.white, FontWeight.normal),
                                            ]),
                                        SizedBox(height: 5.h,),
                                        texts("Images :", 19.sp, Colors.white, FontWeight.normal),
                                        SizedBox(height: 3.h,),
                                        SizedBox(
                                          height: 12.h,
                                          child: ListView.builder(
                                            itemBuilder: (context, index) {
                                              return Container(
                                                height: 12.h,
                                                width: 40.w,
                                                color: Colors.white,
                                                margin: EdgeInsets.only(right: 2.w),
                                                child: Image.network(vehicleInformation[0]['vehicleImage'][index], fit: BoxFit.fitWidth,),
                                              );
                                            },
                                            itemCount: vehicleInformation[0]['vehicleImage'].length,
                                            scrollDirection: Axis.horizontal,
                                          ),),
                                        SizedBox(height: 6.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.calendar_month_outlined,
                                              color: Colors.white,
                                              size: 5.h,
                                            ),
                                            SizedBox(width: 2.w),
                                            texts("Choose Dates", 15.sp, Colors.white, FontWeight.normal)
                                          ],
                                        ),
                                        SizedBox(height: 3.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 5.h,
                                              width: 20.h,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(20),
                                                      bottomLeft: Radius.circular(20)),
                                                  color: Color.fromRGBO(228, 221, 205, 1)),
                                              child: texts(firstDate.substring(0, 10), 12.sp,
                                                  Colors.black, FontWeight.normal),
                                              alignment: Alignment.center,
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Container(
                                              height: 5.h,
                                              width: 20.h,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      bottomRight: Radius.circular(20),
                                                      topLeft: Radius.circular(20)),
                                                  color: Color.fromRGBO(228, 221, 205, 1)),
                                              child: texts(lastDate.substring(0, 10), 12.sp, Colors.black,
                                                  FontWeight.normal),
                                              alignment: Alignment.center,
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 2.h),
                                        CalendarDatePicker2(
                                          config: config,
                                          value: _selectedDates,
                                          onValueChanged: (dates) {
                                            setState(() {
                                              _selectedDates = dates;
                                              firstDate = _selectedDates[0]!.toLocal().toString();
                                              lastDate = _selectedDates[1]!.toLocal().toString();
                                            });
                                          },
                                        ),
                                        Align(
                                            alignment: Alignment.center,
                                            child: buttons('RENT', 20.sp, () async{
                                              showDialog(context: context, builder: (context){
                                                return AlertDialog(
                                                  title: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      texts("Pay to confirm booking!!", 16.sp, Colors.white, FontWeight.normal),
                                                      SizedBox(height:1.h),
                                                      texts(
                                                          "Rs. " +
                                                              ((vehicleInformation[0]['vehicleRent'] / 3).toInt() * ((_selectedDates[1]!.difference(_selectedDates[0]!).inDays)+1)).toString(),
                                                          16.sp,
                                                          Colors.white,
                                                          FontWeight.normal
                                                      )],
                                                  ),
                                                  backgroundColor: Color.fromRGBO(4,31,52,20),
                                                  elevation: 2,
                                                  actions: [
                                                    buttons("Pay", 12.sp, (){
                                                      Navigator.pop(context);
                                                      var options = {
                                                        'key': 'rzp_test_srxx5ZiaXSlqeq',
                                                        'amount': ((vehicleInformation[0]['vehicleRent'] ~/ 3) * 100 * ((_selectedDates[1]!.difference(_selectedDates[0]!).inDays)+1)),
                                                        'name': '${vehicleInformation[0]['vehicleName']}',
                                                        'description': 'Ewallet Recharge',
                                                        'prefill': {
                                                          'contact': '9619191966',
                                                          'email': 'mah@gmail.com'
                                                        }
                                                      };
                                                      try{
                                                        razorpay.open(options);
                                                      } on Exception catch(e){
                                                        print("Error is : ${e}");
                                                      }
                                                    })
                                                  ],
                                                );
                                              });

                                            })),
                                        SizedBox(height: 2.h,)
                                      ]
                                    ),
                                  ),
                                ),
                            ),
                     ]
                    ),
                              ),
                ),
              ):Center(child: CircularProgressIndicator(color: Colors.white,)),
            ),
    );

  }
}