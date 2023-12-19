import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/home_data_model.dart';
import '../shared/components/components.dart';
import '../shared/cubits/home_cubit/home_cubit.dart';
import '../shared/cubits/home_cubit/home_states.dart';
import '../shared/network/styles/colors.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: logo,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                defaultTFF(
                  text: 'Search',
                  prefixIcon: CupertinoIcons.search,
                  onSubmit: (String text)
                    {
                      cubit.getSearch(text);
                    }
                ),
                SizedBox(height: 10.0.h,),
                if (state is GetSearchLoading)
                  LinearProgressIndicator(color: blue,),
                SizedBox(height: 10.0.h,),
                if(cubit.searchModel != null)
                  Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => searchItemBuilder(
                            cubit.searchModel!.products[index], context),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 20.0.h,
                        ),
                        itemCount: cubit.searchModel!.products.length,
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget searchItemBuilder(Product product, context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Material(
      borderRadius: BorderRadius.circular(20.0.sp),
      clipBehavior: Clip.hardEdge,
      child: Container(
        color: HomeCubit.get(context).isDark ? asmarFate7 : offWhite,
        height: screenHeight / 4.5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: product.image,
              height: screenHeight / 4.5,
              width: screenHeight / 4.5,
            ),
            SizedBox(
              width: 10.0.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 20.0.h, right: 30.0.w),
                              child: Text(
                                product.name,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 19.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: HomeCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 10.0.h,
                    ),
                    child: Row(
                      children: [
                        Text(
                          product.price.toString() + ' EGP',
                          style: TextStyle(
                            color: orange,
                            fontSize: 18.0.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 5.0.w,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
