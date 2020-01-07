import 'dart:convert';

import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/gallery/imageAdd.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/input_tags.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
class ProductGalleryShow extends StatefulWidget {
    List list;
    String title;
    int id;
    ProductGalleryShow({Key key, this.list,this.title,this.id}) : super(key: key);

  @override
  _ProductGalleryShowState createState() => _ProductGalleryShowState();
}

class _ProductGalleryShowState extends State<ProductGalleryShow> {
   String apptitle;
  int id;
  Icon actionIcon = new Icon(Icons.search);
  final TextEditingController _searchQuery = new TextEditingController();
  Widget appBarTitle;
  final commonClass = new Common();
  bool _isloading=false;
  TextEditingController _textFieldController = TextEditingController();
  var duplicateItems = List();
  List  imageList;
   List<String> _tags=[];

   @override
  void initState() {
    super.initState();
    this.apptitle=widget.title;
    _searchQuery.addListener(textListener);
   // this.imageList=widget.list;
    this.id=widget.id;
    _getProducts(this.id);
   // this.duplicateItems=widget.list;
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
                        _searchQuery.text="";
                        imageList=duplicateItems;
                        this.actionIcon = new Icon(Icons.search);
                        this.appBarTitle = new Text(apptitle);
                      }
                    });
                  }),

                ],
              ),
            body: ModalProgressHUD(
              inAsyncCall:_isloading ,
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
            return InkResponse(
//              onLongPress:()=>_onTileClicked(index),
              child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(

                        child:Image.network("${ Config.imageUrlproduct+"/"+"${imageList[index]['image']}"}",fit:BoxFit.fill,),

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
    var value=imageList[index]['tags'];
    print(value);
    if(imageList[index]['tags']==null){
      _displayDialog(index);
    }
    else{
      _textFieldController.text=imageList[index]['tags'];
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
//    var route = MaterialPageRoute(builder: (BuildContext context) =>
//        ProductDetails(id:productList[index]['id'] ),
//    );
//    Navigator.of(context).push(route);
    setState(() {

    });
    debugPrint("You tapped on item $index");
  }
  _displayDialog(int index)  {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Tag'),
            content:
            Wrap(
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
    try{
      var formData = {
        "image_id":imageList[index]['id'],
        "tag":_textFieldController.text,
      };
      final response = await Services(Config.updateImageTag).postMethod(formData, context);
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];
        print(responseData);
        setState(() {
            _textFieldController.text="";
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
  _addTag(int index)async{
    _isloading = true;
    try{
      var formData = {
        "image_id":imageList[index]['id'],
        "tag": _textFieldController.text,

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
  _getProducts(id)async{
     setState(() {
       _isloading = true;

     });

    try{
      var formData = {
        "product_id":id,
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
          appBarTitle = new Text(apptitle);
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
      Toast.show("Something went wrong please try again later", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }

}
