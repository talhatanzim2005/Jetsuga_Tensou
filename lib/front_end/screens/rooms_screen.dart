import 'package:flutter/material.dart';
import 'package:hackathon/back_end/models.dart';
import 'package:hackathon/back_end/mock_data.dart';
import 'package:hackathon/front_end/theme.dart';
import 'package:hackathon/widget/data_table_view.dart';
import 'package:hackathon/widget/record_form_modal.dart';

/// Rooms table view — ROOM | TYPE | STATUS columns.
class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final CampusDataRepository _repo = CampusDataRepository();

  @override
  void initState() {
    super.initState();
    _repo.addListener(_refresh);
  }

  @override
  void dispose() {
    _repo.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return CampusDataTable(
      sectionTag: 'Find Your Corner',
      title: 'Rooms',
      subtitle: 'Check availability, equipment, and the spaces people are using right now.',
      searchHint: 'Search rooms...',
      columns: const [
        TableCol(label: 'ROOM', flex: 3),
        TableCol(label: 'TYPE', flex: 2),
        TableCol(label: 'STATUS', flex: 1),
      ],
      rows: _repo.rooms.map((r) {
        final isAvailable = r.status == 'available';
        return TableRowData(
          cells: [
            // ROOM column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  r.roomNumber,
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${r.capacity} seats · Floor ${r.floor} · ${r.equipment.join(", ")}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            // TYPE column
            Text(r.type, style: AppTypography.body),
            // STATUS column
            Text(
              r.status,
              style: AppTypography.body.copyWith(
                color: isAvailable ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          onDelete: () => _repo.deleteRoom(r.id),
        );
      }).toList(),
      onAddRecord: _showAddDialog,
    );
  }

  void _showAddDialog() {
    final roomNumCtrl = TextEditingController();
    final typeCtrl = TextEditingController();
    final capacityCtrl = TextEditingController();
    final floorCtrl = TextEditingController();
    final equipCtrl = TextEditingController();
    String status = 'available';

    RecordFormModal.show(
      context: context,
      title: 'Add record',
      fields: [
        FormFieldRow(children: [
          LabeledField(label: 'Room number', controller: roomNumCtrl),
          LabeledField(label: 'Type', controller: typeCtrl, hintText: 'classroom / lab / seminar'),
        ]),
        FormFieldRow(children: [
          LabeledField(label: 'Capacity', controller: capacityCtrl, hintText: 'e.g. 45'),
          LabeledField(label: 'Floor', controller: floorCtrl, hintText: 'e.g. 7'),
        ]),
        LabeledField(label: 'Equipment', controller: equipCtrl, hintText: 'projector, AC, whiteboard'),
        const SizedBox(height: AppSpacing.sm),
        StatefulBuilder(
          builder: (context, setFieldState) {
            return LabeledField(
              label: 'Status',
              isDropdown: true,
              dropdownItems: const ['available', 'unavailable'],
              dropdownValue: status,
              onDropdownChanged: (v) => setFieldState(() => status = v ?? 'available'),
            );
          },
        ),
      ],
      onSave: () {
        if (roomNumCtrl.text.isEmpty) return;
        _repo.addRoom(Room(
          id: 'room-${DateTime.now().millisecondsSinceEpoch}',
          roomNumber: roomNumCtrl.text,
          type: typeCtrl.text,
          capacity: int.tryParse(capacityCtrl.text) ?? 0,
          equipment: equipCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
          floor: int.tryParse(floorCtrl.text) ?? 1,
          status: status,
        ));
      },
    );
  }
}
