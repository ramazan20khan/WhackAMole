import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whackamole/Controllers/VocabMoleController.dart';
import 'package:whackamole/Model/VocabMoleModel.dart';
import 'package:get/get.dart';

class VocabMoleView extends StatelessWidget {
  final VocabMoleController controller = Get.put(VocabMoleController());

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    int columns = 2;
    //int rows = 3;

    if (orientation == Orientation.landscape) {
      columns = 3;
      //rows = 2;
    }

    return Obx(
      () => Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height *
                  0.2, // 20% of screen height
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Score: ${controller.scoreData}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Level: ${controller.levelData}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.orangeAccent,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Stack(
                children: [
                  GridView.count(
                    crossAxisCount: columns,
                    childAspectRatio:
                        orientation == Orientation.portrait ? 1 : 1.6,
                    controller: ScrollController(keepScrollOffset: false),
                    //mainAxisSpacing:
                    //    orientation == Orientation.portrait ? 90.0 : 90,
                    children: genMoleHoles(),
                  ),
                  Center(child: tickGrid(columns, orientation)),
                  Center(child: buildGridView(columns, orientation)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView(int columns, Orientation orientation) {
    return GridView.count(
      crossAxisCount: columns,
      childAspectRatio: orientation == Orientation.portrait ? 1 : 1.6,
      controller: ScrollController(keepScrollOffset: false),
      mainAxisSpacing: orientation == Orientation.portrait ? 0 : 0.0,
      shrinkWrap: true,
      children: controller.vocabMoles
          .map(
            (card) => GestureDetector(
              onTap: () async {
                if (card.isGameCard) {
                  controller.scoreData += 10;
                  controller.playSound('assets/audio/correct.m4a');

                  card.isVisible = false;
                  await Future.delayed(Duration(milliseconds: 800));
                  controller.haveAGo = 0;
                  controller.resetMilliSeconds();
                  controller.generateMoreCards();
                }
              },
              child: AnimatedOpacity(
                opacity: card.isVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              child: SvgPicture.asset(
                                card.imagePath,
                                // semanticsLabel: 'Custom Card Image',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              card.text,
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget tickGrid(int columns, Orientation orientation) {
    return FutureBuilder(
      future: Future.delayed(
        Duration(milliseconds: 300), // Delay of 300 milliseconds
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return Obx(() => GridView.count(
                crossAxisCount: columns,
                childAspectRatio: orientation == Orientation.portrait ? 1 : 1.6,
                controller: ScrollController(keepScrollOffset: false),
                mainAxisSpacing: orientation == Orientation.portrait ? 0 : 0.0,
                shrinkWrap: true,
                children: controller.tickCards.map(
                  (card) {
                    if (card.isGameCard) {
                      return GestureDetector(
                        onTap: () {
                          controller.scoreData += 10;
                          controller.playSound('assets/audio/correct.m4a');
                          card.isVisible = false;
                          controller.generateMoreCards();
                        },
                        child: AnimatedOpacity(
                          opacity: card.isVisible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          card.imagePath,
                                          // semanticsLabel: 'Custom Card Image',
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        card.text,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(); // Hide non-game cards
                    }
                  },
                ).toList(),
              ));
        }
      },
    );
  }

  List<Widget> genMoleHoles() {
    double ellipseHeight = 80.0;
    double ellipseWidth = 120.0;

    return List.generate(
      6,
      (index) => Container(
        child: Center(
          child: Container(
            width: ellipseWidth,
            height: ellipseHeight,
            decoration: BoxDecoration(
              color: Colors.brown,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(ellipseHeight / 2),
            ),
          ),
        ),
      ),
    );
  }
}
