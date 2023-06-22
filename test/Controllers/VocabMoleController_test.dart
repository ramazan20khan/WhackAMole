import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:whackamole/Controllers/VocabMoleController.dart';
import 'package:whackamole/Model/VocabMoleModel.dart';
import 'package:whackamole/Repository/MoleRepository.dart';
import 'package:mocktail/mocktail.dart';

class MockVocabMoleController extends Mock implements VocabMoleController {}

void main() {
  setUp(() {});

  tearDown(() {
    Get.reset(); // Reset Get dependency injection after each test
  });

  group('VocabMoleController', () {
    test('Fetch VocabMoleModel list', () {
      final controller =
          VocabMoleController(); // Create an instance of the controller

      controller.getVocabMoles();

      // Ensure the fetched list is not empty
      expect(controller.vocabMoles.isNotEmpty, true);

      // Ensure the fetched list has the correct type
      expect(controller.vocabMoles[0], isA<VocabMoleModel>());
    });

    // Add more tests here for other methods and functionalities of the controller
  });
}
