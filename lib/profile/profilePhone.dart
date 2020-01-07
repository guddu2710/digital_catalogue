import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/common/validation.dart';
import 'package:digital_catalogue/home/EnterPassword.dart';
import 'package:digital_catalogue/home/otp.dart';
import 'package:digital_catalogue/profile/profileUpdateOTP.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';





class ProfilePhone extends StatefulWidget {
  @override
  _ProfilePhoneState createState() => _ProfilePhoneState();
}

class _ProfilePhoneState extends State<ProfilePhone> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = new TextEditingController();
  final commonClass = new Common();
  final validation = new Validation();
  bool _autoValidate = false;
  var deviceId;
  SharedPreferences sharedPreferences;
  bool _isloading = false;


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
                padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
                child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 80.0,),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Welcome",style:
                              TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: commonClass.hexToColor('#77B790'),
                                  fontSize: 25.0
                              ),),
                              Text("Enter Phone no.to continue",style: TextStyle(
                                  fontSize: 15.0
                              ),),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0,),
                        new TextFormField(

                          //validator: validation.loginEmail,
                         // autovalidate: _autoValidate,
                          controller: phoneController,
                          decoration: new InputDecoration(
                            labelText: 'Phone*',
                            enabledBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: commonClass.hexToColor('#949494')
                                )
                            ),
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: commonClass.hexToColor('#949494')
                            ),
                            focusedBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: commonClass.hexToColor('#949494')
                                )
                            ),
                          ),
                        ),

                        SizedBox(height: 20.0,),
                        new Container(
                            color: commonClass.hexToColor('#77B790'),
                            child: ButtonTheme(
                              minWidth: 50.0,
                              height: 50.0,
                              child: MaterialButton(
                                onPressed: _checkValidation,
                                textColor: Colors.white,
                                child: new Text(
                                  'Next',
                                  style: TextStyle(
                                      fontSize: 16.0
                                  ),
                                ),
                              ),
                            )
                        ),
                        SizedBox(height: 10.0,),



                      ],
                    )
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
  _checkValidation()async {
    await  _dataPost();
//    if (_formKey.currentState.validate()) {
//      setState(() {
//        _isloading = true;
//      });
//      await  _dataPost();
//    } else {
////    If all data are not valid then start auto validation.
//      setState(() {
//        _autoValidate = true;
//      });
//    }
  }

  _dataPost()async{

    try{
      sharedPreferences = await SharedPreferences.getInstance();
      var formData = {
        "phone_no": phoneController.text,
      };

      final response = await Services(Config.check_phone).postMethod(formData, context);
      print(response);
      if(response['success'] == false){
//        final responseData = response['data'];
//        sharedPreferences.setString('userDetails',json.encode(responseData));
//        sharedPreferences.setString('token', deviceId);
//        print(responseData);
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
//        Navigator.of(context).pushReplacementNamed('/join');
      }else if(response['success'] == true){
        setState(() {
          _isloading = false;
        });

        final responseData = response['data'];
    var route = MaterialPageRoute(builder: (BuildContext context) =>
            ProfileOTP(phone: phoneController.text),
        );
        Navigator.of(context).pushReplacement(route);
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);

      }
    }catch(e){
      setState(() {
        _isloading = false;
      });
      Toast.show("Something went wrong please try again later", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }
}
