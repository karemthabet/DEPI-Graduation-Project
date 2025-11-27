import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/core/services/google_maps_place_service.dart';
import 'package:whatsapp/core/services/location_service.dart';
import 'package:whatsapp/features/home/data/repositories/places_repository.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/features/home/presentation/views/places_list_view.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_category_list.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_profile_section.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_recently_viewed.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_recommendation_list.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_search_bar.dart';

import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});
  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final TextEditingController textEditingController = TextEditingController();
  late GoogleMapsPlaceServic googleMapsPlaceServic;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    googleMapsPlaceServic = GoogleMapsPlaceServic();
    super.initState();
    context.read<UserCubit>().loadUserProfile();
    _checkLocationAndLoadPlaces();
  }

  Future<void> _checkLocationAndLoadPlaces() async {
    final status = await LocationService.instance.checkLocationStatus();

    if (!mounted) return;

    switch (status) {
      case LocationStatus.serviceDisabled:
        _showLocationServiceDialog();
        break;
      case LocationStatus.permissionDenied:
        _showPermissionDialog();
        break;
      case LocationStatus.permissionDeniedForever:
        _showPermissionDeniedForeverDialog();
        break;
      case LocationStatus.granted:
        context.read<PlacesCubit>().loadPlaces();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<PlacesCubit, PlacesState>(
        builder: (context, state) {
          if (state is PlacesError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state.failure.errMessage.contains('إذن') ||
                  state.failure.errMessage.contains('GPS')) {
                _showLocationErrorDialog(context, state.failure.errMessage);
              }
            });
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BuildProfileSection(),
                  SizedBox(height: 20.h),

                  BuildSearchBar(textEditingController: textEditingController),
                  SizedBox(height: 24.h),

                  Text(
                    'Browse By Category',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  const BuildCategoryList(),

                  SizedBox(height: 20.h),

                  Text(
                    'Top Recommendations',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (state is PlacesLoaded)
                    BuildRecommendationList(
                      recommendations: state.topRecommendations,
                    )
                  else
                    const BuildRecommendationList(recommendations: []),

                  SizedBox(height: 20.h),

                  Text(
                    'Recently Viewed',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  const BuildRecentlyViewed(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLocationErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ في الموقع'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PlacesCubit>().loadPlaces();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.location_off, size: 48.sp, color: Colors.red),
        title: const Text('خدمة الموقع غير مفعلة'),
        content: const Text(
          'يحتاج التطبيق إلى تفعيل خدمة الموقع (GPS) لعرض الأماكن القريبة منك.\n\nهل تريد تفعيل خدمة الموقع الآن؟',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await LocationService.instance.openLocationSettings();
              // إعادة التحقق بعد فترة قصيرة
              await Future.delayed(const Duration(seconds: 1));
              _checkLocationAndLoadPlaces();
            },
            child: const Text('تفعيل الموقع'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.location_searching, size: 48.sp, color: Colors.orange),
        title: const Text('إذن الوصول للموقع'),
        content: const Text(
          'يحتاج التطبيق إلى إذن الوصول لموقعك لعرض الأماكن القريبة منك.\n\nهل تريد منح الإذن؟',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('رفض'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final permission = await LocationService.instance
                  .requestPermission();
              if (permission == LocationPermission.whileInUse ||
                  permission == LocationPermission.always) {
                _checkLocationAndLoadPlaces();
              } else {
                _showPermissionDeniedMessage();
              }
            },
            child: const Text('منح الإذن'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedForeverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.block, size: 48.sp, color: Colors.red),
        title: const Text('تم رفض إذن الموقع'),
        content: const Text(
          'تم رفض إذن الوصول للموقع بشكل نهائي.\n\nيرجى الذهاب إلى إعدادات التطبيق وتفعيل إذن الموقع يدوياً.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await LocationService.instance.openAppSettings();
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedMessage() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تم رفض إذن الوصول للموقع. لن يتمكن التطبيق من عرض الأماكن القريبة.',
        ),
        action: SnackBarAction(
          label: 'إعادة المحاولة',
          onPressed: _checkLocationAndLoadPlaces,
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
