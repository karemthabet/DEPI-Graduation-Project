import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp/features/home/data/models/place_model.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';

class PlaceDetailsView extends StatefulWidget {
  final PlaceModel place;

  const PlaceDetailsView({super.key, required this.place});

  @override
  State<PlaceDetailsView> createState() => _PlaceDetailsViewState();
}

class _PlaceDetailsViewState extends State<PlaceDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<PlacesCubit>().loadPlaceDetails(widget.place.placeId);
  }

  Future<void> _openInMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يمكن فتح الخريطة')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlacesCubit, PlacesState>(
        builder: (context, state) {
          if (state is PlaceDetailsLoaded) {
            final details = state.details;
            return _buildDetailsContent(details);
          } else if (state is PlacesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    'خطأ في تحميل تفاصيل المكان',
                    style: TextStyle(fontSize: 16.sp, color: Colors.red),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('رجوع'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDetailsContent(Map<String, dynamic> details) {
    return CustomScrollView(
      slivers: [
        // App Bar with Image
        SliverAppBar(
          expandedHeight: 300.h,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              widget.place.name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            background: widget.place.photoReference != null
                ? Image.network(
                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=${widget.place.photoReference}&key=AIzaSyDuccoSdICVDXCXY4Qz-HH9GjyIr6YWayY',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported, size: 64.sp),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.place, size: 64.sp, color: Colors.grey[600]),
                  ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating
                if (widget.place.rating != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20.sp),
                        SizedBox(width: 4.w),
                        Text(
                          widget.place.rating!.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 16.h),

                // Address
                if (details['formatted_address'] != null)
                  _buildInfoCard(
                    icon: Icons.location_on,
                    iconColor: Colors.red,
                    title: 'العنوان',
                    content: details['formatted_address'],
                  ),

                // Phone
                if (details['formatted_phone_number'] != null)
                  _buildInfoCard(
                    icon: Icons.phone,
                    iconColor: Colors.green,
                    title: 'رقم الهاتف',
                    content: details['formatted_phone_number'],
                  ),

                // Website
                if (details['website'] != null)
                  _buildInfoCard(
                    icon: Icons.language,
                    iconColor: Colors.blue,
                    title: 'الموقع الإلكتروني',
                    content: details['website'],
                    isLink: true,
                  ),

                // Description
                if (details['editorial_summary']?['overview'] != null) ...[
                  SizedBox(height: 16.h),
                  Text(
                    'نبذة عن المكان',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      details['editorial_summary']['overview'],
                      style: TextStyle(fontSize: 14.sp, height: 1.5),
                    ),
                  ),
                ],

                // Reviews
                if (details['reviews'] != null && details['reviews'].isNotEmpty) ...[
                  SizedBox(height: 24.h),
                  Text(
                    'التقييمات',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...details['reviews'].take(5).map<Widget>((review) {
                    return _buildReviewCard(review);
                  }),
                ],

                SizedBox(height: 24.h),

                // Google Maps Button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton.icon(
                    onPressed: () => _openInMaps(widget.place.lat, widget.place.lng),
                    icon: const Icon(Icons.directions),
                    label: const Text('افتح في Google Maps'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    bool isLink = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isLink ? Colors.blue : Colors.black87,
                    decoration: isLink ? TextDecoration.underline : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.blue,
                  child: Text(
                    (review['author_name'] ?? 'A')[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['author_name'] ?? 'Anonymous',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      if (review['rating'] != null)
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 14.sp),
                            SizedBox(width: 4.w),
                            Text(
                              review['rating'].toString(),
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (review['text'] != null) ...[
              SizedBox(height: 8.h),
              Text(
                review['text'],
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
