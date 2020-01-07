import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/common/validation.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';
import 'dart:convert';
import 'package:toast/toast.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final commonClass = new Common();
  final validation = new Validation();
  bool _autoValidate = false;
  var deviceId;
  SharedPreferences sharedPreferences;
  bool _isloading = false;



  Future<String> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.androidId;
    } else if (Platform.isIOS) {
      // iOS-specific code
//      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
//      iosDeviceInfo.identifierForVendor;
//      print("ios");
    }
  }

  @override
  void initState() {
    super.initState();
    _getId();
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
            body: Container(
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
                            Text("Sign in to continue",style: TextStyle(
                              fontSize: 15.0
                            ),),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.0,),
                      new TextFormField(

                        validator: validation.loginEmail,
                        autovalidate: _autoValidate,
                        controller: emailController,
                        decoration: new InputDecoration(
                          labelText: 'Email*',
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
                      new TextFormField(
                        autovalidate: _autoValidate,
                        validator: validation.loginPassword,
                        controller: passwordController,
                        obscureText: true,
                        decoration: new InputDecoration(
                          labelText: 'Password*',
                          enabledBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: commonClass.hexToColor('#949494')
                              )
                          ),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: commonClass.hexToColor('#949494')
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: commonClass.hexToColor('#949494')
                              )
                          ),

                        ),
                      ),
                      SizedBox(height: 5.0,),
                      new Container(
                        alignment: Alignment(1.0, 0.0),

                        child: InkWell(
                          onTap: () {
                            print("hello");
                          },
                          child: new Text("Forgot Password?",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0
                            ),
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
                                'Sign In',
                                style: TextStyle(
                                    fontSize: 16.0
                                ),
                              ),
                            ),
                          )
                      ),



                    ],
                  )
              ),

            ),
          ),
        ],
      ),
    );
  }

  _checkValidation()async {
    if (_formKey.currentState.validate()) {
      await  _dataPost();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _dataPost()async{
    setState(() {

    });
    try{
      sharedPreferences = await SharedPreferences.getInstance();
      var formData = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      final response = await Services(Config.login).noAuthPostMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        sharedPreferences.setString('userDetails',json.encode(responseData));
        sharedPreferences.setString('token', deviceId);
        print(responseData);
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
        Navigator.of(context).pushReplacementNamed('/join');
      }


      else{
        setState(() {
          _isloading = false;
        });
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
