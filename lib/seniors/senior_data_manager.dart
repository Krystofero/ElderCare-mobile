import '../data_management/data_manager.dart';

class SeniorDataManager extends BaseDataManager {
  Future<List<Map<String, dynamic>>> getSeniorsData() async {
    try {
      final List<Map<String, dynamic>> serverData = await fetchDataFromServer(
          'https://dummyjson.com/users?select=firstName,lastName,image,age,birthDate,phone,bloodGroup,height,weight,hair,address');
      print('Pobrano dane seniorów z serwera');
      print(serverData);

      //filtruj seniorów i zapisz dane lokalnie
      final List<Map<String, dynamic>> filteredData = serverData
          .where((senior) => senior['age'] != null && senior['age'] > 40)
          .toList();

      await saveDataLocally('seniors_data', filteredData);
      return filteredData;
    } catch (error) {
      print('Błąd w SeniorDataManager: $error');
      return getLocallyStoredData('seniors_data');
    }
  }

}



