import 'package:depi_graduation_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'models/place.dart';
import 'screens/places_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Nearby Restaurants'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Place> places = [];
  bool isLoading = true;
  String? errorMessage;
  Map<String, List<Place>> categorizedPlaces = {};

  final Map<String, IconData> categoryIcons = {
    'tourist_attraction': Icons.camera_alt,
    'historical': Icons.history,
    'museum': Icons.museum,
    'restaurant': Icons.restaurant,
    'hotel': Icons.hotel,
    'zoo': Icons.pets,
    'park': Icons.park,
    'shopping_mall': Icons.shopping_bag,
    'movie_theater': Icons.movie,
  };

  final Map<String, String> categoryNames = {
    'tourist_attraction': 'معالم سياحية / Tourist Attractions',
    'historical': 'أماكن تاريخية / Historical',
    'museum': 'متاحف / Museums',
    'restaurant': 'مطاعم / Restaurants',
    'hotel': 'فنادق / Hotels',
    'zoo': 'حدائق حيوان / Zoos',
    'park': 'حدائق / Parks',
    'shopping_mall': 'مولات / Shopping Malls',
    'movie_theater': 'سينما / Movie Theaters',
  };

  final List<String> categoryOrder = [
    'tourist_attraction',
    'historical',
    'museum',
    'restaurant',
    'hotel',
    'zoo',
    'park',
    'shopping_mall',
    'movie_theater',
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List fetchedPlaces = [];
    Dio dio = Dio();

    // Queries for each category and extra
    Map<String, String> queries = {
      'tourist_attraction': 'best tourist attractions in Cairo',
      'historical': 'best historical sites in Cairo',
      'museum': 'best museums in Cairo',
      'restaurant': 'best restaurants in Cairo',
      'hotel': 'best hotels in Cairo',
      'zoo': 'best zoos in Cairo',
      'park': 'best parks in Cairo',
      'shopping_mall': 'best shopping malls in Cairo',
      'movie_theater': 'best movie theaters in Cairo',
    };

    try {
      for (var entry in queries.entries) {
        String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=${entry.value.replaceAll(' ', '+')}&key=AIzaSyDDNGD0MtxjNGA4xhOHZ9uOcJYjGOm0zTw';
        var response = await dio.get(url);
        if (response.statusCode == 200) {
          var data = response.data;
          if (data['status'] == 'OK') {
            fetchedPlaces.addAll(data['results'] as List);
            // Optionally fetch next page, but to avoid too many, skip for now
          }
        }
        await Future.delayed(const Duration(milliseconds: 500)); // delay between queries
      }

      // Remove duplicates based on place_id
      Map<String, dynamic> uniquePlaces = {};
      for (var place in fetchedPlaces) {
        String id = place['place_id'];
        if (!uniquePlaces.containsKey(id)) {
          uniquePlaces[id] = place;
        }
      }
      fetchedPlaces = uniquePlaces.values.toList();

      final placesList = fetchedPlaces.map((e) => Place.fromJson(e)).toList();
      // Debug: print types
      print('Total places fetched: ${fetchedPlaces.length}');
      for (var p in fetchedPlaces.take(5)) {
        print('Place: ${p['name']}, Types: ${p['types']}');
      }
      categorizedPlaces.clear();
      for (var place in placesList) {
        categorizedPlaces.putIfAbsent(place.category, () => []).add(place);
      }
      setState(() {
        places = placesList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Builder(
                  builder: (context) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: categoryOrder.length,
                      itemBuilder: (context, index) {
                        final category = categoryOrder[index];
                        final count = categorizedPlaces[category]?.length ?? 0;
                        final icon = categoryIcons[category] ?? Icons.place;
                        return Card(
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacesListScreen(
                                    category: category,
                                    places: places,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(icon, size: 48, color: Theme.of(context).primaryColor),
                                const SizedBox(height: 8),
                                Text(
                                  categoryNames[category] ?? category.toUpperCase(),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Text('$count places'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
