import 'package:flutter/material.dart';

class RecipeSearchView extends StatefulWidget {
  @override
  _RecipeSearchViewState createState() => _RecipeSearchViewState();
}

class _RecipeSearchViewState extends State<RecipeSearchView> {
  String searchquery = "";
  final controller = TextEditingController();

  void _setSearchQueryText() {
    searchquery = controller.text;
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_setSearchQueryText);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
