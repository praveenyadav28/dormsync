import 'package:dorm_sync/model/item_model.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/container.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';

class CreateItem extends StatefulWidget {
  const CreateItem({super.key});

  @override
  State<CreateItem> createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItem> {
  ItemList? itemData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && itemData == null) {
      itemData = args as ItemList;

      itemNameController.text = itemData!.itemName ?? "";
      itemNoController.text = itemData!.itemNo ?? "";
      manufacturerController.text = itemData!.manufacturer ?? "";
      stockQtyController.text = itemData!.stockQty?.toString() ?? "";
      _selectedGroup = itemData!.itemGroup;
    }
  }

  String? _selectedGroup;
  final List<String> _groupList = [];

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemNoController = TextEditingController();
  TextEditingController manufacturerController = TextEditingController();
  TextEditingController stockQtyController = TextEditingController();
  TextEditingController miscAddNameController = TextEditingController();
  // TextEditingController stockQtyController = TextEditingController();

  @override
  void initState() {
    ApiService.getGroupList(3, _groupList).then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.width * .02,
          vertical: Sizes.height * .01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: Sizes.height * .04),
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Text(
                    "Item-Master",
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Text(
                          "Back to List  ",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.asset(Images.back),
                        SizedBox(width: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ButtonContainer(text: "Item Details", image: Images.hosteler),
            addMasterOutside3(
              children: [
                CommonTextField(
                  controller: itemNoController,
                  image: Images.itemNo,
                  hintText: "Item No.*",
                ),
                CommonTextField(
                  controller: itemNameController,
                  image: Images.itemname,
                  hintText: "Item Name*",
                ),
                Row(
                  children: [
                    Image.asset(Images.group),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGroup,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.primary,
                        ),
                        hint: Text(
                          "--Item Group--*",
                          style: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedGroup = value;
                          });
                        },
                        items:
                            _groupList.map((group) {
                              return DropdownMenuItem(
                                value: group,
                                child: Text(
                                  group,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Add Group'),
                              content: TextFormField(
                                controller: miscAddNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      dialogContext,
                                    ).pop(); // Close dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ApiService.postMisc(
                                      3,
                                      miscAddNameController.text
                                          .trim()
                                          .toString(),
                                      context,
                                      _groupList,
                                    ).then((value) {
                                      setState(() {
                                        miscAddNameController.clear();
                                        Navigator.of(
                                          dialogContext,
                                        ).pop(); // Close dialog
                                      });
                                    });
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        minRadius: 17,
                        backgroundColor: AppColor.primary,
                        child: Icon(Icons.add, color: AppColor.white),
                      ),
                    ),
                  ],
                ),

                CommonTextField(
                  controller: manufacturerController,
                  image: Images.manufacturer,
                  hintText: "Manufacturer",
                ),
                CommonTextField(
                  controller: stockQtyController,
                  image: Images.stock,
                  hintText: "Stock Qty*",
                ),
              ],
              context: context,
            ),

            SizedBox(height: Sizes.height * .05),

            Center(
              child: DefaultButton(
                text: itemData != null ? "Update" : "Create",
                hight: 40,
                width: 150,
                onTap: () {
                  itemData != null
                      ? showDialog(
                        context: context,
                        builder:
                            (dialogContext) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text(
                                "Are you sure you want to update this item?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(dialogContext).pop(),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primary,
                                  ),
                                  onPressed: () async {
                                    bool success = await updateItem();
                                    Navigator.of(
                                      dialogContext,
                                    ).pop(); // ✅ Close dialog
                                    if (success) {
                                      Navigator.of(
                                        context,
                                      ).pop("New Data"); // ✅ Pop screen
                                    }
                                  },
                                  child: const Text("Update"),
                                ),
                              ],
                            ),
                      )
                      : postItem();
                },
              ),
            ),
            SizedBox(height: Sizes.height * .04),
          ],
        ),
      ),
    );
  }

  Future postItem() async {
    var response = await ApiService.postData('item', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'item_no': itemNoController.text.trim().toString(),
      'item_name': itemNameController.text.trim().toString(),
      'item_group': _selectedGroup,
      'manufacturer': manufacturerController.text.trim().toString(),
      'stock_qty': int.tryParse(stockQtyController.text.trim()) ?? 0,
    });

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future<bool> updateItem() async {
    var response = await ApiService.postData('item/${itemData!.id}', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'item_no': itemNoController.text.trim().toString(),
      'item_name': itemNameController.text.trim().toString(),
      'item_group': _selectedGroup,
      'manufacturer': manufacturerController.text.trim().toString(),
      'stock_qty': int.tryParse(stockQtyController.text.trim()) ?? 0,
      '_method': "PUT",
    });

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      return true;
    } else {
      showCustomSnackbarError(context, response['message']);
      return false;
    }
  }
}
