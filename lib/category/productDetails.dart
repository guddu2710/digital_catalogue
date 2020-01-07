
import 'package:digital_catalogue/common/Common.dart';
import 'dart:convert';

import 'package:digital_catalogue/gallery/productgallery.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter_tags/selectable_tags.dart';

class ProductDetails extends StatefulWidget {
  int id;
  ProductDetails({Key key, this.id}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String apptitle="";

  SharedPreferences sharedPreferences;
  var data;
  var json;
  final commonClass = new Common();
  bool _isloading=false;
  int id;
  var prodcutDetails;
  var imageList=List();
  var category,size,imagePath="";
  List <String>_tags=[];
  @override
  void initState() {
    super.initState();
    this.id =  widget.id;
    _getProductDetails(this.id);
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
            appBar: AppBar(title: Text(apptitle),
              backgroundColor:commonClass.hexToColor('#77B790') ,
            ),
            body: ModalProgressHUD(
              inAsyncCall: _isloading,
              child: ListView(
                children: <Widget>[
                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20.0,),
                          Container(

                            child: Stack(

                              alignment: Alignment.bottomRight,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(

                                    child:
                                    size==0?
                                    Image.asset("images/logo.png",
                                      height: 150.0,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill
                                      ,):
                                    Image.network(
                                      imagePath,
                                    height: 200.0,
                                      scale: 1.3,
                                      width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill
                                      ,),

                                  ),
                               //   new Container(height: 20.0, color: Colors.black26),

                                ],
                              ),
                              Container(
                                alignment:Alignment(1.0, 0.0),
                                width: MediaQuery.of(context).size.width,
                                  height: 40.0, color: Colors.black54,
                                child: Row(
                                   mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[

                                    size!=0?
                                        Text("$size",style: TextStyle(

                                          fontWeight: FontWeight.bold,

                                          color: Colors.white,

                                        )):Text("0",style: TextStyle(

                                      fontWeight: FontWeight.bold,

                                      color: Colors.white,

                                    )),
                                    SizedBox(width: 5.0,),
                                    size!=0?
                                        InkWell(
                                          onTap: (){
                                            var route = MaterialPageRoute(builder: (BuildContext context) =>
                                                ProductGalleryShow(list:imageList,title:prodcutDetails['product_name'],id: prodcutDetails['id'],),
                                            );
                                            Navigator.of(context).push(route);
                                          },
                                          child:Icon(Icons.photo_library,color:Colors.white,) ,) :
                                        Text(""),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                          SizedBox(height: 20.0,),

                          Center(
                            child: Container(
                              padding: EdgeInsets.only(right: 30.0,left: 30.0,top: 20.0),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Text("Code",style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: commonClass.hexToColor('#949494')
                                  ),),
                                  SizedBox(height: 5.0,),
                                  prodcutDetails==null?
                                  Text("", style: TextStyle(

                                    fontWeight: FontWeight.bold,

                                    color: commonClass.hexToColor('#949494'),

                                  ),):
                                  Text("${prodcutDetails['code']}", style: TextStyle(

                                    fontWeight: FontWeight.bold,

                                    color: commonClass.hexToColor('#949494'),

                                  ),),
                                  new Divider(),
                                  SizedBox(height: 5.0,),

                                  Text("Product name",style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: commonClass.hexToColor('#949494')
                                  ),),
                                  SizedBox(height: 5.0,),
                                  prodcutDetails==null?
                                  Text(
                                    "", style: TextStyle(

                                    fontWeight: FontWeight.bold,

                                    color: commonClass.hexToColor('#949494'),

                                  ),):
                                  Text(
                                    "${prodcutDetails['product_name']}", style: TextStyle(

                                    fontWeight: FontWeight.bold,

                                    color: commonClass.hexToColor('#949494'),

                                  ),),
                                  new Divider(),
                                  SizedBox(height: 5.0,),
                                  Text("Description",style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      color: commonClass.hexToColor('#949494')
                                  ),),
                                  SizedBox(height: 5.0,),
                                  prodcutDetails==null?
                                  Text("", style: TextStyle(

                                    fontWeight: FontWeight.bold,

                                    color: commonClass.hexToColor('#949494'),

                                  ),):
                                  Text("${prodcutDetails['description']}", style: TextStyle(

                                    fontWeight: FontWeight.bold,

                                    color: commonClass.hexToColor('#949494'),

                                  ),),
                                  new Divider(),
                                  SizedBox(height: 5.0,),
                                  Text("Category",style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      color: commonClass.hexToColor('#949494')
                                  ),),
                                  SizedBox(height: 5.0,),
                                  prodcutDetails==null?
                                  Text("", style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: commonClass.hexToColor('#949494'),
                                  ),):
                                  Text("${category['name']}", style: TextStyle(

                                    fontWeight: FontWeight.bold,

                                    color: commonClass.hexToColor('#949494'),

                                  ),),
                                  new Divider(),
                                  SizedBox(height: 5.0,),
                                  Text("Tags",style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      color: commonClass.hexToColor('#949494')
                                  ),),
                                  SizedBox(height: 5.0,),
                                  prodcutDetails==null?
                                  Text("", style: TextStyle(

                                    fontWeight: FontWeight.bold,

                                    color: commonClass.hexToColor('#949494'),

                                  ),):
                                  Container(

                                      padding: const EdgeInsets.all(3.0),

                                    child:
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Wrap(
                                       // MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
                                        children: List<Widget>.generate(
                                            _tags==null?0:_tags.length,(int index){
                                            return Padding(
                                              padding: const EdgeInsets.only(left:4.0),
                                              child: ChoiceChip(
                                                pressElevation: 0.0,
                                                disabledColor:commonClass.hexToColor('#77B790') ,
                                                label: _tags==null?
                                                Text(""):
                                                Text("${_tags[index]}",style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,

                                                ),),
                                                 selected:false),
                                            );
                                        }
                                        ),
                                      ),
                                    )

                                  ),
                                  SizedBox(height: 5.0,),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0,),
                        ],
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
  _getProductDetails(int id)async{
    setState(() {
      _isloading = true;
    });
    int countImage=0;
    try{
      var formData = {
        "product_id":id,
      };
      final response = await Services(Config.productDetails).postMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        print(responseData);
        print(responseData['category']['name']);
        setState(() {

          prodcutDetails=responseData;
          apptitle=prodcutDetails['product_name'];
          imageList=responseData['product_images'];
          category=responseData['category'];
          _isloading = false;
          size=imageList.length;
          if(size>0){
            for(int i=0;i< size;i++){
              if(countImage<=0) {
                if (imageList[i]['set_default'] == "1") {
                  imagePath = Config.imageUrlproduct + "/" +
                      imageList[i]['image'];
                  countImage++;
                } else {
                  imagePath = Config.imageUrlproduct + "/" +
                      imageList[0]['image'];
                }
              }
            }

          }
          List<String> stringList = (jsonDecode(responseData['tag']) as List<dynamic>).cast<String>();

          _tags=stringList;
          print(stringList);
          print(_tags);
          print(stringList);

          // _tags=responseData['tag'] ;

          //_tags.addAll(responseData['tag']);

        });

        print(category);
        print(imageList.length);
      }
      else{
        setState(() {
          _isloading = false;
        });
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


}
