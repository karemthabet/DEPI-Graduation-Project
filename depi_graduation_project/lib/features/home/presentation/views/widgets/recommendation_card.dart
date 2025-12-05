import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendationCard extends StatelessWidget {
  final String title;
  final String location;
  final double rating;
  final String imageUrl;

  const RecommendationCard({
    super.key,
    required this.title,
    required this.location,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.w, // Fixed width for horizontal list items
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 90.w,
              height: 90.h,
              fit: BoxFit.fill,
              placeholder: (context, url) => Container(
                width: 90.w,
                height: 90.h,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (context, url, error) => Container(
                width: 90.w,
                height: 90.h,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blueGrey,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blueGrey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.star, color: Colors.amber, size: 16.sp),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
