import 'dart:convert';
import 'dart:io';
import 'package:digital_catalogue/category/UpdateproductDetails.dart';
import 'package:digital_catalogue/category/productDetails.dart';
import 'package:digital_catalogue/common/Common.dart';
import 'package:digital_catalogue/home/EnterEmail.dart';
import 'package:digital_catalogue/model/product.dart';
import 'package:digital_catalogue/services/config.dart';
import 'package:digital_catalogue/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  SharedPreferences sharedPreferences;
  bool _isloading = false;
  List  productList=[];
  var prosucts = new List<Product>();
  final commonClass = new Common();
  File imageFile;
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("");
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  var duplicateItems = List();
  var list;
  String email, phone, name,profileImage;
  var catagory_limit,product_limit,product_image_limit;
  DateTime currentBackPressTime;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {

    super.initState();
    _searchQuery.addListener(textListener);
    _getsubscription_details();
    _getProfiledata();
    _getCategory();
    _getProducts();
  }


  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: (){
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            currentBackPressTime = now;
            Toast.show("double tap to exit", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,);
          }
          else{
            SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
          }
        },
        child: GestureDetector(
        onTap: ()=>FocusScope.of(context).requestFocus(new FocusNode()),
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
                        productList=duplicateItems;
                        this.actionIcon = new Icon(Icons.search);
                        this.appBarTitle = new Text("");
                      }
                    });
                  }),
                  new IconButton(icon: Icon(Icons.add_circle, color: Colors.white,),
                      onPressed: () {
                    if(productList.length<product_limit)
                        Navigator.of(context).pushNamed("/addproduct");
                    else
                      Toast.show("You reached your limit", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,);


                      }),
                ],
              ),
              drawer:
              new Drawer(

                child: Container(
                  color: commonClass.hexToColor('#77B790'),
                  child: new ListView(

                    children: <Widget>[

                      new UserAccountsDrawerHeader
                        (accountName: Text(name),
                        accountEmail: Text("$email"),
                        decoration: BoxDecoration(
                          color:Colors.black
                        ),
                        currentAccountPicture: GestureDetector(
                          child: new CircleAvatar(

                            backgroundColor: Colors.white,
                            child:

                            profileImage==null?
                                Icon(Icons.account_circle):
                            new Container(

                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,

                                      image:  NetworkImage(
                                          "${Config.imageUrlProfile+"/"+profileImage}")
                                    )
                                ))
                          ),
                        ),)

                      ,
                      InkWell(
                        onTap: () {
//                  Navigator.pop(context);
//
//                  Navigator.of(context).pushNamed("/profileSettings");
                        },
                        child:
                        ListTile(
                          title: Text("Profile",style: TextStyle(color: Colors.white),),
                          leading: Icon(Icons.person, color: Colors.white,),
                          onTap: () {
                            print("hi");
                            Navigator.pop(context);
                            print("hi");
                            Navigator.of(context).pushNamed("/profileSettings");
                            print("gi");
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child:
                        ListTile(
                          title: Text("Account Settings",style: TextStyle(color: Colors.white),),
                          leading: Icon(Icons.settings, color: Colors.white,),
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.of(context).pushNamed("/accountSettings");
                          },

                        ),
                      ),
                      InkWell(
                        onTap: () {

                        },
                        child:
                        ListTile(
                          title: Text("Caterories",style: TextStyle(color: Colors.white),),
                          leading: Icon(Icons.dashboard, color: Colors.white,),
                          onTap:() {
                            Navigator.pop(context);

                            Navigator.of(context).pushNamed("/categoryList");
                          },

                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.of(context).pushNamed("/ProductList");

                        },
                        child:
                        ListTile(
                          title: Text("Products",style: TextStyle(color: Colors.white),),
                          leading: Icon(Icons.card_travel, color: Colors.white,),

                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/GalleryShow");
                        },
                        child:
                        ListTile(
                          title: Text("Gallery",style: TextStyle(color: Colors.white),),
                          leading: Icon(Icons.image, color: Colors.white,),
                          onTap:(){
                            Navigator.pop(context);

                            Navigator.of(context).pushNamed("/GalleryShow");
                          } ,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child:
                        ListTile(
                          title: Text("Logout",style: TextStyle(color: Colors.white),),
                          leading: Icon(Icons.arrow_back, color: Colors.white,),
                          onTap: (){
                            sharedPreferences.remove("logged");

                            Navigator.of(context) .pushNamedAndRemoveUntil('/enterEmail', (Route r) => r == null);}


                        ),
                      ),
//                      InkWell(
//                        onTap: () {},
//                        child:
//                        ListTile(
//                          title: Text(
//                            "Empty Category", style: TextStyle(color: Colors.white),),
//                          leading: Icon(Icons.delete, color: Colors.white,),
//
//                        ),
//                      ),


                    ],
                  ),
                ),
              ),
              body: ModalProgressHUD(
                  inAsyncCall:_isloading ,
                child: RefreshIndicator(
                  onRefresh: _refreshProducts,
                  child:
                      productList.length<=0?
                     Container(
                       child: Center(
                         child: Text("No products available", style: TextStyle(
                             color: Colors.black,
                             fontSize: 16.0
                         )),
                       ),
                     )

                          :
                  Container(
                    padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
                    child: ListView(
                      // child: Column(
                      children: <Widget>[
                        Grid(productList)



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

  Container Grid(List prosucts) {
     int size=prosucts.length;
    return Container(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children:
            List.generate(prosucts==null? 0:size, (index) {
              return InkResponse(
                onLongPress:()=>_onLongClick(index) ,
                onTap:()=>_onTileClicked(index),
                child: Container(
                    margin: new EdgeInsets.all(5.0),
                  child:prosucts[index]['product_images'].length>0?
                  image(index):
                  Image.asset("images/logo.png"),
                ),
              )
              ;
            }
            ),
          ),
        )
    );
  }
  void _onTileClicked(int index){

    var route = MaterialPageRoute(builder: (BuildContext context) =>
        ProductDetails(id:productList[index]['id'] ),
    );
    Navigator.of(context).push(route);

    debugPrint("You tapped on item $index");
  }

  _onLongClick(int index){
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ),
    );
    Alert(
      style: alertStyle,
      title: "",
      context: context,
      buttons: [
        DialogButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {Navigator.pop(context);
          _cpmfirmDelete(index);
          },
          color: Colors.red,
        ),
        DialogButton(
          child: Text(
            "Update",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            var route = MaterialPageRoute(builder: (BuildContext context) =>
                UpdateproductDetails(id:productList[index]['id'] ),
            );
            Navigator.of(context).push(route);
          },
            color:  commonClass.hexToColor('#77B790'),

        )
      ],
    ).show();
  }

  _onTileClickedDelete(int index) {
    var id=productList[index]['id'];
    _cpmfirmDelete(id);
  //  _delete(id);
  }



  _delete(int id)async{
    setState(() {
      _isloading = true;
    });
    try{
      var formData = {
        "product_id":id,
      };

      final response = await Services(Config.deleteProduct).postMethod(formData, context);
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
  Future<void> _refresh() async{
    return _getProducts();
  }



  _getProducts()async{
    setState(() {
      _isloading = true;
    });

    try{
      sharedPreferences = await SharedPreferences.getInstance();

      final response = await Services(Config.getProducts).getMethod(context);
      print(response);
      if(response['success'] == true) {
        final responseData = response['data'];
        sharedPreferences.setString('productList', json.encode(responseData));
        print(responseData);
        setState(() {
          _isloading = false;
          productList = responseData;
          duplicateItems = responseData;
          print("products");
          print(productList.length);
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

  createnewList(text) {
    print(text);
  }

  textListener() {
    var searchList=List();
    print("Current Text is ${_searchQuery.text}");
    for(int i=0;i<duplicateItems.length;i++){
      if(duplicateItems[i]['tag'].toString().contains(_searchQuery.text)) {
        print("yes");
        searchList.add(duplicateItems[i]);
      }
      else{
    print("no");
    }
    }
    setState(() {
      print("results=$searchList");
        productList=searchList;

    });
    //duplicateItems.add(productList[0]);
  }

_cpmfirmDelete(index){
  var id=productList[index]['id'];

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
            _delete(id);},
          child: new Text('Yes'),
        ),
      ],
    ),
  );
}

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Toast.show("double tap to exit", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,);
      return Future.value(false);
    }
    return Future.value(true);
  }
  _getCategory()async{

    try{
      sharedPreferences = await SharedPreferences.getInstance();


      final response = await Services(Config.getCatagory).getMethod(context);
      print("response");
      print(response);
      if(response['success'] == true){
        final responseData = response['data'];

        sharedPreferences.setString('categoryList',json.encode(responseData));


        print("responseData");
        print(responseData);
        setState(() {
          _isloading = false;
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

  Future<void> _refreshProducts() async {

    return _getProducts();
  }
  void _getProfiledata() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();

      final data = sharedPreferences.get('userDetails');
      final json1 = JsonDecoder().convert(data);
      print(json1);
      setState(() {
        profileImage = json1['profile_image'];

        email = json1['email'];
        name = json1['name'];
        if (name == null) {
          name = '';
        }
        else{
          name=json1['name'];
        }
        phone = json1['phone_no'];
      });
    }
    catch(e){
      Toast.show("Something went wrong please try again later", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
   }

  Image image(int index) {
    var imagePath;
    int countImage=0;

    for(int i=0;i< productList[index]['product_images'].length;i++){



      if(countImage<=0) {
        if (productList[index]['product_images'][i]['set_default'] == "1") {
          imagePath = Config.imageUrlproduct + "/" +
              productList[index]['product_images'][i]['image'];
          countImage++;
        } else {
          imagePath = Config.imageUrlproduct + "/" +
              productList[index]['product_images'][0]['image'];
        }
      }
//      if(productList[index]['product_images'][i]['set_default']==1){
//         imagePath=Config.imageUrlproduct+"/"+productList[index]['product_images'][i]['image'];
//      }else{
//         imagePath=Config.imageUrlproduct+"/"+productList[index]['product_images'][0]['image'];
//      }
    }
    return Image.network(imagePath,fit: BoxFit.fill,);
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
      print(catagory_limit);
      print(product_limit);
      print(product_image_limit);

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
