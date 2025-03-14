
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/add_item_bloc.dart';
import 'package:rpro_mini/bloc/auth_provider.dart';
import 'package:rpro_mini/ui/components/flying_animation.dart';
import 'package:rpro_mini/ui/pages/cart_page.dart';
import 'package:rpro_mini/ui/themes/colors.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final GlobalKey cartKey = GlobalKey();
  List<GlobalKey> _itemKeys = [];

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  void _animateToCart(BuildContext context, GlobalKey itemKey) {
    final OverlayState overlayState = Overlay.of(context);
    final RenderBox itemBox = itemKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox cartBox = cartKey.currentContext!.findRenderObject() as RenderBox;

    final Offset itemPosition = itemBox.localToGlobal(Offset.zero);
    final Offset cartPosition = cartBox.localToGlobal(Offset.zero);

    late OverlayEntry overlayEntry;

    // Create an OverlayEntry
    overlayEntry = OverlayEntry(
      builder: (context) {
        return FlyingItemAnimation(
          image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLRS75kXFbSnhLpwOzucGTZnBsr7XZxAZ-OQ&s',
          startPosition: itemPosition,
          endPosition: cartPosition,
          onComplete: () {
            overlayEntry.remove(); // Remove animation when done
          },
        );
      },
    );

    overlayState.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddItemBloc(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Food Items",style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: AppColors.colorPrimary,
          leading: IconButton(
              onPressed: _onBackPressed,
              icon: const Icon(Icons.arrow_back_ios,color: Colors.white)
          ),
          actions: [
            IconButton(
                key: cartKey,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
                },
                icon: const Icon(Icons.shopping_cart,color: Colors.white,))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // 🔹 Horizontal List
              Selector<AddItemBloc,(List<String>,String)>(
                selector: (context,bloc) => (bloc.categories,bloc.selectedCategory),
                builder: (context,data,_){
                  var bloc = context.read<AddItemBloc>();
                  return Container(
                    height: 100,
                    alignment: Alignment.bottomCenter,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 4),
                      itemCount: data.$1.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            bloc.selectedCategory = data.$1[index];
                            bloc.onTapCategory(data.$1[index]);
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Image Container
                              Container(
                                margin: const EdgeInsets.all(6),
                                height: 100,
                                // decoration: BoxDecoration(
                                //   border: data.$1[index] == data.$2
                                //       ? Border.all(width: 3,color: AppColors.colorPrimary50)
                                //       : Border.all(width: 0),
                                //   borderRadius: BorderRadius.circular(18),
                                // ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSk1XUzPI3MBwANtXUkr3RohaUIg4f0sWET9g&s',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()), // Loading
                                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red), // Error
                                  ),
                                ),
                              ),
                              /// Gradient Effect for Better Text Visibility
                              Positioned(
                                bottom: 0, // Positions at the bottom
                                left: 0,
                                right: 0,
                                child: Container(
                                  margin: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                    color: data.$1[index] == data.$2
                                        ? Colors.white.withOpacity(0.3)
                                        : Colors.black.withOpacity(0.5),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    data.$1[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white, // White text for contrast
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Choose Items',style: TextStyle(color: AppColors.colorPrimary,fontFamily: 'Ubuntu',fontWeight: FontWeight.w600,fontSize: 16)),
                  ),
                  Selector<AuthProvider,String>(
                    selector: (context,authBloc) => authBloc.layout,
                    builder: (context,layout,_){
                      return IconButton(
                        icon: Icon(layout == 'list'
                            ? Icons.list
                            : Icons.grid_view,color: Colors.black38),
                        onPressed: () {
                          var bloc = context.read<AuthProvider>();
                          bloc.toggleLayout();
                        },
                      );
                    },
                  ),
                ],
              ),
              // 🔹 Grid View
              Selector<AuthProvider,String>(
                selector: (context,bloc)=> bloc.layout,
                  builder: (context,layout,_){
                  return Selector<AddItemBloc,List<String>>(
                      selector: (context,itemBloc) => itemBloc.items,
                      builder: (context,itemList,_){
                        _itemKeys = List.generate(itemList.length, (index) => GlobalKey());
                        if(layout == 'grid'){
                          return Expanded(
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: itemList.length,
                              itemBuilder: (context, index) {
                                return Expanded(
                                  child: InkWell(
                                    key: _itemKeys[index],
                                    onTap: (){
                                      _animateToCart(context, _itemKeys[index]);
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingPage()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black38,width: 0.6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // 🖼 CachedNetworkImage Implementation
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: 'http://rproplus.asiabrightway.com/storage/Images/6731845646151_tiger.jpg',
                                                width: double.infinity,
                                                fit: BoxFit.cover, // Fill the space while maintaining aspect ratio
                                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                                              ),
                                            ),
                                          ),
                                          /// 📌 Title
                                          const Padding(
                                            padding: EdgeInsets.only(left: 8.0,top: 4),
                                            child: Text(
                                              'Carlsberg',
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.center, // Center title
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              '2400 MMK',
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),
                                              textAlign: TextAlign.center, // Center title
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              'Store Qty: 23',
                                              style: TextStyle(
                                                  fontFamily:'Ubuntu',fontSize: 14,fontWeight: FontWeight.w400,color: AppColors.stockQtyColor),
                                              textAlign: TextAlign.center, // Center title
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        else{
                          return Expanded(
                            child: SizedBox(
                                child: _buildListView(itemList)
                            ),
                          );
                        }
                      },
                  );

                  },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List<String> itemList) {
    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        return Card(
          key: _itemKeys[index],
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                width: 40,
                height: 40,
                imageUrl: 'http://rproplus.asiabrightway.com/storage/Images/6731845646151_tiger.jpg',
                fit: BoxFit.cover, // Fill the space while maintaining aspect ratio
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()), // Placeholder
                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red), // Error handling
              ),
            ),
            title: const Text('Carlsberg'),
            subtitle: Text('2400 MMK',style: TextStyle(color: AppColors.colorPrimary,fontSize: 16),),
            trailing: TextButton(
              onPressed: () {
                _animateToCart(context, _itemKeys[index]);
              },
              child: const Text("Add"),
            ),
          ),
        );
      },
    );
  }
}
