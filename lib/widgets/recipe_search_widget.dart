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
  void dispose() {
    controller.removeListener(_setSearchQueryText);
    controller.dispose();
    super.dispose();
  }

  void _searchRecipe(String inp) {
    print(inp);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: TextField(
            controller: controller,
            onSubmitted: _searchRecipe,
          ),
        )
      ],
    );
  }
}
