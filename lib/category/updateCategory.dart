import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
class CategoryUpadte extends StatefulWidget {
  String categoryName;
  int categoryId;
  CategoryUpadte({Key key, this.categoryName,this.categoryId}) : super(key: key);
  @override
  _CategoryUpadteState createState() => _CategoryUpadteState();
}

class _CategoryUpadteState extends State<CategoryUpadte> {


  @override
  void initState() {
    super.initState();
    this.categoryName =  widget.categoryName;
    this.categoryId =  widget.categoryId;
    this.categoryController.text=widget.categoryName;


  }
  String categoryName;
  int categoryId;
  final commonClass = new Common();
  SharedPreferences sharedPreferences;

  TextEditingController categoryController = new TextEditingController();
  bool _isloading = false;

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

             appBar: AppBar(title: Text('Update Categories'),
               backgroundColor:commonClass.hexToColor('#77B790') ,
             ),

            body: ModalProgressHUD(
              inAsyncCall: _isloading,
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
                              Text("CATEROGY UPDATE",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                  color: commonClass.hexToColor('#77B790')
                              ),),
                              SizedBox(height: 5.0,),
                              new TextFormField(
                                validator: (value){
                                    if(value.length < 1)
                                    {
                                      return "Enter Category name";
                                    }else
                                    {
                                      return null;
                                    }
                                  },
//                          autovalidate: _autoValidate,
                                controller: categoryController,
                                decoration: new InputDecoration(
                                  labelText: 'Category Name',
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

                        child: ButtonTheme(
                          height: 45.0,
                          child: RaisedButton(
                            onPressed: (){

                              _dataPost();
                            },
                            textColor: Colors.white,
                            color: commonClass.hexToColor('#77B790'),
                            child: new Text('UPDATE',
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
        ],
      ),
    );

  }




  _dataPost()async{
    setState(() {
      _isloading = true;

    });
    try{
      sharedPreferences = await SharedPreferences.getInstance();
      var formData = {
        "id":categoryId,
        "name": categoryController.text,
      };

      final response = await Services(Config.updateCatagory).postMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
//        sharedPreferences.setString('userDetails',json.encode(responseData));
//        sharedPreferences.setString('token', deviceId);
//        sharedPreferences.setString('email', responseData['email']);
//        sharedPreferences.setString('phone', responseData['phone']);
//        sharedPreferences.setString('email', responseData['password']);
//        sharedPreferences.setString('category', response['category'].toString());


        print(responseData);
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
        Navigator.of(context).popAndPushNamed("/categoryList");
      }
//      else if(response['success'] == null) {
//        final responseData = response['data'];
//
//        var route = MaterialPageRoute(builder: (BuildContext context) =>
//            Mobileverify(phone: responseData['phone'],email:responseData['email'],password:responseData['password']),
//        );
//        Navigator.of(context).pushReplacement(route);
//      }
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
