import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp/core/services/location_service.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';

class CategoriesViewDetailsBody extends StatefulWidget {
  final ItemModel itemModel;
  const CategoriesViewDetailsBody({super.key, required this.itemModel});

  @override
  State<CategoriesViewDetailsBody> createState() =>
      _CategoriesViewDetailsBodyState();
}

class _CategoriesViewDetailsBodyState extends State<CategoriesViewDetailsBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.itemModel.id != null && widget.itemModel.id!.isNotEmpty) {
      _loadPlaceDetails();
    }
  }

  Future<void> _loadPlaceDetails() async {
    if (widget.itemModel.id == null) return;
    await context.read<PlacesCubit>().loadPlaceDetails(widget.itemModel.id!);
  }

  Future<void> _openInMaps() async {
    try {
      final position = await LocationService.instance.getCurrentLocation();
      final url =
          'https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=${Uri.encodeComponent(widget.itemModel.name)}&destination_place_id=${widget.itemModel.id ?? ""}';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        if (!mounted) return;
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يمكن فتح Google Maps')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: ${e.toString()}')));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Clear place details when leaving the page
    context.read<PlacesCubit>().clearPlaceDetails();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.itemModel;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<PlacesCubit, PlacesState>(
        builder: (context, state) {
          Map<String, dynamic>? placeDetails;
          bool isLoading = false;

          if (state is PlacesLoaded) {
            placeDetails = state.placeDetails;
          } else if (state is PlaceDetailsLoading) {
            isLoading = true;
          }

          return Column(
            children: [
              Stack(
                children: [
                  Hero(
                    tag: '${item.image}_${item.name}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(25),
                      ),
                      child: Image.network(
                        item.image,
                        height: 330.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 330.h,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported, size: 40.sp),
                          );
                        },
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.4),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () =>context.pop(),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 20.w,
                    right: 20.w,
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF9CF),
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                      size: 14.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        item.location,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                if (isLoading)
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 14.sp,
                                        height: 14.sp,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.grey,
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'جاري التحميل...',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                else if (placeDetails?['opening_hours'] != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.grey,
                                        size: 14.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        placeDetails!['opening_hours']['open_now'] ==
                                                true
                                            ? 'مفتوح الآن'
                                            : 'مغلق',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color:
                                              placeDetails['opening_hours']['open_now'] ==
                                                      true
                                                  ? Colors.green
                                                  : Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Text(
                                      item.rating,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 14.sp,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.favorite_border,
                            color: Colors.grey[700],
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.h, left: 20.w, right: 20.w),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [Tab(text: 'Description'), Tab(text: 'Reviews')],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDescriptionTab(item, placeDetails, isLoading),
                      _buildReviewsTab(placeDetails, isLoading),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE66D),
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _openInMaps,
                  child: Text(
                    'Find Your Way',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDescriptionTab(
    ItemModel item,
    Map<String, dynamic>? placeDetails,
    bool isLoading,
  ) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFE66D)),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (placeDetails?['editorial_summary']?['overview'] != null) ...[
            Text(
              'نبذة عن المكان',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              placeDetails!['editorial_summary']['overview'],
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            SizedBox(height: 16.h),
          ],
          Text(
            'الوصف',
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            item.description,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
          if (placeDetails?['formatted_phone_number'] != null) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Icon(Icons.phone, size: 16.sp, color: Colors.green),
                SizedBox(width: 8.w),
                Text(
                  placeDetails!['formatted_phone_number'],
                  style: TextStyle(fontSize: 13.sp),
                ),
              ],
            ),
          ],
          if (placeDetails?['website'] != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.language, size: 16.sp, color: Colors.blue),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    placeDetails!['website'],
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewsTab(Map<String, dynamic>? placeDetails, bool isLoading) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFE66D)),
      );
    }

    return SingleChildScrollView(
      child:
          placeDetails?['reviews'] != null &&
                  placeDetails!['reviews'].isNotEmpty
              ? Column(
                children: [
                  ...placeDetails['reviews']
                      .take(5)
                      .map<Widget>(
                        (review) => Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.yellow.shade700),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16.r,
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      (review['author_name'] ?? 'A')
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 12.sp,
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                review['rating'].toString(),
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                ),
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
                                    color: Colors.grey[800],
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                ],
              )
              : Center(
                child: Text(
                  'لا توجد تقييمات متاحة',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ),
    );
  }
}
