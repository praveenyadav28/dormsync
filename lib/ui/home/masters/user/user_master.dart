import 'package:dorm_sync/model/usermodel.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  UserModel? staffData;

  /// Rights structure
  final Map<String, List<String>> rightsStructure = {
    "Dashboard": ["View"],
    "Student Report": ["View"],
    "Leave Report": ["View"],
    "Fees Report": ["View"],
    "Ledger Report": ["View"],
    "Bank Report": ["View"],
    "Rooms": ["View", "Assign", "Create"],
    "User Master": ["View", "Create", "Update", "Delete"],
    "Staff Master": ["View", "Create", "Update", "Delete"],
    "Ledger Master": ["View", "Create", "Update", "Delete"],
    "Item Master": ["View", "Create", "Update", "Delete"],
    "Hostelers": ["View", "Create", "Update", "Delete"],
    "Fees Entry": ["View", "Create", "Update", "Delete"],
    "Fees Recieve": ["View", "Create", "Update", "Delete"],
    "Guest": ["View", "Create", "Update", "Delete"],
    "Leave": ["View", "Create", "Update", "Delete"],
    "Attendence": ["View", "Create", "Update", "Delete"],
    "Mess Attendence": ["View", "Create", "Update", "Delete"],
    "Voucher": ["View", "Create", "Update", "Delete"],
    "No Dues": ["View"],
    "Session": ["View", "Create", "Delete"],
    "Activate Student": ["View", "Create", "Update", "Delete"],
    "Deactivate Student": ["View", "Create", "Update", "Delete"],
    "CRM": ["View", "Create", "Update", "Delete"],
  };

  /// Stores selected rights
  Map<String, List<String>> selectedRights = {};

  TextEditingController employeeController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && staffData == null) {
      staffData = args as UserModel;
      employeeController.text = staffData!.staffName ?? "";
      userNameController.text = staffData!.userName ?? "";
      passwordController.text = staffData!.password ?? "";

      if (staffData!.rights != null && staffData!.rights!.isNotEmpty) {
        selectedRights = _parseRights(staffData!.rights!);
      }
    }
  }

  /// Convert rights map to string for API
  String _rightsToString(Map<String, List<String>> rights) {
    return rights.entries.map((e) => "${e.key}:${e.value.join(',')}").join('|');
  }

  /// Convert saved rights (List<String> OR string) back into map
  Map<String, List<String>> _parseRights(dynamic rightsData) {
    final Map<String, List<String>> map = {};

    if (rightsData is String) {
      // parse "Module:Right,Right|Module2:Right"
      final modules = rightsData.split('|');
      for (var module in modules) {
        if (module.contains(':')) {
          final parts = module.split(':');
          final moduleName = parts[0];
          final rightsList = parts[1].split(',');
          map[moduleName] = rightsList;
        }
      }
    } else if (rightsData is List<String>) {
      map["All"] = rightsData;
    }
    return map;
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
            /// Header
            Container(
              margin: EdgeInsets.only(bottom: Sizes.height * .04),
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 30),
                  Text(
                    "User-Master",
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
                        const SizedBox(width: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Fields
            addMasterOutside3(
              children: [
                CommonTextField(
                  image: Images.hosteler,
                  controller: employeeController,
                  hintText: "Staff Name*",
                ),
                CommonTextField(
                  controller: userNameController,
                  image: Images.aadhar,
                  hintText: 'Username*',
                ),
                CommonTextField(
                  controller: passwordController,
                  image: Images.town,
                  hintText: 'Password*',
                ),
              ],
              context: context,
            ),

            const SizedBox(height: 20),
            Text(
              "Select Rights",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 12),

            /// Desktop-friendly rights grid
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = (constraints.maxWidth ~/ 320).clamp(
                  1,
                  4,
                ); // responsive grid

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3,
                  children:
                      rightsStructure.keys.map((module) {
                        final subRights = rightsStructure[module]!;
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  module,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Divider(),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 8,
                                  children:
                                      subRights.map((right) {
                                        final isSelected =
                                            selectedRights[module]?.contains(
                                              right,
                                            ) ??
                                            false;
                                        return FilterChip(
                                          label: Text(right),
                                          selected: isSelected,
                                          onSelected: (value) {
                                            setState(() {
                                              selectedRights.putIfAbsent(
                                                module,
                                                () => [],
                                              );
                                              if (value) {
                                                selectedRights[module]!.add(
                                                  right,
                                                );

                                                if ([
                                                  "Create",
                                                  "Update",
                                                  "Delete",
                                                ].contains(right)) {
                                                  if (!selectedRights[module]!
                                                      .contains("View")) {
                                                    selectedRights[module]!.add(
                                                      "View",
                                                    );
                                                  }
                                                }
                                              } else {
                                                selectedRights[module]!.remove(
                                                  right,
                                                );
                                              }
                                            });
                                          },
                                        );
                                      }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                );
              },
            ),

            const SizedBox(height: 30),
            Center(
              child: DefaultButton(
                text: staffData == null ? "Create" : "Update",
                hight: 40,
                width: 150,
                onTap: () async {
                  staffData != null
                      ? showDialog(
                        context: context,
                        builder:
                            (dialogContext) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text(
                                "Are you sure you want to update this user?",
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
                                    bool success = await updateStaff();
                                    Navigator.of(dialogContext).pop();
                                    if (success) {
                                      Navigator.of(context).pop("New Data");
                                    }
                                  },
                                  child: const Text("Update"),
                                ),
                              ],
                            ),
                      )
                      : await postUser();
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future postUser() async {
    final response = await ApiService.postData('only_user', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'u_name': employeeController.text.trim(),
      'username': userNameController.text.trim(),
      'password': passwordController.text.trim(),
      'rights': _rightsToString(selectedRights),
    });

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future<bool> updateStaff() async {
    final response = await ApiService.postData(
      'only_user/${staffData!.id}?licence_no=${Preference.getString(PrefKeys.licenseNo)}',
      {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'u_name': employeeController.text.trim(),
        'username': userNameController.text.trim(),
        'password': passwordController.text.trim(),
        'rights': _rightsToString(selectedRights),
        '_method': "PUT",
      },
    );

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      return true;
    } else {
      showCustomSnackbarError(context, response['message']);
      return false;
    }
  }
}
