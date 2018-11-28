import 'package:flutter/material.dart';
import 'package:ckfl/Recipe.dart' show Recipe;

class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;

  RecipeGrid({Key key, this.recipes}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.extent(
          maxCrossAxisExtent: 260.0,
          children: recipes.map((i) => _RecipeSearchItem(i)).toList()),
    );
  }
}

class _RecipeSearchItem extends StatefulWidget {
  final Recipe recipe;

  _RecipeSearchItem(this.recipe);

  @override
  _RecipeSearchItemState createState() {
    return new _RecipeSearchItemState();
  }
}

class _RecipeSearchItemState extends State<_RecipeSearchItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridTile(
        child: Hero(
          tag: widget.recipe.thumbnail,
          child: Image.network(
            widget.recipe.thumbnail,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: _RecipeSearchItemTitle(widget.recipe.title),
          subtitle: _RecipeSearchItemRating(widget.recipe.rating),
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

class RecipeViewer extends StatefulWidget {
  const RecipeViewer({Key key, this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  _RecipeViewerState createState() => _RecipeViewerState();
}

class _RecipeViewerState extends State<RecipeViewer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
