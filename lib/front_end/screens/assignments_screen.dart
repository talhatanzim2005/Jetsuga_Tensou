import 'package:flutter/material.dart';
import 'package:hackathon/back_end/models.dart';
import 'package:hackathon/back_end/mock_data.dart';
import 'package:hackathon/front_end/theme.dart';
import 'package:hackathon/widget/data_table_view.dart';
import 'package:hackathon/widget/record_form_modal.dart';

/// Assignments table view — ASSIGNMENT | COURSE | DEADLINE columns.
class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
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
      sectionTag: 'Track Your Work',
      title: 'Assignments',
      subtitle: 'Deadlines, submission platforms, and marks — never miss a due date.',
      searchHint: 'Search assignments...',
      columns: const [
        TableCol(label: 'ASSIGNMENT', flex: 3),
        TableCol(label: 'COURSE', flex: 2),
        TableCol(label: 'DEADLINE', flex: 1),
      ],
      rows: _repo.assignments.map((a) {
        return TableRowData(
          cells: [
            // ASSIGNMENT column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  a.title,
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${a.submissionPlatform} · ${a.marks} marks',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            // COURSE column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  a.course,
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(a.courseTitle, style: AppTypography.bodySmall),
              ],
            ),
            // DEADLINE column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  a.deadline,
                  style: AppTypography.body.copyWith(
                    color: _isUrgent(a.deadline) ? AppColors.error : AppColors.contentText,
                    fontWeight: _isUrgent(a.deadline) ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                Text(
                  a.status.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    color: a.status == 'pending' ? AppColors.warning : AppColors.success,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
          onDelete: () => _repo.deleteAssignment(a.id),
        );
      }).toList(),
      onAddRecord: _showAddDialog,
    );
  }

  DateTime? _parseDate(String input) {
    if (input.trim().isEmpty) return null;
    if (input.contains('-')) {
      final parts = input.split('-');
      if (parts.length == 3) {
        if (parts[2].length == 4) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day != null && month != null && year != null) {
            return DateTime(year, month, day);
          }
        }
      }
    }
    return DateTime.tryParse(input);
  }

  bool _isUrgent(String deadline) {
    final d = _parseDate(deadline);
    if (d == null) return false;
    return d.difference(DateTime.now()).inDays <= 3;
  }

  void _showAddDialog() {
    final courseCtrl = TextEditingController();
    final courseTitleCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final assignedCtrl = TextEditingController();
    final deadlineCtrl = TextEditingController();
    final platformCtrl = TextEditingController();
    final marksCtrl = TextEditingController();
    String status = 'pending';

    RecordFormModal.show(
      context: context,
      title: 'Add record',
      fields: [
        FormFieldRow(children: [
          LabeledField(label: 'Course code', controller: courseCtrl),
          LabeledField(label: 'Course title', controller: courseTitleCtrl),
        ]),
        FormFieldRow(children: [
          LabeledField(label: 'Assignment title', controller: titleCtrl),
          LabeledField(label: 'Assigned date', controller: assignedCtrl, hintText: 'DD-MM-YYYY', isDate: true),
        ]),
        FormFieldRow(children: [
          LabeledField(label: 'Deadline', controller: deadlineCtrl, hintText: 'DD-MM-YYYY', isDate: true),
          LabeledField(label: 'Submission platform', controller: platformCtrl),
        ]),
        FormFieldRow(children: [
          StatefulBuilder(
            builder: (context, setFieldState) {
              return LabeledField(
                label: 'Status',
                isDropdown: true,
                dropdownItems: const ['pending', 'submitted', 'graded'],
                dropdownValue: status,
                onDropdownChanged: (v) => setFieldState(() => status = v ?? 'pending'),
              );
            },
          ),
          LabeledField(label: 'Marks', controller: marksCtrl, hintText: 'e.g. 20'),
        ]),
        const SizedBox(height: AppSpacing.sm),
        LabeledField(label: 'Description', controller: descCtrl, maxLines: 3),
      ],
      onSave: () {
        if (courseCtrl.text.isEmpty || titleCtrl.text.isEmpty) return;
        _repo.addAssignment(Assignment(
          id: 'asgn-${DateTime.now().millisecondsSinceEpoch}',
          course: courseCtrl.text,
          courseTitle: courseTitleCtrl.text,
          title: titleCtrl.text,
          description: descCtrl.text,
          assignedDate: assignedCtrl.text,
          deadline: deadlineCtrl.text,
          submissionPlatform: platformCtrl.text,
          status: status,
          marks: int.tryParse(marksCtrl.text) ?? 0,
        ));
      },
    );
  }
}
