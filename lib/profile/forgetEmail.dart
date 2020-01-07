import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/common/validation.dart';
import 'package:digital_catalogue/profile/profileUpdateOTP.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';





class ForgetEmail extends StatefulWidget {
  @override
  _forgetEmailState createState() => _forgetEmailState();
}

class _forgetEmailState extends State<ForgetEmail> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  final commonClass = new Common();
  final validation = new Validation();
  bool _autoValidate = false;
  var deviceId;
  SharedPreferences sharedPreferences;
  bool _isloading = false;
  @override
  void initState() {
    super.initState();
    emailController.addListener(_emailSpaceRestriction);

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

                              Text("Enter Email to continue",style: TextStyle(
                                  fontSize: 15.0
                              ),),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0,),
                        new TextFormField(

                          validator: validation.loginEmail,
                          autovalidate: _autoValidate,
                          controller: emailController,
                          decoration: new InputDecoration(
                            labelText: 'Email*',
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
                        new Container(
                            color: commonClass.hexToColor('#77B790'),
                            child: ButtonTheme(
                              minWidth: 50.0,
                              height: 50.0,
                              child: MaterialButton(
                                onPressed: _checkValidation,
                                textColor: Colors.white,
                                child: new Text(
                                  'Next',
                                  style: TextStyle(
                                      fontSize: 16.0
                                  ),
                                ),
                              ),
                            )
                        ),
                        SizedBox(height: 10.0,),



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
        "email": emailController.text,
      };

      final response = await Services(Config.check_email).postMethod(formData, context);
      print(response);
      if(response['success'] == false){
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
        Navigator.of(context).pushReplacementNamed('/join');
      }else if(response['success'] == true){
        setState(() {
          _isloading = false;
        });

        final responseData = response['data'];
        var route = MaterialPageRoute(builder: (BuildContext context) =>
            ProfileOTP(email: emailController.text,route:"/profileSettings"),
        );
        Navigator.of(context).pushReplacement(route);
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);

      }else if(response['success'] == null){
        setState(() {
          _isloading = false;
        });
        final responseData = response['data'];
        var route = MaterialPageRoute(builder: (BuildContext context) =>
            ProfileOTP(email: emailController.text,route:"/forgetEmail")
        );
        Navigator.of(context).pushReplacement(route);
        //Navigator.of(context).pushReplacement(route);
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
  _emailSpaceRestriction() {
    if(emailController.text.startsWith(" ")){
      setState(() {
        emailController.text="";
        print(emailController.text);
      });
    }
  }

}
