import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

//import 'package:multiple_image_picker/multiple_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  TextEditingController profileNameController = new TextEditingController();
  File imageFile;

  final commonClass = new Common();
  bool _isloading = false;
  SharedPreferences sharedPreferences;
  String email="", phone="", name="",profileImage="";
  var image;
  File _image;

  @override
  void initState() {
    super.initState();

    _getProfiledata();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pushReplacementNamed("/ProductList");
      },
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Image.asset(
              "images/background.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,),
            new Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset : false,
              resizeToAvoidBottomPadding:false,
              appBar: AppBar(title: Text('Profile'),
                backgroundColor: commonClass.hexToColor('#77B790'),
              ),
              body: ModalProgressHUD(
                inAsyncCall: _isloading,
                child: Container(
                  padding: EdgeInsets.only(right: 30.0, left: 30.0, top: 20.0),
                  child: new Form(
                    //  key: _formKey,
                    // autovalidate: _autoValidate,
                    child: ListView(
                      // child: Column(
                      children: <Widget>[
                        SizedBox(height: 40.0,),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _showImageDialog();
                                },
                                child: profileImage==null?
                                new Container(

                                  height: 150.0,
                                  width: 150.0,
                                  padding: const EdgeInsets.all(20.0),
                                  //I used some padding without fixed width and height
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      // You can use like this way or like the below line
                                      //borderRadius: new BorderRadius.circular(30.0),
                                      border: Border.all(width: 3,
                                          color: commonClass.hexToColor('#77B790')),
                                      borderRadius: BorderRadius.circular(75.0)
                                  ),
                                  child:_image == null
                                      ?Icon(Icons.camera_alt,
                                    color: commonClass.hexToColor('#77B790'),
                                    size: 50.0,)
                                      :
                                  new Container(
                                      width: 190.0,
                                      height: 190.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new NetworkImage(
                                                  _image.path)
                                          )
                                      )),

                               // You can add a Icon instead of text also, like below.
                                  //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                                ):
                                new Container(
                                    width: 190.0,
                                    height: 190.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(
                                                Config.imageUrlProfile+"/"+profileImage)
                                        )
                                    )),
                              )

                            ],
                          ),
                        ),
                        // SizedBox(height: 20.0,),
                        // isEnterprice ? enterpriceField(context) : SizedBox(height: 1.0,),

                        SizedBox(height: 20.0,),

                        Text("Name", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: commonClass.hexToColor('#949494')
                        ),),
                        TextFormField(
                          controller: profileNameController,
                          //initialValue: name,
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
                        SizedBox(height: 20.0,),

                        Text("Phone", style: TextStyle(
                            fontWeight: FontWeight.bold,

                            color: commonClass.hexToColor('#949494')
                        ),),
                        SizedBox(height: 20.0,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("$phone", style: TextStyle(

                              fontWeight: FontWeight.bold,

                              color: commonClass.hexToColor('#949494'),

                            ),),
                            Align(
                              alignment: Alignment.centerRight,
                              child:
                              InkWell(
                                  onTap: () =>
                                      Navigator.of(context).pushNamed('/profilePhone')
                                  ,
                                  child: Icon(Icons.arrow_forward_ios, size: 15.0,)),
                            )

                          ],
                        ),
                        new Divider(),

                        SizedBox(height: 20.0,),
                        Text("Email", style: TextStyle(
                            fontWeight: FontWeight.bold,

                            color: commonClass.hexToColor('#949494')
                        ),),
                        SizedBox(height: 20.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(email, style: TextStyle(

                              fontWeight: FontWeight.bold,

                              color: commonClass.hexToColor('#949494'),

                            ),),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                  onTap: () =>
                                      Navigator.of(context).pushNamed('/profileEmail'),
                                  child: Icon(Icons.arrow_forward_ios, size: 15.0,)),
                            )

                          ],
                        ),
                        new Divider(),
                        SizedBox(height: 30.0,),
                        Container(
                          child: ButtonTheme(
                            height: 45.0,
                            child: RaisedButton(
                              onPressed: () {
                                _dataPost();
                                // Navigator.of(context).pushNamed("/addCategory");

                              },
                              textColor: Colors.white,
                              color: commonClass.hexToColor('#77B790'),
                              child: new Text('Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0
                                ),
                              ),

                            ),
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
      ),
    );
  }

  _dataPost() async {
    _isloading = true;
    try {
      var formData = {
        "name": profileNameController.text,

      };

      final response = await Services(Config.updateName).postMethod(
          formData, context);
      print(response);
      if (response['success'] == true) {
        final responseData = response['data'];
        sharedPreferences.setString('userDetails', json.encode(responseData));

        setState(() {
          _isloading = false;

        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,);
        // Navigator.of(context).pushNamed("/categoryList");
      }
//      else if(response['success'] == null) {
//        final responseData = response['data'];
//
//        var route = MaterialPageRoute(builder: (BuildContext context) =>
//            Mobileverify(phone: responseData['phone'],email:responseData['email'],password:responseData['password']),
//        );
//        Navigator.of(context).pushReplacement(route);
//      }
      else {
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,);
      }
    } catch (e) {
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
        email = json1['email'];

        name = json1['name'];
        if (name == null) {
          name = '';
        }
        if (name == null) {
          name = '';
        }
        profileNameController.text = name;
        profileImage = json1['profile_image'];
        phone = json1['phone_no'];
      });
    }
    catch(e){
      Toast.show("Something went wrong please try again later", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
    // email=json1['']
//    phone=email=sharedPreferences.get('phone');
//    name=email=sharedPreferences.get('name');

  }

  _profileImagePost() async {


    try {
      sharedPreferences = await SharedPreferences.getInstance();
        setState(() {
          _isloading = true;

        });
      try {
        print(image);
//      var formData = {
//        "profile_image":UploadFileInfo(_image, path.basename(_image.path))
//      };
        FormData formdata = new FormData(); // just like JS
        formdata.add("profile_image",
            new UploadFileInfo(_image, path.basename(_image.path)));
        final response = await Services(Config.update_profile_image).postMethod(
            formdata, context);
        print(response);
        if (response['success'] == true) {


          setState(() {
            _isloading = false;

            profileImage = response['image_name'];
            print(profileImage);

          });
          sharedPreferences = await SharedPreferences.getInstance();
          final data = sharedPreferences.get('userDetails');
          final json1 = JsonDecoder().convert(data);
          json1['profile_image']=profileImage;
          sharedPreferences.setString('userDetails',json.encode(json1));

//        sharedPreferences.setString('token', deviceId);
//        sharedPreferences.setString('email', responseData['email']);
//        sharedPreferences.setString('phone', responseData['phone']);
//        sharedPreferences.setString('email', responseData['password']);
//        sharedPreferences.setString('category', response['category'].toString());


          setState(() {
          });
          Toast.show(response['message'], context, duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,);
//          sharedPreferences = await SharedPreferences.getInstance();
//
//          setState(() {
//            profileImage = response['image_name'];
//            final data = sharedPreferences.get('userDetails');
//            final json1 = JsonDecoder().convert(data);
//            json1['profile_image']=profileImage;
//            print(json1['profile_image']);
//
//            sharedPreferences.setString('userDetails',json.encode(json1));
//          //  print(json1['profile_image']);
//          });
//
//
//
//          setState(() {
//            _isloading = false;
//          });
//          Toast.show(response['message'], context, duration: Toast.LENGTH_LONG,
//            gravity: Toast.TOP,);
          // Navigator.of(context).pushNamed("/categoryList");
        }
//      else if(response['success'] == null) {
//        final responseData = response['data'];
//
//        var route = MaterialPageRoute(builder: (BuildContext context) =>
//            Mobileverify(phone: responseData['phone'],email:responseData['email'],password:responseData['password']),
//        );
//        Navigator.of(context).pushReplacement(route);
//      }
        else {
          setState(() {
            _isloading = false;
          });
          Toast.show(response['message'], context, duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,);
        }
      } catch (e) {
        setState(() {
          _isloading = false;
        });
        Toast.show("Something went wrong please try again later", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
      }
    }
    catch(e){

    }

  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  Navigator.pop(context);

                  getImage();
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  Navigator.pop(context);

                  takeImage();
//                  _pickImage('Camera').then((selectedImage) {
//                    setState(() {
//                      imageFile = selectedImage;
//                      print("imagefile=$imageFile");
//                    });
//                    _profileImagePost();
//                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }




  getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _image = image;
      print("image=$image");
      _profileImagePost();
    });
  }


  takeImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera,
    );
    setState(() {
      _image = image;
      _profileImagePost();
    });
  }
}
