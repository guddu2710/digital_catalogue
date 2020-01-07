import 'dart:convert';

import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  List<PaymentItem> paymentList = [];

  List results=[] ;
  final _formKey = GlobalKey<FormState>();
  bool _isloading=false;

  TextEditingController planController = new TextEditingController();
  TextEditingController validityController = new TextEditingController();
  TextEditingController passwordContoller = new TextEditingController();
  TextEditingController cPasswordContoller = new TextEditingController();
  bool _autoValidate = false;
  SharedPreferences sharedPreferences;
  var upgrade,plan;
  @override
  void initState() {
    super.initState();
    this._getProfiledata();
    this._getsubscription_validity();
    this._getpaymentDetails();
  }
  DataRow getDataRow(data) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(data["logo"])),
        DataCell(Text(data["location"])),
        DataCell(Text(data["distance"])),
        DataCell(Text(data["price"])),
        DataCell(Text(data["facilities"]))
      ],
    );
  }
  DataRow _getDataRow(result) {
    return DataRow(
      cells: <DataCell>[
     //   DataCell(Text(result['start_date'])),
        DataCell(Text(result['start_date'])),
        DataCell(Text(plan)),
        DataCell(Text("")),
       // DataCell(Text(result["text3"])),
      ],
    );
  }
  final commonClass = new Common();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: GestureDetector(
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
              appBar: AppBar(title: Text('Account Settings'),
                backgroundColor:commonClass.hexToColor('#77B790') ,
                bottom: TabBar(tabs:
                [
                  Tab(text: "Credentinals",),
                  Tab(text: "Billing",),
                  Tab(text: "Subscriptions",),
                ],
                  indicatorColor: commonClass.hexToColor('#F0F0F3')),
              ),

              body: ModalProgressHUD(
                inAsyncCall: _isloading,
                child: TabBarView(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(right: 30.0,left: 30.0,top: 20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 50.0,),
                              Center(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new TextFormField(
                                        obscureText: true,

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
                                      controller: passwordContoller,
                                        decoration: new InputDecoration(
                                          labelText: 'Password',
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

                                      new TextFormField(
                                        obscureText: true,

                                        validator: (confirmpass){
                                          var password = passwordContoller.text;
                                          if(confirmpass != password)
                                          {
                                            return "Confirm Password should match password";
                                          }
                                        },
                                       autovalidate: _autoValidate,
                                        controller: cPasswordContoller,
                                        decoration: new InputDecoration(
                                          labelText: 'Confirm Password',
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
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0,),
                              Container(

                                child: ButtonTheme(
                                  height: 45.0,
                                  child: RaisedButton(
                                    onPressed: (){
                                      _checkValidation();
                                      //_verifyOtp();
                                    },
                                    textColor: Colors.white,
                                    color: commonClass.hexToColor('#77B790'),
                                    child: new Text('Update Password',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0
                                      ),
                                    ),

                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                      ),
                    ),


                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(right: 30.0,left: 30.0,top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 50.0,),
                            upgrade==1?
                            Center(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new TextFormField(
                                      controller:planController ,
                                      decoration: new InputDecoration(
                                        labelText: 'Current Plan',
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

                                    new TextFormField(
//
//                          validator: validation.loginEmail,
//                          autovalidate: _autoValidate,
                                      controller: validityController,
                                      decoration: new InputDecoration(
                                        labelText: 'Subscriptions Validity',
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





                                  ],
                                ),
                              ),
                            ):Center(),
                            SizedBox(height: 20.0,),
                            Container(

                                child:
                                Column(
                                  children: <Widget>[

                                    upgrade==1?ButtonTheme(
                                      height: 45.0,
                                      child: RaisedButton(
                                        onPressed: (){
                                          //_verifyOtp();
                                        },
                                        textColor: Colors.white,
                                        color: commonClass.hexToColor('#77B790'),
                                        child: new Text('Renew current plan',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0
                                          ),
                                        ),

                                      ),
                                    ):Center(),
                                    SizedBox(height: 20.0,),

                                    upgrade!=1?
                                    Container(
                                      alignment: Alignment.center,

                                      child: InkWell(
                                        onTap: () {
                                          print("hello");
//                                    var route = MaterialPageRoute(builder: (BuildContext context) =>
//                                        PasswordOTP(email: email,route:"/PasswordOTP"),
//                                    );
//                                    Navigator.of(context).pushReplacement(route);
                                        },
                                        child: new Text("Upgrade to premium account",
                                          style: TextStyle(

                                              color: Colors.black,
                                              fontSize: 16.0
                                          ),
                                        ),
                                      ),
                                    ):Container(),
                                    SizedBox(height: 10.0,),
//                                    upgrade!=1?
//                                    Container(
//                                      alignment: Alignment.center,
//
//                                      child: InkWell(
//                                        onTap: () {
//                                          _UpgraedUser();
//                                      //    Toast.show("under processs", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
//                                          print("hello");
////                                    var route = MaterialPageRoute(builder: (BuildContext context) =>
////                                        PasswordOTP(email: email,route:"/PasswordOTP"),
////                                    );
////                                    Navigator.of(context).pushReplacement(route);
//                                        },
//                                        child: new Text("Upgrade",
//
//                                          style: TextStyle(
//                                              decoration: TextDecoration.underline,
//                                              color: Colors.green,
//                                              fontSize: 16.0
//                                          ),
//                                        ),
//                                      ),
//                                    ):
//                                    Container(),
                                    upgrade!=1?
                                        upgrade >1?
                                        Container(
                                          alignment: Alignment.center,

                                          child: InkWell(
                                            onTap: () {
                                              //_UpgraedUser();
                                              //    Toast.show("under processs", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
                                              print("hello");
//                                    var route = MaterialPageRoute(builder: (BuildContext context) =>
//                                        PasswordOTP(email: email,route:"/PasswordOTP"),
//                                    );
//                                    Navigator.of(context).pushReplacement(route);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(top:20.0),
                                              child: Center(
                                                child: new Text("Upgrade request already sent\n Waiting for admin approval",

                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize: 16.0
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ):
                                    Container(
                                      alignment: Alignment.center,

                                      child: InkWell(
                                        onTap: () {
                                          _UpgraedUser();
                                          //    Toast.show("under processs", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
                                          print("hello");
//                                    var route = MaterialPageRoute(builder: (BuildContext context) =>
//                                        PasswordOTP(email: email,route:"/PasswordOTP"),
//                                    );
//                                    Navigator.of(context).pushReplacement(route);
                                        },
                                        child: new Text("Upgrade ",

                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              color: Colors.green,
                                              fontSize: 16.0
                                          ),
                                        ),
                                      ),
                                    ):
                                    Container(),
                                  ],
                                )



                            ),
                            SizedBox(height: 10.0),




                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(right: 30.0,left: 30.0,top: 20.0),
                        child:
                        DataTable(
                          columns: [
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Plan')),
                            DataColumn(label: Text('Amount')),
                          ],
                          rows:



                          List.generate(
                              results.length, (index) => _getDataRow(results[index])),
                        )
                      ),
                    ),
                  ],

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  _UpgraedUser()async{

    try{
      var formData = {

      };
      final response = await Services(Config.upgradeToPaidUser).postMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        print(responseData);
        setState(() {
          _isloading = false;
          passwordContoller.text="";
          cPasswordContoller.text="";
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
//        Navigator.of(context).pushReplacementNamed('/join');
      }else{
        setState(() {
          _isloading = false;
        });
//        Navigator.of(context).pushReplacementNamed('/enterEmail');
//        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
      }
    }catch(e){
      setState(() {
        _isloading = false;
      });
      Toast.show("Something went wrong please try again later", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
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

    try{
      var formData = {
        "password": passwordContoller.text,
      };
      final response = await Services(Config.change_password).postMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        print(responseData);
        setState(() {
          _isloading = false;
          passwordContoller.text="";
          cPasswordContoller.text="";
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
//        Navigator.of(context).pushReplacementNamed('/join');
      }else{
        setState(() {
          _isloading = false;
        });
//        Navigator.of(context).pushReplacementNamed('/enterEmail');
//        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
      }
    }catch(e){
      setState(() {
        _isloading = false;
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
        plan=json1['subscription_id'];
        upgrade = int.parse(json1['upgrade']);



      });
      print("upgrade=$upgrade");
    }
    catch(e){

      Toast.show("${e.toString()}", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
//      Toast.show("Something went wrong please try again later", context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
    // email=json1['']
//    phone=email=sharedPreferences.get('phone');
//    name=email=sharedPreferences.get('name');

  }
  _getpaymentDetails()async{
    _isloading = true;

    try{
      sharedPreferences = await SharedPreferences.getInstance();

      final response = await Services(Config.payment_details).getMethod(context);
      print(response);
      if(response['success'] == true) {
        final responseData = response['data'];
        sharedPreferences.setString('paymentDetails', json.encode(responseData));
        print(responseData);
        setState(() {
          _isloading = false;
          results = responseData;
       //   duplicateItems = responseData;
          print(results);
         // print(productList);
        });
      }
      else{
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
      }
    }catch(e){
      print(e.toString());
      setState(() {
        _isloading = false;
      });
      Toast.show("Something went wrong please try again later", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }
  _getsubscription_validity()async{
    _isloading = true;

    try{
      sharedPreferences = await SharedPreferences.getInstance();

      final response = await Services(Config.subscription_validity).getMethod(context);
      print(response);
      if(response['success'] == true) {
        final responseData = response['data'];
       // sharedPreferences.setString('productList', json.encode(responseData));
        print(responseData);
        if(responseData==null){
          setState(() {
            planController.text=plan;
            validityController.text=responseData['end_date'];
            // results=responseData;
            for (var u in responseData) {
              PaymentItem petrol = PaymentItem(u["id"], u["user_id"], u["start_date"], u["end_date"]);
              paymentList.add(petrol);
            }
            _isloading = false;

          });
        }

      }
      else{
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
      }
    }catch(e){
      print(e.toString());
      setState(() {
        _isloading = false;
      });
      Toast.show("Something went wrong please try again later", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }

}

class PaymentItem {
  final int id;
  final int user_id;
  final String start_date;
  final String end_date;
//  final String subscription_amount;
//  final String facilities;

  PaymentItem(this.id, this.user_id, this.start_date, this.end_date);
}
