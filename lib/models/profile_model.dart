import '../modules/login_model.dart';

class ProfileModel
{
  late bool status;
  late UserData data;

  ProfileModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    data = UserData.fromJson(json['data']);
  }
}