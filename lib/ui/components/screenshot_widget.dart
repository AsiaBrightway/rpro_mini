import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rpro_mini/data/vos/item_vo.dart';
import 'package:screenshot/screenshot.dart'; // Ensure you have the `screenshot` package installed

// Define a widget to encapsulate the Screenshot content
class ScreenshotReceiptWidget extends StatelessWidget {
  final List<ItemVo> items;
  final String? printerLocation;
  final double listWidth;
  final double textSize;
  final ScreenshotController screenshotController;

  const ScreenshotReceiptWidget({super.key, required this.screenshotController, required this.listWidth, required this.textSize, required this.items, this.printerLocation});

  @override
  Widget build(BuildContext context) {
    String formattedDateTime = DateFormat('yyyy-MM-dd h:mm:ss a').format(DateTime.now());
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black45,width: 0.5)
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        color: Colors.white,
        width: listWidth,
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "INNOCENT",
                  style: TextStyle(color: Colors.black,fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '($printerLocation Orders)',
                        style: const TextStyle(
                          color: Colors.black,
                            fontSize: 8, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(formattedDateTime, style: const TextStyle(fontSize: 9,color: Colors.black)),
                Text(
                    '(700)',
                    style: TextStyle(fontSize: 9,color: Colors.black)
                )
              ],
            ),
            const Row(
              children: [
                Text('G-Floor, ', style: TextStyle(fontSize: 9,color: Colors.black)),
                Text('B4, ', style: TextStyle(fontSize: 9,color: Colors.black)),
                Text('1', style: TextStyle(fontSize: 9,color: Colors.black))
              ],
            ),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    "Name",
                    style: TextStyle(fontSize: 8, fontFamily: 'Ubuntu',color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Unit",
                    style: TextStyle(
                        fontSize: 8, fontWeight: FontWeight.w400, fontFamily: 'Ubuntu',color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Qty",
                    style: TextStyle(
                        fontSize: 8, fontWeight: FontWeight.w400, fontFamily: 'Ubuntu',color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Remark",
                    style: TextStyle(
                        fontSize: 8, fontWeight: FontWeight.w400, fontFamily: 'Ubuntu',color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 8,top: 4),
                  physics: const ScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            maxLines: 2,
                            items[index].itemName ?? '_',
                            style: TextStyle(fontSize: textSize,color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Cup",
                            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w400,color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "1",
                            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w400,color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "no sugar",
                            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w400,color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}