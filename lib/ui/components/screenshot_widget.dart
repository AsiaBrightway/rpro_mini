import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart'; // Ensure you have the `screenshot` package installed

// Define a widget to encapsulate the Screenshot content
class ScreenshotReceiptWidget extends StatelessWidget {
  final ScreenshotController screenshotController;

  const ScreenshotReceiptWidget({super.key, required this.screenshotController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black45,width: 0.5)
      ),
      child: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          color: Colors.white,
          width: 200,
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "INNOCENT",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '(Bar and Refrigerator Orders)',
                          style: TextStyle(
                              fontSize: 8, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Text('2025-02-20, ', style: TextStyle(fontSize: 9)),
                  Text('2:49 PM ', style: TextStyle(fontSize: 9)),
                  Text('(700)', style: TextStyle(fontSize: 9))
                ],
              ),
              const Row(
                children: [
                  Text('G-Floor, ', style: TextStyle(fontSize: 9)),
                  Text('B4, ', style: TextStyle(fontSize: 9)),
                  Text('1', style: TextStyle(fontSize: 9))
                ],
              ),
              const SizedBox(height: 4),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Name",
                      style: TextStyle(fontSize: 8, fontFamily: 'Ubuntu'),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Unit",
                      style: TextStyle(
                          fontSize: 8, fontWeight: FontWeight.w400, fontFamily: 'Ubuntu'),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Qty",
                      style: TextStyle(
                          fontSize: 8, fontWeight: FontWeight.w400, fontFamily: 'Ubuntu'),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Remark",
                      style: TextStyle(
                          fontSize: 8, fontWeight: FontWeight.w400, fontFamily: 'Ubuntu'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 8),
                physics: const ScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          "ထမင်းကြော်",
                          style: TextStyle(fontSize: 8),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Cup",
                          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "1",
                          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}