class ProductCategoryModel{
  String id;
  String main;
  String header;
  String sub;
  String position;
  String categoryIcon;

  ProductCategoryModel({
      this.id, this.main, this.header, this.sub, this.position,this.categoryIcon});
}

class MainCategoryWithId{
  String id;
  String main;
  String position;
  String categoryIcon;

  MainCategoryWithId({this.id, this.main, this.position, this.categoryIcon});
}