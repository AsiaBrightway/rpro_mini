
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/product_vo.dart';
import 'package:rpro_mini/ui/components/product_card.dart';
import 'package:rpro_mini/ui/pages/add_product_page.dart';
import 'package:rpro_mini/utils/helper_functions.dart';

import '../../bloc/auth_provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _token = '';
  String _refreshToken = '';
  List<ProductVo> productList = [];
  final ShoppyAdminModel _model = ShoppyAdminModel();

  @override
  void initState() {
    super.initState();
    _initializeData();
    getProductLit();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.accessToken;
    _refreshToken = authModel.refreshToken;
  }

  Future<void> _deleteProduct(int index) async{

  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  Future<void> getProductLit() async {
    try {
      final onValue = await _model.getProducts(_token);
      if (mounted && productList != onValue) {
        setState(() {
          productList = onValue;
        });
      }
    } catch (error) {
      if(!mounted) return;
      showToastMessage(context, error.toString());
    }
  }

  void _editProductSheet(int index,ProductVo? product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductPage(isAdd: false, product: product)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Products',style: TextStyle(fontFamily: 'Agdasima',fontSize: 28,color: Colors.white,fontWeight: FontWeight.w700),),
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white
          ),
          onPressed: _onBackPressed,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: 20,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 18,right: 18),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(36),topRight: Radius.circular(36))
                ),
                child: ListView.builder(
                    padding: const EdgeInsets.only(top: 26,bottom: 60),
                    itemCount: productList.length,
                    itemBuilder: (context, index){
                      return ProductCard(
                        product: productList[index],
                        onEdit: () => _editProductSheet(index,productList[index]),
                        onDelete: () => _deleteProduct(index),
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 56.0, // Custom width
        height: 56.0, // Custom height
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductPage(isAdd: true,product: null)));
          },
          backgroundColor: Colors.deepPurple,
          tooltip: 'Add',
          shape: const CircleBorder(),
          child: const Icon(Icons.add), // Explicitly set the shape to a circle
        ),
      ),
    );
  }
}



