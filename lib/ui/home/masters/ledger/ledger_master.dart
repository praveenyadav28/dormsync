import 'dart:io';
import 'package:dorm_sync/model/ledger.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/container.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/file_saver.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/statecities.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchfield/searchfield.dart';

class CreateLedger extends StatefulWidget {
  const CreateLedger({super.key});

  @override
  State<CreateLedger> createState() => _CreateLedgerState();
}

class _CreateLedgerState extends State<CreateLedger> {
  String _selectedTitle = 'Mr';
  final List<String> _titles = ['Mr', 'Miss', 'Mrs', 'Dr'];

  String _selectedBalance = 'Cr';
  String _selectedClosingBalance = 'Cr';
  final List<String> _balanceType = ['Cr', 'Dr'];

  String _selectedsubTitle = 'S/O';
  final List<String> _subtitles = ['S/O', 'D/O', 'W/O'];

  String? _selectedLedgerGroup;
  final List<String> _groupLedgerList = [
    'Bank Account',
    'Cash In Hand',
    'Sundry Debtors',
    'Sundry Creditors',
    'Expense',
    'Fixed Asset',
    'Capital',
    'Loans (Liability)',
    'Misc Charges',
  ];

  final ImagePicker _picker = ImagePicker();
  List<XFile> _documentImages = []; // Multiple docs
  List<String> _documentImageUrls = [];

  // ------------ Pick Multiple Docs ------------
  Future<void> _pickDocumentImages() async {
    try {
      final docs = await _picker.pickMultiImage();
      if (docs.isNotEmpty) {
        setState(() => _documentImages.addAll(docs));
      }
    } catch (e) {
      print("Failed to pick docs: $e");
    }
  }

  LedgerList? ledgerData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && ledgerData == null) {
      ledgerData = args as LedgerList;

      _selectedTitle = ledgerData?.title ?? "";
      _selectedsubTitle = ledgerData?.relationType ?? "";
      _selectedLedgerGroup = ledgerData?.ledgerGroup ?? "";
      _selectedClosingBalance = ledgerData?.openingType ?? "Dr";
      _selectedBalance = ledgerData?.openingType ?? "Dr";
      ledgerNameController.text = ledgerData?.ledgerName ?? "";
      fatherNameController.text = ledgerData?.name ?? "";
      _documentImageUrls = ledgerData?.uplodeFile?.cast<String>() ?? [];
      contactNoNameController.text = ledgerData?.contactNo ?? "";
      emailIdController.text = ledgerData?.email ?? "";
      whatsapppNoController.text = ledgerData?.whatsappNo ?? "";
      gstNoController.text = ledgerData?.gstNo ?? "";
      closingBalanceController.text = ledgerData?.closingBalance ?? "";
      openingBalanceController.text = ledgerData?.openingBalance ?? "";
      aadharNoController.text = ledgerData?.aadharNo ?? "";
      permanentAddressController.text = ledgerData?.permanentAddress ?? "";
      permanentareaController.text = ledgerData?.cityTownVillage ?? "";
      permanentpinCodeController.text = ledgerData?.pinCode ?? "";
      temporaryAddressController.text = ledgerData?.temporaryAddress ?? "";
      temporaryareaController.text = ledgerData?.tcityTownVillage ?? "";
      temporarypinCodeController.text = ledgerData?.tpinCode ?? "";
      selectedState = SearchFieldListItem<String>(
        ledgerData?.state ?? "",
        item: ledgerData?.state ?? "",
      );
      selectedCity = SearchFieldListItem<String>(
        ledgerData?.city ?? "",
        item: ledgerData?.city ?? "",
      );
      stateController.text = selectedState?.searchKey ?? '';
      cityController.text = selectedCity?.searchKey ?? '';
      selectedStateTemp = SearchFieldListItem<String>(
        ledgerData?.tstate ?? "",
        item: ledgerData?.tstate ?? "",
      );
      selectedCityTemp = SearchFieldListItem<String>(
        ledgerData?.tcity ?? "",
        item: ledgerData?.tcity ?? "",
      );
      tempSateController.text = selectedStateTemp?.searchKey ?? '';
      tempCityController.text = selectedCityTemp?.searchKey ?? '';
      citiesSuggestions = stateCities[selectedState?.searchKey] ?? [];
      citiesSuggestionsTemp = stateCities[selectedStateTemp?.searchKey] ?? [];
    }
  }

  TextEditingController miscAddNameController = TextEditingController();
  TextEditingController ledgerNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController contactNoNameController = TextEditingController();
  TextEditingController whatsapppNoController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController closingBalanceController = TextEditingController();
  TextEditingController openingBalanceController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController temporaryAddressController = TextEditingController();
  TextEditingController permanentpinCodeController = TextEditingController();
  TextEditingController temporarypinCodeController = TextEditingController();
  TextEditingController permanentareaController = TextEditingController();
  TextEditingController temporaryareaController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController tempSateController = TextEditingController();
  final TextEditingController tempCityController = TextEditingController();

  late List<String> statesSuggestions;
  late List<String> citiesSuggestions;
  late List<String> citiesSuggestionsTemp;

  late SearchFieldListItem<String>? selectedState;
  late SearchFieldListItem<String>? selectedStateTemp;
  late SearchFieldListItem<String>? selectedCity;
  late SearchFieldListItem<String>? selectedCityTemp;
  @override
  void initState() {
    statesSuggestions = stateCities.keys.toList();
    citiesSuggestions = [];
    citiesSuggestionsTemp = [];
    selectedState = null;
    selectedStateTemp = null;
    selectedCity = null;
    selectedCityTemp = null;
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
                    "Ledger-Master",
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

            ButtonContainer(text: "Ledger Details", image: Images.hosteler),
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
                            _selectedTitle = newValue ?? 'Mr';
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
                        isDense: true, // Reduces vertical spacing
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextFormField(
                        controller: ledgerNameController,
                        style: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                          height: 2,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                          hintText: "Ledger Name*",
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
                          hintText: "Name",
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
            addMasterOutside(
              children: [
                Row(
                  children: [
                    Image.asset(Images.ledgerGroup),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedLedgerGroup,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.primary,
                        ),
                        hint: Text(
                          "--Ledger Group--*",
                          style: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedLedgerGroup = value;
                          });
                        },
                        items:
                            _groupLedgerList.map((ledegrGroup) {
                              return DropdownMenuItem(
                                value: ledegrGroup,
                                child: Text(
                                  ledegrGroup,
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
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: CommonTextField(
                        controller: openingBalanceController,
                        image: Images.openingBalance,
                        hintText: 'Opening Balance',
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
                CommonTextField(
                  controller: gstNoController,
                  image: Images.guardian,
                  hintText: 'GST NO. (Optional) ',
                ),
                CommonTextField(
                  controller: aadharNoController,
                  image: Images.aadhar,
                  hintText: 'Aadhar No. (Optional)',
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .05),

            ButtonContainer(text: "Address Details", image: Images.location),
            SizedBox(height: Sizes.height * .03),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Permanent Address  ',
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                Expanded(child: Divider(color: AppColor.black)),
                Expanded(child: Container()),
                Expanded(child: Container()),
              ],
            ),
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
                          hintText: 'Select State',
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
                        hint: 'Select City',
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
                  hintText: 'City/Town/Village',
                ),
                CommonTextField(
                  controller: permanentAddressController,
                  image: Images.location,
                  hintText: 'Address (Area and Street)',
                ),
                CommonTextField(
                  controller: permanentpinCodeController,
                  image: Images.pincode,
                  hintText: 'Pin Code',
                ),
              ],
              context: context,
            ),

            SizedBox(height: Sizes.height * 0.04),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Temporary Address  ',
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                Expanded(child: Divider(color: AppColor.black)),
                Expanded(child: Container()),
                Expanded(child: Container()),
              ],
            ),
            addMasterOutside3(
              children: [
                Row(
                  children: [
                    Image.asset(Images.state),
                    SizedBox(width: 5),
                    Expanded(
                      child: SearchField<String>(
                        controller: tempSateController,
                        suggestionStyle: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                        searchStyle: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                        searchInputDecoration: InputDecoration(
                          hintText: 'Select State',
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
                            selectedStateTemp = item;
                            tempSateController.text = item.searchKey;
                            citiesSuggestionsTemp =
                                stateCities[item.searchKey] ?? [];
                            selectedCityTemp = null;
                            tempCityController.clear();
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
                        controller: tempCityController,
                        hint: 'Select City',
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
                            selectedCityTemp = item;
                            tempCityController.text = item.searchKey;
                          });
                        },
                        suggestions:
                            citiesSuggestionsTemp
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
                  controller: temporaryareaController,
                  image: Images.town,
                  hintText: 'City/Town/Village',
                ),
                CommonTextField(
                  controller: temporaryAddressController,
                  image: Images.location,
                  hintText: 'Address (Area and Street)',
                ),
                CommonTextField(
                  controller: temporarypinCodeController,
                  image: Images.pincode,
                  hintText: 'Pin Code',
                ),
              ],
              context: context,
            ),

            SizedBox(height: Sizes.height * .03),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload Documents"),
              onPressed: _pickDocumentImages,
            ),
            SizedBox(height: 10),
            DocumentImageGrid(
              networkUrls: _documentImageUrls,
              localFiles: _documentImages.map((doc) => File(doc.path)).toList(),
            ),

            SizedBox(height: Sizes.height * .05),

            Center(
              child: DefaultButton(
                text: ledgerData == null ? "Create" : 'Update',
                hight: 40,
                width: 150,
                onTap: () async {
                  // multiple documents (XFile)
                  final List<XFile> documents = _documentImages;

                  ledgerData != null
                      ? showDialog(
                        context: context,
                        builder:
                            (dialogContext) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text(
                                "Are you sure you want to update this ledger?",
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
                                    bool success = await updateLedger(
                                      documents,
                                    );
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
                      : postLedger(documents);
                },
              ),
            ),
            SizedBox(height: Sizes.height * .04),
          ],
        ),
      ),
    );
  }

  Future postLedger(List<XFile>? documents) async {
    final response = await ApiService.uploadFiles(
      endpoint: 'ledger',
      multiFiles:
          documents != null && documents.isNotEmpty
              ? {"ledger_file[]": documents}
              : null,
      fields: {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'title': _selectedTitle,
        'ledger_name': ledgerNameController.text.trim().toString(),
        'relation_type': _selectedsubTitle,
        // 'ledger_file': 'nullable|array',
        // 'ledger_file.*': 'file|max:2048',
        'name': fatherNameController.text.trim().toString(),
        'contact_no': contactNoNameController.text.trim().toString(),
        'whatsapp_no': whatsapppNoController.text.trim().toString(),
        'email': emailIdController.text.trim().toString(),
        'ledger_group': _selectedLedgerGroup ?? "Sundry Debitors",
        'opening_balance': openingBalanceController.text.trim().toString(),
        'opening_type': _selectedBalance,
        'closing_balance': "0",
        'closing_type': "Dr",
        'gst_no': gstNoController.text.trim().toString(),
        'aadhar_no': aadharNoController.text.trim().toString(),
        // 'l_docu_uplode': 'nullable|file|max:2048',
        'permanent_address': permanentAddressController.text.trim().toString(),
        'state': stateController.text.trim().toString(),
        'city': cityController.text.trim().toString(),
        'city_town_village': permanentareaController.text.trim().toString(),
        'pin_code': permanentpinCodeController.text.trim().toString(),
        'temporary_address': temporaryAddressController.text.trim().toString(),
        't_state': tempSateController.text.trim().toString(),
        't_city': tempCityController.text.trim().toString(),
        't_city_town_village': temporaryareaController.text.trim().toString(),
        't_pin_code': temporarypinCodeController.text.trim().toString(),
        'other1': 'LGR',
        'other4': "",
        'other5': "",
      },
    );

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future updateLedger(List<XFile>? documents) async {
    final response = await ApiService.uploadFiles(
      endpoint: 'ledger/${ledgerData!.id}',
      multiFiles:
          documents != null && documents.isNotEmpty
              ? {"ledger_file[]": documents}
              : null,
      fields: {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'title': _selectedTitle,
        'ledger_name': ledgerNameController.text.trim().toString(),
        'relation_type': _selectedsubTitle,
        // 'ledger_file': 'nullable|array',
        // 'ledger_file.*': 'file|max:2048',
        'name': fatherNameController.text.trim().toString(),
        'contact_no': contactNoNameController.text.trim().toString(),
        'whatsapp_no': whatsapppNoController.text.trim().toString(),
        'email': emailIdController.text.trim().toString(),
        'ledger_group': _selectedLedgerGroup ?? "Sundry Debitors",
        'opening_balance': openingBalanceController.text.trim().toString(),
        'opening_type': _selectedBalance,
        'closing_balance': closingBalanceController.text.trim().toString(),
        'closing_type': _selectedClosingBalance,
        'gst_no': gstNoController.text.trim().toString(),
        'aadhar_no': aadharNoController.text.trim().toString(),
        // 'l_docu_uplode': 'nullable|file|max:2048',
        'permanent_address': permanentAddressController.text.trim().toString(),
        'state': stateController.text.trim().toString(),
        'city': cityController.text.trim().toString(),
        'city_town_village': permanentareaController.text.trim().toString(),
        'pin_code': permanentpinCodeController.text.trim().toString(),
        'temporary_address': temporaryAddressController.text.trim().toString(),
        't_state': tempSateController.text.trim().toString(),
        't_city': tempCityController.text.trim().toString(),
        't_city_town_village': temporaryareaController.text.trim().toString(),
        't_pin_code': temporarypinCodeController.text.trim().toString(),
        'other1': 'LGR',
        'other4': "",
        'other5': "",
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
