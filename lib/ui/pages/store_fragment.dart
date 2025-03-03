import 'package:flutter/material.dart';
import 'package:rpro_mini/ui/pages/brands_page.dart';
import 'package:rpro_mini/ui/pages/category_page.dart';
import 'package:rpro_mini/ui/pages/color_page.dart';
import 'package:rpro_mini/ui/pages/products_page.dart';
import 'package:rpro_mini/ui/pages/sizes_page.dart';
import 'package:rpro_mini/ui/pages/sub_category_page.dart';

class StoreFragment extends StatelessWidget {
  const StoreFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        toolbarHeight: 1,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ///addresses and close
            Container(
              color: Theme.of(context).colorScheme.primary,
              width: MediaQuery.of(context).size.width * 1,
              height: 100,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Store Setup',
                    style: TextStyle(color: Colors.white,fontFamily: 'Agdasima',fontWeight: FontWeight.w700,fontSize: 28)),
                ],
              ),
            ),
            Container(
              height: 40,
              color: Theme.of(context).colorScheme.primary,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(32),topLeft: Radius.circular(32))
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMenuContainer(
                                context,
                                image: 'assets/icons/color_icon.png',
                                setUpName: 'Colors',
                                count: '18',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ColorPage()));
                                },
                              ),
                              _buildMenuContainer(
                                context,
                                image: 'assets/icons/size_icon.png',
                                setUpName: 'Sizes',
                                count: '23',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SizesPage()));
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMenuContainer(
                                context,
                                image: 'assets/icons/brands_icon.png',
                                setUpName: 'Brands',
                                count: '18',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BrandsPage()));
                                },
                              ),
                              _buildMenuContainer(
                                context,
                                image: 'assets/icons/category_icon.png',
                                setUpName: 'Categories',
                                count: '23',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryPage()));
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMenuContainer(
                                context,
                                image: 'assets/icons/sub_categories.png',
                                setUpName: 'Sub Categories',
                                count: '18',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SubCategoryPage()));
                                },
                              ),
                              _buildMenuContainer(
                                context,
                                image: 'assets/icons/category_icon.png',
                                setUpName: 'Products',
                                count: '23',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsPage()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuContainer(BuildContext context, {required String count,required String image,required String setUpName, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Container(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      setUpName,
                      style: const TextStyle(color: Colors.white)
                  ),
                  Image.asset(image,width: 20,height: 20,)
                ],
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              Text(
                count,
                style: const TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
