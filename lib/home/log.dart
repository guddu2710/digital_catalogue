import 'package:digital_catalogue/common/Common.dart';
import 'package:flutter/material.dart';


class Logon extends StatelessWidget {
  final commonClass = new Common();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
        resizeToAvoidBottomPadding:false,

      backgroundColor: commonClass.hexToColor('#F0F0F3'),
        body: new Container(
          child: new Center(
              child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                ButtonTheme(
                minWidth: 150.0,
                height: 50.0,
                buttonColor: commonClass.hexToColor('#77B790'),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/enterEmail");
                  },
                  child: Text("Log in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0
                    ),),
                ),
              ),
                SizedBox(height: 20.0,),
                ButtonTheme(
                  minWidth: 150.0,
                  height: 50.0,
                  buttonColor: commonClass.hexToColor('#77B790'),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/registration");
                    },
                    child: Text("Sign up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0
                      ),),
                  ),
                ),
                ],
              )

          )
        ),


    );
  }
}
