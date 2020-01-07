import 'dart:convert';
import 'package:flutter_tags/input_tags.dart';
import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/gallery/imageAdd.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
class ProductAdd extends StatefulWidget {
  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final commonClass = new Common();
  TextEditingController productCodeController = new TextEditingController();
  TextEditingController productNameController = new TextEditingController();
  TextEditingController productdescriptionController = new TextEditingController();
  TextEditingController productTagsController = new TextEditingController();
  SharedPreferences sharedPreferences;
  var catagory_limit,product_limit,product_image_limit;

  List<Items> _items = [];
  String selectedItems;
  var data;
  bool _isloading = false;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  List<String> _tags=[];
  @override
  void initState(){

   super.initState();
   this._getsubscription_details();

   this._getcategorydata();
  }
  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List fruits) {
    List<DropdownMenuItem<String>> items = new List();
    for (String fruit in fruits) {
      items.add(new DropdownMenuItem(value: fruit, child: new Text(fruit)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: ()=>FocusScope.of(context).requestFocus(new FocusNode()),
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
            resizeToAvoidBottomPadding:true,
            appBar: AppBar(title: Text('Add Products'),
              backgroundColor:commonClass.hexToColor('#77B790') ,
            ),

            body: ModalProgressHUD(
              inAsyncCall: _isloading,
              child: Container(
                padding: EdgeInsets.only(right: 30.0,left: 30.0,top: 20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new TextFormField(
//
                                  validator: (value){
                                    if(value.length < 1)
                                    {
                                      return "Enter Code";
                                    }else
                                    {
                                      return null;
                                    }
                                  },
                                autovalidate: _autoValidate,
                                  controller: productCodeController,
                                  decoration: new InputDecoration(
                                    labelText: 'Code',
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
                                  validator: (value){
                                    if(value.length < 1)
                                    {
                                      return "Enter product name";
                                    }else
                                    {
                                      return null;
                                    }
                                  },
                                autovalidate: _autoValidate,
                                  controller: productNameController,
                                  decoration: new InputDecoration(
                                    labelText: 'Product Name',
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

                                Text("Catrgory",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: commonClass.hexToColor('#949494')
                                ),),
                                SizedBox(height: 20.0,),
                                  Center(
                                    child:

                                    DropdownButtonHideUnderline(

                                      child: ButtonTheme(
                                        alignedDropdown: true,

                                        child: new DropdownButton<String>(
                                          isExpanded: true,
                                          hint: new Text("Select Category"),
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




                                  ),
                                SizedBox(height: 20.0,),

                                Text("Description",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: commonClass.hexToColor('#949494')
                                ),),
                                SizedBox(height: 20.0,),
                                TextFormField(
                                  maxLines:4,
//
                                    validator: (value){
                                      if(value.length < 3)
                                      {
                                        return "Enter Description";
                                      }else
                                      {
                                        return null;
                                      }
                                    },
                                autovalidate: _autoValidate,
                                  controller: productdescriptionController,
                                  decoration: new InputDecoration(
                                    focusedBorder: new OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: commonClass.hexToColor('#949494')
                                        )
                                    ),
                                    enabledBorder: new OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: commonClass.hexToColor('#949494')
                                        )
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20.0,),

                                Text("Tags",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: commonClass.hexToColor('#949494')
                                ),),
                                SizedBox(height: 20.0,),

                                Container(
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: new BoxDecoration(
                                      border: new Border.all(color: commonClass.hexToColor('#949494'))
                                  ),
                                  child: InputTags(

                                    placeholder: "Add tag",
                                    iconColor: Colors.black,
                                    backgroundContainer:Colors.transparent  ,
                                    color:commonClass.hexToColor('#77B790'),
                                    tags: _tags,
                                    onDelete: (tag){
                                      print(tag);
                                    },
                                    onInsert: (tag){
                                      print(tag);
                                    },
                                  ),
                                )
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
                              },
                              textColor: Colors.white,
                              color: commonClass.hexToColor('#77B790'),
                              child: new Text('ADD',
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
            ),
          ),
        ],
      ),
    );
  }

  _addProduct()async{
      setState(() {
        _isloading = true;

      });
    try{
      var formData = {
        "category_id":int.parse(selectedItems),
        "product_name":productNameController.text,
        "code":productCodeController.text,
        "tag":_tags,
        "description":productdescriptionController.text

      };

      final response = await Services(Config.addProduct).postMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        print(responseData);
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);

        var route = MaterialPageRoute(builder: (BuildContext context) =>
            ImageAdd( id:responseData['product_id'],remainingImage: product_image_limit,),
        );
        Navigator.of(context).pushReplacement(route);
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
  _checkValidation()async {
    if (_formKey.currentState.validate())
    {
      await  _addProduct();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
  void _getsubscription_details() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();

      final data = sharedPreferences.get('subscription_details');
      final json1 = JsonDecoder().convert(data);
      print(json1);
      setState(() {
        catagory_limit = int.parse(json1['catagory_limit']);
        product_limit = int.parse(json1['product_limit']);
        product_image_limit = int.parse(json1['product_image_limit']);
        Toast.show("$product_image_limit", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);



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