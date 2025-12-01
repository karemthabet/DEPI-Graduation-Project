import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp/core/services/location_service.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';
import 'package:whatsapp/features/home/presentation/cubit/place_details_cubit.dart';
import 'package:whatsapp/features/visit_Screen/presentation/cubit/visit_cubit.dart';
import 'package:whatsapp/core/di/injection_container.dart';
import 'package:whatsapp/features/visit_Screen/data/model/place__model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatsapp/core/utils/constants/api_constants.dart';

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
        _buildHeroImage(item, placeDetails),
        _buildBackButton(),
        _buildInfoCard(item, placeDetails, isLoading),
      ],
    );
  }

  Widget _buildHeroImage(ItemModel item, Map<String, dynamic>? placeDetails) {
    String imageUrl = item.image;

    if (placeDetails != null &&
        placeDetails['photos'] != null &&
        (placeDetails['photos'] as List).isNotEmpty) {
      final photoRef = placeDetails['photos'][0]['photo_reference'];
      if (photoRef != null) {
        imageUrl =
            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoRef&key=${ApiBase.apiKey}';
      }
    }

    return Hero(
      tag: '${item.image}_${item.name}', // Keep original tag for transition
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 330.h,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder:
              (context, url) => Container(
                height: 330.h,
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.darkBlue),
                ),
              ),
          errorWidget: (context, url, error) {
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
    // Use details from API if available, otherwise fallback to item
    final String name = placeDetails?['name'] ?? item.name;
    final String location = placeDetails?['formatted_address'] ?? item.location;
    final String rating = placeDetails?['rating']?.toString() ?? item.rating;
    

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
                    name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  _buildLocationRow(location),
                  SizedBox(height: 4.h),
                  _buildOpeningHoursRow(placeDetails, isLoading),
                  SizedBox(height: 4.h),
                  _buildRatingRow(rating),
                ],
              ),
            ),
            Icon(Icons.favorite_border, color: Colors.grey[700], size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(String location) {
    return Row(
      children: [
        Icon(Icons.location_on, color: Colors.grey, size: 14.sp),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            location,
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

  Widget _buildRatingRow(String rating) {
    return Row(
      children: [
        Text(
          rating,
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



Widget _buildDescriptionTab(ItemModel item, Map<String, dynamic>? placeDetails, bool isLoading) {
  if (isLoading) {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFFFFE66D)),
    );
  }

  // Debug: Print the entire placeDetails to see what we're working with
  print('🔍 placeDetails: $placeDetails');
  
  final result = placeDetails;
  if (result == null) {
    return const Center(
      child: Text('لا توجد بيانات متاحة'),
    );
  }

  // Debug: Print the structure of the result
  print('🔍 result keys: ${result.keys.toList()}');
  if (result['result'] != null) {
    print('🔍 result[result] keys: ${result['result'].keys.toList()}');
  }

  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        if (result['result']?['editorial_summary']?['overview'] != null) ...[
          _buildSectionTitle('الوصف'),
          SizedBox(height: 8.h),
          _buildSectionText(result['result']?['editorial_summary']?['overview'] ?? ''),
          SizedBox(height: 16.h),
        ],
        
        // Address
        if (result['result']?['formatted_address'] != null) ...[
          _buildSectionTitle('العنوان'),
          SizedBox(height: 8.h),
          _buildSectionText(result['result']?['formatted_address'] ?? ''),
          SizedBox(height: 16.h),
        ],
        
        // Phone Number
        if (result['result']?['formatted_phone_number'] != null) ...[
          _buildPhoneRow(result['result']?['formatted_phone_number'] ?? ''),
          SizedBox(height: 16.h),
        ],
        
        // Rating
        if (result['result']?['rating'] != null) ...[
          _buildSectionTitle('التقييم'),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                '${result['result']?['rating']} من 5',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 16.h),
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

  // Debug: Print the placeDetails to see what we're working with
  print('🔍 placeDetails in reviews: $placeDetails');
  
  final result = placeDetails;
  if (result == null) {
    return const Center(
      child: Text('لا توجد بيانات متاحة'),
    );
  }

  final reviews = result['result']?['reviews'] as List<dynamic>?;
  
  // Debug: Print the reviews if they exist
  print('🔍 Reviews data: $reviews');
  
  if (reviews == null || reviews.isEmpty) {
    return Center(
      child: Text(
        'لا توجد تقييمات متاحة',
        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
      ),
    );
  }

  return ListView.builder(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
    itemCount: reviews.length,
    itemBuilder: (context, index) {
      final review = reviews[index];
      if (review is Map<String, dynamic>) {
        return _buildReviewCard(review);
      }
      return const SizedBox.shrink();
    },
  );
}
Widget _buildReviewCard(Map<String, dynamic> review) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
    child: Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (review['profile_photo_url'] != null)
                CircleAvatar(
                  radius: 20.sp,
                  backgroundImage: NetworkImage(review['profile_photo_url']),
                ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['author_name'] ?? 'مستخدم مجهول',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (review['relative_time_description'] != null)
                      Text(
                        review['relative_time_description'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18.sp),
                  SizedBox(width: 4.w),
                  Text(
                    review['rating']?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (review['text'] != null && review['text'].toString().isNotEmpty)
            Text(
              review['text'],
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          if (review['translated'] == true)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                'تمت الترجمة تلقائياً',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
  Widget _buildNavigationButton() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          Expanded(
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
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                elevation: 0,
              ),
              onPressed: _addToPlan,
              child: Text(
                'Add to Plan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addToPlan() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2C3E50),
              onPrimary: Colors.white,
              onSurface: Color(0xFF2C3E50),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2C3E50),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      try {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId == null) {
          _showSnackBar('Please login first');
          return;
        }

        // Create Place object from ItemModel
        final place = Place(
          id: widget.itemModel.id ?? '',
          name: widget.itemModel.name,
          address: widget.itemModel.location,
          imageUrl: widget.itemModel.image,
          rating: double.tryParse(widget.itemModel.rating) ?? 0.0,
          rawData: {
            'name': widget.itemModel.name,
            'vicinity': widget.itemModel.location,
            'rating': widget.itemModel.rating,
            'photos': [{'photo_reference': widget.itemModel.image}], 
            // Note: This is a simplified reconstruction. 
            // Ideally we should pass the full PlaceModel if available.
          },
        );

        final visitCubit = sl<VisitCubit>();
        await visitCubit.addVisit(
          place: place,
          visitDate: picked,
          userId: userId,
        );

        if (mounted) {
          _showSnackBar('Added to plan successfully!');
          // Optional: Navigate to Visit List
          // context.pushNamed(RoutesName.visitList);
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Failed to add visit: $e');
        }
      }
    }
  }
}
