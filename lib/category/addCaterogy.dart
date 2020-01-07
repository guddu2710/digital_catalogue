import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
class CategoryAdd extends StatefulWidget {
  @override
  _CategoryAddState createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  @override
  void initState() {
    super.initState();
    categoryController.addListener(_categorySpaceRestriction);

  }
  final commonClass = new Common();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  TextEditingController categoryController = new TextEditingController();

  bool _isloading = false;
  _categorySpaceRestriction() {
    if(categoryController.text.startsWith(" ")){
      setState(() {
        categoryController.text="";
        print(categoryController.text);
      });
    }
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
             appBar: AppBar(title: Text('Add Categories'),
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
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("CATEROGY ADD",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0,
                                    color: commonClass.hexToColor('#77B790')
                                ),),
                                SizedBox(height: 5.0,),
                                new TextFormField(
                                  validator: (value){
                                    if(value.length < 1)
                                    {
                                      return "Enter proper category name";
                                    }else
                                    {
                                      return null;
                                    }
                                  },
                                  autovalidate: _autoValidate,
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
         ],
       ),
     );

  }
  _checkValidation()async {
    if (_formKey.currentState.validate())
    {
      await  _addCategory();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _addCategory()async{
    setState(() {
      _isloading = true;
    });
    try{
      var formData = {
        "name": categoryController.text,
      };
      final response = await Services(Config.addCatagory).postMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        print(responseData);
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
        Navigator.of(context).pushNamed("/categoryList");
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
