
import 'package:flutter/material.dart';
import 'package:rpro_mini/ui/components/item_cart.dart';
import 'package:rpro_mini/ui/pages/setting_page.dart';
import 'package:rpro_mini/ui/themes/colors.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorPrimary,
        centerTitle: true,
        leading: IconButton(
          onPressed: _onBackPressed,
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        title: const Text('Table( T003 )',style: TextStyle(color: Colors.white,fontFamily: 'Ubuntu',letterSpacing: 0.8),),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 4,
                padding: EdgeInsets.only(top: 8),
                itemBuilder: (context,index){
                  return ItemCart(index: index);
                }),
          ),
          Container(
            color: Colors.white,
            child: Container(
              color: const Color.fromRGBO(217, 217, 217, 0.4),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
                        },
                        child: Text('Place Order',style: TextStyle(color: Colors.white),)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
