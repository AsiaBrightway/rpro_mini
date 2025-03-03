import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../data/vos/color_vo.dart';
import '../../utils/color_utils.dart';

class ColorCard extends StatefulWidget {

  final ColorVo color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const ColorCard({super.key, required this.onEdit, required this.onDelete, required this.color});

  @override
  State<ColorCard> createState() => _ColorCardState();
}

class _ColorCardState extends State<ColorCard> with SingleTickerProviderStateMixin{
  late final SlidableController controller;

  // void _handleOpen() {
  //   controller.openEndActionPane(duration: const Duration(seconds: 1));
  // }

  @override
  void initState() {
    super.initState();
    controller = SlidableController(this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
          height: 56,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary
          ),
          child: Slidable(
            controller: controller,
            startActionPane: ActionPane(
              extentRatio: 0.2,
              motion: const BehindMotion(),
              children: [
                // Customized delete button
                SlidableAction(
                  onPressed: (context) {
                    widget.onEdit();
                    controller.close();
                  },
                  backgroundColor: Colors.orange, // Orange background for delete button
                  foregroundColor: Colors.white, // White icon color
                  icon: Icons.edit,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12),bottomLeft: Radius.circular(12)), // Rounded corners for the button
                  autoClose: false,
                ),
              ],
            ),
            endActionPane: ActionPane(
              extentRatio: 0.2,
              motion: const BehindMotion(),
              children: [
                // Customized delete button
                SlidableAction(
                  onPressed: (context) {
                    widget.onDelete();
                    controller.close();
                  },
                  backgroundColor: Colors.red, // Red background for delete button
                  foregroundColor: Colors.white, // White icon color
                  icon: Icons.delete,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(12),bottomRight: Radius.circular(12)), // Rounded corners for the button
                  autoClose: false,
                ),
              ],
            ),
            child: SizedBox(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 40,right: 60),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: parseColor(widget.color.colorCode),
                        borderRadius: BorderRadius.circular(4)
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.color.colorName,style: const TextStyle(color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Text("#${widget.color.colorCode}",style: const TextStyle(color: Colors.white70,letterSpacing: 0.2)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}