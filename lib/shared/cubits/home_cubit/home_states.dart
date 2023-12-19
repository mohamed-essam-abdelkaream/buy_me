
import '../../../models/favorite_model.dart';
import '../../../modules/login_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class ChangeHomeNavIndexState extends HomeStates {}

class GetHomeDataLoadingSate extends HomeStates {}

class GetHomeDataSuccessSate extends HomeStates {}

class GetHomeDataErrorSate extends HomeStates {}

class GetCategorySuccessSate extends HomeStates {}

class GetCategoryErrorSate extends HomeStates {}

class ChangeFavState extends HomeStates {}

class ChangeFavSuccessState extends HomeStates {
  FavoriteModel model;

  ChangeFavSuccessState(this.model);
}

class ChangeFavErrorState extends HomeStates {}

class GetFavSuccessState extends HomeStates {}

class GetFavErrorState extends HomeStates {}

class ChangeThemeMode extends HomeStates {}

class ChangeImage extends HomeStates {}

class GetProfileSuccessState extends HomeStates {}

class GetProfileErrorState extends HomeStates {}

class UpdateProfileSuccessState extends HomeStates {
  late LoginModel model;

  UpdateProfileSuccessState(this.model);
}

class UpdateProfileErrorState extends HomeStates {}

class UpdateProfileLoadingState extends HomeStates {}

class ChangeVisibility extends HomeStates {}

class SignUpLoadingState extends HomeStates {}

class SignUpSuccessState extends HomeStates {
  LoginModel model;

  SignUpSuccessState(this.model);
}

class SignUpErrorState extends HomeStates {}

class ChangeLanguage extends HomeStates {}

class GetSearchSuccess extends HomeStates {}

class GetSearchLoading extends HomeStates {}

class GetSearchError extends HomeStates {}