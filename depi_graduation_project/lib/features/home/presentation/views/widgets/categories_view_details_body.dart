import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp/core/services/location_service.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';
import 'package:whatsapp/features/home/presentation/cubit/place_details_cubit.dart';

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

    // Load place details if ID exists
    if (widget.itemModel.id != null && widget.itemModel.id!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<PlaceDetailsCubit>().loadPlaceDetails(
          widget.itemModel.id!,
        );
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        _showSnackBar('لا يمكن فتح Google Maps');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('خطأ: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.itemModel;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<PlaceDetailsCubit, PlaceDetailsState>(
        builder: (context, state) {
          Map<String, dynamic>? placeDetails;
          bool isLoading = false;

          if (state is PlaceDetailsLoaded) {
            placeDetails = state.details;
          } else if (state is PlaceDetailsLoading) {
            isLoading = true;
          }

          return Column(
            children: [
              _buildHeader(item, placeDetails, isLoading),
              _buildTabs(),
              Expanded(child: _buildTabBarView(item, placeDetails, isLoading)),
              _buildNavigationButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    ItemModel item,
    Map<String, dynamic>? placeDetails,
    bool isLoading,
  ) {
    return Stack(
      children: [
        _buildHeroImage(item),
        _buildBackButton(),
        _buildInfoCard(item, placeDetails, isLoading),
      ],
    );
  }

  Widget _buildHeroImage(ItemModel item) {
    return Hero(
      tag: '${item.image}_${item.name}',
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
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
    );
  }

  Widget _buildBackButton() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.4),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    ItemModel item,
    Map<String, dynamic>? placeDetails,
    bool isLoading,
  ) {
    return Positioned(
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
                  _buildLocationRow(item),
                  SizedBox(height: 4.h),
                  _buildOpeningHoursRow(placeDetails, isLoading),
                  SizedBox(height: 4.h),
                  _buildRatingRow(item),
                ],
              ),
            ),
            Icon(Icons.favorite_border, color: Colors.grey[700], size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(ItemModel item) {
    return Row(
      children: [
        Icon(Icons.location_on, color: Colors.grey, size: 14.sp),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            item.location,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildOpeningHoursRow(
    Map<String, dynamic>? placeDetails,
    bool isLoading,
  ) {
    if (isLoading) {
      return Row(
        children: [
          SizedBox(
            width: 14.sp,
            height: 14.sp,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'جاري التحميل...',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        ],
      );
    }

    if (placeDetails?['opening_hours'] != null) {
      final isOpen = placeDetails!['opening_hours']['open_now'] == true;
      return Row(
        children: [
          Icon(Icons.access_time, color: Colors.grey, size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            isOpen ? 'مفتوح الآن' : 'مغلق',
            style: TextStyle(
              fontSize: 12.sp,
              color: isOpen ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildRatingRow(ItemModel item) {
    return Row(
      children: [
        Text(
          item.rating,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 3.w),
        Icon(Icons.star, color: Colors.amber, size: 14.sp),
      ],
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, left: 20.w, right: 20.w),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.transparent,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        tabs: const [Tab(text: 'Description'), Tab(text: 'Reviews')],
      ),
    );
  }

  Widget _buildTabBarView(
    ItemModel item,
    Map<String, dynamic>? placeDetails,
    bool isLoading,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildDescriptionTab(item, placeDetails, isLoading),
          _buildReviewsTab(placeDetails, isLoading),
        ],
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
            _buildSectionTitle('نبذة عن المكان'),
            SizedBox(height: 8.h),
            _buildSectionText(placeDetails!['editorial_summary']['overview']),
            SizedBox(height: 16.h),
          ],
          _buildSectionTitle('الوصف'),
          SizedBox(height: 8.h),
          _buildSectionText(item.description),
          if (placeDetails?['formatted_phone_number'] != null) ...[
            SizedBox(height: 16.h),
            _buildPhoneRow(placeDetails!['formatted_phone_number']),
          ],
          if (placeDetails?['website'] != null) ...[
            SizedBox(height: 8.h),
            _buildWebsiteRow(placeDetails!['website']),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSectionText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 13.sp, color: Colors.grey[800], height: 1.5),
    );
  }

  Widget _buildPhoneRow(String phone) {
    return Row(
      children: [
        Icon(Icons.phone, size: 16.sp, color: Colors.green),
        SizedBox(width: 8.w),
        Text(phone, style: TextStyle(fontSize: 13.sp)),
      ],
    );
  }

  Widget _buildWebsiteRow(String website) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(website);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Row(
        children: [
          Icon(Icons.language, size: 16.sp, color: Colors.blue),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              website,
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
    );
  }

  Widget _buildReviewsTab(Map<String, dynamic>? placeDetails, bool isLoading) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFE66D)),
      );
    }

    if (placeDetails?['reviews'] == null || placeDetails!['reviews'].isEmpty) {
      return Center(
        child: Text(
          'لا توجد تقييمات متاحة',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children:
            placeDetails['reviews']
                .take(5)
                .map<Widget>((review) => _buildReviewCard(review))
                .toList(),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
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
                  (review['author_name'] ?? 'A').substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
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
                          Icon(Icons.star, color: Colors.amber, size: 12.sp),
                          SizedBox(width: 4.w),
                          Text(
                            review['rating'].toString(),
                            style: TextStyle(fontSize: 11.sp),
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
    );
  }

  Widget _buildNavigationButton() {
    return Padding(
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
    );
  }
}
