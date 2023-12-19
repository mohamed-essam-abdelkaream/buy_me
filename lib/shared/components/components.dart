import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:motion_toast/motion_toast.dart';
import '../cubits/home_cubit/home_cubit.dart';
import '../cubits/home_cubit/home_states.dart';
import '../network/styles/colors.dart';

void navigateAndRemove(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget,),
        (route) => false);

void navigateTo(context, widget) => Navigator.push(context,
    MaterialPageRoute(builder: (context) => widget,));

Widget defaultTFF({
  TextEditingController? controller,
  FocusNode? focusNode,
  TextInputType? keyboardType,
  required String text,
  required IconData prefixIcon,
  IconData? suffixIcon,
  Function()? onPressedSuffix,
  String? Function(String?)? validate,
  bool isObscure = false,
  Function()? onTap,
  Function(String)? onSubmit,
})
{
  return BlocConsumer<HomeCubit, HomeStates>(
    listener: (context, state) {},
    builder: (context, state) {
      HomeCubit cubit = HomeCubit.get(context);

      return TextFormField(
        controller: controller,
        onTap: onTap,
        onFieldSubmitted: onSubmit,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: isObscure,
        maxLines: 1,
        style: TextStyle(
          color: cubit.isDark? Colors.white : Colors.black,
          fontSize: 16.0.sp,
        ),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0.sp),
            borderSide: BorderSide(style: BorderStyle.none),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0.sp),
            borderSide: BorderSide(style: BorderStyle.none),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0.sp),
            borderSide: BorderSide(style: BorderStyle.none),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0.sp),
            borderSide: BorderSide(style: BorderStyle.none),),
          hintText: text,
          hintStyle: TextStyle(
              color: metal,
              fontSize: 16.0.sp
          ),
          filled: true,
          fillColor: cubit.isDark? asmarFate7 : offWhite,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
            child: Icon(
              prefixIcon,
              color: cubit.isDark? skin : Colors.black54,
              size: 24.0.sp,
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 5.0.w,),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0.sp),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: onPressedSuffix,
                  icon: Icon(suffixIcon, size: 22.0.sp,),
                  color: cubit.isDark? skin : Colors.black54,
                ),
              ),
            ),
          ),
        ),
        validator: validate,
      );
    },
  );
}

Widget login(context) => Text(
  'Login',
  style: TextStyle(
    color: HomeCubit.get(context).isDark ? Colors.white : Colors.black,
    fontSize: 36.0.sp,
    fontWeight: FontWeight.w700,
  ),
);

Widget askToCreate(context) => Text(
  "Don't have an account?",
  style: TextStyle(
    color: HomeCubit.get(context).isDark ? skin : Colors.black,
    fontSize: 14.0.sp
  ),
);

Widget defaultButton({
  required Function() onPressed,
  Widget? child,
}) => MaterialButton(
  onPressed: onPressed,
  highlightColor: Colors.orange,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 7.5.h,),
  child: child,
  color: orange,
);

void defaultToast({
  required BuildContext context,
  required String message,
  required Color iconColor,
  required IconData icon,
})
{
  MotionToast(
    description: Text(
      message,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.0.sp,
      ),
    ),
    primaryColor: HexColor('DEDEDE'),
    animationDuration: Duration(milliseconds: 500,),
    toastDuration: Duration(seconds: 5),
    displaySideBar: false,
    icon: icon,
    animationCurve: Curves.fastLinearToSlowEaseIn,
    secondaryColor: iconColor,
    enableAnimation: false,
    constraints: BoxConstraints(),
    padding: EdgeInsets.all(20.0.sp),
    ).show(context);
  }

Widget logo = Row(
  children: [
    Icon(
      Icons.shopping_bag,
      color: orange,
      size: 28.0.sp,
    ),
    Text(
      'BuyMe',
      style: TextStyle(
        fontSize: 24.0.sp,
        fontWeight: FontWeight.w500
      ),
    ),
  ],
);

Widget loading = SizedBox(
  width: 35.0.sp,
  height: 35.0.sp,

  child: CircularProgressIndicator(
    color: orange,
  ),
);