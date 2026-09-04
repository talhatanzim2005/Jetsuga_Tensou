import 'package:flutter/material.dart';
import 'package:hackathon/back_end/models.dart';
import 'package:hackathon/back_end/mock_data.dart';
import 'package:hackathon/front_end/theme.dart';
import 'package:hackathon/widget/data_table_view.dart';
import 'package:hackathon/widget/record_form_modal.dart';

/// Events table view — EVENT | VENUE | DATE columns.
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
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
      sectionTag: 'What\'s Happening',
      title: 'Events',
      subtitle: 'Campus events, workshops, and hackathons — register before seats fill up.',
      searchHint: 'Search events...',
      columns: const [
        TableCol(label: 'EVENT', flex: 3),
        TableCol(label: 'VENUE', flex: 2),
        TableCol(label: 'DATE', flex: 1),
      ],
      rows: _repo.events.map((e) {
        return TableRowData(
          cells: [
            // EVENT column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  e.name,
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${e.organizer} · ${e.registered}/${e.capacity} registered',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            // VENUE column
            Text('Room ${e.venue}', style: AppTypography.body),
            // DATE column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e.date, style: AppTypography.body),
                Text(
                  '${e.startTime} – ${e.endTime}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ],
          onDelete: () => _repo.deleteEvent(e.id),
        );
      }).toList(),
      onAddRecord: _showAddDialog,
    );
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();
    final venueCtrl = TextEditingController();
    final orgCtrl = TextEditingController();
    final capCtrl = TextEditingController();

    RecordFormModal.show(
      context: context,
      title: 'Add record',
      fields: [
        FormFieldRow(children: [
          LabeledField(label: 'Event name', controller: nameCtrl),
          LabeledField(label: 'Organizer', controller: orgCtrl),
        ]),
        FormFieldRow(children: [
          LabeledField(label: 'Date', controller: dateCtrl, hintText: 'YYYY-MM-DD', isDate: true),
          LabeledField(label: 'Venue (room)', controller: venueCtrl),
        ]),
        FormFieldRow(children: [
          LabeledField(label: 'Start time', controller: startCtrl, hintText: '09:00'),
          LabeledField(label: 'End time', controller: endCtrl, hintText: '18:00'),
        ]),
        LabeledField(label: 'Capacity', controller: capCtrl, hintText: 'e.g. 50'),
        const SizedBox(height: AppSpacing.sm),
        LabeledField(label: 'Description', controller: descCtrl, maxLines: 3),
      ],
      onSave: () {
        if (nameCtrl.text.isEmpty) return;
        _repo.addEvent(Event(
          id: 'evt-${DateTime.now().millisecondsSinceEpoch}',
          name: nameCtrl.text,
          description: descCtrl.text,
          date: dateCtrl.text,
          startTime: startCtrl.text,
          endTime: endCtrl.text,
          endDate: dateCtrl.text,
          venue: venueCtrl.text,
          organizer: orgCtrl.text,
          capacity: int.tryParse(capCtrl.text) ?? 0,
          registered: 0,
          status: 'upcoming',
        ));
      },
    );
  }
}
