import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shared/components/components.dart';
import '../shared/cubits/home_cubit/home_cubit.dart';
import '../shared/cubits/home_cubit/home_states.dart';
import '../shared/network/local/cache_helper.dart';
import '../shared/network/styles/colors.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  late Offset offset;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);

        return ConditionalBuilder(
          condition: cubit.profileModel != null,
          builder: (context) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //image
                  CircleAvatar(
                    radius: 45.0.sp,
                    backgroundColor: Colors.transparent,
                    child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(45.0.sp),
                        child: CacheHelper.getData(key: 'image') != null
                            ? Image.file(
                                File(CacheHelper.getData(key: 'image')),
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Image(
                                image: NetworkImage(
                                    cubit.profileModel!.data.image),
                              )),
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  //name
                  Text(
                    cubit.profileModel!.data.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      fontWeight: FontWeight.w500,
                      color: cubit.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 3.0.h,
                  ),
                  //email
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mail_outline_rounded,
                        color: metal,
                        size: 24.0.sp,
                      ),
                      SizedBox(
                        width: 10.0.w,
                      ),
                      Text(
                        cubit.profileModel!.data.email,
                        style: TextStyle(
                          color: metal,
                          fontSize: 15.0.sp,
                        ),
                      ),
                    ],
                  ),
                  //phone
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        color: metal,
                        size: 24.0.sp,
                      ),
                      SizedBox(
                        width: 10.0.w,
                      ),
                      Text(
                        cubit.profileModel!.data.phone,
                        style: TextStyle(color: metal, fontSize: 15.0.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  defaultButton(
                    onPressed: () {
                      navigateTo(context, EditProfileScreen());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0.sp,
                          ),
                        ),
                        SizedBox(
                          width: 10.0.w,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 22.0.sp,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  Container(
                    color: cubit.isDark ? asmarFate7 : offWhite,
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        left: 20.0.w, top: 7.5.h, bottom: 7.5.h),
                    child: Text(
                      'Preferences'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //language
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0.h),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.language_outlined,
                                  size: 28.sp,
                                  color: cubit.isDark ? skin : Colors.black54,
                                ),
                                SizedBox(
                                  width: 10.0.w,
                                ),
                                Text(
                                  'Language',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.0.sp,
                                    color: cubit.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () async {
                                    await showMenu(
                                        color: cubit.isDark
                                            ? asmarFate7
                                            : Colors.white,
                                        context: context,
                                        position: RelativeRect.fromLTRB(
                                            offset.dx, offset.dy, 0, 0),
                                        items: [
                                          PopupMenuItem(
                                            child: Text(
                                              'English',
                                              style: TextStyle(
                                                color: cubit.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14.0.sp,
                                              ),
                                            ),
                                            onTap: () {
                                              cubit.changeLanguage('en');
                                            },
                                          ),
                                          PopupMenuItem(
                                            child: Text(
                                              'العربية',
                                              style: TextStyle(
                                                color: cubit.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14.0.sp,
                                              ),
                                            ),
                                            onTap: () {
                                              cubit.changeLanguage('ar');
                                            },
                                          ),
                                        ]);
                                  },
                                  onTapDown: (details) =>
                                      offset = details.globalPosition,
                                  highlightColor:
                                      cubit.isDark ? asmarFate7 : offWhite,
                                  borderRadius: BorderRadius.circular(10.0.sp),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0.sp, horizontal: 10.0.sp),
                                    child: Row(
                                      children: [
                                        Text(
                                          cubit.lang,
                                          style: TextStyle(
                                            color: cubit.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14.0.sp,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18.0.sp,
                                          color: cubit.isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          //dark mode
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.dark_mode_outlined,
                                  size: 28.sp,
                                  color: cubit.isDark ? skin : Colors.black54,
                                ),
                                SizedBox(
                                  width: 10.0.w,
                                ),
                                Text(
                                  'Dark Mode',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.0.sp,
                                    color: cubit.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.all(12.0.h),
                                  child: Transform.scale(
                                    scale: 1.0.h,
                                    child: CupertinoSwitch(
                                      value: cubit.isDark,
                                      onChanged: (state) {
                                        cubit.changeThemeMode(state);
                                      },
                                      activeColor: orange,
                                      thumbColor:
                                          cubit.isDark ? asmarFate7 : Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: cubit.isDark ? asmarFate7 : offWhite,
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        left: 20.0.w, top: 7.5.h, bottom: 7.5.h),
                    child: Text(
                      'Logout'.toUpperCase(),
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0.sp),
                    ),
                  ),
                  //logout
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0.h, horizontal: 20.0.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          size: 28.sp,
                          color: cubit.isDark ? skin : Colors.black54,
                        ),
                        SizedBox(
                          width: 10.0.w,
                        ),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0.sp,
                            color: cubit.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          borderRadius: BorderRadius.circular(10.0.sp),
                          highlightColor: cubit.isDark ? asmarFate7 : offWhite,
                          onTap: () {
                            CacheHelper.removeData(key: 'token');
                            navigateAndRemove(context, LoginScreen());
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0.sp),
                            child: Row(
                              children: [
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: orange,
                                    fontSize: 14.0.sp,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18.0.sp,
                                  color: orange,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(child: loading),
        );
      },
    );
  }
}
