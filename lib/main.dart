import 'package:flutter/material.dart';
import 'package:ckfl/widgets/recipe_grid_widget.dart';
import 'package:ckfl/mockrecipes.dart';
import 'package:ckfl/widgets/recipe_search_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CK',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.green[500],
        accentColor: Colors.lime[500],
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => RecipeSearchView(),
        '/recipegrid': (context) => RecipeGrid(
              recipes: mockresultlist,
              searchterm: "ck",
            ),
      },
      //RecipeGrid(recipes: mockresultlist),
    );
  }
}
