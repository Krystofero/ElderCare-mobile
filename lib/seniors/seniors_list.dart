import 'package:flutter/material.dart';
import 'senior_details.dart';
import 'senior_data_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SeniorsList extends StatefulWidget {
  @override
  _SeniorsListState createState() => _SeniorsListState();
}

class _SeniorsListState extends State<SeniorsList> {
  final SeniorDataManager dataManager = SeniorDataManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Seniorów'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dataManager.getSeniorsData(),
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
            List<Map<String, dynamic>> seniors = snapshot.data!;
            print('Pierwszy senior: ${seniors.isNotEmpty ? seniors[0] : null}');
            return ListView.builder(
              itemCount: seniors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    try {
                      List<Map<String, dynamic>> updatedSeniors = await dataManager.fetchDataFromServer(
                          'https://dummyjson.com/users?select=firstName,lastName,image,age,birthDate,phone,bloodGroup,height,weight,hair,address');
                      print('Pobrano zaktualizowane dane seniorów: $updatedSeniors');
                      setState(() {
                        seniors = updatedSeniors;
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
                        future: getImageWidget(seniors[index]['image']),
                        builder: (context, imageSnapshot) {
                          if (imageSnapshot.connectionState == ConnectionState.waiting) {
                            return const CircleAvatar(radius: 30, backgroundColor: Colors.grey);
                          } else {
                            return CircleAvatar(radius: 30, child: imageSnapshot.data);
                          }
                        },
                      ),
                      title: Text(
                        '${seniors[index]['firstName']} ${seniors[index]['lastName']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Wiek: ${seniors[index]['age']}',
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeniorDetails(senior: seniors[index]),
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

