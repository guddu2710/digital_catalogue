
  import 'dart:convert';

  import 'package:digital_catalogue/common/Common.dart';
  import 'package:digital_catalogue/gallery/UpdateImage.dart';
  import 'package:digital_catalogue/services/config.dart';
  import 'package:digital_catalogue/services/services.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_tags/input_tags.dart';
  import 'package:modal_progress_hud/modal_progress_hud.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:toast/toast.dart';
  class UpdateproductDetails extends StatefulWidget {
    int id;
    UpdateproductDetails({Key key, this.id}) : super(key: key);
    @override
    _UpdateProductDetailsState createState() => _UpdateProductDetailsState();
  }

  class _UpdateProductDetailsState extends State<UpdateproductDetails> {
    TextEditingController productCodeController = new TextEditingController();
    TextEditingController productNameController = new TextEditingController();
    TextEditingController productdescriptionController = new TextEditingController();
    SharedPreferences sharedPreferences;
    String selectedItems;
    String selected="Select Category";
    var id;
    var data;
    var json;
    List<Items> _items = [];
    final commonClass = new Common();
    bool _isloading=false;
    int catergoyId;
    var image;
    var prodcutDetails;
    var imageList=List();
    var category,size,imagePath="";
    List<String> _tags=[];

    @override
    void initState() {
      super.initState();
      this.id =  widget.id;
      _getcategorydata();
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
              resizeToAvoidBottomPadding:true,
              appBar: AppBar(title: Text('Product Details'),
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
                                    Container(
                                  height: 200.0,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  size==0?
                                  Image.asset("images/logo.png",
  //                                  height: 150.0,
  //                                  width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover
                                    ,):
                                  Image.network(
                                    imagePath,

                                  fit: BoxFit.fill
                                    ,),

                                ),
                                    Container(height: 40.0, color: Colors.black54),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        size!=0?
                                        Text("$size",style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          )):Text("No Image",style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          )),
                                        SizedBox(width: 5.0,),
                                        InkWell(
                                          onTap: (){
                                            var route = MaterialPageRoute(builder: (BuildContext context) =>
                                                UpdateImage(list:imageList,title:prodcutDetails['product_name'],id: prodcutDetails['id'],),
                                            );
                                            Navigator.of(context).push(route);
                                          },
                                          child:Icon(Icons.photo_library,color:Colors.white) ,),
                                      ],
                                    )
                                ]
                          ),
                        ),
                            SizedBox(height: 20.0,),
                            Center(

                              child: Padding(
                                padding: EdgeInsets.only(right: 30.0,left: 30.0,top: 20.0),

                                child: Container(
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
                                      TextFormField(
                                        controller: productCodeController,
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
                                      TextFormField(
                                        controller: productNameController,
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
                                      TextFormField(
                                        controller: productdescriptionController,
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
                                      SizedBox(height:20.0,),
                                      Text("Category",style: TextStyle(
                                          fontWeight: FontWeight.bold,

                                          color: commonClass.hexToColor('#949494')
                                      ),),
                                      SizedBox(height: 20.0,),
                                      _items==null?
                                      Text("", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: commonClass.hexToColor('#949494'),
                                      ),):
                                      DropdownButtonHideUnderline(

                                        child: ButtonTheme(
                                          alignedDropdown: true,

                                          child: new DropdownButton<String>(
                                            isExpanded: true,

                                            hint: new Text(selected),
                                            value: selectedItems,
                                            isDense: true,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                selectedItems = newValue;
                                              });
                                              print(selectedItems);
                                            },
                                            items: _items.map((Items map) {
                                              return new DropdownMenuItem<String>(

                                                value: (map.categoryId).toString(),
                                                child: new Text(map.categoryName,
                                                    style: new TextStyle(color: Colors.black)),

                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),


  //                                  prodcutDetails==null?
  //                                  Text("", style: TextStyle(
  //                                    fontWeight: FontWeight.bold,
  //                                    color: commonClass.hexToColor('#949494'),
  //                                  ),):
  //                                  Text("${category['name']}", style: TextStyle(
  //
  //                                    fontWeight: FontWeight.bold,
  //
  //                                    color: commonClass.hexToColor('#949494'),
  //
  //                                  ),),
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
                                        decoration: new BoxDecoration(
                                            border: new Border.all(color: commonClass.hexToColor('#949494'))
                                        ),
                                        child: InputTags(
                                          iconColor: Colors.black,

                                          placeholder: "Add tag",
                                          backgroundContainer:Colors.transparent  ,
                                          color:commonClass.hexToColor('#77B790'),
                                          tags: _tags,
                                            textOverflow:TextOverflow.fade,
                                          onDelete: (tag){
                                            print(tag);
                                          },
                                          onInsert: (tag){
                                            print(tag);
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 5.0,),
                                      SizedBox(height: 20.0,),
                                      Container(
                                        width: MediaQuery.of(context).size.width,

                                        child: ButtonTheme(
                                          height: 45.0,
                                          child: RaisedButton(
                                            onPressed: (){
                                              _updateProduct();
                                              //print(catergoyId);
                                              //print(selectedItems);
                                              //_checkValidation();
                                            },
                                            textColor: Colors.white,
                                            color: commonClass.hexToColor('#77B790'),
                                            child: new Text('Update',
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
      int countImage=0;
      setState(() {
        _isloading = true;

      });
      try{
        var formData = {
          "product_id":id,
        };
        final response = await Services(Config.productDetails).postMethod(formData, context);
        print(response);
        if(response['success'] == true){
          final responseData = response['data'];
          print(responseData['category']);
          setState(() {
            prodcutDetails=responseData;
            imageList=responseData['product_images'];
            category=responseData['category'];
            _isloading = false;
            size=imageList.length;
            productNameController.text = prodcutDetails['product_name'];
            productCodeController.text = prodcutDetails['code'];
            productdescriptionController.text = prodcutDetails['description'];
            selected=category['name'];
            catergoyId=category['id'];
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
          });
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
    void _getcategorydata() async {
      sharedPreferences = await SharedPreferences.getInstance();
      data=sharedPreferences.get('categoryList');
      final json = JsonDecoder().convert(data);
      setState(() {
        _items = (json).map<Items>((item) => Items.fromJson(item)).toList();
        print("_items\n");

      });
      print(_items);

    }
    _updateProduct()async{
        if( selectedItems==null){
          id=catergoyId;
        }
        else{
          id=int.parse(selectedItems);
        }
        setState(() {
          _isloading = true;

        });
      try{
        var formData = {
          "id":prodcutDetails['id'],
          "category_id":id,
          "product_name":productNameController.text,
          "code":productCodeController.text,
          "tag":_tags,
          "description":productdescriptionController.text

        };
        final response = await Services(Config.updateProduct).postMethod(formData, context);
        print(response);
        if(response['success'] == true){
          final responseData = response['data'];
          print(responseData);
          setState(() {
            _isloading = false;
          });
          Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
          _getProductDetails(prodcutDetails['id']);

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
  class Items {
    final int categoryId;
    final String categoryName;
    Items({this.categoryId, this.categoryName});
    factory Items.fromJson(Map<String, dynamic> json) {
      return new Items(
          categoryId: json['id'], categoryName: json['name']);
    }

  }