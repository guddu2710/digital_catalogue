import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/common/validation.dart';
import 'package:digital_catalogue/home/MobileVerify.dart';
import 'package:digital_catalogue/home/passwordUpdateOTP.dart';
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


class EnterPassword extends StatefulWidget {
  String email;
  EnterPassword({Key key, this.email}) : super(key: key);
  @override
  _EnterPasswordState createState() => _EnterPasswordState();
}

class _EnterPasswordState extends State<EnterPassword> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = new TextEditingController();
  final commonClass = new Common();
  final validation = new Validation();
  bool _autoValidate = false;
  var deviceId;
  SharedPreferences sharedPreferences;
  bool _isloading = false;
  String email;
  var value;
  Future<String> _getId() async {
    print("email  ${this.email}");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.androidId;
    } else if (Platform.isIOS) {
//       iOS-specific code
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId=iosDeviceInfo.identifierForVendor;
      print("ios");
      print("$deviceId");


    }
  }
  @override
  void initState() {
    super.initState();
   this.email =  widget.email;
    _getId();
    this.getValue();

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
                              Text("Enter password to continue",style: TextStyle(
                                  fontSize: 15.0
                              ),),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0,),

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
                              var route = MaterialPageRoute(builder: (BuildContext context) =>
                                  PasswordOTP(email: email,route:"/PasswordOTP"),
                              );
                              Navigator.of(context).pushReplacement(route);
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
          ),
        ],
      ),
    );
  }

  _checkValidation()async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isloading = true;
      });
      await  _dataPost();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _dataPost()async{

    try{
      sharedPreferences = await SharedPreferences.getInstance();
      var formData = {
        "email": email,
        "password": passwordController.text,
        "device_token": deviceId
      };
      print("hw=e");
      final response = await Services(Config.login).noAuthPostMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        value=response['category'].toString();
        sharedPreferences.setString("logged", "logged");
        sharedPreferences.setString("password",passwordController.text );
        sharedPreferences.setString('subscription_details',json.encode(response['subscription_details']));
        sharedPreferences.setString('categorycount', response['category'].toString());
        sharedPreferences.setString('userDetails',json.encode(responseData));
        sharedPreferences.setString('token', deviceId);
        sharedPreferences.setString('category', response['category'].toString());


        print(responseData);
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
        int count=int.parse(value);

        if(count>0) {
          Navigator.of(context).pushNamed("/ProductList");
        }
        else{
          Navigator.of(context).pushNamed("/firstCaterogy");
        }
      }else if(response['success'] == null) {
        final responseData = response['data'];
        sharedPreferences.setString("password",passwordController.text );

        var route = MaterialPageRoute(builder: (BuildContext context) =>
            Mobileverify(phone: responseData['phone'],email:responseData['email'],password:responseData['password']),
        );
        Navigator.of(context).pushReplacement(route);
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
  getValue() async{
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      value=sharedPreferences.getString('categorycount');

    });


  }
}
