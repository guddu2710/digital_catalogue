import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/home/CreatePasssword.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:quiver/async.dart';
import 'dart:ui';
import 'package:toast/toast.dart';

import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Mobileverify extends StatefulWidget {
  String phone;
  String email;
  String password;
  Mobileverify({Key key, this.phone,this.email,this.password}) : super(key: key);
  @override
  _MobileverifyState createState() => _MobileverifyState();
}

class _MobileverifyState extends State<Mobileverify> {

  TextEditingController otpController = TextEditingController();
  bool hasError = false;
  final commonClass = new Common();
  String email;
  String password;
  String phone;
  String getOtp;
  int _start = 13;
  String display = '13';
  bool _isloading = false;
  var deviceId;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    this.email = widget.email;
    this.password = widget.password;
    this.phone = widget.phone;
    setState(() {
      _isloading = true;
    });
    this.sendOtp(this.phone);
  }

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      if ((_start - duration.elapsed.inSeconds) < 10) {
        setState(() {
          display =
              (_start - duration.elapsed.inSeconds).toString().padLeft(2, '0');
        });
      } else {
        setState(() {
          display = (_start - duration.elapsed.inSeconds).toString();
        });
      }
    });


    sub.onDone(() {
      display = '13';
      print("Done");
      sub.cancel();
    });
  }


  sendOtp(phone) async {
    try {
      var formData = {
        "phone": phone,
      };
      final response = await Services(Config.sendOtp).noAuthPostMethod(
          formData, context);
      print(response);
      if (response['success'] == true) {
        this.getOtp = response['data']['otp'].toString();
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,);
      } else {
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,);
      }
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).requestFocus(new FocusNode()),
      child: Stack(
        children: <Widget>[
          Image.asset(
            "images/background.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,),
          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset : false,
            resizeToAvoidBottomPadding:false,
            body: ModalProgressHUD(
              inAsyncCall: _isloading,
              child: Container(
                padding: EdgeInsets.only(right: 30.0, left: 30.0, top: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 150.0,),
                      Center(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Welcome", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                  color: commonClass.hexToColor('#77B790')
                              ),),
                              SizedBox(height: 5.0,),
                              Text("Submit OTP to verify mobile number",
                                style: TextStyle(
                                    fontSize: 15.0
                                ),),
                              Text("+91${phone}", style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold
                              ),),
                            ],
                          ),
                        ),
                      ),
                      PinCodeTextField(
                        maxLength: 4,
                        controller: otpController,
                        pinBoxHeight: 50.0,
                        pinBoxWidth: 50.0,
                        hasError: hasError,
                        autofocus: false,
                        pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType
                            .AUTO_ADJUST_WIDTH,
                        pinBoxDecoration: ProvidedPinBoxDecoration
                            .underlinedPinBoxDecoration,
                        pinTextStyle: TextStyle(
                            fontSize: 18.0
                        ),
                        onTextChanged: (text) {
                          setState(() {
                            hasError = false;
                          });
                        },
                      ),
                      SizedBox(height: 20.0,),
                      Container(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: ButtonTheme(
                          height: 45.0,
                          child: RaisedButton(
                            onPressed: () {
                              _verifyOtp();
                            },
                            textColor: Colors.white,
                            color: commonClass.hexToColor('#77B790'),
                            child: new Text('VERIFY',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0
                              ),
                            ),

                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: display == '13' ? ButtonTheme(
                          height: 45.0,
                          child: RaisedButton(
                            onPressed: () {
                              startTimer();
                              this.sendOtp(this.phone);
                            },
                            textColor: Colors.white,
                            color: commonClass.hexToColor('#77B790'),
                            child: new Text('Resend otp',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0
                              ),
                            ),
                          ),
                        ) : ButtonTheme(
                          height: 45.0,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.grey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text('Resend otp',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                new Text("0:$display",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.0,),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Not received your code?", style: TextStyle(
                                fontSize: 15.0
                            ),
                            ),
                          ],
                        ),
                      )


                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _verifyOtp() {
    print(otpController.text);
    print(getOtp);
    if (otpController.text == getOtp) {
      setState(() {
        _isloading = false;
      });
      _updateuser();
     // Navigator.of(context).pushReplacementNamed('/join');
    } else {
      Toast.show('Please enter valid otp', context, duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,);
    }
  }

  _updateuser() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
        deviceId = androidDeviceInfo.androidId;
      }
      else if(Platform.isIOS){
      IosDeviceInfo iosDeviceInfo=await deviceInfo.iosInfo;
      deviceId=iosDeviceInfo.identifierForVendor;
      }
        sharedPreferences = await SharedPreferences.getInstance();
        var formData = {
          "email": email,
          "device_token": deviceId
        };
        final response = await Services(Config.verified).noAuthPostMethod(
            formData, context);
        print(response);
        if (response['success'] == true) {

          final responseData = response['data'];
          final value=response['category'].toString();
          sharedPreferences.setString("logged", "logged");
          sharedPreferences.setString('categorycount', response['category'].toString());
          sharedPreferences.setString('userDetails',json.encode(responseData));
          sharedPreferences.setString('token', deviceId);
          sharedPreferences.setString('subscription_details',json.encode(response['subscription_details']));

          sharedPreferences.setString('category', response['category'].toString());
          print(responseData);
          setState(() {
            _isloading = false;
          });

          int count=int.parse(value);

          if(count>0) {
            Navigator.of(context).pushNamed("/ProductList");
          }
          else{
            Navigator.of(context).pushNamed("/firstCaterogy");
          }

          Toast.show(response['message'], context, duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,);
        }
        else {
          setState(() {
            _isloading = false;
          });
          Toast.show(response['message'], context, duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,);
        }
    }
    catch (e) {
      setState(() {
        _isloading = false;
      });
      Toast.show("Something went wrong please try again later", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }
}