import 'home_data_model.dart';

class GetFavoriteModel
{
  late bool status;
  List<Product> products = [];

  GetFavoriteModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    json['data']['data'].forEach((product){
      products.add(Product.fromJsonFav(product['product']));
    });
  }
}