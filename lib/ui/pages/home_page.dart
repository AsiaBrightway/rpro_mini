import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/home_bloc.dart';
import 'package:rpro_mini/data/vos/table_vo.dart';
import 'package:rpro_mini/ui/components/user_drawer.dart';
import 'package:rpro_mini/ui/pages/add_order_page.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import '../../bloc/auth_provider.dart';

class HomePage extends StatefulWidget {
  final List<String> floors;
  const HomePage({super.key, required this.floors});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.floors.length, vsync: this);
    _initializeData();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    authModel.loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight,
          title: const Text('R Pro',style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the drawer icon color
          ),
          backgroundColor: AppColors.colorPrimary,
          centerTitle: true,

        ),
        drawer: const UserDrawer(),
        body: Selector<HomeBloc,List<String>>(
          selector: (context,bloc) => bloc.floors,
          builder: (context,floors,_){
            if(floors.isNotEmpty){
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true, // Keep this for many tabs
                      labelColor: Colors.white, // Text color when selected
                      unselectedLabelColor: Colors.grey[800], // Text color when unselected
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      indicator: BoxDecoration( // Custom box indicator
                        color: AppColors.colorPrimary, // Background color for selected tab
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                      indicatorPadding: const EdgeInsets.symmetric(vertical: 13), // Padding around the box
                      labelPadding: const EdgeInsets.only(right: 16,top: 8,bottom: 8), // Padding inside the tab
                      tabs: floors.map((floor) {
                        return Tab(
                          child: Container(
                            margin: const EdgeInsets.only(right: 8,left: 8),
                            padding: const EdgeInsets.symmetric(vertical: 6), // Inner padding for text
                            decoration: BoxDecoration(
                              // Unselected tab decoration (optional)
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              floor.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                      child: Selector<HomeBloc,List<TableVo>>(
                        selector: (context,bloc) => bloc.tables,
                        builder: (context,tables,_){
                          if(tables.isNotEmpty){
                            return TabBarView(
                              controller: _tabController,
                              children: floors.map((floor) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                    padding: const EdgeInsets.only(top: 30),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 1.1,
                                    ),
                                    itemCount: tables.length,
                                    itemBuilder: (context, index) {
                                      return TableCard(table: tables[index]);
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          }
                          else{
                            return const Center(child: Text('Empty Table',style: TextStyle(fontSize: 16),));
                          }
                        },
                      ))
                ],
              );
            }else{
              return const Center(child: Text('Empty Table'));
            }
          },
        ),

      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}

class TableCard extends StatelessWidget {
  final TableVo table;

  const TableCard({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddOrderPage()));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              table.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

