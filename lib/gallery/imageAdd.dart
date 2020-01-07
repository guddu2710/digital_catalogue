import 'package:digital_catalogue/gallery/UpdateImage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
//import 'package:multiple_image_picker/multiple_image_picker.dart';
class ImageAdd extends StatefulWidget {
  int id,remainingImage;
  String route,title;
  ImageAdd({Key key, this.id,this.route,this.title,this.remainingImage}) : super(key: key);

  @override
  _ImageAddState createState() => _ImageAddState();
}

class _ImageAddState extends State<ImageAdd> {
  SharedPreferences sharedPreferences;
  bool _isloading = false;
  List  productList;
  int id,remainingImage;
  final commonClass = new Common();
  File imageFile;
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("hiii");
  final key = new GlobalKey<ScaffoldState>();
  List  imageList=new List();
  List<File>_image=new List();
  String route,title;
  @override
  void initState() {
    this.remainingImage=widget.remainingImage;
    print("remain=${this.remainingImage}");
    if(widget.route!=null)
      this.route=widget.route;
    if(widget.title!=null)
      this.title=widget.title;
    this.id=widget.id;
    super.initState();



  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>FocusScope.of(context).requestFocus(new FocusNode()),
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
            appBar: AppBar(
              title: Text("Add Image"),
              backgroundColor: commonClass.hexToColor('#77B790'),
              actions: <Widget>[
                new IconButton(icon: Icon(Icons.add_circle, color: Colors.white,),
                    onPressed: () {
                      Toast.show("$remainingImage", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
                      Toast.show("${_image.length}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,);

                      print(remainingImage);
                      print(_image.length);
                  if(_image.length<remainingImage) {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>new CartPage()));
                    _showImageDialog();
                  }
                  else
                    {
                      Toast.show("You reached your limit", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);

                    }

                    }),
              ],
            ),
            body: ModalProgressHUD(
              inAsyncCall:_isloading ,
              child: Container(
                padding: EdgeInsets.only(right: 5.0, left: 5.0, top: 5.0),
                child: new Container(
                  //  key: _formKey,
                  // autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          // child: Column(
                          children: <Widget>[

                            Grid(_image)


                          ],

                        ),
                      ),

                      new Align(
                          alignment: Alignment.bottomCenter,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Container(

                                  child: ButtonTheme(
                                    minWidth: MediaQuery.of(context).size.width-50,

                                    height: 45.0,
                                    child: RaisedButton(
                                      onPressed: (){
                                        _image.length>0?
                                        _profileImagePost():
                                        Toast.show("No image to upload", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);

                                        //   Navigator.of(context).pushNamed("/addCategory");

                                        //_addCategory();
                                      },
                                      textColor: Colors.white,
                                      color: commonClass.hexToColor('#77B790'),
                                      child: new Text('Upload',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0
                                        ),
                                      ),

                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))

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

  Container Grid(List<File> image) {
    // int size=productList.length;
    return Container(
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: List.generate(image==null? 0:image.length, (index) {
            return InkResponse(
              onLongPress:()=>_onTileClicked(index),
              child: Card(


                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(

                          child:Image.file(image[index],fit:BoxFit.cover,),

                      ),
                                     ],)),
            )
            ;
          }
          ),
        )
    );
  }
  void _onTileClicked(int index){

//    var route = MaterialPageRoute(builder: (BuildContext context) =>
//        ProductDetails(id:productList[index]['id'] ),
//    );
//    Navigator.of(context).push(route);
      setState(() {
        _image.removeAt(index);

      });
      Toast.show("Image Deleted", context,duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
      debugPrint("You tapped on item $index");
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
                  getImage();
                  Navigator.pop(context);

                },

              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  takeImage();
                  Navigator.pop(context);


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
      if(_image.length<=remainingImage)
      _image.add(image);
      else
        Toast.show("You reached your limit", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);

      print("image=$image");
    });
   // Grid(_image);

  }
  takeImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      if(_image.length<=remainingImage)
      _image.add(image);
      else
        Toast.show("You reached your limit", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);

      print("image=$image");

    });
    //Grid(_image);
  }
  _profileImagePost() async {


    try {

      setState(() {
        _isloading = true;
      });
      try {
        final imagesBytes = {};
        for (var name in _image) {
          final bytes = await name;
          imagesBytes[name.path] = bytes.path;
        }
        final imagesData = _image.map((a) => UploadFileInfo(a, a.path)).toList();
        print("images=$imagesData");

        FormData data=new FormData();
        data.add("product_id", id);
        data.add("upload_images[]", imagesData);
        final response = await Services(Config.uploadProductImages).postMethod(
            data, context);
        print(response);
        if (response['success'] == true) {
          setState(() {
            _isloading = false;

            if(route!=null){

              Toast.show(response['message'], context, duration: Toast.LENGTH_LONG,
                gravity: Toast.TOP,);
              var route1 = MaterialPageRoute(builder: (BuildContext context) =>
                  UpdateImage(id:id,title: title,),
              );
              Navigator.of(context).pushReplacement(route1);
            }
            else{
              Navigator.of(context).popAndPushNamed("/ProductList");

            }
            //profileImage = response['image_name'];
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
    catch(e){
      setState(() {
        _isloading = false;

      });

      Toast.show("Something went wrong please try again later", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }

  }

}
