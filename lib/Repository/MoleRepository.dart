import 'package:get/get.dart';
import 'package:whackamole/Model/VocabMoleModel.dart';

class MoleRepository extends GetxController {
  List<VocabMoleModel> getVocabMoleList() {
    List<String> imagePaths = [
      'assets/images/fc_tomato.svg',
      'assets/images/fc_potato.svg',
      'assets/images/fc_orange.svg',
      'assets/images/fc_egg.svg',
      'assets/images/fc_carrot.svg',
      'assets/images/fc_cake.svg',
      'assets/images/fc_bread.svg',
      'assets/images/fc_banana.svg',
      'assets/images/fc_apple.svg',
      'assets/images/tick.svg',
    ];

    List<String> soundPaths = [
      'assets/audio/fc_tomato.m4a',
      'assets/audio/fc_potato.m4a',
      'assets/audio/fc_orange.m4a',
      'assets/audio/fc_egg.m4a',
      'assets/audio/fc_carrot.m4a',
      'assets/audio/fc_cake.m4a',
      'assets/audio/fc_bread.m4a',
      'assets/audio/fc_banana.m4a',
      'assets/audio/fc_apple.m4a',
      'assets/audio/correct.m4a',
    ];

    List<VocabMoleModel> customCards = [];

    for (int num = 0; num < soundPaths.length; num++) {
      VocabMoleModel customCard = VocabMoleModel(
        imagePath: imagePaths[num],
        soundPath: soundPaths[num],
        text: imagePaths[num],
        isVisible: false, // Set the initial visibility of all cards to false
        isGameCard: false,
        //onTap: () {},
        onVisible: () {},
      );
      customCards.add(customCard);
    }

    return customCards;
  }

  List<VocabMoleModel> getAllMoles() {
    List<VocabMoleModel> vocamMoleList = getVocabMoleList();
    if (vocamMoleList.length > 1) {
      return vocamMoleList.sublist(0, vocamMoleList.length - 1);
    } else {
      return [];
    }
  }

  List<VocabMoleModel> getTickList() {
    List<VocabMoleModel> moles = [];
    VocabMoleModel mole =
        VocabMoleModel(imagePath: "", text: "", soundPath: "");
    for (int i = 0; i < 6; i++) {
      mole.imagePath = 'images/tick.svg';
      mole.text = 'Correct';
      mole.soundPath = 'assets/audio/correct.m4a';
      mole.isVisible = false;
      moles.add(mole);
    }
    return moles;
  }

/*
  void addVocabMole(VocabMoleModel mole) {
    // Add a new VocabMoleModel object to the list
  }

  void removeVocabMole(int index) {
    // Remove a VocabMoleModel object from the list at the specified index
  }

  void updateVocabMole(int index, VocabMoleModel updatedMole) {
    // Update a VocabMoleModel object in the list at the specified index with the provided updatedMole
  }

  void clearVocabMoles() {
    // Clear all VocabMoleModel objects from the list
  }

  // Additional methods that you might find useful:
  
  List<VocabMoleModel> getVisibleMoles() {
    // Return a list of only the visible VocabMoleModel objects
    
  }

  List<VocabMoleModel> getGameCards() {
    // Return a list of only the game card VocabMoleModel objects
  }

  VocabMoleModel getVocabMole(int index) {
    // Return the VocabMoleModel object at the specified index
  }
  */
  VocabMoleModel getLastVocabMole() {
    // Return the VocabMoleModel object at the specified index
    return getVocabMoleList().last;
  }

  int getVocabMoleCount() {
    // Return the count of VocabMoleModel objects in the list
    return getVocabMoleList().length;
  }
}
