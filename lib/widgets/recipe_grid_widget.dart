import 'package:flutter/material.dart';
import 'package:ckfl/Recipe.dart' show Recipe;

class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;

  RecipeGrid({Key key, this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.extent(
          maxCrossAxisExtent: 260.0,
          children: recipes.map((i) => _RecipeSearchItem(recipe: i)).toList()),
    );
  }
}

class _RecipeSearchItem extends StatefulWidget {
  final Recipe recipe;

  _RecipeSearchItem({Key key, this.recipe}) : super(key: key);

  @override
  _RecipeSearchItemState createState() {
    return new _RecipeSearchItemState();
  }
}

class _RecipeSearchItemState extends State<_RecipeSearchItem> {
  void _showRecipe(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.recipe.title),
        ),
        body: SizedBox.expand(
          child: Hero(
            tag: widget.recipe.thumbnail,
            child: RecipeViewer(recipe: widget.recipe),
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () => _showRecipe(context),
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
    return Card(
      child: Column(children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(child:
          child: Image.network(
            widget.recipe.thumbnail,
            fit: BoxFit.cover,
          ),
    ),
        ),
        Expanded(
            child: Column(
          children: <Widget>[
            recipeInfoRow("Preptime: ", widget.recipe.preptime),
            recipeInfoRow("Difficulty", widget.recipe.difficulty),
          ],
        )),
      ]),
    );
  }

  Padding recipeInfoRow(String description, String detail) {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text(description),
                Text(detail),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          );
  }
}
