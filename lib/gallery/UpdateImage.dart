import 'dart:convert';

import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/gallery/imageAdd.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/input_tags.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
class UpdateImage extends StatefulWidget {
  List list;
  String title;
  int id;
  UpdateImage({Key key, this.list,this.title,this.id}) : super(key: key);
  @override
  _UpdateImageState createState() => _UpdateImageState();
}

class _UpdateImageState extends State<UpdateImage> {
  var catagory_limit,product_limit,product_image_limit;
  SharedPreferences sharedPreferences;

  Icon actionIcon = new Icon(Icons.search);
  final TextEditingController _searchQuery = new TextEditingController();
  Widget appBarTitle;
  final commonClass = new Common();
  bool _isloading=false;
  TextEditingController _textFieldController = TextEditingController();
  var duplicateItems = List();
  List  imageList;
  String titile;
  var id;

  List<String> _tags=[];

  @override
  void initState() {
    super.initState();
    this.id=widget.id;
    this.titile=widget.title;
    this._getsubscription_details();
    _searchQuery.addListener(textListener);
    _getProducts();
  }
  textListener() {
    var searchList=List();
    print("Current Text is ${_searchQuery.text}");
    for(int i=0;i<duplicateItems.length;i++){
      if(duplicateItems[i]['tags'].toString().contains(_searchQuery.text)) {
        print("yes");
        searchList.add(duplicateItems[i]);
      }
      else{
        print("no");
      }
    }
    setState(() {
      print("results=$searchList");
      imageList=searchList;


    });
    //duplicateItems.add(productList[0]);
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
              appBar: AppBar(
                title: appBarTitle,
                backgroundColor: commonClass.hexToColor('#77B790'),
                actions: <Widget>[

                  new IconButton(icon: actionIcon, onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>new CartPage()));
                    setState(() {
                      if (this.actionIcon.icon == Icons.search) {
                        this.actionIcon = new Icon(Icons.close);
                        this.appBarTitle = new TextField(
                          controller: _searchQuery,
                          style: new TextStyle(
                            color: Colors.white,
                          ),
                          decoration: new InputDecoration(
                              prefixIcon: new Icon(Icons.search, color: Colors.white),
                              hintText: "Search...",
                              hintStyle: new TextStyle(color: Colors.white)
                          ),
                        );
                        // _handleSearchStart();
                      }
                      else {
                        imageList=duplicateItems;
                        this.actionIcon = new Icon(Icons.search);
                        this.appBarTitle = new Text("Gallery");
                      }
                    });
                  }),
                  new IconButton(icon: Icon(Icons.add_circle, color: Colors.white,),
                      onPressed: () {
                        Toast.show("${product_image_limit-imageList.length}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
                        var route = MaterialPageRoute(builder: (BuildContext context) =>
                            ImageAdd( id:id,remainingImage:(product_image_limit-imageList.length),route:"jj",title: titile, ),
                        );
                        Navigator.of(context).push(route);
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>new CartPage()));
                      })
                ],
              ),
            body: ModalProgressHUD(
              inAsyncCall:_isloading ,
              child: RefreshIndicator(
                onRefresh: _refreshProducts,
                child: Container(
                  padding: EdgeInsets.only(right: 5.0, left: 5.0, top: 5.0),
                  child: new Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            // child: Column(
                            children: <Widget>[

                              Grid(imageList)


                            ],

                          ),
                        ),



                      ],
                    ),
                  ),
                ),
              ),
            ),
//              floatingActionButton: new FloatingActionButton(
//                  elevation: 0.0,
//                  child: new Icon(Icons.add,color: Colors.white,),
//                  backgroundColor: commonClass.hexToColor('#77B790'),
//                  onPressed: (){
//                    var route = MaterialPageRoute(builder: (BuildContext context) =>
//                        ImageAdd( id:id),
//                    );
//                    Navigator.of(context).push(route);
//                  }
//              )
          ),
        ],
      ),
    );
  }
  Container Grid(List imageList) {
    // int size=productList.length;
    return Container(
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: List.generate(imageList==null? 0:imageList.length, (index)
              {
            return

              Stack(
                alignment: const Alignment(1.0, -1.0),
                children: <Widget>[
                  InkResponse(
                  onLongPress:()=>_showMenu(index),
                  child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child:Image.network("${ Config.imageUrlproduct+"/"+"${imageList[index]['image']}"}",fit:BoxFit.cover,),

                          ),
                        ],)),
            ),
//                  Container(
//                    padding: const EdgeInsets.all(5.0),
//                    child:
//                    InkWell(
//                      onTap: (){_cpmfirmDelete(index);},
//                        child: Icon(Icons.cancel, color: Colors.black,)),
//                  )
                ],
              )
            ;
          }
          ),
        )
    );
  }
  void _onTileClicked(int index){
    var value=imageList[index]['tags'];
    print(value);
    if(imageList[index]['tags']==null){
      _displayDialog(index);
    }
    else{
      _textFieldController.text=imageList[index]['tags'];
      _displayDialogUpdate(index);

    }
//    var route = MaterialPageRoute(builder: (BuildContext context) =>
//        ProductDetails(id:productList[index]['id'] ),
//    );
//    Navigator.of(context).push(route);

    debugPrint("You tapped on item $index");
  }
  _displayDialog(int index)  {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Tag'),
            content:Wrap(
              children: <Widget>[
                InputTags(
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
                    //_tags.add(tag);
                    print(tag);
                  },
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child:
                new Text('CANCEL'),
                onPressed: () {
                  _tags=[];
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _updateTag(index);
                },
              ),

            ],
          );
        });
  }

  _displayDialogUpdate(int index)  {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Tag'),
            content: Wrap(
              children: <Widget>[
                InputTags(
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
                    //_tags.add(tag);
                    print(tag);
                  },
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  _tags=[];
                  _textFieldController.text="";
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Update'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _updateTag(index);
                },
              ),

            ],
          );
        });
  }
  _updateTag(int index)async{
    setState(() {
      _isloading = true;

    });
    print(_tags);
    try{
      var formData = {
        "image_id":_tags.length<0?"":imageList[index]['id'],
        "tag":_tags,
      };
      final response = await Services(Config.updateImageTag).postMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        print(responseData);
        setState(() {
          _tags=[];
          _isloading = false;
        });
        _getProducts();
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
  _getProducts()async{
    setState(() {
      _isloading = true;

    });

    try{
      var formData = {
        "product_id":this.id,
      };
      final response = await Services(Config.getProductImages).postMethod(formData, context);

      print(response);
      if(response['success'] == true) {
        final responseData = response['data'];
        print(responseData);
        setState(() {
          _isloading = false;
          imageList = responseData;
          duplicateItems = responseData;
        //  List<String> stringList = (jsonDecode(responseData['tag']) as List<dynamic>).cast<String>();
          appBarTitle = new Text(titile);

          //_tags=stringList;
          print("products");
          print(imageList);
        });
      }
      else{
        setState(() {
          _isloading = false;
        });
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);
      }
    }catch(e){
      print(e.toString());
      setState(() {
        _isloading = false;
      });
      Toast.show("${e.toString()}", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }
  _cpmfirmDelete(index){

    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want delete Item?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: (){
              Navigator.of(context).pop(true);
              _delete(index);},
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }
  _delete(index)async{
    var id=imageList[index]['id'];
    setState(() {
      _isloading = true;

    });
    try{
      var formData = {
        "image_id":id
      };

      final response = await Services(Config.deleteImage).postMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        print(responseData);
        setState(() {
          print("\n");
          _getProducts();

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
  _showMenu(index){

    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        content:Wrap(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5.0,),
                InkWell(
                  onTap:(){
                    Navigator.pop(context);
                    _setDefaultImage(index);
                  } ,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.photo_album, size: 15.0,),
                        SizedBox(width: 10.0,),
                        Text('Set as default',style: TextStyle(
                            color: Colors.black
                        )),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: commonClass.hexToColor('#949494'),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    print(imageList[index]['tags']);
                    if(imageList[index]['tags']==null){
                      _displayDialog(index);
                    }
                    else{
                      try {
                        var a = imageList[index]['tags'];
                        var ab = (json.decode(a)as List<dynamic>).cast<String>();
                        _tags = ab;
                        print(_tags);
                      }
                      catch(e){
                        print(e);
                      }
                      _displayDialogUpdate(index);

                    }
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.local_offer, size: 15.0,),
                        SizedBox(width: 10.0,),
                        Text('Set tag',style: TextStyle(
                            color: Colors.black
                        )),
                      ],
                    ),
                  ),
                ),
                Divider(
                    color:commonClass.hexToColor('#949494')
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);

                    _cpmfirmDelete(index);
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.delete, size: 15.0,),
                        SizedBox(width: 10.0,),
                        Text('Delete',style: TextStyle(
                            color: Colors.black
                        )),
                      ],
                    ),
                  ),
                ),
                Divider(
                    color:commonClass.hexToColor('#949494')
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);

                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.close, size: 15.0,),
                        SizedBox(width: 10.0,),

                        Text('Cancel',style: TextStyle(
                            color: Colors.black
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ) ,

      ),
    );
  }
  _setDefaultImage(index)async{
    var id=imageList[index]['id'];
    setState(() {
      _isloading = true;

    });
    try{
      var formData = {
        "image_id":id
      };

      final response = await Services(Config.setImageDefault).postMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        print(responseData);
        setState(() {
          print("\n");
          _getProducts();

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

  Future<void> _refreshProducts() async {

    return _getProducts();
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

}
