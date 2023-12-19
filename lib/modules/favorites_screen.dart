import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/home_data_model.dart';
import '../shared/components/components.dart';
import '../shared/cubits/home_cubit/home_cubit.dart';
import '../shared/cubits/home_cubit/home_states.dart';
import '../shared/network/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is ChangeFavSuccessState) {
          if (state.model.status) {
            defaultToast(
              context: context,
              message: 'Already Broken',
              iconColor: Colors.red,
              icon: Icons.heart_broken,
            );
          }
        }
      },
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ConditionalBuilder(
            condition: cubit.getFavoriteModel != null,
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Break my heart to remove from the list',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0.sp,
                  ),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => favoriteItemBuilder(
                        cubit.getFavoriteModel.products[index], context),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20.0.h,
                    ),
                    itemCount: cubit.getFavoriteModel.products.length,
                  ),
                ),
              ],
            ),
            fallback: (context) => Center(child: loading),
          ),
        );
      },
    );
  }

  Widget favoriteItemBuilder(Product product, context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Material(
      borderRadius: BorderRadius.circular(20.0),
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
                                  fontWeight: FontWeight.w700,
                                  color: HomeCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25.0.w),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              HomeCubit.get(context).changeFavorite(product.id);
                            },
                            child: Container(
                              padding: EdgeInsets.all(7.0.w),
                              child: Icon(
                                Icons.heart_broken,
                                color: metal,
                                size: 25.0.w,
                                ),
                            ),
                              highlightColor: HomeCubit.get(context).isDark
                                  ? asmar
                                  : Colors.white,
                            ),
                          ),
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
                          width: 5.0,
                        ),
                        if (product.price != product.oldPrice)
                          Expanded(
                            child: Text(
                              product.oldPrice.toString() + ' EGP',
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                color: skin,
                                decoration: TextDecoration.lineThrough,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
