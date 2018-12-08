import 'package:flutter/material.dart';
import 'package:ckfl/Recipe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ckfl/mockrecipedetail.dart';

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
      AppBar appBar = AppBar(title: Text(widget.recipe.title));
      return Scaffold(
        appBar: appBar,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height:
              MediaQuery.of(context).size.height - appBar.preferredSize.height,
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
            child: CachedNetworkImage(
              imageUrl: widget.recipe.thumbnail,
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
  void _showRecipeDetail(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              title: Text(widget.recipe.title),
            ),
            body: RecipeDetailView(recipeDetail: schupfnudel));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () => _showRecipeDetail(context, widget.recipe.url),
          child: CachedNetworkImage(
            imageUrl: widget.recipe.thumbnail,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            recipeInfoRow("Rating", widget.recipe.rating),
            recipeInfoRow("Preptime: ", widget.recipe.preptime),
            recipeInfoRow("Difficulty", widget.recipe.difficulty),
          ],
        ),
      ),
    ]);
  }

  Padding recipeInfoRow(String description, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
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

class RecipeDetailView extends StatefulWidget {
  final RecipeDetail recipeDetail;

  RecipeDetailView({Key key, this.recipeDetail}) : super(key: key);

  @override
  _RecipeDetailViewState createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.recipeDetail.thumbnail,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                _RecipeIngredientsView(widget.recipeDetail.ingredients),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _RecipeIngredientsView extends StatelessWidget {
  final List<RecipeIngredient> _ingredients;

  _RecipeIngredientsView(this._ingredients);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: _ingredients.map((i) => _ingredientView(i)).toList(),
    ));
  }

  Widget _ingredientView(RecipeIngredient ingredient) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Text(ingredient.amount + " "),
          Text(ingredient.ingredient),
        ],
      ),
    );
  }
}
