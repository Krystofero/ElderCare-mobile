import '../data_management/data_manager.dart';

class RecipesDataManager extends BaseDataManager {
  Future<List<Map<String, dynamic>>> getRecipesData() async {
    try {
      // final List<Map<String, dynamic>> serverData = await fetchDataFromServer(
      //     'https://dummyjson.com/recipes?select=name,image');
      final List<Map<String, dynamic>> serverData = await fetchDataFromServer(
          'https://dummyjson.com/recipes?limit=20&select=name,image,ingredients,instructions,prepTimeMinutes,cookTimeMinutes,servings,difficulty,caloriesPerServing');
    print('Pobrano dane przepisów z serwera');

      await saveDataLocally('recipes_data', serverData);
      return serverData;
    } catch (error) {
      print('Błąd w RecipesDataManager: $error');
      return getLocallyStoredData('recipes_data');
    }
  }
}
