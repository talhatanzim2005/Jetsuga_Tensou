import 'package:flutter/material.dart';
import 'package:hackathon/back_end/models.dart';
import 'package:hackathon/back_end/mock_data.dart';
import 'package:hackathon/front_end/theme.dart';
import 'package:hackathon/widget/data_table_view.dart';
import 'package:hackathon/widget/record_form_modal.dart';

/// Schedule table view — COURSE | WHEN | WHERE columns.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
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
      sectionTag: 'Your Week at a Glance',
      title: 'Schedule',
      subtitle: 'Classes with the details you actually need to get there on time.',
      searchHint: 'Search schedule...',
      columns: const [
        TableCol(label: 'COURSE', flex: 3),
        TableCol(label: 'WHEN', flex: 2),
        TableCol(label: 'WHERE', flex: 1),
      ],
      rows: _repo.schedules.map((s) {
        return TableRowData(
          cells: [
            // COURSE column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  s.course,
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${s.title} · ${s.instructor}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            // WHEN column
            Text(
              '${s.day}\n${s.startTime} – ${s.endTime}',
              style: AppTypography.body.copyWith(color: AppColors.contentText),
            ),
            // WHERE column
            Text(
              s.room,
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
          onEdit: null,
          onDelete: () => _repo.deleteSchedule(s.id),
        );
      }).toList(),
      onAddRecord: _showAddDialog,
    );
  }

  void _showAddDialog() {
    final courseCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final dayCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();
    final roomCtrl = TextEditingController();
    final instrCtrl = TextEditingController();
    final sectionCtrl = TextEditingController();

    RecordFormModal.show(
      context: context,
      title: 'Add record',
      fields: [
        FormFieldRow(children: [
          LabeledField(label: 'Course code', controller: courseCtrl),
          LabeledField(label: 'Course title', controller: titleCtrl),
        ]),
        FormFieldRow(children: [
          LabeledField(label: 'Day', controller: dayCtrl, hintText: 'e.g. Sunday'),
          LabeledField(label: 'Section', controller: sectionCtrl),
        ]),
        FormFieldRow(children: [
          LabeledField(label: 'Start time', controller: startCtrl, hintText: '08:00'),
          LabeledField(label: 'End time', controller: endCtrl, hintText: '09:30'),
        ]),
        FormFieldRow(children: [
          LabeledField(label: 'Room', controller: roomCtrl),
          LabeledField(label: 'Instructor', controller: instrCtrl),
        ]),
      ],
      onSave: () {
        if (courseCtrl.text.isEmpty) return;
        _repo.addSchedule(Schedule(
          id: 'sch-${DateTime.now().millisecondsSinceEpoch}',
          course: courseCtrl.text,
          title: titleCtrl.text,
          day: dayCtrl.text,
          startTime: startCtrl.text,
          endTime: endCtrl.text,
          room: roomCtrl.text,
          instructor: instrCtrl.text,
          section: sectionCtrl.text,
        ));
      },
    );
  }
}
