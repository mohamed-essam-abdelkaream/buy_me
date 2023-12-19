class HomeDataModel
{
  late bool status;
  late DataModel data;

  HomeDataModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    data = DataModel.fromJson(json['data']);
  }

}

class DataModel
{
  List<Banner> banners = [];
  List<Product> products = [];

  DataModel.fromJson(Map<String, dynamic> json)
  {
    json['banners'].forEach((element) {
      banners.add(Banner.fromJson(element));
    });
    json['products'].forEach((element){
      products.add(Product.fromJson(element));
    });
  }
}

class Banner
{
  late int id;
  late String image;

  Banner.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    image = json['image'];
  }
}

class Product
{
  late int id;
  late num price;
  late num oldPrice;
  late num discount;
  late String image;
  late String name;
  late bool inFavorites;
  late bool inCart;

  Product.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    price = json['price'] ?? 0;
    oldPrice = json['old_price'] ?? 0;
    discount = json['discount'] ?? 0;
    image = json['image'];
    name = json['name'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }

  Product.fromJsonFav(Map<String, dynamic> json)
  {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
  }
}