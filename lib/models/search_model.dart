import 'home_data_model.dart';

class SearchModel
{
  late bool status;
  List<Product> products = [];

  SearchModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    json['data']['data'].forEach((product){
      products.add(Product.fromJson(product));
    });
  }
}