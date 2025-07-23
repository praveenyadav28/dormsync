import 'package:dorm_sync/model/fees_receive.dart';
import 'package:dorm_sync/model/ledger.dart';
import 'package:dorm_sync/model/voucher_model.dart';
import 'package:dorm_sync/ui/home/reports/util.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/navigations.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class LedgerReport extends StatefulWidget {
  const LedgerReport({super.key});

  @override
  State<LedgerReport> createState() => _LedgerReportState();
}

class _LedgerReportState extends State<LedgerReport> {
  final TextEditingController datepickarfrom = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  final TextEditingController datepickarto = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  List<LedgerList> ledgerListSearch = [];

  List<VoucherModel> voucherList = [];
  List<ReceivedListModel> feesReceiveList = [];
  List<LedgerList> ledgerList = [];

  LedgerList? selectedLedger;
  String? ledgerId;
  TextEditingController ledgerNameController = TextEditingController();
  TextEditingController ledgerGroupController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();

  final FocusNode ledgerFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    getLedgers().then((_) {
      // Setup listener after data is set
      ledgerNameController.addListener(() {
        final input = ledgerNameController.text.trim().toLowerCase();
        final found = ledgerListSearch.any(
          (ledger) => (ledger.ledgerName ?? '').trim().toLowerCase() == input,
        );

        if (!found) {
          ledgerGroupController.clear();
          contactNoController.clear();
        }
      });

      setState(() {});
    });
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
                          "Ledger-Report",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Ledger Details  ',
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
                          Image.asset(Images.reports, height: 35),
                          SizedBox(width: 5),
                          Expanded(
                            child: SearchField<LedgerList>(
                              focusNode: ledgerFocusNode,
                              suggestions:
                                  ledgerListSearch
                                      .map(
                                        (e) => SearchFieldListItem<LedgerList>(
                                          e.ledgerName ?? '',
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
                              controller: ledgerNameController,
                              hint: '--Ledger Name--',
                              onSuggestionTap: (selected) async {
                                selectedLedger = selected.item!;
                                ledgerId = selectedLedger!.id.toString();
                                ledgerNameController.text =
                                    selectedLedger!.ledgerName ?? '';
                                ledgerGroupController.text =
                                    selectedLedger!.ledgerGroup ?? '';
                                contactNoController.text =
                                    selectedLedger!.contactNo ?? '';
                              },
                            ),
                          ),
                        ],
                      ),

                      CommonTextFieldBorder(
                        readOnly: true,
                        controller: ledgerGroupController,
                        image: Images.ledgerGroup,
                        hintText: '--Ledger Group--',
                      ),
                      CommonTextFieldBorder(
                        readOnly: true,
                        controller: contactNoController,
                        image: Images.contactNo,
                        hintText: '--Contact No--',
                      ),
                    ],
                    context: context,
                  ),
                  SizedBox(height: Sizes.height * 0.04),
                  addMasterOutside3(
                    children: [
                      DateRange(
                        datepickar1: datepickarfrom,
                        datepickar2: datepickarto,
                      ),
                      Center(
                        child: DefaultButton(
                          text: "Save",
                          hight: 40,
                          width: 150,
                          onTap: () {
                            geLedgerData();
                          },
                        ),
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
              decoration: BoxDecoration(
                color: AppColor.primary.withValues(alpha: .6),
              ),
              alignment: Alignment.center,

              child: Text(
                "Ledger-Report Details",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
            if (ledgerList.isNotEmpty)
              LedgerReportScreen(
                ledger: selectedLedger!,
                feesReceiveList: feesReceiveList,
                voucherList: voucherList,
                fromDate: DateFormat("dd/MM/yyyy").parse(datepickarfrom.text),
                toDate: DateFormat("dd/MM/yyyy").parse(datepickarto.text),
              ),
          ],
        ),
      ),
    );
  }

  Future getLedgers() async {
    var response = await ApiService.fetchData(
      "ledger?licence_no=${Preference.getString(PrefKeys.licenseNo)}",
    );
    if (response["status"] == true) {
      ledgerListSearch =
          ledgerListFromJson(
            response['data'],
          ).where((ledger) => ledger.other1 != "STU").toList();
    }
  }

  Future geLedgerData() async {
    final response = await ApiService.fetchData(
      'ledger_id_name?ledger_id=$ledgerId&ledger_name=${ledgerNameController.text.toString()}',
    );

    if (response["status"] == true) {
      feesReceiveList = feesReceiveModelFromJson(
        response['data']['Fees-Received'],
      );
      ledgerList = ledgerListFromJson(response['data']['Ledger']);
      voucherList = voucherModelFromJson(response['data']['vouchere']);

      setState(() {});
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }
}
