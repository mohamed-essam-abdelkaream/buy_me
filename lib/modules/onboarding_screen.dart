import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../shared/components/components.dart';
import '../shared/cubits/onboarding_cubit/cubit.dart';
import '../shared/cubits/onboarding_cubit/states.dart';
import '../shared/network/local/cache_helper.dart';
import '../shared/network/styles/colors.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  List<OnboardingModel> onBoardInfo = [
    OnboardingModel(
        'Choose Product',
        'You Can Easily Find The Product You Want From Our Various Products!',
        'assets/images/i.png'),
    OnboardingModel('Choose a Payment Method',
        'We Have Many Payment Methods Supported!', 'assets/images/ii.png'),
    OnboardingModel(
        'Get Your Order',
        'Open The Doors, Your Order is Now Ready For You!',
        'assets/images/iii.png'),
  ];

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();

    return BlocConsumer<OnBoardingCubit, OnBoardingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              //page view
              Expanded(
                flex: 4,
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: pageController,
                  itemBuilder: (context, index) =>
                      onboardBuildPage(onBoardInfo[index]),
                  itemCount: onBoardInfo.length,
                  onPageChanged: (index) {
                    if (index == onBoardInfo.length - 1) {
                      OnBoardingCubit.get(context).listenPageLastIndex(true);
                    } else
                      OnBoardingCubit.get(context).listenPageLastIndex(false);
                  },
                ),
              ),

              //indicator, buttons
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(20.0.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //Indicator
                      SmoothPageIndicator(
                        controller: pageController,
                        count: onBoardInfo.length,
                        effect: WormEffect(
                          dotColor: metal,
                          activeDotColor: orange,
                          dotHeight: 10.0.sp,
                          dotWidth: 10.0.sp,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          //Skip
                          TextButton(
                            onPressed: () {
                              CacheHelper.saveData(
                                  key: 'onboardingIsSeen', value: true);
                              navigateAndRemove(context, LoginScreen());
                            },
                            child: Text(
                              'SKIP',
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                color: orange,
                              ),
                            ),
                          ),
                          Spacer(),
                          MaterialButton(
                            padding: EdgeInsets.all(10.0.sp),
                            onPressed: () {
                              if (OnBoardingCubit.get(context).isLastPage) {
                                CacheHelper.saveData(
                                    key: 'onboardingIsSeen', value: true);
                                navigateAndRemove(context, LoginScreen());
                              } else {
                                pageController.nextPage(
                                  duration: Duration(milliseconds: 1000),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                );
                              }
                            },
                            color: orange,
                            shape: OnBoardingCubit.get(context).isLastPage
                                ? RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.0.sp))
                                : CircleBorder(),
                            child: OnBoardingCubit.get(context).isLastPage
                                ? Text(
                                    'Get Started',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0.sp,
                                    ),
                                  )
                                : Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 24.0.sp,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget onboardBuildPage(OnboardingModel pageInfo) => Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40.0.h),
            child: Image.asset(
              '${pageInfo.imagePath}',
            ),
          ),

          //upper texts
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Text(
                  '${pageInfo.title}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: blue,
                    fontSize: 28.0.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${pageInfo.describtion}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: black,
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class OnboardingModel {
  final String title;
  final String describtion;
  final String imagePath;

  OnboardingModel(this.title, this.describtion, this.imagePath);
}
