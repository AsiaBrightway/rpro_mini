import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rpro_mini/data/vos/order_details_vo.dart';
import 'package:screenshot/screenshot.dart'; // Ensure you have the `screenshot` package installed

// Define a widget to encapsulate the Screenshot content
class ScreenshotReceiptWidget extends StatelessWidget {
  final List<OrderDetailsVo> items;
  final String floorName;
  final String tableName;
  final String groupName;
  final String? printerLocation;
  final double textSize;
  final String empName;
  final String restaurantName;
  final ScreenshotController screenshotController;

  const ScreenshotReceiptWidget({
    super.key,
    required this.screenshotController,
    required this.textSize,
    required this.items,
    this.printerLocation,
    required this.floorName,
    required this.tableName,
    required this.groupName,
    required this.empName,
    required this.restaurantName}
      );

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
        width: 200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  restaurantName,
                  style: const TextStyle(color: Colors.black,fontSize: 10, fontWeight: FontWeight.bold),
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
                const Text(
                    '(700)',
                    style: TextStyle(fontSize: 9,color: Colors.black)
                )
              ],
            ),
            Row(
              children: [
                Text('$floorName, ', style: const TextStyle(fontSize: 9,color: Colors.black)),
                Text('$tableName, ', style: const TextStyle(fontSize: 9,color: Colors.black)),
                Text(groupName, style: const TextStyle(fontSize: 9,color: Colors.black))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(empName, style: const TextStyle(fontSize: 9,color: Colors.black)),
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
                            items[index].itemName,
                            style: TextStyle(fontSize: textSize,color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            items[index].unitName ?? '',
                            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w400,color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            items[index].quantity.toString(),
                            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w400,color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            items[index].remark ?? '',
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