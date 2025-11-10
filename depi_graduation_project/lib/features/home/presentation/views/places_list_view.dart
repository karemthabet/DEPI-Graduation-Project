import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';
import 'package:whatsapp/features/home/data/models/place_model.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/place_details.dart';

class PlacesListView extends StatelessWidget {
  final String categoryKey;
  final String categoryName;

  const PlacesListView({
    super.key,
    required this.categoryKey,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(categoryName),
        elevation: 0,
      ),
      body: BlocBuilder<PlacesCubit, PlacesState>(
        builder: (context, state) {
          if (state is PlacesLoaded) {
            final places = state.categorized[categoryKey] ?? [];

            if (places.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, size: 64.sp, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text(
                      'No places available',
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: places.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                final place = places[index];
                final itemModel = _convertPlaceToItem(place);
                final uniqueId = '${place.placeId}_$index';
                
                return GestureDetector(
                  onTap: () => context.push(
                    RoutesName.categoriesViewDetails,
                    extra: itemModel,
                  ),
                  child:  PlaceDetails(
                    itemModel: itemModel,
                    heroTag: 'category_place_$uniqueId',
                  ),
                );
              },
            );
          } else if (state is PlacesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    'Error loading places',
                    style: TextStyle(fontSize: 16.sp, color: Colors.red),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.failure.errMessage,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    textAlign: TextAlign.center,
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

  ItemModel _convertPlaceToItem(PlaceModel place) {
    final photoUrl = place.photoReference != null
        ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place.photoReference}&key=AIzaSyDuccoSdICVDXCXY4Qz-HH9GjyIr6YWayY'
        : 'https://www.legrand.com.eg/modules/custom/legrand_ecat/assets/img/no-image.png';

    return ItemModel(
      id: place.placeId,
      name: place.name,
      location: place.vicinity,
      image: photoUrl,
      rating: place.rating?.toStringAsFixed(1) ?? 'N/A',
      description: place.description ?? 'No description available',
    );
  }
}
