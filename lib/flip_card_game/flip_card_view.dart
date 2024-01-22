import 'package:flutter/material.dart';
import 'flip_card_game.dart';
import 'data.dart';

class Details {
  String name;
  Color? primaryColor;
  Color? secondaryColor;
  Widget goto;
  int numberOfStars;

  Details({
    required this.name,
    this.primaryColor,
    this.secondaryColor,
    required this.numberOfStars,
    required this.goto,
  });
}

class FlipCardView extends StatefulWidget {
  @override
  _FlipCardViewState createState() => _FlipCardViewState();
}

class _FlipCardViewState extends State<FlipCardView> {
  List<Details> _list = [
    Details(
      name: "Łatwy",
      primaryColor: Colors.blue,
      secondaryColor: Colors.blue[300],
      numberOfStars: 1,
      goto: FlipCardGame(Level.Easy),
    ),
    Details(
      name: "Średni",
      primaryColor: Colors.orange,
      secondaryColor: Colors.orange[300],
      numberOfStars: 2,
      goto: FlipCardGame(Level.Medium),
    ),
    Details(
      name: "Trudny",
      primaryColor: Colors.red,
      secondaryColor: Colors.red[300],
      numberOfStars: 3,
      goto: FlipCardGame(Level.Hard),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybierz Poziom Trudności'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => _list[index].goto,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Zmieniony kształt przycisku
                  ),
                  elevation: 5,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: _list[index].primaryColor ?? Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _list[index].name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 2,
                                offset: Offset(1, 2),
                              ),
                              Shadow(
                                color: Colors.green,
                                blurRadius: 2,
                                offset: Offset(0.5, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: generatestar(_list[index].numberOfStars),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> generatestar(int no) {
    List<Widget> _icons = [];
    for (int i = 0; i < no; i++) {
      _icons.insert(
        i,
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20,
        ),
      );
    }
    return _icons;
  }
}
