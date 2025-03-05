import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/add_item_bloc.dart';
import 'package:rpro_mini/ui/themes/colors.dart';// Your AuthProvider class

class AddOrderPage extends StatefulWidget {

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddItemBloc() ,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Food Items",style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: AppColors.colorPrimary,
          leading: IconButton(
              onPressed: _onBackPressed,
              icon: const Icon(Icons.arrow_back_ios,color: Colors.white)
          ),
          actions: [
            IconButton(
                onPressed: (){

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
              Container(
                height: 100,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 4),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(17)
                      ),
                      margin: const EdgeInsets.only(right: 6),
                      child: Column(
                        children: [
                          // 🖼 CachedNetworkImage
                          SizedBox(
                            height: 65,  // Specify height for the image
                            width: 90,  // Specify width for the image
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(16),topLeft: Radius.circular(16)),
                              child: CachedNetworkImage(
                                imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSk1XUzPI3MBwANtXUkr3RohaUIg4f0sWET9g&s',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()), // Loading
                                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red), // Error
                              ),
                            ),
                          ),
                          // 📌 Title
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text('Beer', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Choose Items',style: TextStyle(color: AppColors.colorPrimary,fontFamily: 'Ubuntu',fontWeight: FontWeight.w600,fontSize: 16),),
                  ),
                ],
              ),
              // 🔹 Grid View
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38,width: 0.6),
                          borderRadius: BorderRadius.circular(10), // Rounded corners for the whole container
                          color: Colors.white, // Background color for items
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🖼 CachedNetworkImage Implementation
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: 'http://rproplus.asiabrightway.com/storage/Images/6731845646151_tiger.jpg',
                                height: 110, // Fixed height for better layout control
                                width: double.infinity, // Take up the full width of the container
                                fit: BoxFit.cover, // Fill the space while maintaining aspect ratio
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()), // Placeholder
                                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red), // Error handling
                              ),
                            ),
                            // 📌 Title
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
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
