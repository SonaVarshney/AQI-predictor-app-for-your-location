import 'package:aqi/content_data.dart';
import 'package:flutter/material.dart';
// import 'package:nutrition_app_gdsc/widgets/nutrition_data.dart';
import 'package:aqi/main.dart';

class MyCardWidget extends StatelessWidget {
  bool isLoading;
  final String text;
  var composition; //map
  final List<String> contents;
  // final String? servingSize;

  MyCardWidget(
      {required this.text,
      required this.contents,
      this.composition,
      // this.servingSize,
      required this.isLoading});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 690,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.grey[300],
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(
            20,
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //text on the card
                    Text(
                      '$text',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 0.0,
                        children: List.generate(
                          contents.length,
                          (index) {
                            return Container(
                              height: 0,
                              child: ContentData(
                                  contentName: contents[index],
                                  amountPresent: composition[contents[index]]),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
