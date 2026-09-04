import 'package:flutter/material.dart';
import 'package:hackathon/front_end/theme.dart';

/// Centered floating white modal for adding/editing campus records.
/// Matches the video's "Add record" dialog style.
class RecordFormModal extends StatelessWidget {
  const RecordFormModal({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
    this.onCancel,
  });

  final String title;
  final List<Widget> fields;
  final VoidCallback onSave;
  final VoidCallback? onCancel;

  /// Show this modal as a dialog.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<Widget> fields,
    required VoidCallback onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (ctx) => RecordFormModal(
        title: title,
        fields: fields,
        onSave: onSave,
        onCancel: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 520,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: AppColors.contentSurface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.md, AppSpacing.sm, 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CAMPUS RECORD',
                          style: AppTypography.caption.copyWith(
                            letterSpacing: 1.5,
                            color: AppColors.contentTextMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(title, style: AppTypography.h4),
                      ],
                    ),
                    IconButton(
                      onPressed: onCancel ?? () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, color: AppColors.contentTextMuted),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // ── Fields ──
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: fields,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Actions ──
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onCancel ?? () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: AppTypography.body.copyWith(
                          color: AppColors.contentTextMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: () {
                        onSave();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.sidebarBg,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_rounded, size: 16, color: AppColors.white),
                            const SizedBox(width: 6),
                            Text(
                              'Save record',
                              style: AppTypography.body.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A labeled form field row (for 2-column layout inside the modal).
class FormFieldRow extends StatelessWidget {
  const FormFieldRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: children.map((child) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: child,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// A single labeled input field for use inside modals.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.isDate = false,
    this.isDropdown = false,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final bool isDate;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final String? dropdownValue;
  final ValueChanged<String?>? onDropdownChanged;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.contentText,
          ),
        ),
        const SizedBox(height: 6),
        if (isDropdown && dropdownItems != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.tableHeaderBg,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.contentDivider),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropdownValue,
                items: dropdownItems!.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item, style: AppTypography.body));
                }).toList(),
                onChanged: onDropdownChanged,
                style: AppTypography.body,
                dropdownColor: AppColors.contentSurface,
              ),
            ),
          )
        else
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: AppTypography.body,
            readOnly: isDate,
            onTap: isDate
                ? () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    final ctrl = controller;
                    if (picked != null && ctrl != null) {
                      final dd = picked.day.toString().padLeft(2, '0');
                      final mm = picked.month.toString().padLeft(2, '0');
                      final yyyy = picked.year.toString();
                      ctrl.text = '$dd-$mm-$yyyy';
                    }
                  }
                : null,
            decoration: InputDecoration(
              hintText: hintText ?? (isDate ? 'DD-MM-YYYY' : label),
              filled: true,
              fillColor: AppColors.tableHeaderBg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: const BorderSide(color: AppColors.contentDivider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: const BorderSide(color: AppColors.contentDivider),
              ),
              suffixIcon: isDate
                  ? const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.contentTextMuted)
                  : null,
            ),
          ),
      ],
    );
  }
}
