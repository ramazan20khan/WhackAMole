import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';

import 'package:whackamole/Model/VocabMoleModel.dart';
import 'package:whackamole/Repository/MoleRepository.dart';

class VocabMoleController extends GetxController {
  final MoleRepository moleRepository = MoleRepository();
  final RxList<VocabMoleModel> vocabMoles = <VocabMoleModel>[].obs;
  final List<VocabMoleModel> tickCards = <VocabMoleModel>[].obs;

  RxInt scoreData = 0.obs;
  RxInt levelData = 1.obs;
  int milliSeconds = 0.obs();
  int sMilli = 0;
  int prevLevel = 0;
  int milliDuration = 0;
  late DateTime startTime;
  //late Timer visibilityTimer;
  //late Timer intervalTimer;
  int visibilityDuration = 2000; // Initial visibility duration in milliseconds
  int haveAGo = 0;

  @override
  void onInit() {
    super.onInit();
    //generateMoreCards(1, 2);
    //getVocabMoles();
    startGameLogic();
    ever(scoreData, (_) {
      levelCardNumbers();
    });
    //getVocabMoles(); // Fetch the VocabMoleModel list on initialization
  }

  void generateMoreCards() {
    List<VocabMoleModel> allMoles = moleRepository.getAllMoles();

    // Shuffle the list of moles
    allMoles.shuffle();
    List<VocabMoleModel> generatedCards = [...allMoles.sublist(0, 6)];

    generatedCards[1].isGameCard = true;
    generatedCards[1].isVisible = true;
    //generatedCards[2].isGameCard = true;
    //generatedCards[2].isVisible = true;
    generatedCards.shuffle();

    vocabMoles.assignAll(generatedCards);
    allignTicks();

    //tickCards.assignAll(vocabMoles);
  }

  void resetMilliSeconds() {
    milliSeconds = 0;
  }

  void getVocabMoles() {
    List<VocabMoleModel> fetchedMoles = moleRepository.getVocabMoleList();
    vocabMoles.assignAll(fetchedMoles);
  }

  void toggleVisibility(int index) {
    vocabMoles[index].isVisible = !vocabMoles[index].isVisible;
    //update();
  }

  void levelCardNumbers() {
    int level = (scoreData.value / 30).ceil();

    if (prevLevel < level) {
      prevLevel = level;
      sMilli -= 200;
    }
    if (level > 3) {
      level = level % 3;
    }
    if (level == 0) {
      level = 1;
    }

    levelData.value = level;
  }

  void startGameLogic() {
    generateMoreCards();
    int timerTick = 0;
    levelCardNumbers();
    int milliDuration = (milliSeconds + (visibilityDuration * 2)) + sMilli;
    Timer visibilityTimer =
        Timer.periodic(Duration(milliseconds: milliDuration), (timer) {
      timerTick++;
      startTime = DateTime.now();

      // Toggle the visibility of game cards
      Duration elapsed = DateTime.now().difference(startTime);
      haveAGo++;

      if (elapsed.inMilliseconds < visibilityDuration) {
        // Make the cards visible for the specified duration
        vocabMoles.forEach((card) {
          if (card.isGameCard) {
            card.isVisible = true;
            playSound(card.soundPath);
          }
        });
      } else {
        // Make the cards invisible after the specified duration
        vocabMoles.forEach((card) {
          if (card.isGameCard) {
            card.isVisible = false;
          }
        });
      }

      if (haveAGo > 3) {
        haveAGo = 0;
        milliSeconds += 1000;
      }
      milliDuration = (milliSeconds + (visibilityDuration * 2)) +
          sMilli; // Recalculate milliDuration
      print(
        "$milliDuration  ${milliSeconds} ${haveAGo} $visibilityDuration ${milliSeconds + (visibilityDuration * 2)}",
      );

      // Shuffle the game cards
      vocabMoles.shuffle();
      allignTicks();
      //tickCards.assignAll(vocabMoles);
    });
  }

  void allignTicks() {
    tickCards.clear();
    for (int i = 0; i < vocabMoles.length; i++) {
      VocabMoleModel mole = VocabMoleModel(
          imagePath: 'assets/images/tick.svg',
          text: "Correct",
          soundPath: 'assets/audio/correct.m4a',
          isGameCard: vocabMoles[i].isGameCard,
          isVisible: vocabMoles[i].isVisible);
      tickCards.add(mole);
    }
  }

  void playSound(String soundPath) {
    final assetsAudioPlayer = AssetsAudioPlayer();

    assetsAudioPlayer.open(
      Audio(soundPath),
    );
  }
}
