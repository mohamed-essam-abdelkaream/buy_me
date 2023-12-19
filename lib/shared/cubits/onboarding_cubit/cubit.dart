import 'package:bloc/bloc.dart';
import 'package:buy_me/shared/cubits/onboarding_cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingCubit extends Cubit<OnBoardingStates>
{
  OnBoardingCubit() : super(InitialState());

  static OnBoardingCubit get(context) => BlocProvider.of(context);

  bool isLastPage = false;

  void listenPageLastIndex(bool isLast)
  {
    isLastPage = isLast;
    emit(ChangePageLastIndexState());
  }
}