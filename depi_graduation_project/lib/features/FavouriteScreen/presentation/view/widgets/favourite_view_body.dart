import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whatsapp/l10n/app_localizations.dart';
import '../../../../../core/utils/router/routes_name.dart';
import '../../../../root_navigation_glass/presentation/views/main_view.dart';
import '../../cubit/favourite_cubit.dart';
import '../../cubit/favourite_state.dart';
import 'favourite_card.dart';

class FavouriteViewBody extends StatelessWidget {
  const FavouriteViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final bool isGuest = storage.read('isGuest') ?? false;

    if (isGuest) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.favourites),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  AppLocalizations.of(context)!.loginToSeeFavorites,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, RoutesName.login),
                child: Text(AppLocalizations.of(context)!.goToLogin),
              ),
            ],
          ),
        ),
      );
    }

    // Load once per build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesCubit>().loadFavorites();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favourites),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const MainView()),),
            icon: Image.asset('assets/images/plus.png', height: 24, width: 24),
          ),
        ],
      ),
      body: BlocConsumer<FavoritesCubit, FavoritesState>(
        listener: (context, state) {
          if (state is FavoritesActionFailure) {
            final message = state.errMessage == 'no_internet'
                ? AppLocalizations.of(context)!.noInternetConnection
                : state.errMessage;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesNoInternet) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.noInternetConnection,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<FavoritesCubit>().loadFavorites(),
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            );
          } else if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noFavouritesYet),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, index) =>
                  FavouriteCard(item: state.favorites[index]),
            );
          } else if (state is FavoritesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 24),
                  Text(state.failure.errMessage, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<FavoritesCubit>().loadFavorites(),
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
