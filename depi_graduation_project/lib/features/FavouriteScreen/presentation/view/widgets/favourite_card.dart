import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/core/functions/device_size.dart';
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
                width: screenWidth(context) / 0.3,
                height: screenHeight(context) / 7,
                decoration: BoxDecoration(
                  color: AppColors.Cardcolor,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        item.imageUrl,
                        width: 124,
                        height: 112,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 155,
                          child: Text(
                            item.title,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF243E4B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColors.namesColor,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            SizedBox(
                              width: 155,
                              child: Text(
                                item.location,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.namesColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.starColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 155,
                              child: Text(
                                item.rating,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.namesColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 24,
                right: 24,
                child: GestureDetector(
                  onTap: () {
                    context.read<FavoritesCubit>().toggleFavorite(item);
                  },
                  child: isFavorite
                      ? Image.asset(
                          'assets/images/heartFilled.png',
                          width: 24,
                          height: 24,
                        )
                      : Image.asset(
                          'assets/images/heart.png',
                          width: 24,
                          height: 24,
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
