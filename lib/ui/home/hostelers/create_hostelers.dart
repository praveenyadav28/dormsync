import 'dart:io';
import 'package:dorm_sync/model/admission.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/container.dart';
import 'package:dorm_sync/utils/date_change.dart';
import 'package:dorm_sync/utils/decoration.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/file_saver.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/statecities.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class CreateHostelers extends StatefulWidget {
  const CreateHostelers({super.key});

  @override
  State<CreateHostelers> createState() => _CreateHostelersState();
}

class _CreateHostelersState extends State<CreateHostelers> {
  final FocusNode _focusPCity = FocusNode();
  final FocusNode _focusPArea = FocusNode();
  final FocusNode _focusTCity = FocusNode();
  final FocusNode _focusTArea = FocusNode();

  String? _selectedGender;
  final List<String> _genderList = ['Male', 'Female', 'Other'];
  String? _selectedCaste;
  final List<String> _casteList = ['General', 'OBC', 'SC', 'ST'];

  int maritalStatus = 0;

  // ------------ Variables ------------
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage; // Single profile image
  List<XFile> _documentImages = []; // Multiple docs
  String? _profileImageUrl;
  List<String> _documentImageUrls = [];

  // ------------ Pick Profile Image ------------
  Future<void> _pickProfileImage() async {
    try {
      final img = await _picker.pickImage(source: ImageSource.gallery);
      if (img != null) {
        setState(() => _profileImage = img);
      }
    } catch (e) {
      print("Failed to pick profile image: $e");
    }
  }

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

  AdmissionList? admissionData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && admissionData == null) {
      admissionData = args as AdmissionList;

      _selectedCaste = admissionData?.caste! ?? "";
      _selectedGender = admissionData?.gender! ?? "";
      studentNameController.text = admissionData!.studentName ?? "";
      studentIdController.text = admissionData!.studentId ?? "";
      fatherNameController.text = admissionData!.fatherName ?? "";
      contactNoController.text = admissionData!.primaryContactNo ?? "";
      dobDatepicker.text = DateFormat(
        'dd/MM/yyyy',
      ).format(admissionData!.dateOfBirth!);
      admissionDatepicker.text = DateFormat(
        'dd/MM/yyyy',
      ).format(admissionData!.admissionDate!);
      emailIdController.text = admissionData!.email ?? "";
      collegeController.text = admissionData!.collegeName ?? "";
      courseController.text = admissionData!.course ?? "";
      yearController.text = admissionData!.year ?? "";
      motherNameController.text = admissionData!.motherName ?? "";
      guardianNameController.text = admissionData!.guardian ?? "";
      emergencyNoController.text = admissionData!.emergencyNo ?? "";
      parentContactController.text = admissionData!.parentContect ?? "";
      maritalStatus = admissionData!.maritalStatus == "Single" ? 0 : 1;
      whatsapppNoController.text = admissionData!.whatsappNo ?? "";
      aadharNoController.text = admissionData!.aadharNo ?? "";
      _profileImageUrl = admissionData?.image;
      _documentImageUrls = admissionData?.uplodeFile?.cast<String>() ?? [];
      permanentAddressController.text = admissionData!.permanentAddress ?? "";
      permanentareaController.text = admissionData!.permanentCityTown ?? "";
      permanentpinCodeController.text = admissionData!.permanentPinCode ?? "";
      temporaryAddressController.text = admissionData!.temporaryAddress ?? "";
      temporaryareaController.text = admissionData!.temporaryCityTown ?? "";
      temporarypinCodeController.text = admissionData!.temporaryPinCode ?? "";
      selectedState = SearchFieldListItem<String>(
        admissionData!.permanentState ?? "",
        item: admissionData!.permanentState ?? "",
      );
      selectedCity = SearchFieldListItem<String>(
        admissionData!.permanentCity ?? "",
        item: admissionData!.permanentCity ?? "",
      );
      stateController.text = selectedState?.searchKey ?? '';
      cityController.text = selectedCity?.searchKey ?? '';
      selectedStateTemp = SearchFieldListItem<String>(
        admissionData!.temporaryState ?? "",
        item: admissionData!.temporaryState ?? "",
      );
      selectedCityTemp = SearchFieldListItem<String>(
        admissionData!.temporaryCity ?? "",
        item: admissionData!.temporaryCity ?? "",
      );
      tempSateController.text = selectedStateTemp?.searchKey ?? '';
      tempCityController.text = selectedCityTemp?.searchKey ?? '';
      citiesSuggestions = stateCities[selectedState?.searchKey] ?? [];
      citiesSuggestionsTemp = stateCities[selectedStateTemp?.searchKey] ?? [];
    }
  }

  int? studentUpdateId;
  TextEditingController studentIdController = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController whatsapppNoController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController dobDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  TextEditingController admissionDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );

  TextEditingController collegeController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  TextEditingController fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController guardianNameController = TextEditingController();
  TextEditingController parentContactController = TextEditingController();
  TextEditingController emergencyNoController = TextEditingController();

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
    getStudentId().then((_) {
      setState(() {});
    });
    super.initState();
  }

  // Controllers
  DateTime? startDate;
  DateTime? endDate;

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
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
                    "Admission-Form",
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
            ButtonContainer(text: "Hosteler Details", image: Images.hosteler),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: addMasterOutside3(
                    children: [
                      CommonTextField(
                        controller: studentIdController,
                        image: Images.studentId,
                        hintText: 'Student ID*',
                      ),
                      CommonTextField(
                        controller: studentNameController,
                        image: Images.studentName,
                        hintText: "Student Name*",
                      ),
                      CommonTextField(
                        image: Images.year,
                        onPressIcon: () async {
                          selectDate(context, admissionDatepicker).then((
                            onValue,
                          ) {
                            setState(() {});
                          });
                        },
                        hintText: "Admission Date*",
                        controller: admissionDatepicker,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 43,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColor.black81),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(2, (index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {});
                                  maritalStatus = index;
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: maritalStatus == index ? 45 : 41,
                                  width:
                                      maritalStatus == index
                                          ? Sizes.width * .1
                                          : Sizes.width * .065,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(5, 5),
                                        blurRadius: 10,
                                        color:
                                            maritalStatus == index
                                                ? AppColor.grey
                                                : AppColor.transparent,
                                      ),
                                    ],
                                    color:
                                        maritalStatus == index
                                            ? Color(0xffF5FFF1)
                                            : AppColor.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    index == 0 ? "Single" : 'Married',
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
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
                        image: Images.dob,
                        onPressIcon: () async {
                          selectDate(context, dobDatepicker).then((onValue) {
                            setState(() {});
                          });
                        },
                        controller: dobDatepicker,
                        suffixIcon: Container(
                          height: 35,
                          width: 70,
                          margin: EdgeInsets.only(bottom: 6),
                          alignment: Alignment.center,
                          decoration: insideShadow(),
                          child: Text(
                            "${calculateAge(DateFormat('dd/MM/yyyy').parse(dobDatepicker.text))} yr",
                            style: TextStyle(
                              color: AppColor.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          bool isValid = smartDateOnChanged(
                            value: val,
                            controller: dobDatepicker,
                            previousText: _previousText,
                            updatePreviousText:
                                (newText) => _previousText = newText,
                          );

                          if (isValid) {
                            setState(
                              () {},
                            ); // Only triggers when valid date is formed
                          }
                        },
                      ),
                    ],
                    context: context,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickProfileImage,
                        child: CircleAvatar(
                          maxRadius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              _profileImage != null
                                  ? (kIsWeb
                                      ? NetworkImage(_profileImage!.path)
                                      : FileImage(File(_profileImage!.path))
                                          as ImageProvider)
                                  : (_profileImageUrl != null
                                      ? NetworkImage(_profileImageUrl!)
                                      : null),
                          child:
                              (_profileImage == null &&
                                      _profileImageUrl == null)
                                  ? const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                    color: Colors.black54,
                                  )
                                  : null,
                        ),
                      ),
                      Text(
                        "Candidate Photo",
                        style: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Sizes.height * 0.02),
            addMasterOutside(
              children: [
                Row(
                  children: [
                    Image.asset(Images.caste, height: 30),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCaste,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.primary,
                        ),
                        hint: Text(
                          "--Select Caste--",
                          style: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedCaste = value;
                          });
                        },
                        items:
                            _casteList.map((caste) {
                              return DropdownMenuItem(
                                value: caste,
                                child: Text(
                                  caste,
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
                  controller: contactNoController,
                  image: Images.contactNo,
                  hintText: 'Contact No.*',
                ),
                CommonTextField(
                  controller: aadharNoController,
                  image: Images.aadhar,
                  hintText: "Aadhar No.*",
                ),

                // CommonTextField(
                //   controller: whatsapppNoController,
                //   image: Images.whatsapp,
                //   hintText: 'Whatsapp No. (Optional)',
                // ),
                CommonTextField(
                  controller: emailIdController,
                  image: Images.mail,
                  hintText: 'Email (Optional)',
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .05),
            ButtonContainer(text: "Academic Info", image: Images.acadmic),
            addMasterOutside(
              children: [
                CommonTextField(
                  controller: collegeController,
                  image: Images.college,
                  hintText: 'College Name*',
                ),
                CommonTextField(
                  controller: courseController,
                  image: Images.course,
                  hintText: 'Course*',
                ),
                CommonTextField(
                  controller: yearController,
                  image: Images.year,
                  hintText: 'Year',
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .05),
            ButtonContainer(text: "Parental Details", image: Images.parental),
            addMasterOutside(
              children: [
                CommonTextField(
                  controller: fatherNameController,
                  image: Images.father,
                  hintText: 'Father Name*',
                ),
                CommonTextField(
                  controller: motherNameController,
                  image: Images.mother,
                  hintText: 'Mother Name*',
                ),
                CommonTextField(
                  controller: guardianNameController,
                  image: Images.guardian,
                  hintText: 'Guardian (Optional)',
                ),
                Container(),
                CommonTextField(
                  controller: parentContactController,
                  image: Images.contactNo,
                  hintText: 'Contact No.*',
                ),
                CommonTextField(
                  controller: emergencyNoController,
                  image: Images.emergency,
                  hintText: 'Emergency No. (Optional)',
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
                            FocusScope.of(context).requestFocus(_focusPCity);

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
                        focusNode: _focusPCity,
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
                            FocusScope.of(context).requestFocus(_focusPArea);
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
                  focuesNode: _focusPArea,
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
                            FocusScope.of(context).requestFocus(_focusTCity);
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
                        focusNode: _focusTCity,
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
                            FocusScope.of(context).requestFocus(_focusTArea);
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
                  focuesNode: _focusTArea,
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
                text: admissionData == null ? "Create" : 'Update',
                hight: 40,
                width: 150,
                onTap: () {
                  admissionData != null
                      ? showDialog(
                        context: context,
                        builder:
                            (dialogContext) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text(
                                "Are you sure you want to update this hostler?",
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
                                    // multiple documents (XFile)
                                    final List<XFile> documents =
                                        _documentImages;

                                    // single profile image (XFile)
                                    final XFile? profile = _profileImage;

                                    // Call the new cross-platform uploader
                                    bool success = await updateAdmission(
                                      documents: documents,
                                      profileImage: profile,
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
                      : studentIdController.text.isEmpty
                      ? showCustomSnackbarError(
                        context,
                        "Please enter studentId",
                      )
                      : getStudentDetails();
                },
              ),
            ),

            SizedBox(height: Sizes.height * .04),
          ],
        ),
      ),
    );
  }

  Future<void> postAdmission({
    List<XFile>? documents, // multiple images/files
    XFile? profileImage, // single image
  }) async {
    try {
      final response = await ApiService.uploadFiles(
        endpoint: 'admissionform',
        fields: {
          'licence_no': Preference.getString(PrefKeys.licenseNo),
          'branch_id': Preference.getint(PrefKeys.locationId).toString(),
          'admission_date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
          'student_id': studentIdController.text.trim(),
          'student_name': studentNameController.text.trim(),
          'gender': _selectedGender ?? "Male",
          'marital_status': maritalStatus == 0 ? "Single" : "Married",
          'aadhar_no': aadharNoController.text.trim(),
          'caste': _selectedCaste ?? "OBC",
          'primary_contact_no': contactNoController.text.trim(),
          'whatsapp_no': whatsapppNoController.text.trim(),
          'email': emailIdController.text.trim(),
          'college_name': collegeController.text.trim(),
          'course': courseController.text.trim(),
          'date_of_birth': dobDatepicker.text.trim(),
          'year': yearController.text.trim(),
          'father_name': fatherNameController.text.trim(),
          'mother_name': motherNameController.text.trim(),
          'guardian': guardianNameController.text.trim(),
          'emergency_no': emergencyNoController.text.trim(),
          'parent_contect': parentContactController.text.trim(),
          'permanent_address': permanentAddressController.text.trim(),
          'permanent_state': stateController.text.trim(),
          'permanent_city': cityController.text.trim(),
          'permanent_city_town': permanentareaController.text.trim(),
          'permanent_pin_code': permanentpinCodeController.text.trim(),
          'temporary_address': temporaryAddressController.text.trim(),
          'temporary_state': tempSateController.text.trim(),
          'temporary_city': tempCityController.text.trim(),
          'temporary_city_town': temporaryareaController.text.trim(),
          'temporary_pin_code': temporarypinCodeController.text.trim(),
          'title': "Mr",
          'relation_type': "S/O",
          'ledger_group': "Sundry Debtors",
          'opening_balance': "0",
          'opening_type': "Dr",
        },
        singleFiles: profileImage != null ? {"image": profileImage} : null,
        multiFiles:
            documents != null && documents.isNotEmpty
                ? {"uplode_file[]": documents}
                : null,
      );

      if (response["status"] == true) {
        showCustomSnackbarSuccess(context, response['message']);
        print("✅ Admission data and image(s) uploaded successfully!");
        Navigator.pop(context, "New Data");
      } else {
        showCustomSnackbarError(context, response['message']);
        print("❌ Failed to upload admission data or image(s).");
      }
    } catch (e) {
      showCustomSnackbarError(context, "Upload failed: $e");
      print("❌ Exception while uploading admission: $e");
    }
  }

  Future<bool> updateAdmission({
    List<XFile>? documents, // multiple images/files
    XFile? profileImage, // optional single profile image
  }) async {
    try {
      final response = await ApiService.uploadFiles(
        endpoint: 'admissionform/${admissionData!.id}',
        fields: {
          'licence_no': Preference.getString(PrefKeys.licenseNo),
          'branch_id': Preference.getint(PrefKeys.locationId).toString(),
          'admission_date': DateFormat(
            'dd/MM/yyyy',
          ).format(admissionData!.admissionDate!),
          'student_id': studentIdController.text.trim(),
          'student_name': studentNameController.text.trim(),
          'gender': _selectedGender ?? "Male",
          'marital_status': maritalStatus == 0 ? "Single" : "Married",
          'aadhar_no': aadharNoController.text.trim(),
          'caste': _selectedCaste ?? "OBC",
          'primary_contact_no': contactNoController.text.trim(),
          'whatsapp_no': whatsapppNoController.text.trim(),
          'email': emailIdController.text.trim(),
          'college_name': collegeController.text.trim(),
          'course': courseController.text.trim(),
          'date_of_birth': dobDatepicker.text.trim(),
          'year': yearController.text.trim(),
          'father_name': fatherNameController.text.trim(),
          'mother_name': motherNameController.text.trim(),
          'guardian': guardianNameController.text.trim(),
          'emergency_no': emergencyNoController.text.trim(),
          'parent_contect': parentContactController.text.trim(),
          'permanent_address': permanentAddressController.text.trim(),
          'permanent_state': stateController.text.trim(),
          'permanent_city': cityController.text.trim(),
          'permanent_city_town': permanentareaController.text.trim(),
          'permanent_pin_code': permanentpinCodeController.text.trim(),
          'temporary_address': temporaryAddressController.text.trim(),
          'temporary_state': tempSateController.text.trim(),
          'temporary_city': tempCityController.text.trim(),
          'temporary_city_town': temporaryareaController.text.trim(),
          'temporary_pin_code': temporarypinCodeController.text.trim(),
          'title': "Mr",
          'relation_type': "S/O",
          'ledger_group': "Sundry Debtors",
          'opening_balance': admissionData!.ledger!.openingBalance ?? "",
          'opening_type': admissionData!.ledger!.openingType ?? "",
          '_method': "PUT", // for method override
        },
        singleFiles: profileImage != null ? {"image": profileImage} : null,
        multiFiles:
            documents != null && documents.isNotEmpty
                ? {"uplode_file[]": documents}
                : null,
      );

      if (response["status"] == true) {
        showCustomSnackbarSuccess(context, response['message']);
        return true;
      } else {
        showCustomSnackbarError(context, response['message']);
        print("❌ Failed to update admission.");
        return false;
      }
    } catch (e) {
      showCustomSnackbarError(context, "Update failed: $e");
      print("❌ Exception while updating admission: $e");
      return false;
    }
  }

  int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future getStudentId() async {
    var response = await ApiService.fetchData(
      "next-student-id?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );

    studentIdController.text =
        admissionData != null
            ? admissionData!.studentId!
            : response['next-student-id'].toString();
  }

  Future getStudentDetails() async {
    var response = await ApiService.fetchData(
      "contect/student?student_name=${studentNameController.text}&primary_contact_no=${contactNoController.text}?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      await showDialog(
        context: context,
        barrierDismissible: false, // User must tap button to dismiss
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Warning'),
            content: Text(
              'Student with same name and number already exists\nStudent Id - ${response["data"][0]['student_id']} and Admission Date - ${response["data"][0]['admission_date']}.\nDo you want to proceed with admission?',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(false); // User cancelled
                },
              ),
              ElevatedButton(
                child: const Text('Confirm'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop(true);

                  // multiple documents (XFile)
                  final List<XFile> documents = _documentImages;

                  // single profile image (XFile)
                  final XFile? profile = _profileImage;

                  // Call the new cross-platform uploader
                  await postAdmission(
                    documents: documents,
                    profileImage: profile,
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      // Convert List<XFile> → List<File>
      // multiple documents (XFile)
      final List<XFile> documents = _documentImages;

      // single profile image (XFile)
      final XFile? profile = _profileImage;

      // Call the new cross-platform uploader
      await postAdmission(documents: documents, profileImage: profile);
    }
  }
}
