import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';

class PlaceItemInfo extends StatelessWidget {
  const PlaceItemInfo({
    super.key,
    required this.itemModel,
    required this.heroTag,
  });

  final ItemModel itemModel;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 220.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9CF),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              topRight: Radius.circular(15.r),
            ),
            child: Hero(
              tag: heroTag,
              child: CachedNetworkImage(
                imageUrl: itemModel.image,
                width: double.infinity,
                height: 100.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 100.h,
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return Container(
                    height: 100.h,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, size: 40.sp),
                  );
                },
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            itemModel.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.favorite_border,
                          color: Colors.grey[700],
                          size: 16.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 13.sp,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            itemModel.location,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

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
                    SizedBox(height: 2.h),

                    Text(
                      itemModel.openNow ? '• Open Now' : '• Closed',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
