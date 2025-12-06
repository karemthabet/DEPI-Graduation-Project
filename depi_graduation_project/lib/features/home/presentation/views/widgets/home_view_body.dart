import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whatsapp/core/services/google_maps_place_service.dart';
import 'package:whatsapp/core/services/location_service.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_category_list.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_profile_section.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_recommendation_list.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_search_bar.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_recently_viewed.dart';

import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';
import 'package:whatsapp/l10n/app_localizations.dart';

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
      child: BlocListener<PlacesCubit, PlacesState>(
        listener: (context, state) {
          if (state is PlacesError) {
            if (state.failure.errMessage.contains('إذن') ||
                state.failure.errMessage.contains('GPS') ||
                state.failure.errMessage.contains('Location') ||
                state.failure.errMessage.contains('الموقع')) {
              _showLocationErrorDialog(context, state.failure.errMessage);
            }
          }
        },
        child: SingleChildScrollView(
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
                  AppLocalizations.of(context)!.browseByCategory,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12.h),
                const BuildCategoryList(),
                SizedBox(height: 24.h),
                Text(
                  AppLocalizations.of(context)!.topRecommendations,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10.h),
                const BuildRecommendationList(),
                SizedBox(height: 20.h),

                // Recently Viewed Section (From Logic)
                Text(
                  AppLocalizations.of(context)!.recentlyViewed,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10.h),
                const BuildRecentlyViewed(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLocationErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.locationErrorTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PlacesCubit>().loadPlaces();
            },
            child: Text(AppLocalizations.of(context)!.retry),
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
        title: Text(AppLocalizations.of(context)!.locationServiceDisabledTitle),
        content: Text(
          AppLocalizations.of(context)!.locationServiceDisabledMessage,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.later),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await LocationService.instance.openLocationSettings();
              await Future.delayed(const Duration(seconds: 1));
              _checkLocationAndLoadPlaces();
            },
            child: Text(AppLocalizations.of(context)!.enableLocation),
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
        title: Text(AppLocalizations.of(context)!.permissionDeniedTitle),
        content: Text(AppLocalizations.of(context)!.permissionDeniedMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.deny),
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
            child: Text(AppLocalizations.of(context)!.grantPermission),
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
        title: Text(AppLocalizations.of(context)!.permissionDeniedForeverTitle),
        content: Text(
          AppLocalizations.of(context)!.permissionDeniedForeverMessage,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await LocationService.instance.openAppSettings();
            },
            child: Text(AppLocalizations.of(context)!.openSettings),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedMessage() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.permissionDeniedSnackBar),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.retry,
          onPressed: _checkLocationAndLoadPlaces,
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
