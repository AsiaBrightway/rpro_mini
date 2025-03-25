import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/cart_bloc.dart';
import 'package:rpro_mini/data/vos/order_details_vo.dart';
import '../themes/colors.dart';

class ItemCart extends StatelessWidget {
  final String baseUrl;
  final OrderDetailsVo orderDetails;
  final Function(OrderDetailsVo) onPressDelete;
  final Function(OrderDetailsVo) onPressRemark;
  final Function(OrderDetailsVo) onPressText;
  const ItemCart({
    super.key, required this.orderDetails, required this.onPressDelete, required this.onPressRemark, required this.baseUrl, required this.onPressText
  });

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<CartBloc>();
    return Container(
        height: 120,
        margin: const EdgeInsets.only(top: 8,left: 8,right: 8),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: orderDetails.isOrdered == 1
              ? AppColors.colorPrimary
              : AppColors.colorSeeAll,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if(orderDetails.isOrdered == 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: // Replace the entire Column with quantity controls:
                    Selector<CartBloc, int>(
                      selector: (_, bloc) => bloc.combinedOrderItems
                          .firstWhere((item) => item.itemId == orderDetails.itemId && item.isOrdered == 0)
                          .quantity,
                      builder: (context, quantity, _) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => bloc.incrementQuantity(orderDetails.itemId),
                              child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () => onPressText(orderDetails),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  quantity.toString(),
                                  style: const TextStyle(color: Colors.white,fontFamily: 'Ubuntu',fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => bloc.decrementQuantity(orderDetails.itemId),
                              child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    width: 70,
                    height: 75,
                    imageUrl: '$baseUrl/storage/Images/${orderDetails.itemImage}',
                    fit: BoxFit.cover, // Fill the space while maintaining aspect ratio
                    errorWidget: (context, url, error) => const Icon(Icons.image, color: Colors.grey), // Error handling
                  ),
                ),
                // Title column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        orderDetails.itemName,
                        style: const TextStyle(
                          fontFamily: 'Ubuntu',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        orderDetails.isOrdered == 1
                            ? const SizedBox(width: 1)
                            : GestureDetector(
                          onTap: () => onPressRemark(orderDetails),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 4,top: 4),
                            child: Text(
                              '+remark',
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        if(orderDetails.isOrdered == 0)
                          SizedBox(
                          width: 100,
                          child: Selector<CartBloc,String?>(
                              selector: (context,bloc) => bloc.combinedOrderItems
                                  .firstWhere((item) => item.itemId == orderDetails.itemId && item.isOrdered == 0)
                                  .remark,
                            builder: (context,remark,_){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    remark ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Colors.grey
                                    ),
                                  ),
                                );
                            },),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 4),
                      child: Text(
                        orderDetails.itemPrice,
                        style: const TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Material(
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onPressDelete(orderDetails),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}