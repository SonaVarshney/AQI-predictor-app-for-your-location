import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class ContentData extends StatelessWidget {
  ContentData({required this.amountPresent, required this.contentName});

  final String contentName;

  String? amountPresent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      // color: Colors.black,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.sp,
        children: [
          Container(
            // height: 1,

            decoration: BoxDecoration(
                color: Color.fromARGB(255, 231, 220, 248),
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: Colors.grey,
                )),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child:
                  //to display amount of nutrient present
                  Text(amountPresent == null ? '0' : '${amountPresent}g',
                      style: const TextStyle(
                        fontSize: 16.0,
                      )),
            ),
          ),
          //to display nutrient name
          Text('$contentName',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
