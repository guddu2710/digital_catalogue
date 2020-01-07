import 'package:digital_catalogue/common/Common.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class EnterpriseKey extends StatefulWidget {
  @override
  _EnterpriseKeyState createState() => _EnterpriseKeyState();
}

class _EnterpriseKeyState extends State<EnterpriseKey> {
  final commonClass = new Common();

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
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
              child: Container(
                padding: EdgeInsets.only(right: 30.0,left: 30.0,top: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 150.0,),
                      Center(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Enter Enterprise Key",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                  color: commonClass.hexToColor('#77B790')
                              ),),
                              SizedBox(height: 5.0,),
                              new TextFormField(
//
                                validator: (value){
                                  if(value.length < 1)
                                  {
                                    return "Enter product name";
                                  }else
                                  {
                                    return null;
                                  }
                                },
                                //autovalidate: _autoValidate,
//                          controller: emailController,
                                decoration: new InputDecoration(
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
                        padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                        child: ButtonTheme(
                          height: 45.0,
                          child: RaisedButton(
                            onPressed: (){
                              //_verifyOtp();
                            },
                            textColor: Colors.white,
                            color: commonClass.hexToColor('#77B790'),
                            child: new Text('SUBMIT',
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
            ),
    ),
          ],
        ),
      );
  }
}
