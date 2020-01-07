import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/common/validation.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';
import 'dart:convert';


class CreateforgetPasssword extends StatefulWidget {

  String email;
  CreateforgetPasssword({Key key, this.email}) : super(key: key);

  @override
  _CreateforgetPassswordState createState() => _CreateforgetPassswordState();
}

class _CreateforgetPassswordState extends State<CreateforgetPasssword> {
  final commonClass = new Common();
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  final validation = new Validation();
  SharedPreferences sharedPreferences;
  String email;
  bool _isloading = false;
  TextEditingController passwordController = new TextEditingController();
  var deviceId;


  @override
  void initState() {
    super.initState();
    this.email =  widget.email;
    _getDeviceId();
  }
  Future<String> _getDeviceId() async {
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
                          child: Text("Set Password",style:
                          TextStyle(
                              color: commonClass.hexToColor('#77B790'),
                              fontSize: 25.0
                          ),),
                        ),
                        SizedBox(height: 15.0,),
                        new TextFormField(
                          validator: (value){
                            if(value.length < 4)
                            {
                              return "Password must be of 4 digit";
                            }else
                            {
                              return null;
                            }
                          },
                          autovalidate: _autoValidate,
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
                          validator: (confirmpass){
                            var password = passwordController.text;
                            if(confirmpass != password)
                            {
                              return "Confirm Password should match password";
                            }

                          },
                          obscureText: true,
                          decoration: new InputDecoration(
                            labelText: 'Confirm Password*',
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
                                  'Update Password',
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
    if (_formKey.currentState.validate())
    {
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
      _isloading = true;

    });
    try{
      sharedPreferences = await SharedPreferences.getInstance();
      var formData = {
        "email": email,
        "password": passwordController.text
      };
      final response = await Services(Config.updatePassword).noAuthPostMethod(formData, context);
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
        Navigator.of(context).pushReplacementNamed('/enterEmail');

      }else{
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pushReplacementNamed('/enterEmail');
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

