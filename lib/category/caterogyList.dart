import 'dart:convert';

import 'package:digital_catalogue/category/updateCategory.dart';
import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
class CategotyList extends StatefulWidget {
  @override
  _CategotyListState createState() => _CategotyListState();
}

class _CategotyListState extends State<CategotyList> {
  var catagory_limit,product_limit,product_image_limit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getValue();
    this._getCategory();
    this._getsubscription_details();
  }




  List  CategoryList;
  SharedPreferences sharedPreferences;
  var value;

  final commonClass = new Common();
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        if(CategoryList.length>0)
          Navigator.of(context).pushReplacementNamed("/ProductList");
        else
          Navigator.of(context).pushReplacementNamed("/addCategory");
      },
      child: GestureDetector(
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
              resizeToAvoidBottomInset : false,
              resizeToAvoidBottomPadding:false,
              appBar: AppBar(title: Text('Categories'),
                backgroundColor:commonClass.hexToColor('#77B790'),
                actions: <Widget>[


                  new IconButton(icon: Icon(Icons.add_circle, color: Colors.white,),
                      onPressed: () {
                        if(CategoryList.length<catagory_limit)
                        Navigator.of(context).pushNamed("/addCategory");
                        else
                          Toast.show("You reached your limit", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);

                      }),
                ],
              ),
              body:ModalProgressHUD(
                inAsyncCall:_isloading,
                child: Container(
                  padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0
                  ),
                    child:
                    Column(

                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(bottom: 5.0),

                            child:
                            getNoteListView(context,CategoryList),
                      ),
                        ),
                        //
//                new Align(
//                    alignment: Alignment.bottomCenter,
//                    child: new Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        Padding(
//                          padding: const EdgeInsets.only(bottom: 20.0),
//                          child: Container(
//
//                            child: ButtonTheme(
//                              minWidth: MediaQuery.of(context).size.width-50,
//
//                              height: 45.0,
//                              child: RaisedButton(
//                                onPressed: (){
//                                  Navigator.of(context).pushNamed("/addCategory");
//
//                                  //_addCategory();
//                                },
//                                textColor: Colors.white,
//                                color: commonClass.hexToColor('#77B790'),
//                                child: new Text('ADD',
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      fontSize: 16.0
//                                  ),
//                                ),
//
//                              ),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ))
                      ],
                    ),


                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView getNoteListView(BuildContext context, List categoryList,) {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: categoryList==null? 0:categoryList.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text("${categoryList[position]['name']}"),
            trailing:Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(icon: Icon(Icons.create), onPressed:
                    () {
                      var route = MaterialPageRoute(builder: (BuildContext context) =>
                          CategoryUpadte(categoryName: categoryList[position]['name'],categoryId: categoryList[position]['id']),
                      );
                      Navigator.of(context).pushReplacement(route);
                }
//                (){
//              databaseHelper.delete(this.productList[position].id);
//            }
                ),
                IconButton(icon: Icon(Icons.delete), onPressed:
                    () {
                  return showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      title: new Text('Are you sure?'),
                      content: new Text('Do you want to delete this Category'),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: new Text('No'),
                        ),
                        new FlatButton(
                          onPressed: (){ Navigator.of(context).pop(true);
                          _deleteCategory(categoryList[position]['id']);},
                          child: new Text('Yes'),
                        ),
                      ],
                    ),
                  ) ?? false;
                }
//                (){
//              databaseHelper.delete(this.productList[position].id);
//            }
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
            },

          ),
        );
      },
    );
  }
  getValue() async{
    sharedPreferences = await SharedPreferences.getInstance();
    value=sharedPreferences.getString('category');


  }

  _getCategory()async{
    setState(() {
      _isloading = true;
    });


    try{
      sharedPreferences = await SharedPreferences.getInstance();


      final response = await Services(Config.getCatagory).getMethod(context);
      print("response");
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];

        sharedPreferences.setString('categoryList',json.encode(responseData));
//        var data=json.encode(responseData);
//        final json1 = JsonDecoder().convert(data);
//
//        print(json1.length);

        print("responseData");
        print(responseData);
        setState(() {
          _isloading = false;
          CategoryList=responseData;
          print(CategoryList);
        });

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
  _deleteCategory(int id)async{
    setState(() {
      _isloading = true;
    });
    try{
      var formData = {
        "id":id,
      };

      final response = await Services(Config.deleteCatagory).postMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        print(responseData);
        setState(() {
          print("\n");
          _getCategory();

          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
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
