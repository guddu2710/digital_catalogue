class Product{
  int id;
  String product_name;
  String tag;
  int code;
  String description;
  int user_id;
  int category_id;

  Product(this.id, this.product_name, this.tag, this.code,
      this.description, this.user_id,this.category_id);
  Map<String,dynamic> toMap(){
    var map=<String,dynamic>{
      'id':id,
      'product_name':product_name,
      'tag':tag,
      'code':code,
      'description':description,
      'user_id':user_id,
      'category_id':category_id
    };
    return map;
  }
  Product.fromMap(Map<String,dynamic>map){
    id=map['id'];
    product_name=map['product_name'];
    tag=map['tag'];
    code=map['code'];
    description=map['description'];
    user_id=map['user_id'];
    category_id=map['category_id'];

  }

  Map toJson() {
    return {'id': id, 'product_name': product_name, 'tag': tag,'code': code, 'description': description, 'user_id': user_id,'category_id':category_id};
  }
}