import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/common/validation.dart';
import 'package:digital_catalogue/home/otp.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';



class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController enterpriceController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  String dropdownValue;
  SharedPreferences sharedPreferences;
  var deviceId;
  bool isEnterprice = true;
  bool _isloading = false;
  final commonClass = new Common();
  int _currentIndex = 1;
  final _validation = new Validation();






  List<GroupModel> _group = [
    GroupModel(
      text: "Enterprise user",
      index: 1,
    ),
    GroupModel(
      text: "Single user",
      index: 2,
    ),
  ];
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
            fit: BoxFit.fill,
          ),


          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset : false,
            resizeToAvoidBottomPadding:false,
            body: ModalProgressHUD(
              inAsyncCall: _isloading,
              child: Container(
                      padding: EdgeInsets.only(right: 30.0,left: 30.0,top: 20.0),
                      child: new Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: ListView(
                         // child: Column(
                            children: <Widget>[
                                SizedBox(height: 40.0,),
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
                                      Text("Create an account",style: TextStyle(
                                          fontSize: 15.0
                                      ),),
                                    ],
                                  ),
                                ),

/*old*/
//                          Container(
//                            padding: EdgeInsets.only(left: 28.0),
//                            child: Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Text("I am",style:
//                                  TextStyle(
//                                    fontSize: 30.0,
//                                    color: commonClass.hexToColor('#77B790'),
//                                    fontWeight: FontWeight.bold
//                                  ),),
//                                Text("!",style: TextStyle(
//                                    fontSize: 30.0,
//                                    fontWeight: FontWeight.bold,
//                                  color: Colors.black
//                                ),),
//                              ],
//                            ),
//                          ),
                               // SizedBox(height: 20.0,),
//                          Container(
//                            height: 100.0,
//                            child: ListView(
//                              children: _group
//                                  .map((item) => RadioListTile(
//                                activeColor: commonClass.hexToColor('#77B790'),
//                                groupValue: _currentIndex,
//                                title: Text("${item.text}"),
//                                value: item.index,
//                                onChanged: (val) {
//                                  if(val == 1)
//                                    {
//                                      setState(() {
//                                      isEnterprice = true;
//                                      });
//                                    }
//                                    else{
//                                      setState(() {
//                                      isEnterprice = false;
//                                      });
//                                  }
//                                  setState(() {
//                                    _currentIndex = val;
//                                  });
//                                },
//                              ))
//                                  .toList(),
//                            ),
//                          ),
                              /*old*/
                               // SizedBox(height: 20.0,),
                               // isEnterprice ? enterpriceField(context) : SizedBox(height: 1.0,),
                                SizedBox(height: 20.0,),
                                emailField(context),
                                SizedBox(height: 20.0,),
                                phoneField(context),
                                SizedBox(height: 30.0,),
                                //show


                              //show
                                ButtonTheme(
                                    height: 50.0,
                                    child: RaisedButton(
                                    onPressed: _validateInputs,
                                    textColor: Colors.white,
                                    color: commonClass.hexToColor('#77B790'),
                                    child: new Text('JOIN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0
                                    ),),

                                    ),
                                ),
                                SizedBox(height: 20.0,),
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

  void _validateInputs() async
  {

    if (_formKey.currentState.validate()) {
      /*old*/
//      if(isEnterprice == true){
//        Toast.show("Enterprice user functionlity under process", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
//      }else{
//        setState(() {
//          _isloading = true;
//        });
//        await  _dataPost();
//      }
//
      /*old*/
      setState(() {
          _isloading = true;
        });
      await  _dataPost();

    } else {
//    If all data are not valid then start auto validation.
      if(isEnterprice == true){
        Toast.show("Enterprice user functionlity under process", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
      }
      setState(() {
        _autoValidate = true;
      });
    }
  }
  // post data
  _dataPost()async{

    try{
      sharedPreferences = await SharedPreferences.getInstance();
      var formData = {
        "email": emailController.text,
        "phone_no": phoneController.text,
        "device_token": deviceId
      };
      print(formData);

      final response = await Services(Config.registration).noAuthPostMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        sharedPreferences.setString('userDetails',json.encode(responseData));
        sharedPreferences.setString('token', deviceId);
        sharedPreferences.setString('email', responseData['email']);
        sharedPreferences.setString('phone', responseData['phone']);
        sharedPreferences.setString('email', responseData['password']);
        print(responseData);
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
        var route = MaterialPageRoute(builder: (BuildContext context) =>
            Otp(phone: phoneController.text),
        );
        Navigator.of(context).pushReplacement(route);
      }else{
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

  TextFormField enterpriceField(BuildContext context) {
    return new TextFormField(
      autovalidate: _autoValidate,
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter enterprice id';
        }
        return null;
      },
      decoration: new InputDecoration(
          labelText: 'Enterprise id*',
          fillColor: Colors.white,
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: commonClass.hexToColor('#DCDCDC'), width: 1.0),
          ),
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: commonClass.hexToColor('#878787')

          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: commonClass.hexToColor('#949494'),

              )
          )
      ),
      keyboardType: TextInputType.text,

      controller: enterpriceController,
    );

  }

  TextFormField emailField(BuildContext context) {
    return new TextFormField(
      autovalidate: _autoValidate,
      validator: _validation.validateEmail,
      decoration: new InputDecoration(
          labelText: 'Email*',
          fillColor: Colors.white,
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: commonClass.hexToColor('#DCDCDC'), width: 1.0),
          ),
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: commonClass.hexToColor('#878787')

          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: commonClass.hexToColor('#949494'),

              )
          )
      ),
      keyboardType: TextInputType.text,

      controller: emailController,
    );

  }

  TextFormField phoneField(BuildContext context) {
    return new TextFormField(
      autovalidate: _autoValidate,
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter phone number';
        }
        return null;
      },
      decoration: new InputDecoration(
          labelText: 'Phone No*',
          fillColor: Colors.white,
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: commonClass.hexToColor('#DCDCDC'), width: 1.0),
          ),
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: commonClass.hexToColor('#878787')

          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: commonClass.hexToColor('#949494'),

              )
          )
      ),
      keyboardType: TextInputType.number,
      controller: phoneController,
    );

  }

}


class GroupModel {
  String text;
  int index;
  GroupModel({this.text, this.index});
}