
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/request/color_request_vo.dart';
import 'package:rpro_mini/utils/color_utils.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
import '../../bloc/auth_provider.dart';
import '../../data/vos/color_vo.dart';
import '../components/color_card.dart';
import '../themes/colors.dart';

class ColorPage extends StatefulWidget {
  const ColorPage({super.key});

  @override
  State<ColorPage> createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
  List<ColorVo> colorList = [];
  String _token = '';
  String _refreshToken = '';
  final ShoppyAdminModel _model = ShoppyAdminModel();

  @override
  void initState() {
    super.initState();
    _initializeData();
    getColorList();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.accessToken;
    _refreshToken = authModel.refreshToken;
  }

  Future<void> _deleteColor(int index) async{

  }

  Future<void> _addColor(String name,String colorCode) async{
    ColorRequestVo requestVo = ColorRequestVo(name, colorCode);
    _model.addColor(_token,requestVo).then((value){
      showSuccessToast(context, value?.message ?? "");
      getColorList();
      Navigator.pop(context);
    }).catchError((onError){
      showScaffoldMessage(context, onError.toString());
    });
  }

  Future<void> _updateColorById(int id,ColorRequestVo request) async{
    _model.updateColor(_token,id, request).then((onValue){
      Navigator.pop(context);
      showSuccessToast(context, onValue?.message.toString() ?? "");
      getColorList();
    }).catchError((onError){
      showScaffoldMessage(context, onError.toString());
    });
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  Future<void> getColorList() async {
    try {
      final onValue = await _model.getColors(_token);
      if (mounted && colorList != onValue) {
        setState(() {
          colorList = onValue;
        });
      }
    } catch (error) {
      showToastMessage(context, error.toString());
    }
  }

  void _editColorSheet(int index,ColorVo? colorRequest) {
    _showColorBottomSheet(context,false,colorRequest);
  }

  void _showColorBottomSheet(BuildContext context,bool isAdd,ColorVo? color) {
    TextEditingController nameController = TextEditingController();
    TextEditingController codeController = TextEditingController();

    Color selectedColor = Colors.grey;
    if(color != null) {
      selectedColor = parseColor(color.colorCode);
    }
    nameController.text = color?.colorName ?? ""; // Replace with actual color name
    codeController.text = color?.colorCode ?? "";

    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      expand: false, // Start with a small height
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false, // Start with a small height
          initialChildSize: 0.7, // Initial height (70% of screen)
          maxChildSize: 0.83, // Maximum height (90% of screen)
          minChildSize: 0.3, // Minimum height (30% of screen)
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context,setState){
                return  Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text( isAdd ? 'Add Color' : 'Edit Color',
                          style: TextStyle(color: AppColors.colorPrimary,fontFamily: 'Agdasima',fontSize: 28,fontWeight: FontWeight.w700)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Color Name',
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface,fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Red',
                                hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Color Code',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: codeController,
                                    decoration: InputDecoration(
                                      hintText: '#eeffff',
                                      hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      suffixIcon: selectedColor == Colors.grey
                                          ? const SizedBox()
                                          : Container(
                                              width: 32,
                                              height: 32,
                                              margin: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: selectedColor,
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(color: Colors.black26),
                                              ),
                                            ),
                                     ),
                                     onChanged: (value){
                                       setState(() {
                                         selectedColor = parseColor(value);
                                       });
                                     },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isAdd
                                    ?
                                ElevatedButton.icon(
                                    onPressed: () {
                                      _addColor(nameController.text,codeController.text);
                                    },
                                    icon: const Icon(Icons.add, color: Colors.white, size: 14,),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.colorPrimary,
                                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    label: const Text('Add', style: TextStyle(color: Colors.white),)
                                )
                                    :
                                ElevatedButton.icon(
                                    onPressed: () {
                                      ColorRequestVo colorRequest = ColorRequestVo(nameController.text, codeController.text);
                                      _updateColorById(color?.colorId ?? 0,colorRequest);
                                    },
                                    icon: const Icon(Icons.edit, color: Colors.white, size: 14),
                                    style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.colorPrimary,
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                    label: const Text('Update', style: TextStyle(color: Colors.white),)
                                ),
                                const SizedBox(width: 30,),
                                ElevatedButton(onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.colorPrimary,
                                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Cancel',style: TextStyle(color: Colors.white),))
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Colors',style: TextStyle(fontFamily: 'Agdasima',fontSize: 28,color: Colors.white,fontWeight: FontWeight.w700),),
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white
          ),
          onPressed: _onBackPressed,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: 20,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 18,right: 18),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(36),topRight: Radius.circular(36))
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 24),
                    itemCount: colorList.length,
                    itemBuilder: (context, index){
                      return ColorCard(
                        color: colorList[index],
                        onEdit: () => _editColorSheet(index,colorList[index]),
                        onDelete:() => _deleteColor(index),
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 56.0, // Custom width
        height: 56.0, // Custom height
        child: FloatingActionButton(
          onPressed: () {
            _showColorBottomSheet(context, true,null);
          },
          backgroundColor: Colors.deepPurple,
          tooltip: 'Add',
          shape: const CircleBorder(),
          child: const Icon(Icons.add), // Explicitly set the shape to a circle
        ),
      ),
    );
  }
}



