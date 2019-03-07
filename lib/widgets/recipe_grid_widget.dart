import 'package:flutter/material.dart';
import 'package:ckfl/Recipe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ckfl/mockrecipedetail.dart';
import 'package:ckfl/mockrecipes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  void _searchRecipe(String inp) {
    searchRecipe(context, inp);
  }
}

void searchRecipe(BuildContext context, String inp) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RecipeGrid(
                recipes: mockresultlist,
                searchterm: inp,
                onChanged: null,
             // _showResultsBody(fetchRecipes(inp, "1")),
              )),
  );
}

class RecipeGrid extends StatefulWidget {
  final List<Recipe> recipes;
  final String searchterm;
  final ValueChanged<int> onChanged;

  RecipeGrid({Key key, this.recipes, this.searchterm, this.onChanged})
      : super(key: key);

  @override
  RecipeGridState createState() {
    return new RecipeGridState();
  }
}

class RecipeGridState extends State<RecipeGrid> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar bottomNavBar = BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.navigate_before),
          title: Text("back"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.navigate_next),
          title: Text("next"),
        ),
      ],
      type: BottomNavigationBarType.shifting,
      onTap: _handleTap,
    );

    return Scaffold(
      appBar: AppBar(title: Text("search title")),
      body: buildRecipeGridView(),
      bottomNavigationBar: bottomNavBar,
    );
  }

  void _handleTap(int index) {
    if (index == 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      setState(() {
        if (_currentIndex > 0) {
          _currentIndex--;
        }
      });
    }
  }

  GridView buildRecipeGridView() {
    return GridView.extent(
        maxCrossAxisExtent: 480.0,
        children:
            widget.recipes.map((i) => _RecipeSearchItem(recipe: i)).toList());
  }

  Widget _showMoreRecipes() {
    return FloatingActionButton(
      onPressed: null,
    );
  }
}

Uri searchUrl(String searchterm, String page) {
  Uri uri =
      Uri.http('10.0.2.2:8080', 'search', {'query': searchterm, 'page': page});
  return uri;
}

Future<List<Recipe>> fetchRecipes(String searchterm, String page) async {
  final url = searchUrl(searchterm, page);
  final response = await http.get(url);
  print(url);
  print(response.body);
  print(response);

  if (response.statusCode == 200) {
    var u8 = utf8.decode(response.bodyBytes);
    var decoded = json.decode(u8) as List;
    if (decoded != null) {
      return decoded.map((i) => Recipe.fromJson(i)).toList();
    } else {
      return [];
    }
  } else
    throw Exception("Failed to load recipe.");
}

FutureBuilder<List<Recipe>> _showResultsBody(Future<List<Recipe>> handler) {
  return FutureBuilder(
      future: handler,
      builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container(child: Center(child: Text("Please try again.")));
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container(child: Center(child: CircularProgressIndicator()));
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Something went wrong: " + snapshot.error.toString());
            }
            return RecipeGrid(recipes: snapshot.data);
        }
      });
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
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 0.5,
          ),
          child: Center(
            child: Hero(
              tag: widget.recipe.thumbnail,
              child: RecipeViewer(recipe: widget.recipe),
            ),
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
    final Size _size = MediaQuery.of(context).size;
    const double _kRecipeViewMaxWidth = 460.0;
    final bool fullWidth = _size.width < _kRecipeViewMaxWidth;
    return Container(
      constraints: BoxConstraints(
        maxWidth: fullWidth ? _size.width : _kRecipeViewMaxWidth,
        maxHeight: _size.height,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: _size.height / 3,
            width: fullWidth ? _size.width : _kRecipeViewMaxWidth,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _recipeInfoRow("Rating", widget.recipe.rating),
                _recipeInfoRow("Preptime: ", widget.recipe.preptime),
                _recipeInfoRow("Difficulty", widget.recipe.difficulty),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Padding _recipeInfoRow(String description, String detail) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
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
