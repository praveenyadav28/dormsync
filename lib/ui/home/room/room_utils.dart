import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:flutter/material.dart';

class RoomSelectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> buildings;
  final List<Map<String, dynamic>> floors;
  final List<Map<String, dynamic>> rooms;
  final int? selectedBuildingId;
  final int? selectedFloorId;
  final String? selectedRoomType;
  final int? selectedRoomId;
  final void Function(Map<String, dynamic>)? onRoomDetailsSelected;

  final Function(int?) onBuildingChange;
  final Function(int?) onFloorChange;
  final Function(String?) onRoomTypeChange;
  final Function(int?) onRoomChange;

  RoomSelectionWidget({
    super.key,
    required this.buildings,
    required this.floors,
    required this.rooms,
    required this.selectedBuildingId,
    required this.selectedFloorId,
    required this.selectedRoomType,
    required this.selectedRoomId,
    required this.onBuildingChange,
    required this.onFloorChange,
    required this.onRoomTypeChange,
    required this.onRoomChange,
    required this.onRoomDetailsSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filteredFloors =
        selectedBuildingId == null
            ? []
            : floors
                .where((f) => f['building_id'] == selectedBuildingId)
                .toList();

    final filteredRooms =
        (selectedBuildingId != null &&
                selectedFloorId != null &&
                selectedRoomType != null)
            ? rooms
                .where(
                  (r) =>
                      r['building_id'] == selectedBuildingId &&
                      r['floor_id'] == selectedFloorId &&
                      r['room_type'] == selectedRoomType,
                )
                .toList()
            : [];

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 2.2,
      crossAxisSpacing: Sizes.width * .03,
      mainAxisSpacing: Sizes.height * .03,
      children: [
        _dropdown<int>(
          label: "Building",
          value: selectedBuildingId,
          items: buildings,
          getLabel: (b) => b['building'],
          getValue: (b) => b['id'],
          onChanged: onBuildingChange,
        ),
        _dropdown<int>(
          label: "Floor",
          value: selectedFloorId,
          items: filteredFloors,
          getLabel: (f) => f['floor'],
          getValue: (f) => f['id'],
          onChanged: onFloorChange,
        ),
        _dropdown<String>(
          label: "Room Type",
          value: selectedRoomType,
          items: ['A/C', 'Non-A/C'],
          getLabel: (v) => v,
          getValue: (v) => v,
          onChanged: onRoomTypeChange,
        ),
        _dropdown<int>(
          label: "Room No.",
          value: selectedRoomId,
          items: filteredRooms,
          getLabel: (r) => 'Room ${r['room_no']}',
          getValue: (r) => r['id'],
          onChanged: (val) {
            onRoomChange(val);
            final room = filteredRooms.firstWhere(
              (r) => r['id'] == val,
              orElse: () => <String, dynamic>{},
            );
            if (onRoomDetailsSelected != null) {
              onRoomDetailsSelected!(room);
            }
          },
        ),
      ],
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T? value,
    required List items,
    required String Function(dynamic) getLabel,
    required T Function(dynamic) getValue,
    required Function(T?) onChanged,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        DropdownButtonFormField<T>(
          value: value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColor.black,
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          decoration: const InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            hintText: "--Select--",
          ),
          items:
              items
                  .map<DropdownMenuItem<T>>(
                    (item) => DropdownMenuItem<T>(
                      value: getValue(item),
                      child: Text(getLabel(item)),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
