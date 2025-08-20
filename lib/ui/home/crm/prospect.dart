import 'package:dorm_sync/model/prospect.dart';
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
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class ProspectCRM extends StatefulWidget {
  const ProspectCRM({super.key});

  @override
  State<ProspectCRM> createState() => _ProspectCRMState();
}

class _ProspectCRMState extends State<ProspectCRM> {
  ProspectList? prospectData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && prospectData == null) {
      prospectData = args as ProspectList;

      _selectedGender = prospectData?.gender! ?? "";
      _selectedStaff = prospectData?.staff! ?? "";
      studentNameController.text = prospectData!.studentName ?? "";
      contactNoController.text = prospectData!.contactNo ?? "";
      addressController.text = prospectData!.address ?? "";
      remarkController.text = prospectData!.remark ?? "";
      fatherNameController.text = prospectData!.fatherName ?? "";
      fContactNoController.text = prospectData!.fContactNo ?? "";
      prospectDatepicker.text = prospectData!.prospectDate!;
      appointmentDatepicker.text = prospectData!.nextAppointmentDate!;
      appointmentTimePicker = TimeOfDay(
        hour: int.parse(prospectData!.time!.split(":")[0]),
        minute: int.parse(prospectData!.time!.split(":")[1]),
      );
      selectedState = SearchFieldListItem<String>(
        prospectData!.state ?? "",
        item: prospectData!.state ?? "",
      );

      citiesSuggestions = stateCities[prospectData!.state] ?? [];

      selectedCity = SearchFieldListItem<String>(
        prospectData!.city ?? "",
        item: prospectData!.city ?? "",
      );
    }
  }

  String? _selectedStaff;
  final List<String> _staffList = [];

  TextEditingController studentNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController fContactNoController = TextEditingController();
  late List<String> statesSuggestions;
  late List<String> citiesSuggestions;

  late SearchFieldListItem<String>? selectedState;
  late SearchFieldListItem<String>? selectedCity;

  String? _selectedGender;
  final List<String> _genderList = ['Male', 'Female', 'Other'];

  late TimeOfDay appointmentTimePicker;
  Future<void> _selectAppointmentTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: appointmentTimePicker,
    );
    if (picked != null && picked != appointmentTimePicker) {
      setState(() {
        appointmentTimePicker = picked;
      });
    }
  }

  TextEditingController prospectDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  TextEditingController appointmentDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );

  @override
  void initState() {
    appointmentTimePicker = TimeOfDay.now();
    statesSuggestions = stateCities.keys.toList();
    citiesSuggestions = [];
    selectedState = null;
    selectedCity = null;
    getStaff().then((value) {
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
                    prospectData != null
                        ? "Update-Prospect"
                        : "Create-Prospect",
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

            ButtonContainer(text: "Student Details", image: Images.hosteler),
            addMasterOutside(
              children: [
                CommonTextField(
                  controller: studentNameController,
                  image: Images.studentName,
                  hintText: "Student Name*",
                ),
                Row(
                  children: [
                    Image.asset(Images.gender, height: 30),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGender,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.primary,
                        ),
                        hint: Text(
                          "Gender*",
                          style: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                            // height: 2,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        items:
                            _genderList.map((gender) {
                              return DropdownMenuItem(
                                value: gender,
                                child: Text(
                                  gender,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w500,
                                    // height: 2,
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
                CommonTextField(
                  controller: contactNoController,
                  image: Images.contactNo,
                  hintText: "Contact No*",
                ),
                CommonTextField(
                  controller: addressController,
                  image: Images.location,
                  hintText: "Address",
                ),

                Row(
                  children: [
                    Image.asset(Images.state),
                    SizedBox(width: 5),
                    Expanded(
                      child: SearchField<String>(
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
                            citiesSuggestions =
                                stateCities[item.searchKey] ?? [];
                            selectedCity = null;
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
                  controller: fatherNameController,
                  image: Images.father,
                  hintText: "Father Name",
                ),
                CommonTextField(
                  controller: fContactNoController,
                  image: Images.contactNo,
                  hintText: "Father Contact No",
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .05),

            ButtonContainer(text: "Appointment Details", image: Images.upload),
            addMasterOutside(
              children: [
                Row(
                  children: [
                    Image.asset(Images.user, height: 30),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStaff,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.primary,
                        ),
                        hint: Text(
                          "--Select Staff--",
                          style: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedStaff = value;
                          });
                        },
                        items:
                            _staffList.map((state) {
                              return DropdownMenuItem(
                                value: state,
                                child: Text(
                                  state,
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
                CommonTextField(
                  controller: appointmentDatepicker,
                  image: Images.year,
                  hintText: "Appointment Date",
                  onPressIcon: () {
                    selectDate(context, appointmentDatepicker).then((onValue) {
                      setState(() {});
                    });
                  },
                  onChanged: (val) {
                    smartDateOnChanged(
                      value: val,
                      controller: appointmentDatepicker,
                      previousText: _previousText,
                      updatePreviousText: (newText) => _previousText = newText,
                    );
                  },
                ),
                Row(
                  children: [
                    Image.asset(Images.clock, height: 30),
                    SizedBox(width: 5),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _selectAppointmentTime(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              appointmentTimePicker.format(context),
                              style: TextStyle(
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                                height: 2,
                              ),
                              textAlign: TextAlign.left,
                            ),

                            Divider(color: AppColor.black81),
                            SizedBox(height: 3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                CommonTextField(
                  controller: remarkController,
                  image: Images.information,
                  hintText: "Remark",
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .05),

            Center(
              child: DefaultButton(
                text: prospectData == null ? "Create" : 'Update',
                hight: 40,
                width: 150,
                onTap: () {
                  prospectData != null
                      ? showDialog(
                        context: context,
                        builder:
                            (dialogContext) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text(
                                "Are you sure you want to update this prospect?",
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
                                    bool success = await updateProspect();
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
                      : postProspect();
                },
              ),
            ),
            SizedBox(height: Sizes.height * .04),
          ],
        ),
      ),
    );
  }

  Future postProspect() async {
    final response = await ApiService.postData('prospect', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'student_name': studentNameController.text.trim().toString(),
      'prospect_date': prospectDatepicker.text.trim().toString(),
      'gender': _selectedGender,
      'contact_no': contactNoController.text.trim().toString(),
      'father_name': fatherNameController.text.trim().toString(),
      'f_contact_no': fContactNoController.text.trim().toString(),
      'address': addressController.text.trim().toString(),
      'staff': _selectedStaff,
      'next_appointment_date': appointmentDatepicker.text.trim().toString(),
      'time': appointmentTimePicker.format(context),
      'remark': remarkController.text.trim().toString(),
      'city': selectedCity?.item ?? "",
      'state': selectedState?.item ?? "",
      'prospect_status': "In Process",
    });

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future updateProspect() async {
    final response = await ApiService.postData(
      'prospect/${prospectData!.id}',
      {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'student_name': studentNameController.text.trim().toString(),
        'prospect_date': prospectDatepicker.text.trim().toString(),
        'gender': _selectedGender,
        'contact_no': contactNoController.text.trim().toString(),
        'father_name': fatherNameController.text.trim().toString(),
        'f_contact_no': fContactNoController.text.trim().toString(),
        'address': addressController.text.trim().toString(),
        'staff': _selectedStaff,
        'next_appointment_date': appointmentDatepicker.text.trim().toString(),
        'time': appointmentTimePicker.format(context),
        'remark': remarkController.text.trim().toString(),
        'city': selectedCity?.item ?? "",
        'state': selectedState?.item ?? "",
        'prospect_status': "${prospectData!.prospectStatus}",
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

  Future getStaff() async {
    var response = await ApiService.fetchData(
      "staff?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      List<dynamic> data = response["data"];
      _staffList.clear();
      _staffList.addAll(data.map((e) => e['staff_name'].toString()).toList());
    }
  }
}
