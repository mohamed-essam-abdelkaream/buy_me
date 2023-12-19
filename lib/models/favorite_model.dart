class FavoriteModel
{
  late bool status;
  late String message;

  FavoriteModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    message = json['message'];
  }
}