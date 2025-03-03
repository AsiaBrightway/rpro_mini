import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rpro_mini/data/vos/sub_category_vo.dart';

class SubCategoryCard extends StatefulWidget {

  final SubCategoryVo subCategory;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const SubCategoryCard({super.key, required this.onEdit, required this.onDelete, required this.subCategory,});

  @override
  State<SubCategoryCard> createState() => _SubCategoryCardState();
}

class _SubCategoryCardState extends State<SubCategoryCard> with SingleTickerProviderStateMixin{
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
      borderRadius: BorderRadius.circular(18),
      child: Container(
          height: 92,
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
              height: 92,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: widget.subCategory.getImageWithBaseUrl(),
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) {
                          return Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                  child: Text("Add Image", style: TextStyle(fontFamily: 'DMSans',fontSize: 8)))
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,bottom: 4),
                                child: Text(widget.subCategory.category?.categoryName ?? '',style: const TextStyle(color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(widget.subCategory.subCategoryName,style: const TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          GestureDetector(
                              onTap: (){
                                widget.onEdit();
                              },
                              child: Image.asset('assets/icons/edit_pencil.png',width: 16,height: 16,)
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          )
      ),
    );
  }
}