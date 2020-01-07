import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/dashboard/joining.dart';
import 'package:digital_catalogue/gallery/gallery.dart';
import 'package:digital_catalogue/home/CreatePasssword.dart';
import 'package:digital_catalogue/home/EnterEmail.dart';
import 'package:digital_catalogue/home/Signup.dart';
import 'package:digital_catalogue/home/log.dart';
import 'package:digital_catalogue/home/login.dart';
import 'package:digital_catalogue/home/otp.dart';
import 'package:digital_catalogue/home/splash_screen.dart';
import 'package:digital_catalogue/profile/forgetEmail.dart';
import 'package:digital_catalogue/profile/profileEmail.dart';
import 'package:digital_catalogue/profile/profilePhone.dart';
import 'package:digital_catalogue/profile/profileSettings.dart';
import 'package:flutter/material.dart';

import 'account/accountDetails.dart';
import 'category/addCaterogy.dart';
import 'category/addProducts.dart';
import 'category/caterogyList.dart';
import 'category/firstCategory.dart';
import 'category/productDetails.dart';
import 'category/productList.dart';
import 'gallery/imageAdd.dart';
import 'home/MobileVerify.dart';
import 'home/passwordUpdateOTP.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final commonClass = new Common();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Catalogue',
      theme: ThemeData(
        cursorColor: Colors.grey,
      ),
      home:  Splashscreen(),
      routes: <String, WidgetBuilder> {
        '/splash':(BuildContext context)=> new Splashscreen(),
        '/login' : (BuildContext context)=> new Login(),
        '/enterEmail' : (BuildContext context)=> new EmailEnter(),
        '/registration' : (BuildContext context)=> new Signup(),
        '/logon' : (BuildContext context)=> new Logon(),
        '/otp': (BuildContext context)=> new Otp(),
        '/join': (BuildContext context)=> new Joining(),
        '/createPassword': (BuildContext context)=> new CreatePassword(),
        '/profileSettings':(BuildContext context)=> new ProfileSettings(),
        '/accountSettings':(BuildContext context)=> new AccountDetails(),
        '/addCategory':(BuildContext context)=>new CategoryAdd(),
        '/addproduct':(BuildContext context)=>new ProductAdd(),
        '/categoryList':(BuildContext context)=>new CategotyList(),
        '/ProductList':(BuildContext context)=>new ProductList(),
        '/mobileVerify':(BuildContext context)=>new Mobileverify(),
        '/firstCaterogy':(BuildContext context)=>new FirstCaterogy(),
        '/productDetails':(BuildContext context)=>new ProductDetails(),
        '/profilePhone':(BuildContext context)=>new ProfilePhone(),
        '/profileEmail':(BuildContext context)=>new ProfileEmail(),
        '/imageAdd':(BuildContext context)=>new ImageAdd(),
        '/forgetEmail':(BuildContext context)=>new ForgetEmail(),
        '/PasswordOTP':(BuildContext context)=>new PasswordOTP(),
        '/GalleryShow':(BuildContext context)=>new GalleryShow()




      },
    );
  }
}

