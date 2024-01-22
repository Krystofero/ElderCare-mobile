import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'recipes_data_manager.dart';

class RecipesDetails extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final RecipesDataManager dataManager = RecipesDataManager();

  RecipesDetails({required this.recipe});

  Widget buildImageWidget(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 150,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey, // Szare tło w przypadku błędu
        ),
        child: Icon(Icons.error),
      ),
    );
  }

  Widget buildExpansionTile(String title, dynamic content) {
    return ExpansionTile(
      title: Text(title),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            // obsługa zarówno listy jak i ciągu znaków
            content is List ? content.join(", ") : content.toString(),
          ),
        ),
      ],
    );
  }


  Widget buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          //value jako dynamic, aby obsłużyć różne typy danych
          Text(value?.toString() ?? 'Brak danych'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildImageWidget(recipe['image'] ?? ''), // Image URL
              buildDetailRow('Czas przygotowania', '${recipe['prepTimeMinutes']} minut'),
              buildDetailRow('Czas gotowania', '${recipe['cookTimeMinutes']} minut'),
              buildDetailRow('Porcje', recipe['servings']),
              buildDetailRow('Trudność', recipe['difficulty']),
              buildDetailRow('Kalorie na porcję', '${recipe['caloriesPerServing']} kcal'),
              buildExpansionTile('Składniki', recipe['ingredients']),
              buildExpansionTile('Instrukcje', recipe['instructions']),
            ],
          ),
        ),
      ),
    );
  }
}
