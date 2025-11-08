import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/screens/home_screen.dart';
import 'features/home/data/repositories/places_repository_impl.dart';
import 'features/home/presentation/cubit/places_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      create: (_) => PlacesCubit(PlacesRepositoryImpl()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby Explorer',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
