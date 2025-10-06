import 'package:aim/domain/entities/table_filter.dart';
import 'package:flutter/material.dart';
import 'package:aim/core/_ext/build_context_ext.dart';
import 'package:aim/core/theme/theme_helper.dart';
import 'package:aim/presentation/design/wrapper/text_wrapper.dart';

/// Configuration for a table column
class TableColumn<T> {
  final String label;
  final String id;
  final double? width;
  final int flex;
  final String Function(T) getValue;
  final Widget Function(T, BuildContext)? customBuilder;
  final bool sortable;
  final bool searchable;
  final bool numeric; // For Material Design alignment

  TableColumn({
    required this.label,
    required this.id,
    required this.getValue,
    this.width,
    this.flex = 1,
    this.customBuilder,
    this.sortable = true,
    this.searchable = false,
    this.numeric = false,
  });
}


/// Material Design 2 Advanced Data Table Widget
class AdvancedDataTable<T> extends StatefulWidget {
  final List<T> data;
  final List<TableColumn<T>> columns;
  final List<TableFilter<T>> filters;
  final Function(T)? onRowTap;
  final Function(T)? onEdit;
  final Function(T)? onDelete;
  final String title;
  final IconData titleIcon;
  final VoidCallback? onAdd;
  final String? addButtonLabel;
  final List<int> rowsPerPageOptions;
  final int initialRowsPerPage;
  final bool showToolbar;
  final bool dense;
  final Color? Function(T, BuildContext)? getRowColor;

  const AdvancedDataTable({
    super.key,
    required this.data,
    required this.columns,
    this.filters = const [],
    this.onRowTap,
    this.onEdit,
    this.onDelete,
    required this.title,
    this.titleIcon = Icons.table_chart,
    this.onAdd,
    this.addButtonLabel,
    this.rowsPerPageOptions = const [5, 10, 20, 50],
    this.initialRowsPerPage = 10,
    this.showToolbar = true,
    this.dense = false,
    this.getRowColor,
  });

  @override
  State<AdvancedDataTable<T>> createState() => _AdvancedDataTableState<T>();
}

class _AdvancedDataTableState<T> extends State<AdvancedDataTable<T>> {
  late List<T> _filteredData;
  T? _selectedItem;

  // Pagination
  late int _currentPage;
  late int _rowsPerPage;

  // Search
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sort
  String _sortColumn = '';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _rowsPerPage = widget.initialRowsPerPage;
    _sortColumn = widget.columns.first.id;
    _applyFiltersAndSort();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        _currentPage = 0;
        _applyFiltersAndSort();
      });
    });
  }

  @override
  void didUpdateWidget(AdvancedDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _applyFiltersAndSort();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSort() {
    _filteredData = widget.data.where((item) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        bool matchFound = false;
        for (var column in widget.columns.where((c) => c.searchable)) {
          if (column.getValue(item).toLowerCase().contains(query)) {
            matchFound = true;
            break;
          }
        }
        if (!matchFound) return false;
      }

      // Apply all filters
      for (var filter in widget.filters) {
        if (!filter.apply(item)) return false;
      }

      return true;
    }).toList();

    _sortData();
  }

  void _sortData() {
    final column = widget.columns.firstWhere((c) => c.id == _sortColumn);
    _filteredData.sort((a, b) {
      final comparison = column.getValue(a).compareTo(column.getValue(b));
      return _sortAscending ? comparison : -comparison;
    });
  }

  void _sort(String columnId) {
    setState(() {
      if (_sortColumn == columnId) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = columnId;
        _sortAscending = true;
      }
      _sortData();
    });
  }

  List<T> get _paginatedData {
    final start = _currentPage * _rowsPerPage;
    final end = start + _rowsPerPage;
    if (start >= _filteredData.length) return [];
    return _filteredData.sublist(start, end.clamp(0, _filteredData.length));
  }

  int get _totalPages => (_filteredData.length / _rowsPerPage).ceil();

  double get _rowHeight => widget.dense ? 36.0 : 52.0;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        // Material Design Toolbar (optional)
        if (widget.showToolbar) _buildToolbar(context),

        // Table Header
        _buildTableHeader(context),

        // Table Body
        Expanded(
          child: _paginatedData.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  itemCount: _paginatedData.length,
                  itemBuilder: (context, index) => _buildTableRow(context, index),
                ),
        ),

        // Footer with Pagination
        _buildFooter(context),
      ],
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final theme = Theme.of(context);
    final hasActiveFilters = widget.filters.any((f) => f.isActive);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ThemeHelper.getIndent(2),
        vertical: ThemeHelper.getIndent(),
      ),
      color: context.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title and action button
          Row(
            children: [
              Icon(widget.titleIcon, color: context.colorScheme.primary),
              SizedBox(width: ThemeHelper.getIndent()),
              Expanded(
                child: TextWrapper(
                  widget.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (widget.onAdd != null)
                IconButton(
                  onPressed: widget.onAdd,
                  icon: const Icon(Icons.add),
                  tooltip: widget.addButtonLabel ?? 'Add',
                ),
            ],
          ),

          SizedBox(height: ThemeHelper.getIndent()),

          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: ThemeHelper.getIndent(0.75),
              ),
              border: const OutlineInputBorder(),
            ),
          ),

          // Filter chips
          if (widget.filters.isNotEmpty) ...[
            SizedBox(height: ThemeHelper.getIndent()),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 200, // Limit height for filter section
              ),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: ThemeHelper.getIndent(),
                  runSpacing: ThemeHelper.getIndent(0.5),
                  children: [
                    for (var filter in widget.filters)
                      FilterChip(
                        label: Text(filter.getDisplayText()),
                        selected: filter.isActive,
                        onSelected: (_) async {
                          await filter.showFilterDialog(context);
                          setState(() {
                            _currentPage = 0;
                            _applyFiltersAndSort();
                          });
                        },
                      ),

                    if (hasActiveFilters)
                      ActionChip(
                        label: const Text('Clear filters'),
                        onPressed: () {
                          setState(() {
                            for (var filter in widget.filters) {
                              filter.clear();
                            }
                            _currentPage = 0;
                            _applyFiltersAndSort();
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],

          // Results count
          if (_searchQuery.isNotEmpty || hasActiveFilters) ...[
            SizedBox(height: ThemeHelper.getIndent(0.5)),
            TextWrapper(
              '${_filteredData.length} of ${widget.data.length} results',
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {

    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: ThemeHelper.getIndent(2)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          for (var column in widget.columns)
            _buildHeaderCell(column, context),
          if (widget.onEdit != null || widget.onDelete != null)
            SizedBox(width: 80, child: Container()),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(TableColumn<T> column, BuildContext context) {
    final theme = Theme.of(context);
    final isActive = _sortColumn == column.id;

    Widget cell = InkWell(
      onTap: column.sortable ? () => _sort(column.id) : null,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ThemeHelper.getIndent(0.5),
          vertical: ThemeHelper.getIndent(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: column.numeric ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (column.numeric && column.sortable) ...[
              Icon(
                isActive
                    ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                    : Icons.unfold_more,
                size: 18,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.38),
              ),
              SizedBox(width: ThemeHelper.getIndent(0.25)),
            ],
            Flexible(
              child: TextWrapper(
                column.label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.87),
                ),
              ),
            ),
            if (!column.numeric && column.sortable) ...[
              SizedBox(width: ThemeHelper.getIndent(0.25)),
              Icon(
                isActive
                    ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                    : Icons.unfold_more,
                size: 18,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.38),
              ),
            ],
          ],
        ),
      ),
    );

    if (column.width != null) {
      return SizedBox(width: column.width, child: cell);
    } else {
      return Expanded(flex: column.flex, child: cell);
    }
  }

  Widget _buildTableRow(BuildContext context, int index) {
    final item = _paginatedData[index];
    final isSelected = _selectedItem == item;
    final globalIndex = _currentPage * _rowsPerPage + index;

    return InkWell(
      onTap: widget.onRowTap != null
          ? () {
              setState(() {
                _selectedItem = isSelected ? null : item;
              });
              if (!isSelected) {
                widget.onRowTap!(item);
              }
            }
          : null,
      child: Container(
        height: _rowHeight,
        padding: EdgeInsets.symmetric(horizontal: ThemeHelper.getIndent(2)),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primaryContainer.withValues(alpha: 0.12)
              : (globalIndex.isEven
                  ? Colors.transparent
                  : context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.05)),
          border: Border(
            bottom: BorderSide(
              color: context.colorScheme.outline.withValues(alpha: 0.12),
            ),
          ),
        ),
        child: Row(
          children: [
            for (var column in widget.columns)
              _buildDataCell(column, item, context),
            if (widget.onEdit != null || widget.onDelete != null)
              SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.onEdit != null)
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: () => widget.onEdit!(item),
                        tooltip: 'Edit',
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    if (widget.onDelete != null)
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: context.colorScheme.error,
                        ),
                        onPressed: () => widget.onDelete!(item),
                        tooltip: 'Delete',
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCell(TableColumn<T> column, T item, BuildContext context) {
    final theme = Theme.of(context);

    Widget cellContent;
    if (column.customBuilder != null) {
      cellContent = column.customBuilder!(item, context);
    } else {
      cellContent = TextWrapper(
        column.getValue(item),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurface.withValues(alpha: 0.87),
        ),
      );
    }

    final cell = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ThemeHelper.getIndent(0.5),
        vertical: ThemeHelper.getIndent(0.5),
      ),
      child: Align(
        alignment: column.numeric ? Alignment.centerRight : Alignment.centerLeft,
        child: cellContent,
      ),
    );

    if (column.width != null) {
      return SizedBox(width: column.width, child: cell);
    } else {
      return Expanded(flex: column.flex, child: cell);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: context.colorScheme.onSurface.withValues(alpha: 0.38),
          ),
          SizedBox(height: ThemeHelper.getIndent(2)),
          TextWrapper(
            'No results found',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: ThemeHelper.getIndent()),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.colorScheme.outline.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),
          TextWrapper(
            'Rows per page:',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(width: ThemeHelper.getIndent()),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _rowsPerPage,
              items: widget.rowsPerPageOptions.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: TextWrapper('$value'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _rowsPerPage = value;
                    _currentPage = 0;
                  });
                }
              },
            ),
          ),
          SizedBox(width: ThemeHelper.getIndent(3)),
          TextWrapper(
            '${_currentPage * _rowsPerPage + 1}–${(_currentPage * _rowsPerPage + _paginatedData.length).clamp(0, _filteredData.length)} of ${_filteredData.length}',
            style: theme.textTheme.bodySmall,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 0
                ? () => setState(() => _currentPage--)
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < _totalPages - 1
                ? () => setState(() => _currentPage++)
                : null,
          ),
        ],
      ),
    );
  }
}