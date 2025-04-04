
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/cart_bloc.dart';
import 'package:rpro_mini/data/vos/order_details_vo.dart';
import 'package:rpro_mini/ui/components/item_cart.dart';
import 'package:rpro_mini/ui/pages/setting_page.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
import '../../bloc/add_order_bloc.dart';
import '../../bloc/auth_provider.dart';

class CartPage extends StatefulWidget {
  final List<OrderDetailsVo>? newOrderItems;
  final String tableName;
  final String floorName;
  final int group;
  final int tableId;
  const CartPage({super.key, this.newOrderItems, required this.group, required this.tableId, required this.tableName, required this.floorName});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String baseUrl = "";
  String empName = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    baseUrl = authModel.url;
    empName = authModel.empName;
  }

  void _onBackPressed(){
    Navigator.of(context).pop();
  }

  Future<void> onPressDelete(OrderDetailsVo item,CartBloc bloc) async{
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to remove ${item.itemName}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      if(mounted) {
        bloc.removeItem(item,context,(){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SettingPage(
                          orderItems: [item],
                          tableName: widget.tableName,
                          floorName: widget.floorName,
                          groupName: widget.group.toString(),
                          isCancel: true,)
              )
          );
        });
      }
    }
  }

  void onPressText(OrderDetailsVo item,CartBloc bloc) {
    final controller = TextEditingController(text: item.quantity.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text(item.itemName),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: "Quantity",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newQty = int.tryParse(controller.text) ?? item.quantity;
              if (newQty > 0) {
                bloc.updateQuantity(item.itemId, newQty);
              }
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void onPressRemarkButton(OrderDetailsVo item,CartBloc bloc){
    final controller = TextEditingController(text: item.remark.toString());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Remark'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter your remark...',
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.surfaceBright),
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newQty = controller.text;
                bloc.updateRemark(item.itemId, newQty);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartBloc(widget.newOrderItems ?? [],widget.group,widget.tableId),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: AppBar(
          backgroundColor: AppColors.colorPrimary,
          centerTitle: true,
          leading: IconButton(
            onPressed: _onBackPressed,
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
          ),
          title: Text('Table( ${widget.tableName} )',style: const TextStyle(color: Colors.white,fontFamily: 'Ubuntu',letterSpacing: 0.8),),
          actions: [
            if(widget.newOrderItems?.isEmpty == true)
              Selector<CartBloc, int>(
                selector: (_, bloc) => bloc.selectedGroup,
                builder: (context, selectedGroup, _) {
                  final bloc = context.read<CartBloc>();
                  return DropdownButton<int>(
                    value: selectedGroup,
                    padding: const EdgeInsets.only(right: 8),
                    style: const TextStyle(color: Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    elevation: 8,
                    dropdownColor: Colors.purple.shade300,
                    items: [
                      ...bloc.availableGroups.map((tableNum) {
                        return DropdownMenuItem(
                          value: tableNum,
                          child: Text("G - $tableNum"),

                        );
                      }),
                    ],
                    onChanged:(value){
                      if (value != selectedGroup) {  // ← Only trigger if value changed
                        bloc.changeGroup(value!);
                      }
                    },
                  );
                },
              ),
            if(widget.newOrderItems?.isEmpty == false)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text('G - ${widget.group}',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
              )
          ],
        ),
        body: Selector<CartBloc,ItemState>(
          selector: (context,bloc) => bloc.itemState,
          builder: (context,itemState,_){
            var bloc = context.read<CartBloc>();
            if(itemState == ItemState.loading){
              return Center(child: CupertinoActivityIndicator(color: Theme.of(context).colorScheme.primary,radius: 25));
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
                  return Selector<CartBloc,List<OrderDetailsVo>>(
                    selector: (context,bloc) => bloc.combinedOrderItems,
                    builder: (context,combinedItems,_){
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: bloc.combinedOrderItems.length,
                                padding: const EdgeInsets.only(top: 8),
                                itemBuilder: (context,index){
                                  return Selector<CartBloc,OrderDetailsVo>(
                                    selector: (context,bloc) => bloc.combinedOrderItems[index],
                                    shouldRebuild: (prev, next) => prev.quantity != next.quantity,
                                    builder: (context,item,_){
                                      return ItemCart(
                                        orderDetails: bloc.combinedOrderItems[index],
                                        onPressDelete: (OrderDetailsVo item){
                                          onPressDelete(item,bloc);
                                        },
                                        onPressRemark: (OrderDetailsVo item){
                                          onPressRemarkButton(item,bloc);
                                        },
                                        baseUrl: baseUrl,
                                        onPressText: (OrderDetailsVo item){
                                          onPressText(item,bloc);
                                        },
                                      );
                                    },
                                  );
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
                                          if(bloc.newOrderItems.isEmpty){
                                            Fluttertoast.showToast(
                                                msg: 'Empty Item',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.blueGrey.shade800,
                                                textColor: Colors.white
                                            );
                                           return;
                                          }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SettingPage(
                                                        orderItems: bloc.newOrderItems,
                                                        tableName: widget.tableName,
                                                        floorName: widget.floorName,
                                                        groupName: widget.group.toString(),
                                                        isCancel: false,)
                                              )
                                          );
                                        },
                                        child: const Text('Place Order',style: TextStyle(color: Colors.white),)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
