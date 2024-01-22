import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class BaseDataManager {
  //funkcja do pracy z danymi zastępczymi bez konieczności konfigurowania własnej bazy
  //używa pakietu http do wysyłania zapytań HTTP
  //pobiera dane z DummyJSON, a następnie konwertuje odpowiedź na listę map w języku Dart
  //zwraca listę danych w formacie JSON
  Future<List<Map<String, dynamic>>> fetchDataFromServer(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('recipes') && responseData['recipes'] is List) {
          final List<Map<String, dynamic>> data = List<
              Map<String, dynamic>>.from(responseData['recipes']);
          print('mam dane z serwera');
          return data;
        }else if(responseData.containsKey('users') && responseData['users'] is List) {
          final List<Map<String, dynamic>> data = List<
              Map<String, dynamic>>.from(responseData['users']);
          print('mam dane z serwera');
          return data;
        } else {
          print('Błąd pobierania danych: nieprawidłowy format danych');
          throw Exception('Błąd pobierania danych: nieprawidłowy format danych');
        }
      } else {
        print('Błąd pobierania danych: ${response.statusCode}');
        throw Exception('Błąd pobierania danych: ${response.statusCode}');
      }
    } catch (error) {
      print('Błąd podczas pobierania danych z serwera: $error');
      throw error;
    }
  }

  //Mogę użyć np. SharedPreferences, Hive lub innego magazynu danych
  //Zapisuje dane do lokalnego magazynu
  Future<void> saveDataLocally(String key, List<Map<String, dynamic>> data) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String jsonData = json.encode(data);
      await prefs.setString(key, jsonData);
    } catch (error) {
      print('Błąd zapisu danych lokalnie: $error');
    }
  }

  //Odczytuje dane z lokalnego magazynu i zwraca listę danych
  Future<List<Map<String, dynamic>>> getLocallyStoredData(String key) async {
    try {
      print('próbuję zwrócić lokalnie zapisane dane');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? jsonData = prefs.getString(key);
      print(jsonData);
      if (jsonData != null) {
        final List<Map<String, dynamic>> storedData = List<Map<String, dynamic>>.from(json.decode(jsonData));
        return storedData;
      }
    } catch (error) {
      print('Błąd odczytu lokalnych danych: $error');
    }
    return [];
  }
}
