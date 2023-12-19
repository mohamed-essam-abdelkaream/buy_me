import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../shared/components/components.dart';
import '../shared/cubits/home_cubit/home_cubit.dart';
import '../shared/cubits/home_cubit/home_states.dart';
import '../shared/network/styles/colors.dart';

class EditProfileScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if(state is UpdateProfileSuccessState)
          {
            if(state.model.status)
              {
                defaultToast(
                    context: context,
                    message: state.model.message,
                    iconColor: Colors.lightGreen,
                    icon: Icons.check_circle,
                );
              }
            else
              {
                defaultToast(
                  context: context,
                  message: state.model.message,
                  iconColor: Colors.red,
                  icon: Icons.error,
                );
              }
          }
      },
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: logo,
            titleSpacing: 0,
          ),
          body: ConditionalBuilder(
            condition: cubit.profileModel != null,
            builder: (context) => Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(state is UpdateProfileLoadingState)
                    LinearProgressIndicator(color: blue, ),
                  //edit image
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CircleAvatar(
                        radius: 50.0.sp,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.all(5.0.sp),
                          child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(50.0.sp),
                            child: cubit.editImage != '' ?
                            Image.file(
                                File(cubit.editImage,),
                              height: double.infinity,
                              width: double.infinity,)
                              : Image(
                              image: NetworkImage(cubit.profileModel!.data.image),
                            ),
                            ),
                          ),
                      ),
                      CircleAvatar(
                        radius: 15.0.sp,
                        backgroundColor: Colors.transparent,
                        child: Material(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.circular(15.0.sp),
                          color: cubit.isDark ? asmarFate7 : offWhite,
                          child: IconButton(
                            onPressed: () async {
                              final imagePicker = ImagePicker();
                              final image = await imagePicker.pickImage(source: ImageSource.gallery);
                              cubit.changeImage(image!.path);
                            },
                            icon: Icon(Icons.edit_outlined,
                            color: cubit.isDark ? skin : Colors.black,
                              size: 24.0.sp,
                            ),
                            color: Colors.black,
                            padding: EdgeInsets.all(0.0),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20.0.h,),
                  //name
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                          child: Column(
                            children: [
                              defaultTFF(
                                text: 'Name',
                                prefixIcon: Icons.person,
                                controller: nameController,
                                onTap: ()
                                {
                                  nameController.text = cubit.profileModel!.data.name;
                                },
                                validate: (value){
                                  if(value != null && value == '') {
                                    return 'Please, Enter Your Name';
                                  }
                                }
                              ),
                              SizedBox(height: 15.0.h,),
                              //email
                              defaultTFF(
                                text: 'Email',
                                prefixIcon: Icons.alternate_email,
                                controller: emailController,
                                onTap: ()
                                {
                                  emailController.text = cubit.profileModel!.data.email;
                                },
                                keyboardType: TextInputType.emailAddress,
                                validate: (value){
                                  if(value != null && value == '') {
                                    return 'Please, Enter Email Address';
                                  }
                                }
                              ),

                              SizedBox(height: 15.0.h,),
                              //password
                              defaultTFF(
                                text: 'Password',
                                prefixIcon: Icons.lock_outline_rounded,
                                controller: passwordController,
                                isObscure: true,
                                  validate: (value){
                                    if(value != null && value == '') {
                                      return 'Please, Enter Password';
                                    }
                                  },
                              ),
                              SizedBox(height: 15.0.h,),
                              //phone
                              defaultTFF(
                                text: 'Phone',
                                prefixIcon: Icons.phone,
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                onTap: ()
                                {
                                  phoneController.text = cubit.profileModel!.data.phone;
                                },
                                validate: (value){
                                  if(value != null && value == '') {
                                    return 'Please, Enter Phone Number';
                                  }
                                }
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Update Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                    child: Container(
                      width: double.infinity,
                      child: defaultButton(
                        onPressed: (){
                          if(formKey.currentState!.validate())
                            {
                              cubit.updateProfile(
                                name: nameController.text,
                                phone: phoneController.text,
                                password: passwordController.text,
                                email: emailController.text,
                              );
                            }
                        },
                        child: Text(
                          'Update Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0.h,),
                ],
              ),
            ),
            fallback: (context) => Center(child: loading),
          ),
        );
      },
    );
  }
}
