import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/category_model.dart';
import '../models/home_data_model.dart';
import '../shared/components/components.dart';
import '../shared/cubits/home_cubit/home_cubit.dart';
import '../shared/cubits/home_cubit/home_states.dart';
import '../shared/network/styles/colors.dart';

class ProductsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is ChangeFavSuccessState) {
          if (!state.model.status) {
            defaultToast(
              context: context,
              message: state.model.message,
              iconColor: Colors.red,
              icon: Icons.error_outline,
            );
          } else {
            defaultToast(
              context: context,
              message: state.model.message,
              iconColor: Colors.red,
              icon: state.model.message.contains('Deleted')
                  ? Icons.heart_broken
                  : Icons.favorite,
            );
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: HomeCubit.get(context).homeDataModel != null &&
              HomeCubit.get(context).categoryModel != null,
          builder: (context) => productsBuilder(
              HomeCubit.get(context).homeDataModel,
              HomeCubit.get(context).categoryModel,
              context),
          fallback: (context) => Center(child: loading),
        );
      },
    );
  }

  Widget productsBuilder(
      HomeDataModel? homeDataModel, CategoryModel categoryModel, context) {
    HomeCubit cubit = HomeCubit.get(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                items: homeDataModel?.data.banners.map((e) {
                  return CachedNetworkImage(
                    imageUrl: e.image,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: screenHeight / 3.5,
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 4),
                  enableInfiniteScroll: true,
                  initialPage: 0,
                  reverse: false,
                  viewportFraction: 1.0,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              //Categories
              Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0.sp,
                  color: cubit.isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                height: 10.0.h,
              ),
              Container(
                height: 90.0.h,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      categoryItemBuilder(categoryModel.data.data![index]),
                  separatorBuilder: (context, index) => SizedBox(
                    width: 10.0.w,
                  ),
                  itemCount: categoryModel.data.data!.length,
                ),
              ),
              SizedBox(
                height: 20.0.h,
              ),
              //products
              Text(
                'New Products',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.0.sp,
                    color: cubit.isDark ? Colors.white : Colors.black),
              ),
              SizedBox(
                height: 10.0.h,
              ),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: 235.0.h,
                  maxCrossAxisExtent: 300.0,
                  crossAxisSpacing: 10.h,
                  mainAxisSpacing: 10.h,
                ),
                itemBuilder: (context, index) => gridProductBuilder(
                  homeDataModel.data.products[index],
                  context,
                ),
                itemCount: homeDataModel!.data.products.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              )
              // GridView.count(
              //   physics: NeverScrollableScrollPhysics(),
              //   crossAxisCount: 2,
              //   shrinkWrap: true,
              //   mainAxisSpacing: 10.0.h,
              //   crossAxisSpacing: 10.0.w,
              //   childAspectRatio: 1 / key.currentContext!.size!.height,
              //   children: List.generate(homeDataModel!.data.products.length,
              //           (index) => gridProductBuilder(homeDataModel.data.products[index], context),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget gridProductBuilder(Product product, context) {
    HomeCubit cubit = HomeCubit.get(context);

    return Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(20.0),
      color: cubit.isDark ? asmarFate7 : Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.image,
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error_outline),
                      height: 150.0.h,
                      width: double.infinity,
                    ),
                    if (product.price != product.oldPrice)
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(
                                5.0,
                              )),
                          child: Text(
                            'Sale',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.0.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                //favorites button
                InkWell(
                  onTap: () {
                    product.inFavorites = !product.inFavorites;
                    cubit.changeFavorite(product.id);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: CircleAvatar(
                    backgroundColor:
                        cubit.isDark ? Colors.black.withOpacity(0.8) : offWhite,
                    radius: 16.0.sp,
                    child: Icon(
                      product.inFavorites
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: product.inFavorites ? orange : skin,
                      size: 19.0.sp,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w600,
                      color: cubit.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        product.price.round().toString() + ' EGP',
                        style: TextStyle(
                          fontSize: 15.0.sp,
                          color: orange,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if (product.price != product.oldPrice)
                        Expanded(
                          child: Text(
                            product.oldPrice.round().toString() + ' EGP',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              color: skin,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget categoryItemBuilder(DataModel_C category) {
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(20.0),
        clipBehavior: Clip.hardEdge,
        child: Container(
          height: 90.0.h,
          width: 90.0.h,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CachedNetworkImage(
                imageUrl: category.image,
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
                fit: BoxFit.cover,
                height: 90.0.h,
                width: 90.0.h,
              ),
              Container(
                width: double.infinity,
                color: orange.withOpacity(.8),
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                child: Text(
                  category.name,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
