import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

//poziomy trudności gry
enum Level { Hard, Medium, Easy }

//wypełnia tablicę źródłową owocami
List<String> fillSourceArray() {
  return [
    '🍎', '🍎',
    '🍌', '🍌',
    '🍒', '🍒',
    '🍇', '🍇',
    '🍓', '🍓',
    '🍑', '🍑',
    '🍈', '🍈',
    '🍍', '🍍',
    '🥝', '🥝',
  ];
}

//zwraca tablicę źródłową z uwzględnieniem poziomu trudności
List<String> getSourceArray(Level level,) {
  List<String> levelAndKindList = <String>[];
  List sourceArray = fillSourceArray();
  if (level == Level.Hard) {
    sourceArray.forEach((element) {
      levelAndKindList.add(element);
    });
  } else if (level == Level.Medium) {
    for (int i = 0; i < 12; i++) {
      levelAndKindList.add(sourceArray[i]);
    }
  } else if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      levelAndKindList.add(sourceArray[i]);
    }
  }

  levelAndKindList.shuffle();
  return levelAndKindList;
}

//zwraca początkowy stan kart z uwzględnieniem poziomu trudności
List<bool> getInitialItemState(Level level) {
  List<bool> initialItemState = <bool>[];
  if (level == Level.Hard) {
    for (int i = 0; i < 18; i++) {
      initialItemState.add(true);
    }
  } else if (level == Level.Medium) {
    for (int i = 0; i < 12; i++) {
      initialItemState.add(true);
    }
  } else if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      initialItemState.add(true);
    }
  }
  return initialItemState;
}

//zwracająca listę kluczy stanu kart z uwzględnieniem poziomu trudności
List<GlobalKey<FlipCardState>> getCardStateKeys(Level level) {
  List<GlobalKey<FlipCardState>> cardStateKeys = <GlobalKey<FlipCardState>>[];
  if (level == Level.Hard) {
    for (int i = 0; i < 18; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  } else if (level == Level.Medium) {
    for (int i = 0; i < 12; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  } else if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  }
  return cardStateKeys;
}

