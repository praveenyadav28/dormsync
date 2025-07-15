import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';

class RoomAllotment extends StatefulWidget {
  const RoomAllotment({super.key});

  @override
  State<RoomAllotment> createState() => _RoomAllotmentState();
}

class _RoomAllotmentState extends State<RoomAllotment> {
  List<Map<String, dynamic>> buildings = [];
  List<Map<String, dynamic>> floors = [];
  List<Map<String, dynamic>> rooms = [];

  List<Map<String, dynamic>> filteredFloors = [];
  List<Map<String, dynamic>> filteredRooms = [];

  String _selectedRoomType = 'A/C';
  final List<String> _roomTypeList = ['A/C', 'Non-A/C'];

  int? selectedBuildingId;
  int? selectedFloorId;
  final TextEditingController floorController = TextEditingController();
  final TextEditingController roomNoController = TextEditingController();
  final TextEditingController bedCountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchAllData().then((value) {});
  }

  Future<void> fetchAllData() async {
    await getBuildings();
    await getFloors();
    await getRooms();
    totalBeds = rooms.fold<int>(0, (previousSum, map) {
      return previousSum + (map["room_beds"] ?? 0) as int;
    });
    totalVacency = rooms.fold<int>(0, (previousSum, map) {
      return previousSum + (map["current_occupants"] ?? 0) as int;
    });
  }

  Future<void> getBuildings() async {
    final response = await ApiService.fetchData('building');
    if (response["status"] == true) {
      setState(() {
        buildings = List<Map<String, dynamic>>.from(response["data"]);
        totalBeds = rooms.fold<int>(0, (previousSum, map) {
          return previousSum + (map["room_beds"] ?? 0) as int;
        });
        totalVacency = rooms.fold<int>(0, (previousSum, map) {
          return previousSum + (map["current_occupants"] ?? 0) as int;
        });
      });
    }
  }

  Future<void> getFloors() async {
    final response = await ApiService.fetchData('floor');
    if (response["status"] == true) {
      setState(() {
        floors = List<Map<String, dynamic>>.from(response["data"]);
        totalBeds = rooms.fold<int>(0, (previousSum, map) {
          return previousSum + (map["room_beds"] ?? 0) as int;
        });
        totalVacency = rooms.fold<int>(0, (previousSum, map) {
          return previousSum + (map["current_occupants"] ?? 0) as int;
        });
      });
    }
  }

  Future<void> getRooms() async {
    final response = await ApiService.fetchData('room');
    if (response["status"] == true) {
      setState(() {
        roomNoController.clear();
        bedCountController.clear();
        rooms = List<Map<String, dynamic>>.from(response["data"]);
        if (selectedBuildingId != null && selectedFloorId != null) {
          filteredRooms =
              rooms
                  .where(
                    (r) =>
                        r['building_id'] == selectedBuildingId &&
                        r['floor_id'] == selectedFloorId,
                  )
                  .toList();
          totalBeds = rooms.fold<int>(0, (previousSum, map) {
            return previousSum + (map["room_beds"] ?? 0) as int;
          });
          totalVacency = rooms.fold<int>(0, (previousSum, map) {
            return previousSum + (map["current_occupants"] ?? 0) as int;
          });
        } else {
          filteredRooms = [];
        }
      });
    }
  }

  Future<void> addBuilding(String name) async {
    final response = await ApiService.postData('building', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'building': name,
    });
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      await getBuildings().then((_) {
        setState(() {
          floorController.clear();
        });
      });
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future<void> addFloor(String name, int buildingId) async {
    final response = await ApiService.postData('floor', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'building_id': buildingId,
      'floor': name,
    });
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      await getFloors().then((_) {
        setState(() {
          floorController.clear();
          filteredFloors =
              floors
                  .where((f) => f['building_id'] == selectedBuildingId)
                  .toList();
        });
      });
      ;
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future<void> addRoom(
    String number,
    String type,
    int beds,
    int buildingId,
    int floorId,
  ) async {
    final response = await ApiService.postData('room', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'building_id': buildingId.toString(),
      'floor_id': floorId.toString(),
      'room_no': number,
      'room_type': type,
      'room_beds': beds.toString(),
      'occupancy_status': "Empty",
      'current_occupants': 0,
    });
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);

      await getRooms();
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  int totalBeds = 0;
  int totalVacency = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                    "Hostel Rooms",
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      var updatedData = await Navigator.of(
                        context,
                      ).pushNamed('/assign Room', arguments: null);
                      if (updatedData == "New Data") {
                        fetchAllData().then((value) {
                          setState(() {});
                        });
                      }
                    },

                    child: Row(
                      children: [
                        Text(
                          "Assign Room  ",
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
            Row(
              children: [
                SizedBox(
                  width: Sizes.width * .7,
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: buildings.length + 1,
                    itemBuilder: (context, index) {
                      if (index < buildings.length) {
                        final building = buildings[index];
                        final isSelected = selectedBuildingId == building['id'];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedBuildingId = building['id'];
                              selectedFloorId = null;
                              filteredRooms = [];
                              filteredFloors =
                                  floors
                                      .where(
                                        (f) =>
                                            f['building_id'] ==
                                            selectedBuildingId,
                                      )
                                      .toList();
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 130,
                            margin: EdgeInsets.only(right: 20),
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Color(0xffC9C4C4),
                                width: .5,
                              ),
                              color:
                                  isSelected
                                      ? AppColor.primary2
                                      : AppColor.white,
                            ),
                            child: Text(
                              building['building'],
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    title: const Text("Add Building"),
                                    content: SizedBox(
                                      width: 250,
                                      child: CommonTextField(
                                        controller: floorController,
                                        image: Images.selectCity,
                                        hintText: "Building Name*",
                                      ),
                                    ),

                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          addBuilding(
                                            floorController.text.trim(),
                                          );
                                          Navigator.pop(ctx);
                                        },
                                        child: const Text("Save"),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColor.black.withOpacity(0.4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Text(
                            '+ Add Building',
                            style: TextStyle(color: AppColor.black),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Total Capacity  :  ',
                          style: TextStyle(color: AppColor.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: '$totalBeds',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Vacancy  :  ',
                          style: TextStyle(color: AppColor.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${totalBeds - totalVacency}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Sizes.height * .02),
            selectedBuildingId == null
                ? Container()
                : Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredFloors.length + 1,
                    itemBuilder: (context, index) {
                      if (index < filteredFloors.length) {
                        final floor = filteredFloors[index];
                        final isSelected = selectedFloorId == floor['id'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFloorId = floor['id'];
                              filteredRooms =
                                  rooms
                                      .where(
                                        (r) =>
                                            r['building_id'] ==
                                                selectedBuildingId &&
                                            r['floor_id'] == selectedFloorId,
                                      )
                                      .toList();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  floor['floor'],
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? AppColor.primary2
                                            : AppColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  height: 3,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? AppColor.primary2
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Center(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: OutlinedButton(
                            onPressed:
                                selectedBuildingId == null
                                    ? null
                                    : () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (ctx) => AlertDialog(
                                              title: const Text("Add Floor"),
                                              content: SizedBox(
                                                width: 250,
                                                child: CommonTextField(
                                                  controller: floorController,
                                                  image: Images.business,
                                                  hintText: "Floor Name*",
                                                ),
                                              ),

                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(ctx),
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    addFloor(
                                                      floorController.text
                                                          .trim(),
                                                      selectedBuildingId!,
                                                    );
                                                    Navigator.pop(ctx);
                                                  },
                                                  child: const Text("Save"),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColor.background,
                              side: BorderSide(
                                color: AppColor.black.withOpacity(0.4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              '+ Add Floor',
                              style: TextStyle(color: AppColor.black),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            SizedBox(height: Sizes.height * .06),
            selectedBuildingId == null || selectedFloorId == null
                ? Container()
                : Wrap(
                  children: List.generate(filteredRooms.length + 1, (index) {
                    if (index == 0) {
                      return Container(
                        width: 100,
                        height: 130,
                        margin: EdgeInsets.only(
                          right: Sizes.width * .02,
                          bottom: Sizes.height * .04,
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColor.black81,
                            width: .5,
                          ),
                        ),
                        child: InkWell(
                          onTap:
                              selectedBuildingId == null ||
                                      selectedFloorId == null
                                  ? null
                                  : () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (ctx) => AlertDialog(
                                            title: const Text("Add Room"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CommonTextField(
                                                  controller: roomNoController,
                                                  image: Images.rooms,
                                                  hintText: "Room Number*",
                                                ),
                                                SizedBox(
                                                  height: Sizes.height * .02,
                                                ),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      Images.addRoom,
                                                      height: 30,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Expanded(
                                                      child: DropdownButtonFormField<
                                                        String
                                                      >(
                                                        value:
                                                            _selectedRoomType,
                                                        icon: Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color:
                                                              AppColor.primary,
                                                        ),
                                                        hint: Text(
                                                          "Room Type",
                                                          style: TextStyle(
                                                            color:
                                                                AppColor
                                                                    .black81,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _selectedRoomType =
                                                                value!;
                                                          });
                                                        },
                                                        items:
                                                            _roomTypeList.map((
                                                              roomType,
                                                            ) {
                                                              return DropdownMenuItem(
                                                                value: roomType,
                                                                child: Text(
                                                                  roomType,
                                                                  style: TextStyle(
                                                                    color:
                                                                        AppColor
                                                                            .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    // height: 2,
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                        decoration: InputDecoration(
                                                          isDense: true,
                                                          border:
                                                              UnderlineInputBorder(),
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 12,
                                                                vertical: 10,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                SizedBox(
                                                  height: Sizes.height * .02,
                                                ),
                                                CommonTextField(
                                                  controller:
                                                      bedCountController,
                                                  image: Images.department,
                                                  hintText: "Beds Count*",
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(ctx),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  addRoom(
                                                    roomNoController.text
                                                        .trim(),
                                                    _selectedRoomType,
                                                    int.tryParse(
                                                          bedCountController
                                                              .text
                                                              .trim(),
                                                        ) ??
                                                        0,
                                                    selectedBuildingId!,
                                                    selectedFloorId!,
                                                  );
                                                  Navigator.pop(ctx);
                                                },
                                                child: const Text("Save"),
                                              ),
                                            ],
                                          ),
                                    );
                                  },

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(Images.addRoom),
                              SizedBox(height: 10),
                              Text(
                                '+ Add Room',
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final room = filteredRooms[index - 1];
                      return Padding(
                        padding: EdgeInsets.only(right: Sizes.width * .02),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 130,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      room['occupancy_status']
                                              .toString()
                                              .contains("Full")
                                          ? AppColor.red
                                          : room['occupancy_status']
                                              .toString()
                                              .contains("Left")
                                          ? AppColor.primary
                                          : AppColor.blue,
                                  width: .5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Room no",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${room['room_no']}",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "${room['room_type']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 85,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    room['occupancy_status']
                                            .toString()
                                            .contains("Full")
                                        ? AppColor.red
                                        : room['occupancy_status']
                                            .toString()
                                            .contains("Left")
                                        ? AppColor.primary
                                        : AppColor.blue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "(${room['room_beds']}) ${room['occupancy_status'].toString().contains("Left") ? "${room['room_beds'] - room['current_occupants']} Left" : room['occupancy_status']}",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColor.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    floorController.dispose();
    roomNoController.dispose();
    bedCountController.dispose();
    super.dispose();
  }
}
