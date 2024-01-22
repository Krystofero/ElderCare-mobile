import 'package:flutter/material.dart';
import 'seniors/seniors_list.dart';
import 'recipes/recipes_list.dart';
import 'flip_card_game/flip_card_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentAdIndex = 0; //indeks aktualnie wyświetlanej reklamy

  final List<String> ads = [
    'Reklama 1',
    'Reklama 2',
    'Reklama 3',
  ];

  @override
  void initState() {
    super.initState();
    startAdRotation(); //rozpocznij automatyczną zmianę reklam co 3 sekundy
  }

  //metoda do obsługi automatycznej zmiany reklam
  void startAdRotation() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          //zwiększ indeks reklamy
          currentAdIndex = (currentAdIndex + 1) % ads.length;
          //ponownie uruchom timer
          startAdRotation();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ElderCare'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu Główne',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Lista Seniorów'),
              onTap: () {
                Navigator.pop(context); //zamyka Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SeniorsList()),
                );
              },
            ),
            ListTile(
              title: const Text('Przepisy kulinarne'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipesList()),
                );
              },
            ),
            ListTile(
              title: const Text('Ćwiczenie pamięci'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlipCardView()),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          //tło z animacją
          AnimatedBackground(),

          //reklama zmieniająca się automatycznie
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: Text(
                ads[currentAdIndex],
                key: ValueKey<int>(currentAdIndex),
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text('Witaj', style: TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//komponent z animowanym tłem
class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.purple],
        ),
      ),
    );
  }
}
