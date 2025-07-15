import 'package:dorm_sync/model/prospect.dart';
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
import 'package:intl/intl.dart';

class FollowUpCRM extends StatefulWidget {
  const FollowUpCRM({super.key});

  @override
  State<FollowUpCRM> createState() => _FollowUpCRMState();
}

class _FollowUpCRMState extends State<FollowUpCRM> {
  ProspectList? prospectData;
  List<ProspectHistory> followUpList = [];

  TextEditingController studentNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController staffController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController fContactNoController = TextEditingController();

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

  String? _selectedStatus;
  final List<String> _statusList = ['In Process', 'Admitted', 'Lost'];

  TextEditingController appointmentDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );

  @override
  void initState() {
    appointmentTimePicker = TimeOfDay.now();
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && prospectData == null) {
        prospectData = args as ProspectList;

        studentNameController.text = prospectData!.studentName ?? "";
        genderController.text = prospectData!.gender ?? "";
        contactNoController.text = prospectData!.contactNo ?? "";
        addressController.text = prospectData!.address ?? "";
        stateController.text = prospectData!.state ?? "";
        cityController.text = prospectData!.city ?? "";
        remarkController.text = prospectData!.remark ?? "";
        staffController.text = prospectData!.staff ?? "";
        fatherNameController.text = prospectData!.fatherName ?? "";
        fContactNoController.text = prospectData!.fContactNo ?? "";
        _selectedStatus = prospectData!.prospectStatus ?? "";
        appointmentDatepicker.text = DateFormat(
          'dd/MM/yyyy',
        ).format(prospectData!.nextAppointmentDate ?? DateTime.now());
        appointmentTimePicker = TimeOfDay(
          hour: int.parse(prospectData!.time!.split(":")[0]),
          minute: int.parse(prospectData!.time!.split(":")[1]),
        );
      }
      getFollowUpRecord(prospectData!.id!).then((value) {
        setState(() {});
      });
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
                    "Follow-Up",
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
                  readOnly: true,
                  suffixIcon: Icon(Icons.edit_off_outlined),
                  controller: studentNameController,
                  image: Images.studentName,
                  hintText: "Student Name",
                ),
                CommonTextField(
                  readOnly: true,
                  suffixIcon: Icon(Icons.edit_off_outlined),
                  controller: genderController,
                  image: Images.gender,
                  hintText: "Gender",
                ),
                CommonTextField(
                  readOnly: true,
                  suffixIcon: Icon(Icons.edit_off_outlined),
                  controller: contactNoController,
                  image: Images.contactNo,
                  hintText: "Contact No",
                ),
                CommonTextField(
                  readOnly: true,
                  suffixIcon: Icon(Icons.edit_off_outlined),
                  controller: addressController,
                  image: Images.location,
                  hintText: "Address",
                ),
                CommonTextField(
                  readOnly: true,
                  suffixIcon: Icon(Icons.edit_off_outlined),
                  controller: stateController,
                  image: Images.state,
                  hintText: "State",
                ),
                CommonTextField(
                  readOnly: true,
                  suffixIcon: Icon(Icons.edit_off_outlined),
                  controller: cityController,
                  image: Images.selectCity,
                  hintText: "City",
                ),

                CommonTextField(
                  readOnly: true,
                  suffixIcon: Icon(Icons.edit_off_outlined),
                  controller: fatherNameController,
                  image: Images.father,
                  hintText: "Father Name",
                ),
                CommonTextField(
                  readOnly: true,
                  suffixIcon: Icon(Icons.edit_off_outlined),
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
                CommonTextField(
                  readOnly: true,
                  suffixIcon: Icon(Icons.edit_off_outlined),
                  controller: staffController,
                  image: Images.user,
                  hintText: "Staff",
                ),

                Row(
                  children: [
                    Image.asset(Images.year, height: 30),
                    SizedBox(width: 5),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2500),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              appointmentDatepicker.text = DateFormat(
                                'dd/MM/yyyy',
                              ).format(selectedDate);
                            }
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "   ${appointmentDatepicker.text}",
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

                Row(
                  children: [
                    Image.asset(Images.utilities, height: 30),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.primary,
                        ),
                        hint: Text(
                          "Follow-up Status",
                          style: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                            // height: 2,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                        items:
                            _statusList.map((gender) {
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
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .05),

            Center(
              child: DefaultButton(
                text: 'Save',
                hight: 40,
                width: 150,
                onTap: () {
                  postFollowUp();
                },
              ),
            ),
            SizedBox(height: Sizes.height * .04),
            GridView.builder(
              shrinkWrap: true,
              itemCount: followUpList.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    Sizes.width < 600
                        ? 2
                        : Sizes.width < 800
                        ? 3
                        : 4,
                crossAxisSpacing: Sizes.width * .03,
                childAspectRatio:
                    Sizes.width < 600
                        ? 1.8
                        : Sizes.width < 800
                        ? 2.1
                        : 2.5,
                mainAxisSpacing: Sizes.height * .02,
              ),
              itemBuilder: (context, index) {
                final item = followUpList[index];
                return Card(
                  shadowColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        item.oldData!.remark ?? "No remaks added",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black81,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        DateFormat(
                          'dd/MM/yyyy',
                        ).format(item.oldData!.updatedAt!),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black81,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future postFollowUp() async {
    final response =
        await ApiService.postData('prospect/${prospectData!.id}/follow-up', {
          'licence_no': Preference.getString(PrefKeys.licenseNo),
          'branch_id': Preference.getint(PrefKeys.locationId).toString(),
          'student_name': studentNameController.text.trim().toString(),
          'gender': genderController.text.trim().toString(),
          'contact_no': contactNoController.text.trim().toString(),
          'father_name': fatherNameController.text.trim().toString(),
          'f_contact_no': fContactNoController.text.trim().toString(),
          'address': addressController.text.trim().toString(),
          'staff': staffController.text.toString(),
          'next_appointment_date': appointmentDatepicker.text.trim().toString(),
          'time': appointmentTimePicker.format(context),
          'remark': remarkController.text.trim().toString(),
          'city': cityController.text.trim().toString(),
          'state': stateController.text.trim().toString(),
          'prospect_status': _selectedStatus,
        });

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future getFollowUpRecord(int id) async {
    var response = await ApiService.fetchData("prospect/history/$id");
    if (response["status"] == true) {
      followUpList = List<ProspectHistory>.from(
        response['data'].map((x) => ProspectHistory.fromJson(x)),
      );
    }
  }
}
