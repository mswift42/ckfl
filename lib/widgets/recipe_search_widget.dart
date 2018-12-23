import 'package:flutter/material.dart';
import 'package:ckfl/widgets/recipe_grid_widget.dart';
import 'package:ckfl/mockrecipes.dart';

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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeGrid(
                  recipes: mockresultlist,
                  searchterm: inp,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CK"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextField(
              controller: controller,
              onSubmitted: _searchRecipe,
            ),
          )
        ],
      ),
    );
  }
}
