import 'package:flutter/material.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/categories_view_body.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CategoriesViewBody(title: title));
  }
}
