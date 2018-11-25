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
        children: <Widget>[],
      ),
      

    );
  }
}

class _RecipeSearchItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String url;
  final String thumbnail;
  final String rating;
  final String difficulty;
  final String preptime;
  _RecipeSearchItem(this.title, this.subtitle, this.url, this.thumbnail,
      this.rating, this.difficulty, this.preptime);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

