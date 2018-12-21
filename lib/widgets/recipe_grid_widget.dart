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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) {
        return RecipeDetailView(recipeDetail: schupfnudel);
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
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _recipeInfoRow("Rating", widget.recipe.rating),
            _recipeInfoRow("Preptime: ", widget.recipe.preptime),
            _recipeInfoRow("Difficulty", widget.recipe.difficulty),
          ],
        ),
      ),
    ]);
  }
}

Padding _recipeInfoRow(String description, String detail) {
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

class RecipeDetailView extends StatefulWidget {
  final RecipeDetail recipeDetail;

  RecipeDetailView({Key key, this.recipeDetail}) : super(key: key);

  @override
  _RecipeDetailViewState createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.recipeDetail.title),
            bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.info)),
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.description)),
            ]),
          ),
          body: TabBarView(children: <Widget>[
            _RecipeIngredientsView(widget.recipeDetail),
            _RecipeMethodView(widget.recipeDetail),
            _RecipeInfoView(widget.recipeDetail),
          ])
          //_tabBody(context),
          ),
    );
  }
}

Widget _smallDetailThumbnail(BuildContext context, String thumbnail) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0.5, 0, 0.5, 10.0),
    child: SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width,
      child: CachedNetworkImage(fit: BoxFit.fitWidth, imageUrl: thumbnail),
    ),
  );
}

class _RecipeIngredientsView extends StatelessWidget {
  final RecipeDetail _recipeDetail;

  _RecipeIngredientsView(this._recipeDetail);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _smallDetailThumbnail(context, _recipeDetail.thumbnail),
        Expanded(
          child: ListView(
            children: _recipeDetail.ingredients
                .map((i) => _ingredientView(i))
                .toList(),
          ),
        ),
      ],
    );
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

class _RecipeMethodView extends StatelessWidget {
  final RecipeDetail _recipeDetail;

  _RecipeMethodView(this._recipeDetail);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _smallDetailThumbnail(context, _recipeDetail.thumbnail),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _recipeDetail.method,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecipeInfoView extends StatelessWidget {
  final RecipeDetail _recipeDetail;

  _RecipeInfoView(this._recipeDetail);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0.5, 0, 0.5, 10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: CachedNetworkImage(
                fit: BoxFit.fitWidth, imageUrl: _recipeDetail.thumbnail),
          ),
        ),
        _recipeInfoRow("Difficulty", _recipeDetail.difficulty),
        _recipeInfoRow("Rating", _recipeDetail.rating),
        _recipeInfoRow("Preptime", _recipeDetail.preptime),
        _recipeInfoRow(
            "Cooking Time",
            _recipeDetail.cookingtime == ""
                ? "N.A."
                : _recipeDetail.cookingtime),
      ],
    );
  }
}
