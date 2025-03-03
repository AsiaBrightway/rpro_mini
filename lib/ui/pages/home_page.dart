import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/ui/pages/box_fragment.dart';
import 'package:rpro_mini/ui/pages/profile_fragment.dart';
import 'package:rpro_mini/ui/pages/store_fragment.dart';
import '../../bloc/auth_provider.dart';
import '../themes/colors.dart';
import 'add_item_fragment.dart';
import 'home_fragment.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late int currentPage;
  late TabController tabController;

  /// List of fragments (pages)
  final List<Widget> _pages = [
    const HomeFragment(),
    const StoreFragment(),
    const AddItemFragment(),
    const BoxFragment(),
    const ProfileFragment(),
  ];

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 5, vsync: this);
    tabController.animation!.addListener(
          () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    authModel.loadToken();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color unselectedColor = Colors.black ;
    return Scaffold(
      body: BottomBar(
        fit: StackFit.expand,
        borderRadius: BorderRadius.circular(500),
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
        showIcon: true,
        barDecoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 30,
                  offset: Offset(0,10)
              )
            ]
        ),
        width: MediaQuery.of(context).size.width * 0.85,
        barColor: Colors.white70,
        start: 2,
        end: 0,
        offset: 10,
        barAlignment: Alignment.bottomCenter,
        reverse: false,
        hideOnScroll: true,
        scrollOpposite: false,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body: (context, controller) => TabBarView(
          controller: tabController,
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          children: _pages,
        ),
        child: TabBar(
          splashBorderRadius: BorderRadius.circular(42),
          controller: tabController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          tabs: [
            ///home nav item
            Material(
              type: MaterialType.transparency, // Makes the splash effect transparent
              child: InkWell(
                splashColor: Colors.transparent, // Disables the splash color
                highlightColor: Colors.transparent, // Disables the highlight effect
                borderRadius: BorderRadius.circular(36), // Matches your tab's border radius
                onTap: () {
                  tabController.animateTo(0);
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.092,
                  width: MediaQuery.of(context).size.width * 0.12,
                  decoration: BoxDecoration(
                    color: currentPage == 0 ? AppColors.colorNavBackground : Colors.transparent,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.home,
                      color: unselectedColor,
                    ),
                  ),
                ),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                splashColor: Colors.transparent, // Disables the splash color
                highlightColor: Colors.transparent, // Disables the highlight effect
                borderRadius: BorderRadius.circular(36), // Matches your tab's border radius
                onTap: () {
                  tabController.animateTo(1);
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.092,
                  width: MediaQuery.of(context).size.width * 0.12,
                  decoration: BoxDecoration(
                      color: currentPage == 1 ? AppColors.colorNavBackground : Colors.transparent,
                      borderRadius: BorderRadius.circular(36)
                  ),
                  child: Center(
                      child: Image.asset('assets/store_vector.png',width: 22,height: 22,color: Colors.black,)),
                ),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                splashColor: Colors.transparent, // Disables the splash color
                highlightColor: Colors.transparent, // Disables the highlight effect
                borderRadius: BorderRadius.circular(36), // Matches your tab's border radius
                onTap: () {
                  tabController.animateTo(2);
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.092,
                  width: MediaQuery.of(context).size.width * 0.12,
                  decoration: BoxDecoration(
                      color: currentPage == 2 ? AppColors.colorNavBackground : Colors.transparent,
                      borderRadius: BorderRadius.circular(36)
                  ),
                  child: Center(
                      child: Image.asset('assets/add_item.png',width: 20,height: 20,color: Colors.black,)
                  ),
                ),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                splashColor: Colors.transparent, // Disables the splash color
                highlightColor: Colors.transparent, // Disables the highlight effect
                borderRadius: BorderRadius.circular(36), // Matches your tab's border radius
                onTap: () {
                  tabController.animateTo(3);
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.092,
                  width: MediaQuery.of(context).size.width * 0.12,
                  decoration: BoxDecoration(
                      color: currentPage == 3 ? AppColors.colorNavBackground : Colors.transparent,
                      borderRadius: BorderRadius.circular(36)
                  ),
                  child: Center(
                      child: Image.asset('assets/box_vector.png',width: 20,height: 20,color: Colors.black,)
                  ),
                ),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                splashColor: Colors.transparent, // Disables the splash color
                highlightColor: Colors.transparent, // Disables the highlight effect
                borderRadius: BorderRadius.circular(36),
                onTap: () {
                  tabController.animateTo(4);
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.09,
                  width: MediaQuery.of(context).size.width * 0.12,
                  decoration: BoxDecoration(
                      color: currentPage == 4 ? AppColors.colorNavBackground : Colors.transparent,
                      borderRadius: BorderRadius.circular(36)
                  ),
                  child: const Center(
                      child: Icon(
                        Icons.person,
                        color: unselectedColor,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


