import 'package:flutter/material.dart';
import 'recipes_details.dart';
import 'recipes_data_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipesList extends StatefulWidget {
  @override
  _RecipesListState createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  final RecipesDataManager dataManager = RecipesDataManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Przepisy Kulinarne'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dataManager.getRecipesData(),
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('Trwa pobieranie danych...'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Błąd podczas pobierania danych.'),
            );
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>> recipes = snapshot.data!;
            print('Pierwszy przepis: ${recipes.isNotEmpty ? recipes[0] : null}');
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    try {
                      List<Map<String, dynamic>> updatedRecipes = await dataManager.fetchDataFromServer(
                          'https://dummyjson.com/recipes?limit=20&select=name,image,ingredients,instructions,prepTimeMinutes,cookTimeMinutes,servings,difficulty,caloriesPerServing');
                      print('Pobrano zaktualizowane dane przepisów: $updatedRecipes');
                      setState(() {
                        recipes = updatedRecipes;
                      });
                    } catch (error) {
                      print('Błąd podczas pobierania danych: $error');
                    }
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      tileColor: Colors.grey[200],
                      contentPadding: EdgeInsets.all(16),
                      leading: FutureBuilder<Widget>(
                        future: getImageWidget(recipes[index]['image']),
                        builder: (context, imageSnapshot) {
                          if (imageSnapshot.connectionState == ConnectionState.waiting) {
                            return const CircleAvatar(radius: 30, backgroundColor: Colors.grey);
                          } else {
                            return CircleAvatar(radius: 30, child: imageSnapshot.data);
                          }
                        },
                      ),
                      title: Text(
                        '${recipes[index]['name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipesDetails(recipe: recipes[index]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('Brak danych.'),
            );
          }
        },
      ),
    );
  }

  Future<Widget> getImageWidget(String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        return CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 30,
            backgroundImage: imageProvider,
          ),
        );
      }
    } catch (error) {
      print('Błąd podczas pobierania obrazu: $error');
    }

    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey,
    );
  }
}