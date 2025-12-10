import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import '../../../../../core/utils/router/routes_name.dart';
import '../../../../home/data/models/item_model.dart';
import '../../../data/models/favourite_model.dart';
import '../../cubit/favourite_cubit.dart';
import '../../cubit/favourite_state.dart';

class FavouriteCard extends StatelessWidget {
  final FavouriteModel item;

  const FavouriteCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final isFavorite = context.read<FavoritesCubit>().isFavorite(
              item.placeId,
            );

        return GestureDetector(
          onTap: () {
            final itemModel = ItemModel(
              id: item.placeId,
              name: item.title,
              image: item.imageUrl,
              rating: item.rating,
              location: item.location,
              openNow: true,
              description: '',
            );

            context.push(RoutesName.categoriesViewDetails, extra: itemModel);
          },
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    // الصورة
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: Image.network(
                        item.imageUrl,
                        width: 110.w,
                        height: 110.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16.w),

                    // المحتوى - العنوان فقط
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 30.w),
                        child: Center(
                          child: Text(
                            item.title,
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF243E4B),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 16.h,
                right: 16.w,
                child: GestureDetector(
                  onTap: () {
                    context.read<FavoritesCubit>().toggleFavorite(item);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    child: isFavorite
                        ? Image.asset(
                            'assets/images/heartFilled.png',
                            width: 24.w,
                            height: 24.h,
                          )
                        : Image.asset(
                            'assets/images/heart.png',
                            width: 24.w,
                            height: 24.h,
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
