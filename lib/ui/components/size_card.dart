import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rpro_mini/data/vos/size_vo.dart';

class SizeCard extends StatefulWidget {

  final SizeVo sizeVo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const SizeCard({super.key, required this.onEdit, required this.onDelete, required this.sizeVo});

  @override
  State<SizeCard> createState() => _SizeCardState();
}

class _SizeCardState extends State<SizeCard> with SingleTickerProviderStateMixin{
  late final SlidableController controller;


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
      borderRadius: BorderRadius.circular(12),
      child: Container(
          height: 54,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary
          ),
          child: Slidable(
            controller: controller,
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
            child: Container(
              height: 54,
              padding: const EdgeInsets.only(left: 50,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Size: ${widget.sizeVo.sizeName}',style: const TextStyle(color: Colors.white)),
                  IconButton(
                      onPressed:(){
                        widget.onEdit();
                      },
                      icon: const Icon(Icons.edit_outlined,color: Colors.white,))
                ],
              ),
            ),
          )
      ),
    );
  }
}