import 'dart:convert';

import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  SharedPreferences sharedPreferences;
  String _navigate;
  String email,password,deviceId;


  startTime() async {

    var _duration = new Duration(seconds: 3);
      return new Timer(_duration, navigationPage);

  }
  void navigationPage() {

    Navigator.of(context).pushReplacementNamed(_navigate);
  }

  @override
  void initState() {
    super.initState();
    _getLogged();
    startTime();
  }
  void _getLogged() async{
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      final logged=sharedPreferences.get("logged");
      if(logged!=null){
        _getProfiledata();
        print(logged);
      }
      else{
        _navigate="/enterEmail";
      }
    });

  }
  _dataPost()async{

    try{
      sharedPreferences = await SharedPreferences.getInstance();
      var formData = {
        "email": email,
        "password": password,
        "device_token": deviceId
      };

      final response = await Services(Config.login).noAuthPostMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        sharedPreferences.setString("logged", "logged");
        sharedPreferences.setString('userDetails',json.encode(responseData));
        sharedPreferences.setString('token', deviceId);
        sharedPreferences.setString('category', response['category'].toString());
        sharedPreferences.setString("logged", "logged");
        sharedPreferences.setString('subscription_details',json.encode(response['subscription_details']));
        sharedPreferences.setString('categorycount', response['category'].toString());

        print(responseData);


        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
        Navigator.of(context).pushReplacementNamed("/ProductList");

//        setState(() {
//
//          _navigate="/ProductList";
//
//        });

      }else if(response['success'] == null) {
        setState(() {
          _navigate="/enterEmail";

        });
      }
      else{
        setState(() {
          _navigate="/enterEmail";

        });
      }
    }catch(e){
      setState(() {
        _navigate="/enterEmail";

      });

      Toast.show("Something went wrong please try again later", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }
  void _getProfiledata() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();

      final data = sharedPreferences.get('userDetails');
      final json1 = JsonDecoder().convert(data);
      print(json1);
      setState(() {
        email = json1['email'];
        password=sharedPreferences.get('password');
        deviceId=sharedPreferences.get('token');
      });
      _dataPost();
    }
    catch(e){
      setState(() {
        _navigate="/enterEmail";

      });

      Toast.show("Something went wrong please try again later", context,duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }


  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[new Image.asset('images/splash.png')],
      ),
    );
  }


}
