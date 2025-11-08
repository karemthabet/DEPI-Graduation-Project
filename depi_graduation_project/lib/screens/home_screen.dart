import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'places_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, String> categoryNames = const {
    'tourist_attraction': 'معالم سياحية',
    'historical': 'أماكن تاريخية',
    'museum': 'متاحف',
    'restaurant': 'مطاعم',
    'hotel': 'فنادق',
    'zoo': 'حدائق حيوان',
    'park': 'حدائق',
    'shopping_mall': 'مولات',
    'movie_theater': 'سينمات',
    'other': 'أخرى',
  };

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlacesCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('الأماكن القريبة')),
      body: BlocBuilder<PlacesCubit, PlacesState>(
        builder: (context, state) {
          if (state is PlacesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlacesError) {
            return Center(child: Text(state.message));
          } else if (state is PlacesLoaded) {
            return GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              children: state.categorized.entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlacesListScreen(
                          category: categoryNames[entry.key] ?? entry.key,
                          places: entry.value,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Center(
                      child: Text(
                        '${categoryNames[entry.key] ?? entry.key}\n(${entry.value.length})',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }

          cubit.loadNearbyPlaces();
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
