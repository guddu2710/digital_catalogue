import 'package:digital_catalogue/common/Common.dart';
import 'package:flutter/material.dart';

class FirstCaterogy extends StatefulWidget {
  @override
  _FirstCaterogyState createState() => _FirstCaterogyState();
}

class _FirstCaterogyState extends State<FirstCaterogy> {
  final commonClass = new Common();
var val=0;


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
              padding: EdgeInsets.only(right: 30.0,left: 30.0,top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 200.0,
                    padding:EdgeInsets.only(top: 20.0,bottom: 20.0),
                    child: Image.asset(
                      'images/logo.png',
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        SizedBox(width: 5.0,),

                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(

                    child: Flexible(

                      child: Text("You need to \n organised \ncategory & \nProducts\n to upload the\n images",style:TextStyle(
                        fontSize: 40.0,fontWeight: FontWeight.bold,
                      ),textAlign: TextAlign.center,),
                    ),
                  ),

                  SizedBox(height: 10.0),
                  Container(
                    child: ButtonTheme(
                      height: 45.0,
                      child: RaisedButton(
                        onPressed: (){


                            Navigator.of(context).pushNamed("/addCategory");

                        },
                        textColor: Colors.white,
                        color: commonClass.hexToColor('#77B790'),
                        child: new Text('Add Caterogy',
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
}

