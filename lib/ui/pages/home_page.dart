import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/home_bloc.dart';
import 'package:rpro_mini/data/vos/floor_vo.dart';
import 'package:rpro_mini/data/vos/table_vo.dart';
import 'package:rpro_mini/ui/components/user_drawer.dart';
import 'package:rpro_mini/ui/pages/add_order_page.dart';
import 'package:rpro_mini/ui/themes/colors.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the drawer icon color
          ),
          title: const Text('R Pro', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.colorPrimary,
          centerTitle: true,
        ),
        drawer: const UserDrawer(),
        body: Selector<HomeBloc,List<FloorVo>>(
            selector: (context,bloc) => bloc.floors,
            builder: (context,floors,_){
              var bloc = context.read<HomeBloc>();
              return  Column(
                children: [
                  Selector<HomeBloc,String?>(
                    selector: (context,bloc) => bloc.selectedFloor,
                    builder: (context,selectedFloor,_){
                      return Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: floors.length,
                          itemBuilder: (context, index) {
                            final floor = floors[index];
                            final isSelected = floor.floorName == selectedFloor;
                            return GestureDetector(
                              onTap: () {
                                bloc.selectedFloor = floors[index].floorName;
                                bloc.fetchTables(floors[index].floorId); // Update selected day in bloc
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.colorPrimary : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    floors[index].floorName  ,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Expanded(
                      child: Selector<HomeBloc, List<TableVo>>(
                        selector: (context, bloc) => bloc.tables,
                        builder: (context, tables, _) {
                          if (tables.isNotEmpty) {
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
                          } else {
                            return const Center(
                                child: Text('Empty Table', style: TextStyle(fontSize: 16)));
                          }
                    },
                  ))
                ],
              );
            }
        ),
      ),
    );
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
              table.tableName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

