import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../modules/login_model.dart';
import '../../network/end_points.dart';
import '../../network/remote/dio.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isObscure = true;
  IconData passwordSuffixIcon = Icons.visibility_outlined;

  void changeVisibilityMode()
  {
    isObscure = !isObscure;
    passwordSuffixIcon = isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangeVisibilityState());
  }

  late LoginModel loginModel;

  void LogIn({
  required String email,
  required String password,
})
  {
    emit(LoginLoadingState());
    
    DioHelper.postData(
      method: LOGIN,
      data: {
        "email" : email,
        "password" : password,
      },
      lang: 'en',
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(LoginSuccessState(loginModel));

    }).catchError((error) {
      print('error : ' + error.toString());
      emit(LoginErrorState());
    });
  }
}