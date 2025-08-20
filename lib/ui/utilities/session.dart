import 'package:dorm_sync/ui/onboarding/splash.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/navigations.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  List<Map<String, dynamic>> financialYears = [];
  TextEditingController datepickarfrom = TextEditingController(
    text: DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now().subtract(Duration(days: 60))),
  );
  TextEditingController datepickarto = TextEditingController(
    text: DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now().add(Duration(days: 30))),
  );

  void addFinancialYear() async {
    showDialog(
      context: context,
      builder:
          (contextDialog) => AlertDialog(
            title: Text("Add Session"),
            content: SizedBox(
              height: 100,
              child: DateRange(
                datepickar1: datepickarfrom,
                datepickar2: datepickarto,
              ),
            ),

            actions: [
              TextButton(
                onPressed: () {
                  postSession().then((value) {
                    getSession().then((value1) {
                      setState(() {});
                    });
                  });
                  Navigator.pop(contextDialog);
                },
                child: Text("Submit"),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();

    loadInitialSession();
  }

  int? _selectedRowIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.width * .02,
          vertical: Sizes.height * .01,
        ),
        child: Column(
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
                    "Change-Session",
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: addFinancialYear,
                    child: Row(
                      children: [
                        Text(
                          "Create  ",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        CircleAvatar(
                          minRadius: 14,
                          backgroundColor: AppColor.black.withValues(alpha: .1),
                          child: Icon(Icons.add, color: AppColor.white),
                        ),
                        SizedBox(width: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Table Header
            Container(
              height: 45,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 115, 124, 135),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'S No',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(width: 1, height: 45, color: AppColor.background),
                  Expanded(
                    flex: 5,
                    child: Text(
                      '     Start Date',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(width: 1, height: 45, color: AppColor.background),

                  Expanded(
                    flex: 5,
                    child: Text(
                      '     End Date',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(width: 1, height: 45, color: AppColor.background),
                  Expanded(
                    child: Text(
                      'Action',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // Table Rows
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: financialYears.length,
              itemBuilder: (context, index) {
                final dateRange = financialYears[index];
                return Container(
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: const Color.fromARGB(255, 182, 181, 181),
                      ),
                      left: BorderSide(
                        color: const Color.fromARGB(255, 182, 181, 181),
                      ),
                      bottom: BorderSide(
                        color: const Color.fromARGB(255, 182, 181, 181),
                      ),
                    ),
                    color: index % 2 == 0 ? AppColor.white : Colors.grey[50],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Radio<int>(
                          value: index,
                          groupValue: _selectedRowIndex,
                          onChanged: (int? value) {
                            if (value != _selectedRowIndex) {
                              showDialog(
                                context: context,
                                builder:
                                    (ctx) => AlertDialog(
                                      title: Text("Change Session"),
                                      content: Text(
                                        "Are you sure you want to change the session?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(ctx), // Cancel
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            updateSession(
                                              dateRange['id'],
                                              dateRange['session_start_date'],
                                              dateRange['session_end_date'],
                                            );
                                            Navigator.pop(ctx); // Close dialog
                                            setState(() {
                                              _selectedRowIndex = value;
                                            });
                                            final selectedSessionId =
                                                financialYears[value!]['id'];
                                            await Preference.setInt(
                                              PrefKeys.sessionId,
                                              selectedSessionId,
                                            );
                                            await Preference.setString(
                                              PrefKeys.sessionDate,
                                              "${financialYears[value]['session_start_date']} - ${financialYears[value]['session_end_date']}",
                                            );
                                            pushNdRemove(SplashScreen());
                                          },
                                          child: Text("Yes"),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          },

                          activeColor: Colors.blueGrey, // Match app bar color
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 45,
                        color: const Color.fromARGB(255, 182, 181, 181),
                      ),

                      Expanded(
                        flex: 5,
                        child: Text(
                          "     ${dateRange['session_start_date']}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 45,
                        color: const Color.fromARGB(255, 182, 181, 181),
                      ),

                      Expanded(
                        flex: 5,
                        child: Text(
                          "     ${dateRange['session_end_date']}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 45,
                        color: const Color.fromARGB(255, 182, 181, 181),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Image.asset(height: 20, Images.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (dialogContext) => AlertDialog(
                                    title: const Text("Warning"),
                                    content: const Text(
                                      "Are you sure you want to delete this session?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () =>
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop(),
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.red,
                                        ),
                                        onPressed: () {
                                          deleteSession(dateRange['id']!).then((
                                            value,
                                          ) {
                                            loadInitialSession().then((value) {
                                              setState(() {
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop();
                                              });
                                            });
                                          });
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
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

  Future postSession() async {
    var response = await ApiService.postData('session', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'session_start_date': datepickarfrom.text.toString(),
      'session_end_date': datepickarto.text.toString(),
      'is_active': false,
    });
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future updateSession(int id, String fromDate, String toDate) async {
    var response = await ApiService.postData(
      'session/$id?licence_no=${Preference.getString(PrefKeys.licenseNo)}',
      {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'session_start_date': fromDate,
        'session_end_date': toDate,
        'is_active': true,
        '_method': 'PUT',
      },
    );
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future<void> getSession() async {
    var response = await ApiService.fetchData(
      "session?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      setState(() {
        financialYears =
            (response['data'] as List<dynamic>)
                .map((item) => Map<String, dynamic>.from(item as Map))
                .toList();
      });
    }
  }

  Future<void> loadInitialSession() async {
    await getSession(); // Load sessions first

    int savedId = Preference.getint(PrefKeys.sessionId);
    if (savedId != 0) {
      // Look for saved session
      for (int i = 0; i < financialYears.length; i++) {
        if (financialYears[i]['id'] == savedId) {
          setState(() {
            _selectedRowIndex = i;
          });
          return;
        }
      }
    }

    // If no saved session, pick the active one
    for (int i = 0; i < financialYears.length; i++) {
      if (financialYears[i]['is_active'] == 1) {
        setState(() {
          _selectedRowIndex = i;
        });
        await Preference.setInt(PrefKeys.sessionId, financialYears[i]['id']);
        return;
      }
    }
  }

  Future deleteSession(int id) async {
    var response = await ApiService.deleteData("session/$id");
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }
}
