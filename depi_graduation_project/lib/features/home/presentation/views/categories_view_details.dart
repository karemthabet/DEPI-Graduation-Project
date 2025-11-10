import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/categories_view_details_body.dart';

class CategoriesViewDetails extends StatelessWidget {
  const CategoriesViewDetails({super.key, required this.itemModel});
  final ItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<PlacesCubit>(),
      child: Scaffold(body: CategoriesViewDetailsBody(itemModel: itemModel)),
    );
  }
}
