import 'package:flutter/material.dart';
import 'package:hackathon/back_end/models.dart';
import 'package:hackathon/back_end/mock_data.dart';
import 'package:hackathon/front_end/theme.dart';
import 'package:hackathon/widget/data_table_view.dart';
import 'package:hackathon/widget/record_form_modal.dart';

/// Announcements table view — ANNOUNCEMENT | PRIORITY | EXPIRES columns.
class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
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

  @override
  Widget build(BuildContext context) {
    return CampusDataTable(
      sectionTag: 'Stay in the Loop',
      title: 'Announcements',
      subtitle: 'Notices, updates, and important information from your campus.',
      searchHint: 'Search announcements...',
      columns: const [
        TableCol(label: 'ANNOUNCEMENT', flex: 3),
        TableCol(label: 'PRIORITY', flex: 1),
        TableCol(label: 'EXPIRES', flex: 1),
      ],
      rows: _repo.announcements.map((a) {
        final isStale = _parseDate(a.expires)?.isBefore(DateTime.now()) ?? false;
        return TableRowData(
          cells: [
            // ANNOUNCEMENT column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  a.title,
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${a.postedBy} · Posted ${a.date}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            // PRIORITY column
            _PriorityBadge(priority: a.priority),
            // EXPIRES column
            Row(
              children: [
                Text(
                  a.expires,
                  style: AppTypography.body.copyWith(
                    color: isStale ? AppColors.error : AppColors.contentText,
                  ),
                ),
                if (isStale) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warningBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'STALE',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.warning,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
          onDelete: () => _repo.deleteAnnouncement(a.id),
        );
      }).toList(),
      onAddRecord: _showAddDialog,
    );
  }

  void _showAddDialog() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    final postedByCtrl = TextEditingController();
    final expiresCtrl = TextEditingController();
    String priority = 'medium';

    RecordFormModal.show(
      context: context,
      title: 'Add record',
      fields: [
        LabeledField(label: 'Title', controller: titleCtrl),
        const SizedBox(height: AppSpacing.sm),
        FormFieldRow(children: [
          LabeledField(label: 'Posted by', controller: postedByCtrl),
          LabeledField(label: 'Expires', controller: expiresCtrl, hintText: 'DD-MM-YYYY', isDate: true),
        ]),
        StatefulBuilder(
          builder: (context, setFieldState) {
            return LabeledField(
              label: 'Priority',
              isDropdown: true,
              dropdownItems: const ['low', 'medium', 'high'],
              dropdownValue: priority,
              onDropdownChanged: (v) => setFieldState(() => priority = v ?? 'medium'),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        LabeledField(label: 'Body', controller: bodyCtrl, maxLines: 4),
      ],
      onSave: () {
        if (titleCtrl.text.isEmpty) return;
        _repo.addAnnouncement(Announcement(
          id: 'ann-${DateTime.now().millisecondsSinceEpoch}',
          title: titleCtrl.text,
          body: bodyCtrl.text,
          date: DateTime.now().toString().substring(0, 10),
          priority: priority,
          postedBy: postedByCtrl.text,
          expires: expiresCtrl.text,
        ));
      },
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (priority) {
      case 'high':
        bgColor = AppColors.errorBg;
        textColor = AppColors.error;
        break;
      case 'medium':
        bgColor = AppColors.warningBg;
        textColor = AppColors.warning;
        break;
      default:
        bgColor = AppColors.successBg;
        textColor = AppColors.success;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          priority.toUpperCase(),
          style: AppTypography.caption.copyWith(
            color: textColor,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
