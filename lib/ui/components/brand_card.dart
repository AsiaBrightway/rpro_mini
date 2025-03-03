import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rpro_mini/data/vos/brand_vo.dart';

class BrandCard extends StatefulWidget {

  final BrandVo brand;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const BrandCard({super.key, required this.onEdit, required this.onDelete, required this.brand,});

  @override
  State<BrandCard> createState() => _BrandCardState();
}

class _BrandCardState extends State<BrandCard> with SingleTickerProviderStateMixin{
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
          height: 110,
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
              height: 110,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        //todo
                        imageUrl: widget.brand.getImageWithBaseUrl(),
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) {
                          return Container(
                              color: Colors.grey.shade300,
                              child: const Center(child: Text(
                                "Add Image", style: TextStyle(fontFamily: 'DMSans',fontSize: 8))));
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 14,right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.brand.brandName,style: const TextStyle(color: Colors.white)),
                              GestureDetector(
                                  onTap: (){
                                    widget.onEdit();
                                  },
                                  child: Image.asset('assets/icons/edit_pencil.png',width: 16,height: 16,))
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text.rich(
                          maxLines: 4,
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "Description: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: widget.brand.brandDescription,
                              style: const TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
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