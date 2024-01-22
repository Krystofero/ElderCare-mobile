import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'dart:async';

class FlipCardGame extends StatefulWidget {
  final Level _level;
  FlipCardGame(this._level);
  @override
  _FlipCardGameState createState() => _FlipCardGameState(_level);
}

//klasa stanu
class _FlipCardGameState extends State<FlipCardGame> {
  _FlipCardGameState(this._level);

  int _previousIndex = -1;
  bool _flip = false;
  bool _start = false;

  bool _wait = false;
  Level _level;
  Timer? _timer;
  int _time = 5;
  late int _left;
  late bool _isFinished;
  late List<String> _data;
  late List<bool> _cardFlips;
  late List<GlobalKey<FlipCardState>> _cardStateKeys;

  //metoda zwracająca widżet dla danego indeksu
  Widget getItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 3,
            spreadRadius: 0.8,
            offset: Offset(2.0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.all(4.0),
      child: Center(
        child: Text(
          _data[index],
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  //metoda rozpoczynająca odliczanie czasu
  startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        _time = _time - 1;
      });
    });
  }

  void restart() {
    startTimer();
    _data = getSourceArray(
      _level,
    );
    _cardFlips = getInitialItemState(_level);
    _cardStateKeys = getCardStateKeys(_level);
    _time = 5;
    _left = (_data.length ~/ 2);

    _isFinished = false;
    Future.delayed(const Duration(seconds: 6), () {
      setState(() {
        _start = true;
        _timer?.cancel();
      });
    });
  }

  void showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gratulacje!'),
          content: Text('Udało Ci się ukończyć grę!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                restart();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  //inicjalizacja stanu gry
  @override
  void initState() {
    super.initState();
    _left = 0;
    _isFinished = false;
    _cardFlips = [];
    _cardStateKeys = [];

    restart();
  }

  //zwolnienie zasobów
  @override
  void dispose() {
    super.dispose();
  }

  //budowa interfejsu użytkownika
  @override
  Widget build(BuildContext context) {
    return _isFinished
        ? Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              restart();
            });
          },
          child: Container(
            height: 50,
            width: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              "Zagraj ponownie",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Gra w Memory'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _time > 0
                    ? Text(
                  '$_time',
                  style: Theme.of(context).textTheme.displaySmall,
                )
                    : Text(
                  'Zostało par:$_left',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) => _start
                      ? FlipCard(
                      key: _cardStateKeys[index],
                      onFlip: () {
                        if (!_flip) {
                          _flip = true;
                          _previousIndex = index;
                        } else {
                          _flip = false;
                          if (_previousIndex != index) {
                            if (_data[_previousIndex] !=
                                _data[index]) {
                              _wait = true;

                              Future.delayed(
                                  const Duration(milliseconds: 1500),
                                      () {
                                    _cardStateKeys[_previousIndex]
                                        .currentState
                                        ?.toggleCard();
                                    _previousIndex = index;
                                    _cardStateKeys[_previousIndex]
                                        .currentState
                                        ?.toggleCard();

                                    Future.delayed(
                                        const Duration(milliseconds: 160),
                                            () {
                                          setState(() {
                                            _wait = false;
                                          });
                                        });
                                  });
                            } else {
                              _cardFlips[_previousIndex] = false;
                              _cardFlips[index] = false;
                              print(_cardFlips);

                              setState(() {
                                _left -= 1;
                              });
                              if (_cardFlips
                                  .every((t) => t == false)) {
                                print("Won");
                                Future.delayed(
                                    const Duration(milliseconds: 160),
                                        () {
                                      setState(() {
                                        _isFinished = true;
                                        _start = false;
                                      });
                                      showWinDialog();
                                    });
                              }
                            }
                          }
                        }
                        setState(() {});
                      },
                      flipOnTouch: _wait ? false : _cardFlips[index],
                      direction: FlipDirection.HORIZONTAL,
                      front: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 3,
                              spreadRadius: 0.8,
                              offset: Offset(2.0, 1),
                            )
                          ],
                        ),
                        margin: EdgeInsets.all(4.0),
                        child: Center(
                          child: _cardFlips[index]
                              ? Text(
                            '❓',
                            style: TextStyle(
                              fontSize: 36,
                            ),
                          )
                              : Container(),
                        ),
                      ),
                      back: getItem(index))
                      : getItem(index),
                  itemCount: _data.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
