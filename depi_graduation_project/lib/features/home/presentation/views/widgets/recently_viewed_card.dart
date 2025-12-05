import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';

class RecentlyViewedCard extends StatelessWidget {
  final ItemModel itemModel;
  final String? heroTag;

  const RecentlyViewedCard({
    super.key,
    required this.itemModel,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 5,
            child: Hero(
              tag: heroTag ?? itemModel.id ?? itemModel.name,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                ),
                child: CachedNetworkImage(
                  imageUrl: itemModel.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported, size: 40.sp),
                    );
                  },
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          itemModel.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Icon(
                        Icons.favorite_border,
                        color: Colors.grey[700],
                        size: 16.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey, size: 13.sp),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          itemModel.location,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  // Rating
                  Row(
                    children: [
                      Text(
                        itemModel.rating,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Icon(Icons.star, color: Colors.amber, size: 14.sp),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  // Open Now Status - Assuming static for now or add to model if needed
                  Text(
                    itemModel.openNow == true ? '• Open Now' : '• Closed',
                    style: TextStyle(
                      color: itemModel.openNow == true ? Colors.green : Colors.red,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
