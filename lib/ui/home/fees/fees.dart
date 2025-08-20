import 'package:dorm_sync/model/admission.dart';
import 'package:dorm_sync/model/fees.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/date_change.dart';
import 'package:dorm_sync/utils/decoration.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class FeesEntry extends StatefulWidget {
  const FeesEntry({super.key});

  @override
  State<FeesEntry> createState() => _FeesEntryState();
}

class _FeesEntryState extends State<FeesEntry> {
  FeesList? feesData;

  List<Map<String, dynamic>> feePairs = [];
  final TextEditingController _totalAmtController = TextEditingController();
  final TextEditingController _totalDiscountController =
      TextEditingController();
  final TextEditingController _aditionalDiscountController =
      TextEditingController(text: "0");
  final TextEditingController _totalRemainingController =
      TextEditingController();

  List<AdmissionList> studentList = [];

  String? studentId;
  TextEditingController studentController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController admissionDateController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController feesAsignDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  TextEditingController miscAddNameController = TextEditingController();

  final FocusNode studentFocusNode = FocusNode();
  List<TextEditingController> priceControllers = [];
  List<TextEditingController> dateControllers = [];
  void generateInstallments() {
    final totalPrice = double.tryParse(_totalRemainingController.text);
    final installmentCount = int.tryParse(_installmentCountController.text);

    if (totalPrice != null &&
        installmentCount != null &&
        installmentCount > 0) {
      final pricePerInstallment = (totalPrice / installmentCount)
          .toStringAsFixed(2);

      // Generate price controllers
      priceControllers = List.generate(
        installmentCount,
        (index) => TextEditingController(text: pricePerInstallment),
      );

      // Generate empty date controllers
      dateControllers = List.generate(
        installmentCount,
        (index) => TextEditingController(),
      );

      setState(() {});
    }
  }

  Future<void> pickDate(int index) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formatted = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        dateControllers[index].text = formatted;
      });
    }
  }

  @override
  void initState() {
    _addFeeEntry();
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && feesData == null) {
        feesData = args as FeesList;

        studentController.text = feesData!.hostelerName ?? "";
        studentId = feesData!.hostelerId ?? "";
        studentIdController.text = feesData!.hostelerId ?? "";
        courseController.text = feesData!.courseName ?? "";
        feesAsignDatepicker.text = feesData!.other3 ?? "";
        fatherNameController.text = feesData!.fatherName ?? "";
        _totalAmtController.text = feesData!.totalAmount ?? "";
        _totalDiscountController.text = feesData!.discount?.toString() ?? "0";
        _aditionalDiscountController.text = feesData!.other2?.toString() ?? "0";
        _totalRemainingController.text =
            feesData!.totalRemaining?.toString() ?? "0";

        // Admission Date
        if (feesData!.admissionDate != null) {
          admissionDateController.text = DateFormat(
            'dd/MM/yyyy',
          ).format(feesData!.admissionDate!);
        }

        // EMI Count
        if (feesData!.emiTotal != null && feesData!.emiTotal! > 0) {
          _installmentCountController.text = feesData!.emiTotal.toString();
          _isInstallmentEnabled = true;
          setState(() {});
        }

        // Fees Structure (fill feePairs)
        if (feesData!.feesStructure != null) {
          fillFeePairsFromModel(feesData!);
        }

        if (feesData?.installmentStructure != null &&
            feesData!.installmentStructure!.isNotEmpty) {
          final installments = feesData!.installmentStructure!;

          priceControllers = [];
          dateControllers = [];

          for (var entry in installments) {
            priceControllers.add(
              TextEditingController(text: entry.price?.toString() ?? ''),
            );

            dateControllers.add(
              TextEditingController(text: entry.date?.toString() ?? ''),
            );
          }
        }
      }
    });
    _aditionalDiscountController.addListener(_calculateOverallRemaining);
    ApiService.getGroupList(5, feesType).then((value) {
      setState(() {});
    });
    getHostlers().then((value) {
      setState(() {});
    });
    studentController.addListener(() {
      final input = studentController.text.trim().toLowerCase();
      final found = studentList.any(
        (student) => (student.studentName ?? '').trim().toLowerCase() == input,
      );
      if (!found) {
        courseController.clear();
        fatherNameController.clear();
        admissionDateController.clear();
        studentIdController.clear();
      }
    });
    super.initState();
  }

  List<String> feesType = [];

  String _previousText = '';

  void _addFeeEntry() {
    setState(() {
      final totalFeesController = TextEditingController();
      final discountController = TextEditingController();
      final remainingController = TextEditingController();
      final int newIndex = feePairs.length;
      totalFeesController.addListener(() => _calculateEntryRemaining(newIndex));
      discountController.addListener(() => _calculateEntryRemaining(newIndex));
      feePairs.add({
        'fees_type': null,
        'totalFeesController': totalFeesController,
        'discountController': discountController,
        'remainingController': remainingController,
        'price': 0.0,
        'discount': 0.0,
        'remaining': 0.0,
      });
      _calculateOverallTotals();
    });
  }

  void _removeFeeEntry(int index) {
    setState(() {
      (feePairs[index]['totalFeesController'] as TextEditingController)
          .dispose();
      (feePairs[index]['discountController'] as TextEditingController)
          .dispose();
      (feePairs[index]['remainingController'] as TextEditingController)
          .dispose();
      feePairs.removeAt(index);
      _calculateOverallTotals();
    });
  }

  void _calculateEntryRemaining(int index) {
    final entry = feePairs[index];
    final totalFeesController =
        entry['totalFeesController'] as TextEditingController;
    final discountController =
        entry['discountController'] as TextEditingController;
    final remainingController =
        entry['remainingController'] as TextEditingController;
    final double totalFees = double.tryParse(totalFeesController.text) ?? 0.0;
    final double discount = double.tryParse(discountController.text) ?? 0.0;
    final double remaining = totalFees - discount;
    entry['price'] = totalFees;
    entry['discount'] = discount;
    entry['remaining'] = remaining;
    final String newRemainingText = remaining.toStringAsFixed(2);
    if (remainingController.text != newRemainingText) {
      remainingController.text = newRemainingText;
      remainingController.selection = TextSelection.fromPosition(
        TextPosition(offset: remainingController.text.length),
      );
    }
    _calculateOverallTotals();
  }

  void _calculateOverallTotals() {
    double grandTotalFees = 0.0;
    double grandCalculatedDiscount = 0.0;

    for (var entry in feePairs) {
      grandTotalFees += (entry['price'] as num).toDouble();
      grandCalculatedDiscount += (entry['discount'] as num).toDouble();
    }

    _totalAmtController.text = grandTotalFees.toStringAsFixed(2);
    _totalDiscountController.text = grandCalculatedDiscount.toStringAsFixed(2);
    _calculateOverallRemaining();
  }

  void _calculateOverallRemaining() {
    final double overallTotal =
        double.tryParse(_totalAmtController.text) ?? 0.0;
    final double overallCalculatedDiscount =
        double.tryParse(_totalDiscountController.text) ?? 0.0;
    final double additionalDiscount =
        double.tryParse(_aditionalDiscountController.text) ?? 0.0;
    final double totalRemaining =
        overallTotal - overallCalculatedDiscount - additionalDiscount;
    final String newText = totalRemaining.toStringAsFixed(2);
    if (_totalRemainingController.text != newText) {
      _totalRemainingController.text = newText;
      _totalRemainingController.selection = TextSelection.fromPosition(
        TextPosition(offset: _totalRemainingController.text.length),
      );
    }
  }

  @override
  void dispose() {
    for (var entry in feePairs) {
      (entry['totalFeesController'] as TextEditingController).dispose();
      (entry['discountController'] as TextEditingController).dispose();
      (entry['remainingController'] as TextEditingController).dispose();
    }
    _totalAmtController.dispose();
    _totalDiscountController.dispose();
    _aditionalDiscountController.dispose(); // Dispose the new controller
    _totalRemainingController.dispose();
    _installmentCountController.dispose();
    super.dispose();
  }

  bool _isInstallmentEnabled = false;
  final TextEditingController _installmentCountController =
      TextEditingController();

  void fillFeePairsFromModel(FeesList model) {
    feePairs.clear();
    for (var fs in model.feesStructure ?? []) {
      final totalController = TextEditingController(
        text: fs.price?.toString() ?? '0',
      );
      final discountController = TextEditingController(
        text: fs.discount?.toString() ?? '0',
      );
      final remainingController = TextEditingController(
        text: fs.remaining?.toString() ?? '0',
      );

      final index = feePairs.length;

      totalController.addListener(() => _calculateEntryRemaining(index));
      discountController.addListener(() => _calculateEntryRemaining(index));

      feePairs.add({
        'fees_type': fs.feesType ?? '',
        'price': fs.price ?? 0,
        'discount': fs.discount ?? 0,
        'remaining': fs.remaining ?? 0,
        'totalFeesController': totalController,
        'discountController': discountController,
        'remainingController': remainingController,
      });
    }

    _calculateOverallTotals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: Sizes.width * .02,
                right: Sizes.width * .02,
                bottom: Sizes.height * .05,
                top: Sizes.height * .01,
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
                          "Fees Entry",
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Hosteler Details  ',
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
                  SizedBox(height: Sizes.height * .02),
                  addMasterOutside(
                    children: [
                      Row(
                        children: [
                          Image.asset(Images.studentName, height: 35),
                          SizedBox(width: 5),
                          Expanded(
                            child: SearchField<AdmissionList>(
                              readOnly: feesData != null ? true : false,
                              focusNode: studentFocusNode,
                              suggestions:
                                  studentList
                                      .map(
                                        (e) =>
                                            SearchFieldListItem<AdmissionList>(
                                              e.studentName ?? '',
                                              item: e,
                                            ),
                                      )
                                      .toList(),
                              suggestionState: Suggestion.expand,
                              textInputAction: TextInputAction.next,
                              searchStyle: TextStyle(
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                              suggestionStyle: TextStyle(
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                              searchInputDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: AppColor.white,
                                isDense: true,
                                hintStyle: TextStyle(
                                  color: AppColor.black81,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              controller: studentController,
                              hint: '--Hosteler Name--',
                              onSuggestionTap: (selected) async {
                                final selectedStudent = selected.item!;
                                studentId = selectedStudent.studentId;
                                studentController.text =
                                    selectedStudent.studentName ?? '';
                                studentIdController.text =
                                    selectedStudent.studentId ?? '';
                                admissionDateController.text =
                                    selectedStudent.admissionDate != null
                                        ? DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(selectedStudent.admissionDate!)
                                        : '';
                                courseController.text =
                                    selectedStudent.course ?? '';
                                courseController.text =
                                    selectedStudent.course ?? '';
                                fatherNameController.text =
                                    selectedStudent.fatherName ?? '';
                              },
                            ),
                          ),
                        ],
                      ),
                      CommonTextFieldBorder(
                        readOnly: true,
                        controller: studentIdController,
                        image: Images.studentId,
                        hintText: '--Hosteler ID--',
                      ),
                      CommonTextFieldBorder(
                        readOnly: true,
                        controller: admissionDateController,
                        image: Images.year,
                        hintText: '--Admission Date--',
                      ),
                      Container(),
                      CommonTextFieldBorder(
                        readOnly: true,
                        controller: courseController,
                        image: Images.course,
                        hintText: '--Course Name--',
                      ),
                      CommonTextFieldBorder(
                        readOnly: true,
                        controller: fatherNameController,
                        image: Images.father,
                        hintText: '--Father Name--',
                      ),
                    ],
                    context: context,
                  ),
                ],
              ),
            ),
            Container(
              height: 35,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: Sizes.width * 0.04),
              decoration: BoxDecoration(
                color: AppColor.primary.withValues(alpha: .6),
              ),
              alignment: Alignment.center,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                                    5,
                                    miscAddNameController.text
                                        .trim()
                                        .toString(),
                                    context,
                                    feesType,
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
                    child: Row(
                      children: [
                        CircleAvatar(
                          minRadius: 17,
                          backgroundColor: AppColor.primary,
                          child: Icon(Icons.add, color: AppColor.white),
                        ),
                        Text(
                          "  Add Fees Type",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Fees Structure",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  SizedBox(width: 150),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.width * .02,
                vertical: Sizes.height * .01,
              ),
              child: Column(
                children: [
                  ...List.generate(feePairs.length, (index) {
                    final entry = feePairs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: addMasterOutside5(
                        context: context,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Fees Type",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 7),
                              DropdownButtonFormField<String>(
                                value:
                                    (entry['fees_type'] != null &&
                                            feesType.contains(
                                              entry['fees_type'],
                                            ))
                                        ? entry['fees_type']
                                        : null,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items:
                                    feesType.toSet().map((type) {
                                      return DropdownMenuItem(
                                        value: type,
                                        child: Text(
                                          type,
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    entry['fees_type'] = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: AppColor.white,
                                  border: OutlineInputBorder(),
                                  hintText: "Fees Type",
                                  hintStyle: TextStyle(
                                    color: AppColor.black81,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TitleTextField(
                            image: null,
                            titileText: "Fees Amount",
                            hintText: "0.0",
                            controller: entry['totalFeesController'],
                            // onChanged is not needed here as controller listener handles updates
                          ),
                          TitleTextField(
                            image: null,
                            titileText: "Discount",
                            hintText: "0.0",
                            controller: entry['discountController'],
                            // onChanged is not needed here
                          ),
                          TitleTextField(
                            image: null,
                            titileText: "Remaining Amount",
                            hintText: "0.0",
                            controller: entry['remainingController'],
                            readOnly: true, // Make it read-only
                          ),
                          // Only show delete button if there's more than one entry
                          index == feePairs.length - 1
                              ? Container(
                                margin: EdgeInsets.only(bottom: 10),
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                  onPressed: _addFeeEntry,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blue,
                                  ),
                                  child: Text(
                                    "Add",
                                    style: TextStyle(color: AppColor.white),
                                  ),
                                ),
                              )
                              : InkWell(
                                onTap: () => _removeFeeEntry(index),
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    top: 20.0,
                                  ), // Adjust for alignment with dropdown
                                  child: Icon(
                                    Icons
                                        .remove_circle, // More intuitive icon for removal
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    );
                  }),

                  SizedBox(height: Sizes.height * .04),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: 90,
                              padding: EdgeInsets.all(10),
                              decoration: insideShadow(),
                            ),
                          ),
                          Expanded(flex: 1, child: Container()),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: addMasterOutside5(
                          children: [
                            TitleTextField(
                              image: null,
                              readOnly: true,
                              controller: _totalAmtController,
                              hintText: '0.0',
                              titileText: "Total Amount",
                            ),

                            TitleTextField(
                              image: null,
                              readOnly: true,
                              controller: _totalDiscountController,
                              titileText: "Discount",
                              hintText: "0.0",
                            ),

                            TitleTextField(
                              image: null,
                              titileText: "Additional Discount",
                              hintText: "0.0",
                              controller: _aditionalDiscountController,
                            ),

                            TitleTextField(
                              image: null,
                              readOnly: true,
                              controller: _totalRemainingController,
                              titileText: "Total Remaining",
                              hintText: "0.0",
                            ),
                            TitleTextField(
                              titileText: "Fees Asign Date",
                              image: Images.year,
                              hintText: "--Date--",
                              onPressIcon: () async {
                                selectDate(context, feesAsignDatepicker).then((
                                  onValue,
                                ) {
                                  setState(() {});
                                });
                              },
                              controller: feesAsignDatepicker,
                              onChanged: (val) {
                                bool isValid = smartDateOnChanged(
                                  value: val,
                                  controller: feesAsignDatepicker,
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
                    ],
                  ),
                  SizedBox(height: Sizes.height * .04),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Aligns text and checkbox
                    children: [
                      Text(
                        "Installment Setup (EMI) ?",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Checkbox(
                        value: _isInstallmentEnabled,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isInstallmentEnabled = newValue ?? false;
                            if (!_isInstallmentEnabled) {
                              _installmentCountController.clear();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  if (_isInstallmentEnabled)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TitleTextField(
                              image: null,
                              titileText: "Number of Installments",
                              hintText: "0",
                              controller: _installmentCountController,
                              onChanged: (value) {
                                generateInstallments();
                              },
                            ),
                          ),
                          Expanded(flex: 5, child: Container()),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: Sizes.width,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        ...List.generate(priceControllers.length, (index) {
                          return Container(
                            width: 300,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Installment ${index + 1}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 15),
                                CommonTextField(
                                  image: Images.reports,
                                  hintText: "Price*",
                                  controller: priceControllers[index],
                                ),
                                SizedBox(height: 15),
                                CommonTextField(
                                  image: Images.year,
                                  hintText: "Payment Year*",
                                  controller: dateControllers[index],
                                  readOnly: true,
                                  onTap: () => pickDate(index),
                                ),
                              ],
                            ),
                          );
                        }),
                        priceControllers.length % 3 == 2
                            ? Container(width: 300)
                            : Container(),
                      ],
                    ),
                  ),
                  SizedBox(height: Sizes.height * .05),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: DefaultButton(
                      text: feesData == null ? "Save" : 'Update',
                      hight: 40,
                      width: 150,
                      onTap: () {
                        feesData == null ? postFeesEntry() : updateFeesEntry();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getHostlers() async {
    var response = await ApiService.fetchData(
      "admissionform?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      studentList = admissionListFromJson(response['data']);
    }
  }

  Future postFeesEntry() async {
    // 1. Prepare fees_structure for the API
    List<Map<String, dynamic>> apiFeeStructure = [];
    List<Map<String, dynamic>> installmentStructure = [];
    for (var entry in feePairs) {
      apiFeeStructure.add({
        'fees_type': entry['fees_type'],
        'price': entry['price'],
        'discount': entry['discount'],
        'remaining': entry['remaining'],
      });
    }
    for (int i = 0; i < priceControllers.length; i++) {
      final price = priceControllers[i].text.trim();
      final dateText = dateControllers[i].text.trim();

      if (price.isNotEmpty && dateText.isNotEmpty) {
        try {
          final parsedDate = DateFormat('dd/MM/yyyy').parse(dateText);
          final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

          installmentStructure.add({'price': price, 'date': formattedDate});
        } catch (_) {
          // Handle invalid date if needed
        }
      }
    }

    final double calculatedTotalDiscount =
        double.tryParse(_totalDiscountController.text) ?? 0.0;
    final double additionalDiscount =
        double.tryParse(_aditionalDiscountController.text) ?? 0.0;
    final double totalDiscountForApi =
        calculatedTotalDiscount + additionalDiscount;
    int emiTotal = 0; // Default to 0 if EMI is not enabled or count is invalid
    if (_isInstallmentEnabled) {
      emiTotal = int.tryParse(_installmentCountController.text.trim()) ?? 0;
    }

    var response = await ApiService.postData("feesentry", {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'hosteler_id': studentId,
      'admission_date': admissionDateController.text.trim().toString(),
      'hosteler_name': studentController.text.trim().toString(),
      'course_name': courseController.text.toString(),
      'father_name': fatherNameController.text.toString(),
      'fees_structure': apiFeeStructure,
      'installmant_structure': installmentStructure,
      'total_amount': _totalAmtController.text.toString(),
      'discount': totalDiscountForApi.toStringAsFixed(2),
      'total_remaining': _totalRemainingController.text.toString(),
      'EMI_recived': 0,
      'EMI_total': emiTotal,
      'other2': _aditionalDiscountController.text.toString(),
      'other3': feesAsignDatepicker.text.toString(),
    });

    if (response["status"] == true) {
      // Assuming showCustomSnackbarSuccess and showCustomSnackbarError are defined
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future updateFeesEntry() async {
    // 1. Prepare fees_structure for the API
    List<Map<String, dynamic>> apiFeeStructure = [];
    List<Map<String, dynamic>> installmentStructure = [];
    for (int i = 0; i < priceControllers.length; i++) {
      final price = priceControllers[i].text.trim();
      final dateText = dateControllers[i].text.trim();

      if (price.isNotEmpty && dateText.isNotEmpty) {
        try {
          final parsedDate = DateFormat('dd/MM/yyyy').parse(dateText);
          final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
          installmentStructure.add({'price': price, 'date': formattedDate});
        } catch (e) {
          // handle invalid date format
        }
      }
    }

    for (var entry in feePairs) {
      apiFeeStructure.add({
        'fees_type': entry['fees_type'],
        'price': entry['price'],
        'discount': entry['discount'],
        'remaining': entry['remaining'],
      });
    }

    final double calculatedTotalDiscount =
        double.tryParse(_totalDiscountController.text) ?? 0.0;
    final double additionalDiscount =
        double.tryParse(_aditionalDiscountController.text) ?? 0.0;
    final double totalDiscountForApi =
        calculatedTotalDiscount + additionalDiscount;
    int emiTotal = 0; // Default to 0 if EMI is not enabled or count is invalid
    if (_isInstallmentEnabled) {
      emiTotal = int.tryParse(_installmentCountController.text.trim()) ?? 0;
    }

    var response = await ApiService.postData("feesentry/${feesData!.id}", {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'hosteler_id': studentId,
      'admission_date': admissionDateController.text.trim().toString(),
      'hosteler_name': studentController.text.trim().toString(),
      'course_name': courseController.text.toString(),
      'father_name': fatherNameController.text.toString(),
      'fees_structure': apiFeeStructure,
      'installmant_structure': installmentStructure,
      'total_amount': _totalAmtController.text.toString(),
      'discount': totalDiscountForApi.toStringAsFixed(2),
      'total_remaining': _totalRemainingController.text.toString(),
      'EMI_recived': feesData!.emiRecived ?? 0,
      'EMI_total': emiTotal,
      'other2': _aditionalDiscountController.text.toString(),
      'other3': feesAsignDatepicker.text.toString(),
      '_method': "PUT",
    });

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }
}
