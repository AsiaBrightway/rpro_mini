import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/data/vos/table_vo.dart';
import 'package:rpro_mini/ui/pages/add_order_page.dart';
import 'package:rpro_mini/ui/pages/setting_page.dart';
import 'package:rpro_mini/ui/themes/colors.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
import '../../bloc/auth_provider.dart';
import '../../data/models/shoppy_admin_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  final ShoppyAdminModel _model = ShoppyAdminModel();

  final List<TableVo> tables = [
    TableVo(1,"T003"),
    TableVo(2,"T001"),
    TableVo(3,"T005"),
    TableVo(4,"T007"),
    TableVo(5,"Table 5"),
    TableVo(6,"Table 6"),
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    authModel.loadToken();
    getSliders();
  }

  Future<void> getSliders() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    //String url = authModel.url;
    _model.getSliders('Bearer 45|0eLhFQLXwa2x1Z9LvQ4tXSwzL9yTSAuprmcubPoOc9948e0e').then((onValue){
      setState(() {
        showToastMessage(context,'slider success');
      });
    }).catchError((onError){
      showToastMessage(context,'Failed to load slider');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('R Pro',style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.colorPrimary,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          padding: const EdgeInsets.only(top: 30),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.1,
          ),
          itemCount: tables.length,
          itemBuilder: (context, index) {
            return TableCard(table: tables[index]);
          },
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrderPage()));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              table.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700,fontFamily: 'Ubuntu'),
            ),
          ],
        ),
      ),
    );
  }
}

