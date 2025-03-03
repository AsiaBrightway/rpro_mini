import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpro_mini/data/vos/size_vo.dart';
import '../../bloc/add_product_bloc.dart';

class SizeListDropdown extends StatefulWidget {
  final AddProductBloc bloc;
  const SizeListDropdown({super.key, required this.bloc});

  @override
  _SizeListDropdownState createState() => _SizeListDropdownState();
}

class _SizeListDropdownState extends State<SizeListDropdown> {

  void handleOptionSelected(String selectedOption) {
    widget.bloc.selectedSizeName = selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.bloc,
      child: GestureDetector(
        onTap: () {
          showSizeDialog(context, handleOptionSelected,widget.bloc.sizeList ?? []);
        },
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Selector<AddProductBloc, String?>(
                selector: (context, bloc) => bloc.selectedSizeName,
                builder: (context, size, _) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: (size != null)
                        ? Text(size,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black, fontFamily: 'Ubuntu'))
                        : const Text('St',
                        style: TextStyle(fontSize: 13, color: Colors.black, fontFamily: 'Ubuntu')),
                  );
                },
              ),
              const Icon(Icons.arrow_drop_down_sharp)
            ],
          ),
        ),
      ),
    );
  }

  void showSizeDialog(BuildContext context, Function(String) onOptionSelected,List<SizeVo> sizeList) {

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text(
            'Choose Size',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: sizeList.length ?? 0,
                itemBuilder: (context, index) {
                  final size = sizeList[index];
                  return SimpleDialogOption(
                    onPressed: () {
                      onOptionSelected(size.sizeName);
                      Navigator.pop(dialogContext);
                    },
                    child: Text(
                      size.sizeName,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
