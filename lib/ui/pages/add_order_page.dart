import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/add_order_bloc.dart';
import 'package:rpro_mini/bloc/auth_provider.dart';
import 'package:rpro_mini/data/vos/category_vo.dart';
import 'package:rpro_mini/data/vos/item_vo.dart';
import 'package:rpro_mini/ui/components/cached_category_image.dart';
import 'package:rpro_mini/ui/components/flying_animation.dart';
import 'package:badges/badges.dart' as badges;
import 'package:rpro_mini/ui/pages/cart_page.dart';
import 'package:rpro_mini/ui/themes/colors.dart';

class AddOrderPage extends StatefulWidget {
  final String? tableName;
  final String floorName;
  final int tableId;
  const AddOrderPage({super.key, this.tableName, required this.tableId, required this.floorName});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _searchController = TextEditingController();
  bool isSearching = false;
  final GlobalKey cartKey = GlobalKey();
  String baseUrl = "";
  List<GlobalKey> _itemKeys = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    baseUrl = authModel.url;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authModel = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      baseUrl = authModel.url;
    });
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _animateToCart(BuildContext context, GlobalKey itemKey,AddOrderBloc bloc,int itemId,String imageUrl) {
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
          image: '$baseUrl/storage/Images/$imageUrl',
          startPosition: itemPosition,
          endPosition: cartPosition,
          onComplete: () {
            overlayEntry.remove(); // Remove animation when done
            bloc.addOrUpdateOrderItem(itemId);
          },
        );
      },
    );

    overlayState.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = screenWidth > 600 ? 3 : 2; // Tablet (3), Phone (2)
    return ChangeNotifierProvider(
      create: (context) => AddOrderBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.tableName ?? "",style: const TextStyle(color: Colors.white)),
          backgroundColor: AppColors.colorPrimary,
          centerTitle: true,
          leading: IconButton(
              onPressed: _onBackPressed,
              icon: const Icon(Icons.arrow_back_ios,color: Colors.white)
          ),
          actions: [
            Selector<AddOrderBloc, int>(
              selector: (_, bloc) => bloc.selectedGroup,
              builder: (context, selectedGroup, _) {
                final bloc = context.read<AddOrderBloc>();
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
            Selector<AddOrderBloc,bool>(
              selector: (context,bloc) => bloc.isAdd,
              builder: (context,isAdd,_){
                var bloc = context.read<AddOrderBloc>();
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CartPage(
                                  newOrderItems: bloc.orderDetails,
                                  group:bloc.selectedGroup,
                                  tableId: widget.tableId,
                                  tableName: widget.tableName ?? '',
                                  floorName: widget.floorName,
                                )
                        )
                    );
                  },
                  child: Padding(
                    key: cartKey,
                    padding: const EdgeInsets.only(right: 12),
                    child: badges.Badge(
                      showBadge: isAdd,
                      badgeContent: const Text(
                        '!',
                        style: TextStyle(color: Colors.white),
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.red,
                      ),
                      child: const Icon(Icons.shopping_cart),
                    ),
                  ),
                );
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            children: [
              const SizedBox(height: 8),
              ///🔹 Horizontal List
              Selector<AddOrderBloc,bool>(
                  selector: (context,bloc) => bloc.isSearching,
                  builder: (context,isSearching,_){
                    var bloc = context.read<AddOrderBloc>();

                    return Column(
                      children: [
                        (isSearching)
                            ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                          child: Row(
                            children: [
                              /// Search TextField
                              Expanded(
                                child: TextField(
                                  autofocus: true,
                                  onChanged: (value){
                                    bloc.queryStreamController.sink.add(value);
                                  },
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search Items...',
                                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.surfaceBright),
                                    prefixIcon: Icon(Icons.search,color: Theme.of(context).colorScheme.secondary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              /// Close Search Button
                              IconButton(
                                icon: Icon(Icons.close, color: Theme.of(context).colorScheme.secondary),
                                onPressed: () {
                                  bloc.isSearching = !isSearching;
                                },
                              ),
                            ],
                          ),
                        )
                            : Selector<AddOrderBloc,(List<CategoryVo>,String)>(
                          selector: (context,bloc) => (bloc.categories,bloc.selectedCategory),
                          builder: (context,data,_){
                            var bloc = context.read<AddOrderBloc>();
                            return Container(
                              height: 100,
                              alignment: Alignment.bottomCenter,
                              child: ListView.builder(
                                key: const PageStorageKey('category_list'),
                                scrollDirection: Axis.horizontal,
                                itemExtent: 110,
                                addAutomaticKeepAlives: true,
                                padding: const EdgeInsets.only(left: 4),
                                itemCount: data.$1.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: (){
                                      bloc.selectedCategory = data.$1[index].categoryName;
                                      bloc.onTapCategory(data.$1[index].categoryName);
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        // Image Container
                                        Container(
                                          margin: const EdgeInsets.all(6),
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: CachedCategoryImage(
                                                imageUrl: '$baseUrl/Storage/Images/${data.$1[index].categoryImage}'
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
                                              color: data.$1[index].categoryName == data.$2
                                                  ? Colors.white.withOpacity(0.8)
                                                  : Colors.black.withOpacity(0.5),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Text(
                                              data.$1[index].categoryName,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: data.$1[index].categoryName == data.$2 ? Colors.black87 :Colors.white, // White text for contrast
                                                fontWeight: data.$1[index].categoryName == data.$2 ? FontWeight.w700 : FontWeight.w400,
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

                        /// search and filter button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'Choose Items',
                                  style: TextStyle(color: Theme.of(context).colorScheme.tertiary,fontFamily: 'Ubuntu',fontWeight: FontWeight.w600,fontSize: 16)
                              ),
                            ),
                            Selector<AddOrderBloc,ItemState>(
                                selector: (context,bloc) => bloc.itemState,
                                builder: (context,itemState,_){
                                  if(itemState == ItemState.loading){
                                    return CupertinoActivityIndicator(color: AppColors.colorPrimary,);
                                  }else{
                                    return const SizedBox(width: 1);
                                  }
                                },
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary),
                                  onPressed: () {
                                    var bloc = context.read<AddOrderBloc>();
                                    bloc.isSearching = !bloc.isSearching;
                                  },
                                ),
                                Selector<AuthProvider,String>(
                                  selector: (context,authBloc) => authBloc.layout,
                                  builder: (context,layout,_){
                                    return IconButton(
                                      icon: Icon(layout == 'list'
                                          ? Icons.list
                                          : Icons.grid_view,color: Theme.of(context).colorScheme.secondary),
                                      onPressed: () {
                                        var bloc = context.read<AuthProvider>();
                                        bloc.toggleLayout();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    );
                  },
              ),
              // 🔹 Grid View
              Selector<AuthProvider,String>(
                selector: (context,bloc)=> bloc.layout,
                  builder: (context,layout,_){
                  var bloc = context.read<AddOrderBloc>();
                  return Selector<AddOrderBloc,List<ItemVo>>(
                      selector: (context,itemBloc) => itemBloc.items,
                      builder: (context,itemList,_){
                        _itemKeys = List.generate(itemList.length, (index) => GlobalKey());
                        if(layout == 'grid'){
                          return Expanded(
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: itemList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  key: _itemKeys[index],
                                  onTap: (){
                                    _animateToCart(context, _itemKeys[index],bloc,itemList[index].itemId,itemList[index].image ?? '');
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingPage()));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primaryContainer,
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
                                              imageUrl: '$baseUrl/storage/Images/${itemList[index].image}',
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) =>
                                                  Expanded(
                                                      child: Image.asset('assets/placeholder_image.jpg',fit: BoxFit.cover,)
                                                  ),
                                            ),
                                          ),
                                        ),
                                        /// 📌 Title
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0,top: 8),
                                          child: Text(
                                            itemList[index].itemName ?? '',
                                            style: const TextStyle(fontSize: 14),
                                            textAlign: TextAlign.center, // Center title
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8,right: 4,bottom: 4),
                                          child: Text(
                                            itemList[index].itemPrice ?? '',
                                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700),
                                            textAlign: TextAlign.center, // Center title
                                          ),
                                        ),
                                      ],
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
                                child: _buildListView(itemList,bloc)
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

  Widget _buildListView(List<ItemVo> itemList,AddOrderBloc bloc) {
    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        return Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          key: _itemKeys[index],
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                width: 40,
                height: 40,
                imageUrl: '$baseUrl/storage/Images/${itemList[index].image}',
                fit: BoxFit.cover, // Fill the space while maintaining aspect ratio
                errorWidget: (context, url, error) => const Icon(Icons.image, color: Colors.grey), // Error handling
              ),
            ),
            title: Text(itemList[index].itemName ?? ''),
            subtitle: Text(
                itemList[index].itemPrice ?? '0',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary,fontSize: 16)
            ),
            trailing: TextButton(
              onPressed: () {
                _animateToCart(context, _itemKeys[index],bloc,itemList[index].itemId,itemList[index].image ?? '');
              },
              child: Text("Add",style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            ),
          ),
        );
      },
    );
  }
}