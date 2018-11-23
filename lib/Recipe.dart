class Recipe {
  String title;
  String subtitle;
  String url;
  String thumbnail;
  String rating;
  String difficulty;
  String preptime;

  Recipe(this.title, this.subtitle, this.url,
      this.thumbnail, this.rating, this.difficulty,
      this.preptime);

}

class RecipeDetail {
  String title;
  String rating;
  String difficulty;
  String preptime;
  String cookingtime;
  String thumbnail;
  List<RecipeIngredient> ingredients;
  String method;

  RecipeDetail({this.title, this.rating, this.difficulty,
      this.preptime, this.cookingtime, this.thumbnail,
      this.ingredients, this.method});
}

class RecipeIngredient {
  String amount;
  String ingredient;

  RecipeIngredient(this.amount, this.ingredient);
}