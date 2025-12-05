import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import '../../../../../core/utils/router/routes_name.dart';
import '../../../../../supabase_service.dart';
import '../../../../root_navigation_glass/presentation/views/main_view.dart';
import '../../cubit/favourite_cubit.dart';
import '../../cubit/favourite_state.dart';
import 'favourite_card.dart';

class FavouriteViewBody extends StatelessWidget {
  const FavouriteViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = SupabaseService.userId;
    print('Current userId: $userId'); // للتأكد

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Favourites'),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 50, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'You must log in to see your favourites',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: AppColors.darkBlue),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                context.go(RoutesName.login);

              },
                child: const Text('Go to Login',style: TextStyle(color: AppColors.darkBlue),),
              ),
            ],
          ),
        ),
      );
    }

    // إذا المستخدم مسجل دخول
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Favourites',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF243E4B),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MainView()),
              );
            },
            icon: Image.asset('assets/images/plus.png', height: 24, width: 24),
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
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, index) {
                final fav = favorites[index];
                return FavouriteCard(item: fav);
              },
            );
          } else if (state is FavoritesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 24),
                  Text(
                    state.failure.errMessage,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<FavoritesCubit>().loadFavorites(),
                    child: const Text('Retry'),
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
