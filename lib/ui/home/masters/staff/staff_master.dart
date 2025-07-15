import 'dart:io';
import 'package:dorm_sync/model/staff.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/container.dart';
import 'package:dorm_sync/utils/date_change.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/statecities.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class CreateStaff extends StatefulWidget {
  const CreateStaff({super.key});

  @override
  State<CreateStaff> createState() => _CreateStaffState();
}

class _CreateStaffState extends State<CreateStaff> {
  String _selectedTitle = 'Mr';
  final List<String> _titles = ['Mr', 'Miss', 'Mrs', 'Dr'];

  String _selectedsubTitle = 'S/O';
  final List<String> _subtitles = ['S/O', 'D/O', 'W/O'];

  String _selectedBalance = 'Cr';
  final List<String> _balanceType = ['Cr', 'Dr'];

  String? _selecteddegination;
  final List<String> _deginationList = [];
  String? _selecteddepartment;
  final List<String> _departmentList = [];

  int selectedStatus = 0;
  StaffList? staffData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && staffData == null) {
      staffData = args as StaffList;
      _selectedTitle = staffData?.title! ?? "";
      _selectedsubTitle = staffData?.relationType! ?? "";
      _selecteddegination = staffData?.designation! ?? "";
      _selecteddepartment = staffData?.department! ?? "";
      staffIdController.text = staffData!.staffId ?? "";
      staffNameController.text = staffData!.staffName ?? "";
      fatherNameController.text = staffData!.name ?? "";
      contactNoNameController.text = staffData!.contactNo ?? "";
      emailIdController.text = staffData!.email ?? "";
      whatsapppNoController.text = staffData!.whatsappNo ?? "";
      openingBalanceController.text = staffData!.openingBalance.toString();
      _selectedBalance = staffData?.openingType! ?? "";
      joiningDateController.text = staffData!.joiningDate!;
      aadharNoController.text = staffData!.aadharNo ?? "";
      permanentAddressController.text = staffData!.permanentAddress ?? "";
      permanentareaController.text = staffData!.cityTownVillage ?? "";
      permanentpinCodeController.text = staffData!.pinCode ?? "";
      selectedState = SearchFieldListItem<String>(
        staffData!.state ?? "",
        item: staffData!.state ?? "",
      );
      selectedCity = SearchFieldListItem<String>(
        staffData!.city ?? "",
        item: staffData!.city ?? "",
      );
      stateController.text = selectedState?.searchKey ?? '';
      cityController.text = selectedCity?.searchKey ?? '';
      citiesSuggestions = stateCities[selectedState?.searchKey] ?? [];
    }
  }

  TextEditingController miscAddNameController = TextEditingController();
  TextEditingController staffIdController = TextEditingController();
  TextEditingController staffNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController contactNoNameController = TextEditingController();
  TextEditingController whatsapppNoController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController joiningDateController = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController permanentpinCodeController = TextEditingController();
  TextEditingController permanentareaController = TextEditingController();
  TextEditingController openingBalanceController = TextEditingController();
  TextEditingController openingBalanceTypeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  late List<String> statesSuggestions;
  late List<String> citiesSuggestions;

  late SearchFieldListItem<String>? selectedState;
  late SearchFieldListItem<String>? selectedCity;
  @override
  void initState() {
    statesSuggestions = stateCities.keys.toList();
    citiesSuggestions = [];
    selectedState = null;
    selectedCity = null;
    ApiService.getGroupList(1, _departmentList).then((value) {
      setState(() {});
    });

    ApiService.getGroupList(2, _deginationList).then((value) {
      setState(() {});
    });
    getStaffId().then((_) {
      setState(() {});
    });
    super.initState();
  }

  String _previousText = '';

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
                    "Staff-Master",
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

            ButtonContainer(text: "Personal Details", image: Images.hosteler),
            addMasterOutside3(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffF5FFF1),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.grey,
                            offset: Offset(0, 4),
                            spreadRadius: 4,
                            blurRadius: 4,
                          ),
                        ],
                      ),

                      child: DropdownButton<String>(
                        value: _selectedTitle,
                        icon: Container(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTitle = newValue ?? 'S/O';
                          });
                        },
                        items:
                            _titles.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.lightblack,
                                    fontSize: 17,
                                  ),
                                ),
                              );
                            }).toList(),
                        underline: Container(),
                        isDense: true,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextFormField(
                        controller: staffNameController,
                        style: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                          height: 2,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                          hintText: "Staff Name*",
                          hintStyle: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                            height: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffF5FFF1),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.grey,
                            offset: Offset(0, 4),
                            spreadRadius: 4,
                            blurRadius: 4,
                          ),
                        ],
                      ),

                      child: DropdownButton<String>(
                        value: _selectedsubTitle,
                        icon: Container(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedsubTitle = newValue ?? 'S/O';
                          });
                        },
                        items:
                            _subtitles.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.lightblack,
                                    fontSize: 17,
                                  ),
                                ),
                              );
                            }).toList(),
                        underline: Container(),
                        isDense: true, // Reduces vertical spacing
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextFormField(
                        controller: fatherNameController,
                        style: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                          height: 2,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                          hintText: "Name*",
                          hintStyle: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                            height: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                CommonTextField(
                  controller: contactNoNameController,
                  image: Images.contactNo,
                  hintText: 'Contact No.*',
                ),
                CommonTextField(
                  controller: whatsapppNoController,
                  image: Images.whatsapp,
                  hintText: 'Whatsapp No. (Optional)',
                ),
                CommonTextField(
                  controller: emailIdController,
                  image: Images.mail,
                  hintText: 'Email (Optional)',
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Image.asset(Images.upload, height: 45),
                //     SizedBox(width: 30),
                //     CircleAvatar(
                //       backgroundColor: AppColor.primary,
                //       child: Icon(Icons.add, color: AppColor.white),
                //     ),
                //   ],
                // ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .05),
            ButtonContainer(text: "Offical Details", image: Images.parental),
            addMasterOutside3(
              children: [
                CommonTextField(
                  controller: staffIdController,
                  image: Images.studentId,
                  hintText: 'Staff Id*',
                ),

                Row(
                  children: [
                    Image.asset(Images.department),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selecteddepartment,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.primary,
                        ),
                        hint: Text(
                          "--Department--*",
                          style: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selecteddepartment = value;
                          });
                        },
                        items:
                            _departmentList.map((department) {
                              return DropdownMenuItem(
                                value: department,
                                child: Text(
                                  department,
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
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ApiService.postMisc(
                                      1,
                                      miscAddNameController.text
                                          .trim()
                                          .toString(),
                                      context,
                                      _departmentList,
                                    ).then((value) {
                                      setState(() {
                                        miscAddNameController.clear();
                                        Navigator.of(dialogContext).pop();
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
                Row(
                  children: [
                    Image.asset(Images.degination),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selecteddegination,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.primary,
                        ),
                        hint: Text(
                          "--Desgination--*",
                          style: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selecteddegination = value;
                          });
                        },
                        items:
                            _deginationList.map((degination) {
                              return DropdownMenuItem(
                                value: degination,
                                child: Text(
                                  degination,
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
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ApiService.postMisc(
                                      2,
                                      miscAddNameController.text
                                          .trim()
                                          .toString(),
                                      context,
                                      _deginationList,
                                    ).then((value) {
                                      setState(() {
                                        miscAddNameController.clear();
                                        Navigator.of(dialogContext).pop();
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
                  onPressIcon: () async {
                    selectDate(context, joiningDateController).then((onValue) {
                      setState(() {});
                    });
                  },

                  controller: joiningDateController,
                  image: Images.year,
                  hintText: 'Joining Date',
                  onChanged: (val) {
                    smartDateOnChanged(
                      value: val,
                      controller: joiningDateController,
                      previousText: _previousText,
                      updatePreviousText: (newText) => _previousText = newText,
                    );
                  },
                ),
                CommonTextField(
                  controller: aadharNoController,
                  image: Images.aadhar,
                  hintText: 'Aadhar No. (Optional)',
                ),
                Row(
                  children: [
                    Expanded(
                      child: CommonTextField(
                        controller: openingBalanceController,
                        image: Images.openingBalance,
                        hintText: 'Opening Balance*',
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 25,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffF5FFF1),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.grey,
                            offset: Offset(0, 4),
                            spreadRadius: 4,
                            blurRadius: 4,
                          ),
                        ],
                      ),

                      child: DropdownButton<String>(
                        value: _selectedBalance,
                        icon: Icon(Icons.keyboard_arrow_down),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedBalance = newValue ?? 'Dr';
                          });
                        },
                        items:
                            _balanceType.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.lightblack,
                                    fontSize: 17,
                                  ),
                                ),
                              );
                            }).toList(),
                        underline: Container(),
                        isDense: true, // Reduces vertical spacing
                      ),
                    ),
                  ],
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .05),

            ButtonContainer(text: "Address Details", image: Images.location),
            addMasterOutside3(
              children: [
                Row(
                  children: [
                    Image.asset(Images.state),
                    SizedBox(width: 5),
                    Expanded(
                      child: SearchField<String>(
                        controller: stateController,
                        suggestionStyle: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                        searchStyle: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                        searchInputDecoration: InputDecoration(
                          hintText: 'Select State*',
                          isDense: true,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColor.black81,
                          ),
                          border: UnderlineInputBorder(),
                        ),
                        suggestions:
                            statesSuggestions
                                .map(
                                  (x) =>
                                      SearchFieldListItem<String>(x, item: x),
                                )
                                .toList(),
                        onSuggestionTap: (SearchFieldListItem<String> item) {
                          setState(() {
                            selectedState = item;
                            stateController.text = item.searchKey;
                            citiesSuggestions =
                                stateCities[item.searchKey] ?? [];
                            selectedCity = null;
                            cityController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Image.asset(Images.selectCity),
                    SizedBox(width: 5),
                    Expanded(
                      child: SearchField<String>(
                        controller: cityController,
                        hint: 'Select City*',
                        suggestionStyle: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                        searchStyle: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                        searchInputDecoration: InputDecoration(
                          floatingLabelStyle: TextStyle(
                            color: AppColor.black,
                            fontWeight: FontWeight.w500,
                          ),
                          hintStyle: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                          isDense: true,
                          border: UnderlineInputBorder(),
                        ),
                        onSuggestionTap: (SearchFieldListItem<String> item) {
                          setState(() {
                            selectedCity = item;
                            cityController.text = item.searchKey;
                          });
                        },
                        suggestions:
                            citiesSuggestions
                                .map(
                                  (x) =>
                                      SearchFieldListItem<String>(x, item: x),
                                )
                                .toList(),
                        suggestionState: Suggestion.expand,
                      ),
                    ),
                  ],
                ),

                CommonTextField(
                  controller: permanentareaController,
                  image: Images.town,
                  hintText: 'City/Town/Village*',
                ),
                CommonTextField(
                  controller: permanentAddressController,
                  image: Images.location,
                  hintText: 'Address (Area and Street)*',
                ),
                CommonTextField(
                  controller: permanentpinCodeController,
                  image: Images.pincode,
                  hintText: 'Pin Code*',
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .05),
            Center(
              child: DefaultButton(
                text: staffData == null ? "Create" : 'Update',
                hight: 40,
                width: 150,
                onTap: () {
                  staffData != null
                      ? showDialog(
                        context: context,
                        builder:
                            (dialogContext) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text(
                                "Are you sure you want to update this staff?",
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
                                    bool success = await updateStaff([]);
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
                      : postStaff([]);
                },
              ),
            ),
            SizedBox(height: Sizes.height * .04),
          ],
        ),
      ),
    );
  }

  Future postStaff(List<File> images) async {
    List<http.MultipartFile> files = [];

    if (images.isNotEmpty) {
      for (File image in images) {
        final file = await http.MultipartFile.fromPath(
          'upload_file[]',
          image.path,
        );
        files.add(file);
      }
    }

    final response = await ApiService.uploadMultipleFiles(
      endpoint: 'staff',
      fields: {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'title': _selectedTitle,
        'staff_id': staffIdController.text.trim().toString(),
        'staff_name': staffNameController.text.trim().toString(),
        'relation_type': _selectedsubTitle,
        'name': fatherNameController.text.trim().toString(),
        'contact_no': contactNoNameController.text.trim().toString(),
        'whatsapp_no': whatsapppNoController.text.trim().toString(),
        'email': emailIdController.text.trim().toString(),
        'department': _selecteddepartment ?? '',
        'designation': _selecteddegination ?? '',
        'joining_date': joiningDateController.text.trim().toString(),
        'aadhar_no': aadharNoController.text.trim().toString(),
        'permanent_address': permanentAddressController.text.trim().toString(),
        'state': selectedState?.item ?? '',
        'city': selectedCity?.item ?? "",
        'opening_balance': openingBalanceController.text.trim(),
        'opening_type': _selectedBalance,
        'city_town_village': permanentareaController.text.trim().toString(),
        'address': permanentAddressController.text.trim().toString(),
        'pin_code': permanentpinCodeController.text.trim().toString(),
        'temporary_address': permanentAddressController.text.trim().toString(),
        // 'other1': 'STF',
      },
      files: files, // will be empty if no image is selected
    );

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future updateStaff(List<File> images) async {
    List<http.MultipartFile> files = [];

    if (images.isNotEmpty) {
      for (File image in images) {
        final file = await http.MultipartFile.fromPath(
          'upload_file[]',
          image.path,
        );
        files.add(file);
      }
    }

    final response = await ApiService.uploadMultipleFiles(
      endpoint: 'staff/${staffData!.id}',
      fields: {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'title': _selectedTitle,
        'staff_id': staffIdController.text.trim().toString(),
        'staff_name': staffNameController.text.trim().toString(),
        'relation_type': _selectedsubTitle,
        'name': fatherNameController.text.trim().toString(),
        'contact_no': contactNoNameController.text.trim().toString(),
        'whatsapp_no': whatsapppNoController.text.trim().toString(),
        'email': emailIdController.text.trim().toString(),
        'department': _selecteddepartment ?? '',
        'designation': _selecteddegination ?? '',
        'joining_date': joiningDateController.text.trim().toString(),
        'aadhar_no': aadharNoController.text.trim().toString(),
        'permanent_address': permanentAddressController.text.trim().toString(),
        'state': selectedState?.item ?? '',
        'city': selectedCity?.item ?? "",
        'opening_balance': openingBalanceController.text.trim().toString(),
        'opening_type': _selectedBalance,
        'city_town_village': permanentareaController.text.trim().toString(),
        'address': permanentAddressController.text.trim().toString(),
        'pin_code': permanentpinCodeController.text.trim().toString(),
        'temporary_address': permanentAddressController.text.trim().toString(),
        // 'other1':'STF'
        '_method': "PUT",
      },
      files: files, // will be empty if no image is selected
    );

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      return true;
    } else {
      showCustomSnackbarError(context, response['message']);
      return false;
    }
  }

  Future getStaffId() async {
    var response = await ApiService.fetchData("next-staff-id");
    staffIdController.text =
        staffData != null
            ? staffData!.staffId!
            : response['next_staff_id'].toString();
  }
}
