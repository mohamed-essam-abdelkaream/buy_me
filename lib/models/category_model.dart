class CategoryModel
{
  late bool status;
  late CategoryDataModel data;

  CategoryModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    data = CategoryDataModel.fromJson(json["data"]);
  }
}

class CategoryDataModel
{
  late int currentPage;
  List<DataModel_C>? data = [];

  CategoryDataModel.fromJson(Map<String, dynamic>json)
  {
    currentPage = json['current_page'];
    json['data'].forEach((element){
      data?.add(DataModel_C.fromJson(element));
    });
  }
}

class DataModel_C
{
  late int id;
  late String name;
  late String image;

  DataModel_C.fromJson(Map<String, dynamic>json)
  {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}