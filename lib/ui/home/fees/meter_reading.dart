import 'package:dorm_sync/model/assign_room.dart';
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

class MeterReadingAdd extends StatefulWidget {
  const MeterReadingAdd({super.key});

  @override
  State<MeterReadingAdd> createState() => _MeterReadingAddState();
}

class _MeterReadingAddState extends State<MeterReadingAdd> {
  List<Map<String, dynamic>> buildings = [];
  List<Map<String, dynamic>> floors = [];
  List<Map<String, dynamic>> rooms = [];
  List<Map<String, dynamic>> filteredFloors = [];
  List<Map<String, dynamic>> filteredRooms = [];

  Map<String, dynamic>? selectedBuilding;
  Map<String, dynamic>? selectedFloor;

  List<AssignRoomModel> studentList = [];

  // Room controllers
  Map<int, TextEditingController> openingControllers = {};
  Map<int, TextEditingController> closingControllers = {};
  Map<int, TextEditingController> discountControllers = {};
  Map<int, double> finalPriceValues = {}; // calculated final price

  @override
  void initState() {
    super.initState();
    getBuildings();
    getFloors();
    getRooms();
    getRoomAsign();
  }

  Future<void> getBuildings() async {
    final response = await ApiService.fetchData(
      'building?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}',
    );
    if (response["status"] == true) {
      setState(() {
        buildings = List<Map<String, dynamic>>.from(response["data"]);
      });
    }
  }

  Future<void> getFloors() async {
    final response = await ApiService.fetchData(
      'floor?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}',
    );
    if (response["status"] == true) {
      setState(() {
        floors = List<Map<String, dynamic>>.from(response["data"]);
      });
    }
  }

  Future<void> getRooms() async {
    final response = await ApiService.fetchData(
      'room?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}',
    );
    if (response["status"] == true) {
      setState(() {
        rooms = List<Map<String, dynamic>>.from(response["data"]);
      });
    }
  }

  Future<void> getRoomAsign() async {
    var response = await ApiService.fetchData(
      "roomassign?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      setState(() {
        studentList = assignRoomModelFromJson(response['data']);
      });
    }
  }

  double getUnitPrice() {
    return double.tryParse(Preference.getString(PrefKeys.unitPrice)) ?? 0.0;
  }

  void calculateFinal(int roomId) {
    double opening =
        double.tryParse(openingControllers[roomId]?.text ?? "0") ?? 0;
    double closing =
        double.tryParse(closingControllers[roomId]?.text ?? "0") ?? 0;
    double discount =
        double.tryParse(discountControllers[roomId]?.text ?? "0") ?? 0;
    double unitPrice = getUnitPrice();

    double units = closing - opening - discount;
    double finalPrice = units * unitPrice;

    setState(() {
      finalPriceValues[roomId] = finalPrice;
    });
  }

  Future<void> postMeterReading() async {
    List<Map<String, dynamic>> structure = [];

    for (var room in filteredRooms) {
      int roomId = room["id"];

      // Get students in this room
      final studentsInRoom =
          studentList
              .where((s) => s.roomNo == room["room_no"].toString())
              .toList();

      double openingReading =
          double.tryParse(openingControllers[roomId]?.text ?? "0") ?? 0;
      double closingReading =
          double.tryParse(closingControllers[roomId]?.text ?? "0") ?? 0;
      double discountUnit =
          double.tryParse(discountControllers[roomId]?.text ?? "0") ?? 0;
      double unitPrice = getUnitPrice();

      List<Map<String, dynamic>> studentStructure = [];

      if (studentsInRoom.isNotEmpty) {
        // Sort students by their "other1" start unit
        studentsInRoom.sort(
          (a, b) => (double.tryParse(a.other1 ?? "0") ?? 0).compareTo(
            double.tryParse(b.other1 ?? "0") ?? 0,
          ),
        );

        // Loop through students and calculate units
        for (int i = 0; i < studentsInRoom.length; i++) {
          var s = studentsInRoom[i];
          double studentStart =
              double.tryParse(s.other1 ?? openingReading.toString()) ??
              openingReading;

          double studentEnd;
          if (i < studentsInRoom.length - 1) {
            double nextStudentStart =
                double.tryParse(
                  studentsInRoom[i + 1].other1 ?? closingReading.toString(),
                ) ??
                closingReading;
            studentEnd = nextStudentStart;
          } else {
            studentEnd = closingReading;
          }

          double studentUnits =
              studentEnd - studentStart - discountUnit / studentsInRoom.length;
          studentUnits = studentUnits > 0 ? studentUnits : 0;

          studentStructure.add({
            "hostler_id": s.hostelerId ?? "",
            "student_name": s.hostelerName ?? "",
            "course": s.courseName ?? "",
            "father_name": s.fatherName ?? "",
            "closing_reading": studentUnits.toStringAsFixed(2),
            "price": (studentUnits * unitPrice).toStringAsFixed(2),
          });
        }
      }

      // Calculate total price for the room
      double roomTotalPrice = studentStructure.fold(
        0,
        (sum, s) => sum + double.parse(s["price"] ?? "0"),
      );

      structure.add({
        "room_id": roomId.toString(),
        "room_no": room["room_no"].toString(),
        "opning_reding": openingControllers[roomId]?.text ?? "0",
        "closing_reding": closingControllers[roomId]?.text ?? "0",
        "descount_unit":
            discountControllers[roomId]?.text.trim().isEmpty ?? true
                ? "0"
                : discountControllers[roomId]?.text ?? "0",
        "unit": unitPrice.toString(),
        "price": roomTotalPrice.toStringAsFixed(2),
        "student_structure": studentStructure,
      });
    }

    // Post data to API
    var response = await ApiService.postData("mitareding", {
      "licence_no": Preference.getString(PrefKeys.licenseNo),
      "branch_id": Preference.getint(PrefKeys.locationId).toString(),
      "building": selectedBuilding?["building"] ?? "",
      "floor": selectedFloor?["floor"] ?? "",
      "structure": structure,
    });

    print(structure);

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.width * .02,
          vertical: Sizes.height * .02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Heading
            Container(
              margin: EdgeInsets.only(bottom: Sizes.height * .02),
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    "Meter Reading Entry",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Text(
                          "Back",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Building & Floor Selection
            addMasterOutside(
              children: [
                Row(
                  children: [
                    Image.asset(Images.business, height: 30),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<Map<String, dynamic>>(
                        isExpanded: true,
                        hint: Text("Select Building"),
                        value: selectedBuilding,
                        items:
                            buildings.map((b) {
                              return DropdownMenuItem(
                                value: b,
                                child: Text(b["building"]),
                              );
                            }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedBuilding = val;
                            selectedFloor = null;
                            filteredFloors =
                                floors
                                    .where(
                                      (f) => f["building_id"] == val!["id"],
                                    )
                                    .toList();
                            filteredRooms = [];
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Image.asset(Images.rooms, height: 30),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<Map<String, dynamic>>(
                        isExpanded: true,
                        hint: Text("Select Floor"),
                        value: selectedFloor,
                        items:
                            filteredFloors.map((f) {
                              return DropdownMenuItem(
                                value: f,
                                child: Text(f["floor"]),
                              );
                            }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedFloor = val;
                            filteredRooms =
                                rooms
                                    .where((r) => r["floor_id"] == val!["id"])
                                    .toList();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
              context: context,
            ),

            SizedBox(height: 20),

            /// Rooms List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredRooms.length,
              itemBuilder: (context, index) {
                final room = filteredRooms[index];
                int roomId = room["id"];

                openingControllers.putIfAbsent(
                  roomId,
                  () => TextEditingController(),
                );
                closingControllers.putIfAbsent(
                  roomId,
                  () => TextEditingController(),
                );
                discountControllers.putIfAbsent(
                  roomId,
                  () => TextEditingController(),
                );

                final studentsInRoom =
                    studentList
                        .where((s) => s.roomNo == room["room_no"].toString())
                        .toList();

                return Card(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Room No: ${room["room_no"]} (${room["room_type"]})",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        addMasterOutside5(
                          children: [
                            TitleTextField(
                              image: null,
                              controller: openingControllers[roomId],
                              titileText: "Opening Reading",
                              hintText: '--0.0--',
                              onChanged: (_) => calculateFinal(roomId),
                            ),
                            TitleTextField(
                              image: null,
                              controller: closingControllers[roomId],
                              titileText: "Closing Reading",
                              hintText: '--0.0--',
                              onChanged: (_) => calculateFinal(roomId),
                            ),
                            // TitleTextField(
                            //   image: null,
                            //   controller: discountControllers[roomId],
                            //   titileText: "Discount Unit",
                            //   hintText: '--0.0--',
                            //   onChanged: (_) => calculateFinal(roomId),
                            // ),
                            TitleTextField(
                              image: null,
                              readOnly: true,
                              controller: discountControllers[roomId],
                              titileText: "Final Price:",
                              hintText:
                                  '₹${finalPriceValues[roomId]?.toStringAsFixed(2) ?? "0.0"}',
                              onChanged: (_) => calculateFinal(roomId),
                            ),
                          ],
                          context: context,
                        ),
                        SizedBox(height: 10),

                        Text(
                          "Students:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Wrap(
                          children:
                              studentsInRoom.map((s) {
                                return SizedBox(
                                  width: 300,
                                  child: ListTile(
                                    dense: true,
                                    title: Text(s.hostelerName ?? ""),
                                    subtitle: Text(
                                      "Opening Reading: ${s.other1 ?? ""}",
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            /// Save Button
            Center(
              child: DefaultButton(
                text: "Save All",
                hight: 45,
                width: 160,
                onTap: postMeterReading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
