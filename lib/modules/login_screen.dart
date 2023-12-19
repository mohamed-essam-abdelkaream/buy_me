import 'package:buy_me/modules/sign_up.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../layout/home_layout.dart';
import '../shared/components/components.dart';
import '../shared/cubits/home_cubit/home_cubit.dart';
import '../shared/cubits/login_cubit/login_cubit.dart';
import '../shared/cubits/login_cubit/login_states.dart';
import '../shared/network/local/cache_helper.dart';
import '../shared/network/styles/colors.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          if (state.loginModel.status) {
            defaultToast(
                context: context,
                message: state.loginModel.message,
                iconColor: Colors.lightGreen,
                icon: Icons.check_circle);
            CacheHelper.saveData(
                key: 'token', value: state.loginModel.data?.token);
            HomeCubit.get(context).getHomeData();
            HomeCubit.get(context).getFavorites();
            HomeCubit.get(context).getProfileData();
            navigateAndRemove(context, HomeLayout());
          } else {
            defaultToast(
                context: context,
                message: state.loginModel.message,
                iconColor: Colors.red,
                icon: Icons.dangerous);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: logo,
          ),
          body: Padding(
            padding: EdgeInsets.all(20.0.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          login(context),
                          SizedBox(
                            height: 5.0.h,
                          ),
                          Text(
                            'Please Sign in to continue.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0.sp,
                            ),
                          ),
                          SizedBox(
                            height: 40.0.h,
                          ),
                          //email
                          defaultTFF(
                              controller: emailController,
                              text: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.alternate_email,
                              validate: (value) {
                                if (value != null && value == '')
                                  return 'Please, Enter an Email';
                              }),
                          SizedBox(
                            height: 20.0.h,
                          ),
                          //password
                          defaultTFF(
                              controller: passwordController,
                              isObscure: LoginCubit.get(context).isObscure,
                              text: 'Password',
                              prefixIcon: Icons.lock_outline_rounded,
                              suffixIcon:
                                  LoginCubit.get(context).passwordSuffixIcon,
                              onPressedSuffix: () {
                                LoginCubit.get(context).changeVisibilityMode();
                              },
                              validate: (value) {
                                if (value != null && value == '')
                                  return 'Please, Enter your password';
                              }),
                          SizedBox(
                            height: 40.0.h,
                          ),
                          //Login Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ConditionalBuilder(
                                condition: state is! LoginLoadingState,
                                builder: (Context) => defaultButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      LoginCubit.get(context).LogIn(
                                        email: emailController.text.toString(),
                                        password:
                                            passwordController.text.toString(),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Icon(
                                        CupertinoIcons.forward,
                                        color: Colors.white,
                                        size: 24.0.sp,
                                      ),
                                    ],
                                  ),
                                ),
                                fallback: (context) => Padding(
                                  padding: EdgeInsets.only(right: 40.0.w),
                                  child: loading,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    askToCreate(context),
                    TextButton(
                      onPressed: () {
                        navigateTo(context, SignUpScreen());
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: orange,
                          fontSize: 14.0.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
