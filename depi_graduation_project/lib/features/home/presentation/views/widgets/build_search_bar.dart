import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/core/services/google_maps_place_service.dart';
import 'package:whatsapp/core/utils/styles/app_text_styles.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';
import 'package:whatsapp/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/categories_view_details_body.dart';
import 'package:whatsapp/models/places_details_model/places_details_model.dart';
import 'package:whatsapp/core/utils/constants/api_constants.dart';

class BuildSearchBar extends StatefulWidget {
  final TextEditingController textEditingController;
  const BuildSearchBar({super.key, required this.textEditingController});

  @override
  _BuildSearchBarState createState() => _BuildSearchBarState();
}

class _BuildSearchBarState extends State<BuildSearchBar> {
  String? sessiontoken;
  late Uuid uuid;
  List<PlaceAutocompleteModel> places = [];
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = widget.textEditingController;
    uuid = const Uuid();
    super.initState();
    fetchPredictions();
  }

  void fetchPredictions() {
    textEditingController.addListener(() async {
      sessiontoken ??= uuid.v4();

      if (textEditingController.text.isNotEmpty) {
        final service = GoogleMapsPlaceServic();
        final result = await service.getpredictions(
          sessiontoken: sessiontoken!,
          input: textEditingController.text,
        );
        places.clear();
        places.addAll(result);
        setState(() {});
      } else {
        places.clear();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: textEditingController,

                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: Colors.grey,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),

                  decoration: InputDecoration(
                    hintText: 'Find things you\'re interested in',
                    hintStyle: AppTextStyles.bodyMedium(context).copyWith(
                      color: Colors.grey,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
                const SizedBox(height: 16),
                customlistview(
                  places: places,
                  onPlaceSelection: (PlaceDetails) {
                    textEditingController.clear();
                    places.clear();
                    sessiontoken = null;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class customlistview extends StatelessWidget {
  customlistview({
    super.key,
    required this.places,
    required this.onPlaceSelection,
  });

  final List<PlaceAutocompleteModel> places;
  final Function(PlacesDetailsModel) onPlaceSelection;
  final GoogleMapsPlaceServic googleMapsPlaceServic = GoogleMapsPlaceServic();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(places[index].description!),
            trailing: IconButton(
              onPressed: () async {
                final placeDetails = await googleMapsPlaceServic
                    .getPlaceDetails(placeId: places[index].placeId.toString());

                String imageUrl = '';
                if (placeDetails.photos?.isNotEmpty == true &&
                    placeDetails.photos![0].photoReference != null) {
                  imageUrl =
                      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${placeDetails.photos![0].photoReference}&key=${ApiBase.apiKey}';
                }

                final item = ItemModel(
                  id: places[index].placeId,

                  name: places[index].description ?? 'unkown place',

                  image: imageUrl,

                  location:
                      placeDetails.formattedAddress ??
                      (placeDetails.geometry != null
                          ? '${placeDetails.geometry!.location!.lat},${placeDetails.geometry!.location!.lng}'
                          : 'Location not available'),
                  description:
                      placeDetails.editorialSummary ??
                      '', // وصف افتراضي أو فاضي
                  openNow: true,
                  rating: placeDetails.rating?.toString() ?? '0', // افتراضي
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CategoriesViewDetailsBody(itemModel: item),
                  ),
                ).then((_) {
                  onPlaceSelection(placeDetails);
                });
              },
              icon: const Icon(Icons.arrow_circle_right_outlined),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 0);
        },
        itemCount: places.length,
      ),
    );
  }
}
