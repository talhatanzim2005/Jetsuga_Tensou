import 'package:flutter/material.dart';
import 'package:hackathon/front_end/theme.dart';

/// Column definition for the reusable data table.
class TableCol {
  final String label;
  final double flex;

  const TableCol({required this.label, this.flex = 1.0});
}

/// Row definition for the reusable data table.
class TableRowData {
  /// One widget per column.
  final List<Widget> cells;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TableRowData({
    required this.cells,
    this.onEdit,
    this.onDelete,
  });
}

/// Reusable data table matching the video's clean table layout:
///   Section header → search bar + record count → column headers → data rows.
class CampusDataTable extends StatefulWidget {
  const CampusDataTable({
    super.key,
    required this.sectionTag,
    required this.title,
    required this.subtitle,
    required this.columns,
    required this.rows,
    required this.searchHint,
    this.onAddRecord,
  });

  final String sectionTag;
  final String title;
  final String subtitle;
  final List<TableCol> columns;
  final List<TableRowData> rows;
  final String searchHint;
  final VoidCallback? onAddRecord;

  @override
  State<CampusDataTable> createState() => _CampusDataTableState();
}

class _CampusDataTableState extends State<CampusDataTable> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ──
          _buildSectionHeader(),
          const SizedBox(height: AppSpacing.lg),

          // ── Search + Count + Add Button ──
          _buildToolbar(),
          const SizedBox(height: AppSpacing.md),

          // ── Table ──
          _buildTable(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tag
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    widget.sectionTag.toUpperCase(),
                    style: AppTypography.caption.copyWith(
                      letterSpacing: 1.5,
                      color: AppColors.contentTextMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              // Title
              Text(widget.title, style: AppTypography.h1),
              const SizedBox(height: 4),
              // Subtitle
              Text(
                widget.subtitle,
                style: AppTypography.body.copyWith(
                  color: AppColors.contentTextMuted,
                ),
              ),
            ],
          ),
        ),
        // Add Record Button
        if (widget.onAddRecord != null)
          _AddRecordButton(onPressed: widget.onAddRecord!),
      ],
    );
  }

  List<TableRowData> get _filteredRows {
    if (_searchQuery.trim().isEmpty) return widget.rows;
    final q = _searchQuery.toLowerCase();
    return widget.rows.where((r) {
      return r.cells.any((cell) {
        if (cell is Text) {
          return cell.data?.toLowerCase().contains(q) ?? false;
        }
        return cell.toString().toLowerCase().contains(q);
      });
    }).toList();
  }

  Widget _buildToolbar() {
    final filtered = _filteredRows;
    return Row(
      children: [
        // Search
        SizedBox(
          width: 300,
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: widget.searchHint,
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.contentTextMuted),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: AppSpacing.sm),
              filled: true,
              fillColor: AppColors.contentSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: const BorderSide(color: AppColors.contentDivider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: const BorderSide(color: AppColors.contentDivider),
              ),
            ),
            style: AppTypography.body,
          ),
        ),
        const Spacer(),
        Text(
          '${filtered.length} of ${widget.rows.length} records',
          style: AppTypography.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTable() {
    final filtered = _filteredRows;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.contentSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.contentDivider),
      ),
      child: Column(
        children: [
          // ── Header Row ──
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.tableHeaderBg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.md),
              ),
            ),
            child: Row(
              children: [
                ...widget.columns.map((col) {
                  return Expanded(
                    flex: col.flex.toInt(),
                    child: Text(
                      col.label,
                      style: AppTypography.tableHeader,
                    ),
                  );
                }),
                // Actions spacer
                const SizedBox(width: 64),
              ],
            ),
          ),

          // ── Data Rows ──
          ...filtered.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            final isLast = index == filtered.length - 1;

            return _DataRowWidget(
              row: row,
              columns: widget.columns,
              showBorder: !isLast,
            );
          }),

          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Text(
                  'No records found.',
                  style: AppTypography.body.copyWith(
                    color: AppColors.contentTextMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A single data row with hover effect and edit/delete actions.
class _DataRowWidget extends StatefulWidget {
  const _DataRowWidget({
    required this.row,
    required this.columns,
    required this.showBorder,
  });

  final TableRowData row;
  final List<TableCol> columns;
  final bool showBorder;

  @override
  State<_DataRowWidget> createState() => _DataRowWidgetState();
}

class _DataRowWidgetState extends State<_DataRowWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.tableRowHover : Colors.transparent,
          border: widget.showBorder
              ? const Border(bottom: BorderSide(color: AppColors.tableRowBorder, width: 1))
              : null,
        ),
        child: Row(
          children: [
            ...widget.row.cells.asMap().entries.map((entry) {
              final colIndex = entry.key;
              final cell = entry.value;
              final flex = colIndex < widget.columns.length
                  ? widget.columns[colIndex].flex.toInt()
                  : 1;
              return Expanded(flex: flex, child: cell);
            }),
            // Actions
            SizedBox(
              width: 64,
              child: AnimatedOpacity(
                opacity: _isHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.row.onEdit != null)
                      InkWell(
                        onTap: widget.row.onEdit,
                        borderRadius: BorderRadius.circular(4),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.edit_outlined, size: 16, color: AppColors.contentTextMuted),
                        ),
                      ),
                    if (widget.row.onDelete != null) ...[
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: widget.row.onDelete,
                        borderRadius: BorderRadius.circular(4),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The warm gold "+ Add record" button.
class _AddRecordButton extends StatefulWidget {
  const _AddRecordButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_AddRecordButton> createState() => _AddRecordButtonState();
}

class _AddRecordButtonState extends State<_AddRecordButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.accentDark : AppColors.accent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, size: 18, color: AppColors.sidebarBg),
              const SizedBox(width: 6),
              Text(
                'Add record',
                style: AppTypography.body.copyWith(
                  color: AppColors.sidebarBg,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
