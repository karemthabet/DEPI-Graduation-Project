import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/constants/api_constants.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';
import 'package:whatsapp/features/home/presentation/cubit/search_cubit.dart';
import 'package:whatsapp/features/home/presentation/cubit/search_state.dart';

class BuildSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const BuildSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ------------------- Search Bar -------------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: (value) =>
                      context.read<SearchCubit>().search(value),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search for a place...',
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // ------------------- Predictions List -------------------
        BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Padding(
                padding: EdgeInsets.only(top: 10),
                child: CircularProgressIndicator(),
              );
            }

            if (state is SearchSuccess) {
              final predictions = state.predictions;

              if (predictions.isEmpty) {
                return const SizedBox.shrink();
              }

              return Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: predictions.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 0, color: Colors.grey),
                  itemBuilder: (context, index) {
                    final item = predictions[index];

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      title: Text(
                        item['description'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onTap: () async {
                        // ---------- Get Place Details ----------
                        // Use the repo directly (as before), but now it caches!
                        final details = await context
                            .read<SearchCubit>()
                            .repo
                            .getPlaceDetails(item['place_id']);

                        if (details == null) return;

                        if (!context.mounted) return;

                        // ---------- Process Image URL ----------
                        String imageUrl = '';
                        if (details['photos'] != null &&
                            (details['photos'] as List).isNotEmpty) {
                          final photoRef =
                              details['photos'][0]['photo_reference'];
                          if (photoRef != null) {
                            imageUrl =
                                'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoRef&key=${ApiBase.apiKey}';
                          }
                        }

                        // ---------- Build ItemModel ----------
                        // Extracting 'editorial_summary' for description if available
                        String description = '';
                        if (details['editorial_summary'] != null &&
                            details['editorial_summary']['overview'] != null) {
                          description =
                              details['editorial_summary']['overview'];
                        }

                        final itemModel = ItemModel(
                          id: details['place_id'] ?? item['place_id'],
                          name: details['name'] ?? item['description'],
                          location: details['formatted_address'] ??
                              details['vicinity'] ??
                              '',
                          image: imageUrl,
                          rating: details['rating']?.toString() ?? '0.0',
                          openNow: details['opening_hours'] != null
                              ? details['opening_hours']['open_now'] ?? false
                              : false,
                          description: description,
                        );

                        // ---------- Clear UI & Navigate ----------
                        controller.clear();
                        context.read<SearchCubit>().search('');

                        context.push(
                          RoutesName.categoriesViewDetails,
                          extra: itemModel,
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
