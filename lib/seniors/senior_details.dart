import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'senior_data_manager.dart';

class SeniorDetails extends StatelessWidget {
  final Map<String, dynamic> senior;
  final SeniorDataManager dataManager = SeniorDataManager();

  SeniorDetails({required this.senior});

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

  Widget buildExpansionTile(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(title),
      children: children,
    );
  }

  Widget buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? 'Brak danych'),
        ],
      ),
    );
  }

  Widget buildHairDetails(Map<String, dynamic>? hairDetails) {
    if (hairDetails == null || hairDetails.isEmpty) {
      return buildDetailRow('  • Kolor', 'Brak danych');
    } else {
      return Column(
        children: [
          buildDetailRow('  • Kolor', hairDetails['color']),
          buildDetailRow('  • Typ', hairDetails['type']),
        ],
      );
    }
  }

  Widget buildAddressDetails(Map<String, dynamic>? addressDetails) {
    if (addressDetails == null || addressDetails.isEmpty) {
      return buildDetailRow('  • Ulica', 'Brak danych');
    } else {
      return Column(
        children: [
          buildDetailRow('  • Ulica', addressDetails['address']),
          buildDetailRow('  • Miasto', addressDetails['city']),
          buildDetailRow('  • Kod pocztowy', addressDetails['postalCode']),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Szczegóły Seniora'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildImageWidget(senior['image'] ?? ''), // Image URL
              buildDetailRow('Imię', senior['firstName']),
              buildDetailRow('Nazwisko', senior['lastName']),
              buildDetailRow('Wiek', senior['age']?.toString()),
              buildDetailRow('Data urodzenia', senior['birthDate']),
              buildDetailRow('Numer telefonu', senior['phone']),
              buildDetailRow('Dane biometryczne', ''),
              buildDetailRow('  • Grupa krwi', senior['bloodGroup']),
              buildDetailRow('  • Wzrost', '${senior['height']} cm'),
              buildDetailRow('  • Waga', '${senior['weight']} kg'),
              buildExpansionTile('Włosy', [buildHairDetails(senior['hair'])]),
              buildExpansionTile('Adres', [buildAddressDetails(senior['address'])]),
            ],
          ),
        ),
      ),
    );
  }
}
