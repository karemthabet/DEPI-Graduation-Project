import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/features/FavouriteScreen/presentation/view/widgets/favourite_view_body.dart';

class FavouriteView extends StatelessWidget {
  final String userId;

  const FavouriteView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return const FavouriteViewBody();
  }
}
