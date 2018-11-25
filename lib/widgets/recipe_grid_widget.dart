import 'package:flutter/material.dart';
import 'package:ckfl/Recipe.dart' show Recipe;

class RecipeGrid extends StatelessWidget {
  final List<Recipe> _recipes;
  RecipeGrid(this._recipes);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.extent(
          maxCrossAxisExtent: 260.0,
        children: _recipes.map((i) => _RecipeSearchItem(i)).toList()
      ),
      

    );
  }
}

class _RecipeSearchItem extends StatelessWidget {
  final Recipe _recipe;
  _RecipeSearchItem(this._recipe);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

