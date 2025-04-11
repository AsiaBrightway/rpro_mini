import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/bloc/home_bloc.dart';
import 'package:rpro_mini/data/vos/floor_vo.dart';
import 'package:rpro_mini/data/vos/table_vo.dart';
import 'package:rpro_mini/ui/components/user_drawer.dart';
import 'package:rpro_mini/ui/pages/add_order_page.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import 'package:upgrader/upgrader.dart';

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
      builder: (context,child){
        var bloc = context.read<HomeBloc>();
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          appBar: AppBar(
            toolbarHeight: 80,
            iconTheme: const IconThemeData(
              color: Colors.white, // drawer icon color
            ),
            title: const Text('R Pro', style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.colorPrimary,
            centerTitle: true,
          ),
          drawer: const UserDrawer(),
          body: UpgradeAlert(
            dialogStyle: UpgradeDialogStyle.cupertino,
            child: RefreshIndicator(
              onRefresh: () async {
                await bloc.fetchFloors(); // refresh method
              },
              child: Column(
                children: [
                  ///floors list
                  Selector<HomeBloc,List<FloorVo>>(
                      selector: (context,bloc) => bloc.floors,
                      builder: (context,floors,_){
                        return Selector<HomeBloc,String?>(
                          selector: (context,bloc) => bloc.selectedFloor,
                          builder: (context,selectedFloor,_){
                            var bloc = context.read<HomeBloc>();
                            return Container(
                              margin: const EdgeInsets.only(top: 12,left: 8,right: 8),
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
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.black,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                          floors[index].floorName,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                  ),
                  Selector<HomeBloc,TableState>(
                      selector: (context,bloc) => bloc.tableState,
                      builder: (context,tableState,_){
                        var bloc = context.read<HomeBloc>();
                        if(tableState == TableState.error){
                          return Center(child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text('Connection Error : ${bloc.tableErrorMessage}'),
                          ));
                        }
                        else if(tableState == TableState.success){
                          return Expanded(
                              child: Selector<HomeBloc, (List<TableVo>,List<int>)>(
                                selector: (context, bloc) => (bloc.tables,bloc.occupiedTables),
                                builder: (context, tables, _) {
                                  if (tables.$1.isNotEmpty) {
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
                                        itemCount: tables.$1.length,
                                        itemBuilder: (context, index) {
                                          return TableCard(table: tables.$1[index],occupiedTables: tables.$2,reservationTables: bloc.reservationTables);
                                        },
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                        child: Text('Empty Table', style: TextStyle(fontSize: 16))
                                    );
                                  }
                                },
                              )
                          );
                        }
                        else{
                          return Expanded(
                            child: Center(
                                child: CupertinoActivityIndicator(color: Theme.of(context).colorScheme.onSurface, radius: 14)
                            ),
                          );
                        }
                      }
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TableCard extends StatelessWidget {
  final TableVo table;
  final List<int>? reservationTables;
  final List<int>? occupiedTables;
  const TableCard({super.key, required this.table,this.occupiedTables, this.reservationTables});

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<HomeBloc>();
    bool isOccupied = occupiedTables?.contains(table.tableId) ?? false;
    bool isReservation = reservationTables?.contains(table.tableId) ?? false;
    return Card(
      color: (isOccupied)
          ? Colors.red
          : (isReservation)
              ? Colors.orange
              : Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddOrderPage(
                        tableName: table.tableName,
                        tableId: table.tableId,
                        floorName: bloc.selectedFloor.toString(),
                      )));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              table.tableName,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500,
                  color : (isOccupied)
                      ? Colors.white
                      : (isReservation)
                        ? Colors.white
                        : Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}