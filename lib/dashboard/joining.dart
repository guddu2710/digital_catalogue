import 'dart:convert';

import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Joining extends StatefulWidget {
  @override
  _JoiningState createState() => _JoiningState();
}

class _JoiningState extends State<Joining> {
  SharedPreferences sharedPreferences;
  var value;

  @override
  void initState() {
    super.initState();
    this.getValue();
    this._getCategory();
  }

  final commonClass = new Common();
    var val=2;
  Future<bool> _onWillPop() {
    return
      showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child:
      Stack(
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
              padding: EdgeInsets.only(right: 30.0,left: 30.0,top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 200.0,
                    padding:EdgeInsets.only(top: 20.0,bottom: 20.0),
                    child: Image.asset(
                      'images/right.png',
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Thank You",style: TextStyle(
                            color: commonClass.hexToColor('#77B790'),
                            fontSize: 16.0
                        ),),
                        SizedBox(width: 5.0,),
                        Text("for joining Digital Catalogue",style: TextStyle(
                            fontSize: 15.0
                        ),)
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Flexible(
                    child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum\n your request is pending waiting for approval"),
                  ),

                  SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                    child: ButtonTheme(
                      height: 45.0,
                      child: RaisedButton(
                        onPressed: (){
                          int count=int.parse(value);
                          if(count>0) {
                            Navigator.of(context).pushNamed("/ProductList");
                          }
                          else{
                            Navigator.of(context).pushNamed("/firstCaterogy");
                          }
                        },
                        textColor: Colors.white,
                        color: commonClass.hexToColor('#77B790'),
                        child: new Text('Continue',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0
                          ),
                        ),

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

   getValue() async{
     sharedPreferences = await SharedPreferences.getInstance();
     setState(() {
       value=sharedPreferences.getString('categorycount');

     });


   }


  _getCategory()async{

    try{
      sharedPreferences = await SharedPreferences.getInstance();


      final response = await Services(Config.getCatagory).getMethod(context);
      print("response");
      print(response);
      if(response['success'] == true){

        final responseData = response['data'];





        print("responseData");
        print(responseData);


      }
//
      else{
        setState(() {
        });
       // Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
      }
    }catch(e){
      setState(() {
      });
//      Toast.show("Something went wrong please try again later", context,
       // duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }

}

