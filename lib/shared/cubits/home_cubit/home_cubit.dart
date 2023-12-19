import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/category_model.dart';
import '../../../models/favorite_model.dart';
import '../../../models/get_favorites_model.dart';
import '../../../models/home_data_model.dart';
import '../../../models/profile_model.dart';
import '../../../models/search_model.dart';
import '../../../modules/category_screen.dart';
import '../../../modules/favorites_screen.dart';
import '../../../modules/login_model.dart';
import '../../../modules/products_screen.dart';
import '../../../modules/settings_screen.dart';
import '../../network/end_points.dart';
import '../../network/local/cache_helper.dart';
import '../../network/remote/dio.dart';
import '../../network/styles/colors.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<BottomNavigationBarItem> navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
      activeIcon: Icon(
        Icons.home,
        color: orange,
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category_outlined),
      label: 'Category',
      activeIcon: Icon(
        Icons.category,
        color: orange,
      ),
    ),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.favorite_outline,
        ),
        label: 'Favorites',
        activeIcon: Icon(
          Icons.favorite,
          color: orange,
        )),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined),
      label: 'Settings',
      activeIcon: Icon(
        Icons.settings,
        color: orange,
      ),
    ),
  ];

  List<Widget> screens = [
    ProductsScreen(),
    CategoryScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  int currentIndex = 0;

  void changeNavIndex(index) {
    currentIndex = index;
    emit(ChangeHomeNavIndexState());
  }

  HomeDataModel? homeDataModel = null;

  void getHomeData() {
    emit(GetHomeDataLoadingSate());

    DioHelper.getData(
      method: HOME,
      token: CacheHelper.getData(key: 'token'),
      lang: CacheHelper.getData(key: 'lang') ?? 'en',
    ).then((response) {
      homeDataModel = HomeDataModel.fromJson(response.data);
      emit(GetHomeDataSuccessSate());
    }).catchError((error) {
      print(error.toString());
      emit(GetHomeDataErrorSate());
    });
  }

  late CategoryModel categoryModel;

  void getCategoryData() {
    DioHelper.getData(
            method: GET_CATEGORY,
            lang: CacheHelper.getData(key: 'lang') ?? 'en')
        .then((response) {
      categoryModel = CategoryModel.fromJson(response.data);
      emit(GetCategorySuccessSate());
    }).catchError((error) {
      print(error.toString());
      emit(GetCategoryErrorSate());
    });
  }

  late FavoriteModel favoriteModel;

  void changeFavorite(int id) {
    emit(ChangeFavState());

    DioHelper.postData(
      method: CHANGE_FAV,
      data: {
        'product_id': id,
      },
      lang: CacheHelper.getData(key: 'lang') ?? 'en',
      token: CacheHelper.getData(key: 'token'),
    ).then((response) {
      favoriteModel = FavoriteModel.fromJson(response.data);
      getHomeData();
      getFavorites();
      emit(ChangeFavSuccessState(favoriteModel));
    }).catchError((error) {
      emit(ChangeFavErrorState());
    });
  }

  late GetFavoriteModel getFavoriteModel;

  void getFavorites() {
    DioHelper.getData(
      method: CHANGE_FAV,
      token: CacheHelper.getData(key: 'token'),
      lang: CacheHelper.getData(key: 'lang') ?? 'en',
    ).then((response) {
      getFavoriteModel = GetFavoriteModel.fromJson(response.data);
      emit(GetFavSuccessState());
    }).catchError((error) {
      emit(GetFavErrorState());
      print(error.toString());
    });
  }

  bool isDark = false;

  void changeThemeMode(bool modeState) {
    isDark = modeState;
    emit(ChangeThemeMode());
  }

  ProfileModel? profileModel = null;

  void getProfileData() {
    DioHelper.getData(
      method: GET_PROFILE,
      token: CacheHelper.getData(key: 'token'),
      lang: CacheHelper.getData(key: 'lang') ?? 'en',
    ).then((response) {
      profileModel = ProfileModel.fromJson(response.data);
      emit(GetProfileSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetProfileErrorState());
    });
  }

  String editImage = CacheHelper.getData(key: 'image') ?? '';

  void changeImage(path) {
    editImage = path;
    emit(ChangeImage());
  }

  late LoginModel updateProfileModel;

  void updateProfile({
    required String name,
    required String phone,
    required String password,
    required String email,
  }) {
    emit(UpdateProfileLoadingState());

    DioHelper.putData(
      method: UPDATE_PROFILE,
      data: {
        'name': name,
        'password': password,
        'phone': phone,
        'email': email,
      },
      lang: CacheHelper.getData(key: 'lang') ?? 'en',
      token: CacheHelper.getData(key: 'token'),
    ).then((response) {
      updateProfileModel = LoginModel.fromJson(response.data);
      CacheHelper.saveData(key: 'image', value: editImage);
      getProfileData();

      emit(UpdateProfileSuccessState(updateProfileModel));
    }).catchError((error) {
      if (kDebugMode) print(error);
      emit(UpdateProfileErrorState());
    });
  }

  bool isObscure = true;
  IconData obscureIcon = Icons.visibility_outlined;

  void changeVisibility() {
    isObscure = !isObscure;
    obscureIcon = obscureIcon == Icons.visibility_outlined
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
    emit(ChangeVisibility());
  }

  late LoginModel signUpModel;

  void signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(SignUpLoadingState());

    DioHelper.postData(
      method: SIGN_UP,
      data: {
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
      },
      lang: CacheHelper.getData(key: 'lang') ?? 'en',
    ).then((response) {
      signUpModel = LoginModel.fromJson(response.data);
      emit(SignUpSuccessState(signUpModel));
    }).catchError((error) {
      if (kDebugMode) print(error);
      emit(SignUpErrorState());
    });
  }

  String lang = 'English';

  void changeLanguage(String language) {
    lang = lang == 'English' ? 'العربية' : 'English';
    CacheHelper.saveData(key: 'lang', value: language);
    getFavorites();
    getHomeData();
    getCategoryData();
    getProfileData();
    emit(ChangeLanguage());
  }

  SearchModel? searchModel = null;

  void getSearch(String text) {
    emit(GetSearchLoading());

    DioHelper.postData(
      method: SEARCH,
      data: {
        "text": text,
      },
      token: CacheHelper.getData(key: 'token'),
    ).then((response) {
      searchModel = SearchModel.fromJson(response.data);
      emit(GetSearchSuccess());
    }).catchError((error) {
      if (kDebugMode) print(error);

      emit(GetSearchError());
    });
  }
}
