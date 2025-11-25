import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../root_navigation_glass/presentation/views/main_view.dart';
import '../../cubit/favourite_cubit.dart';
import '../../cubit/favourite_state.dart';
import 'favourite_card.dart';

class FavouriteViewBody extends StatelessWidget {
  const FavouriteViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'favourites',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF243E4B),
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MainView()),
                );
              },
              icon: Image.asset(
                'assets/images/plus.png',
                height: 24,
                width: 24,
              ),
            ),
          ),
        ],

        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            final favorites = state.favorites;
            if (favorites.isEmpty) {
              return const Center(child: Text('No favourites yet'));
            }
            return ListView.separated(
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
              itemCount: favorites.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final fav = favorites[index];
                return FavouriteCard(item: fav);
              },
            );
          } else if (state is FavoritesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/no internet.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    state.failure.errMessage,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 180),
                  GestureDetector(
                    onTap: () {
                      context.read<FavoritesCubit>().loadFavorites();
                    },

                    child: Image.asset(
                      'assets/images/reload.png',
                      width: 24,
                      height: 24,
                    ),
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
