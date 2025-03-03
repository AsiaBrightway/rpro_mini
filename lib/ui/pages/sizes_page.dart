import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/data/models/shoppy_admin_model.dart';
import 'package:rpro_mini/data/vos/request/size_request.dart';
import 'package:rpro_mini/data/vos/size_vo.dart';
import 'package:rpro_mini/ui/components/size_card.dart';
import 'package:rpro_mini/utils/helper_functions.dart';
import '../../bloc/auth_provider.dart';
import '../themes/colors.dart';

class SizesPage extends StatefulWidget {
  const SizesPage({super.key});
  @override
  State<SizesPage> createState() => _SizesPageState();
}

class _SizesPageState extends State<SizesPage> {
  String _token = '';
  String _refreshToken = '';
  List<SizeVo> sizeList = [];
  final ShoppyAdminModel _model = ShoppyAdminModel();

  @override
  void initState() {
    super.initState();
    _initializeData();
    getSizeList();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.accessToken;
    _refreshToken = authModel.refreshToken;
  }

  Future<void> getSizeList() async {
    try {
      final onValue = await _model.getSizes(_token);
      if (mounted && sizeList != onValue) {
        setState(() {
          sizeList = onValue;
        });
      }
    } catch (error) {
      showToastMessage(context, error.toString());
    }
  }

  Future<void> updateSizeById(int id,SizeRequest request) async{
    _model.updateSizeById(_token, id, request).then((onValue){
      showSuccessToast(context, onValue?.message.toString() ?? "success");
      getSizeList();
      Navigator.pop(context);
    }).catchError((onError){
      showScaffoldMessage(context, onError.toString());
    });
  }

  Future<void> addSizeToServer(String sizeName) async {
    SizeRequest request = SizeRequest(size: sizeName);
    _model.addSize(_token, request).then((onValue){
      showSuccessToast(context, onValue?.message.toString() ?? "success");
      getSizeList();
      Navigator.pop(context);
    }).catchError((onError){
      showScaffoldMessage(context, onError.toString());
    });
  }

  void _deleteSize() {
    setState(() {

    });
  }

  void _showEditSheet(int id,SizeVo? sizeVo) {
    _showSizeBottomSheet(context,false,sizeVo);
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  void _showSizeBottomSheet(BuildContext context,bool isAdd,SizeVo? size) {
    TextEditingController sizeController = TextEditingController();
    sizeController.text = size?.sizeName ?? "";

    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      expand: false, // Start with a small height
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false, // Start with a small height
          initialChildSize: 0.65, // Initial height (70% of screen)
          maxChildSize: 0.83, // Maximum height (90% of screen)
          minChildSize: 0.3, // Minimum height (30% of screen)
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(isAdd ? 'Add Size' : 'Update Size',
                      style: TextStyle(color: AppColors.colorPrimary,fontFamily: 'Agdasima',fontSize: 28,fontWeight: FontWeight.w700)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Size',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'Ubuntu'),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: sizeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'enter size',
                            hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isAdd
                          ? ElevatedButton.icon(
                              onPressed: (){
                                if (sizeController.text.isEmpty) {
                                  showToastMessage(context, 'Category name cannot be empty', isError: true);
                                  return;
                                }
                                  addSizeToServer(sizeController.text);
                                },
                              icon: const Icon(Icons.add,color: Colors.white,size: 14),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.colorPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            label: const Text('Add',style: TextStyle(color: Colors.white),))
                          : ElevatedButton.icon(
                              onPressed: (){
                                if (sizeController.text.isEmpty) {
                                  showToastMessage(context, 'Size cannot be empty', isError: true);
                                  return;
                                }
                                SizeRequest sizeRequest = SizeRequest(size: sizeController.text);
                                updateSizeById(size?.sizeId ?? 0, sizeRequest);
                              },
                              icon: const Icon(Icons.edit,color: Colors.white,size: 14),
                              style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.colorPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                              label: const Text('Update',style: TextStyle(color: Colors.white),)
                          ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                          onPressed: (){
                            Navigator.pop(context);
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
        title: const Text('Sizes',style: TextStyle(fontFamily: 'Agdasima',fontSize: 28,color: Colors.white,fontWeight: FontWeight.w700)),
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
                  padding: EdgeInsets.only(top: 24),
                    itemCount: sizeList.length,
                    itemBuilder: (context, index){
                      return SizeCard(
                        sizeVo: sizeList[index],
                        onEdit: () => _showEditSheet(index,sizeList[index]),
                        onDelete:() => _deleteSize(),
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 56.0,
        height: 56.0,
        child: FloatingActionButton(
          onPressed: () {
            _showSizeBottomSheet(context, true ,null);
          },
          backgroundColor: AppColors.colorPrimary,
          tooltip: 'Add',
          shape: const CircleBorder(),
          child: const Icon(Icons.add), // Explicitly set the shape to a circle
        ),
      ),
    );
  }
}

