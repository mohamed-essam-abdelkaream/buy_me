import '../../../modules/login_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class ChangeVisibilityState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  late LoginModel loginModel;

  LoginSuccessState(this.loginModel);

}

class LoginErrorState extends LoginStates {}