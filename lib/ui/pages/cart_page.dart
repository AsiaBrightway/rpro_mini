
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/cart_bloc.dart';
import 'package:rpro_mini/data/vos/order_details_vo.dart';
import 'package:rpro_mini/network/responses/order_details_response.dart';
import 'package:rpro_mini/ui/components/item_cart.dart';
import 'package:rpro_mini/ui/pages/setting_page.dart';
import 'package:rpro_mini/ui/themes/colors.dart';

import '../../bloc/add_order_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  void _onBackPressed(){
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: AppBar(
          backgroundColor: AppColors.colorPrimary,
          centerTitle: true,
          leading: IconButton(
            onPressed: _onBackPressed,
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
          ),
          title: const Text('Table( T003 )',style: TextStyle(color: Colors.white,fontFamily: 'Ubuntu',letterSpacing: 0.8),),
        ),
        body: Selector<CartBloc,ItemState>(
          selector: (context,bloc) => bloc.itemState,
          builder: (context,itemState,_){
            var bloc = context.read<CartBloc>();
            if(itemState == ItemState.loading){
              return Center(child: CupertinoActivityIndicator(color: AppColors.colorPrimary,radius: 30));
            }if(itemState == ItemState.error){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(bloc.errorMessage),
                  ),
                  IconButton(
                      onPressed: (){
                        bloc.getOrderDetails();
                      },
                      icon: Icon(Icons.refresh,color: AppColors.colorPrimary,size: 30,))
                ],
              );
            }
            else if(itemState == ItemState.success){
              List<OrderDetailsVo> orderDetails = bloc.orderDetailsList;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: orderDetails.length,
                        padding: const EdgeInsets.only(top: 8),
                        itemBuilder: (context,index){
                          return ItemCart(orderDetails: orderDetails[index]);
                        }),
                  ),
                  Container(
                    color: Colors.white,
                    child: Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      padding: const EdgeInsets.only(right: 32,left: 32,top: 8,bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.87,
                            decoration: BoxDecoration(
                                color: AppColors.colorPrimary,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextButton(
                                onPressed:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingPage()));
                                },
                                child: const Text('Place Order',style: TextStyle(color: Colors.white),)),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
