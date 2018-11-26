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
          children: _recipes.map((i) => _RecipeSearchItem(i)).toList()),
    );
  }
}

class _RecipeSearchItem extends StatelessWidget {
  final Recipe _recipe;

  _RecipeSearchItem(this._recipe);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridTile(
        child: Image.network(_recipe.thumbnail,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: _RecipeSearchItemTitle(_recipe.title),
          subtitle: _RecipeSearchItemRating(_recipe.rating),
        ),

      ),
    );
  }
}

class _RecipeSearchItemTitle extends StatelessWidget {
  final String _title;

  _RecipeSearchItemTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(_title),
    );
  }
}

class _RecipeSearchItemRating extends StatelessWidget {
  final String _rating;
  _RecipeSearchItemRating(this._rating);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(_rating),
    );
  }
}


