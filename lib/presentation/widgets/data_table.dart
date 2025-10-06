// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:aim/core/theme/theme_helper.dart';
import 'package:aim/core/_ext/build_context_ext.dart';
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

  TableColumn({
    required this.label,
    required this.id,
    required this.getValue,
    this.width,
    this.flex = 1,
    this.customBuilder,
    this.sortable = true,
    this.searchable = false,
  });
}

/// Configuration for a filter
abstract class TableFilter<T> {
  final String label;
  final String id;

  TableFilter({required this.label, required this.id});

  bool apply(T item);
  Widget buildFilterChip(BuildContext context, VoidCallback onTap);
  Future<void> showFilterDialog(BuildContext context);
}

/// Enum filter implementation
class EnumTableFilter<T, E extends Enum> extends TableFilter<T> {
  final E? selectedValue;
  final List<E> values;
  final E? Function(T) getEnum;
  final Function(E?) onChanged;

  EnumTableFilter({
    required super.label,
    required super.id,
    required this.values,
    required this.getEnum,
    required this.onChanged,
    this.selectedValue,
  });

  @override
  bool apply(T item) {
    if (selectedValue == null) return true;
    return getEnum(item) == selectedValue;
  }

  @override
  Widget buildFilterChip(BuildContext context, VoidCallback onTap) {
    return FilterChip(
      label: TextWrapper(
        selectedValue == null ? '$label: All' : '$label: ${selectedValue!.name}',
      ),
      selected: selectedValue != null,
      onSelected: (_) => onTap(),
    );
  }

  @override
  Future<void> showFilterDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: TextWrapper('Filter by $label'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<E?>(
              title: const TextWrapper('All'),
              value: null,
              groupValue: selectedValue,
              onChanged: (value) {
                onChanged(value);
                Navigator.pop(context);
              },
            ),
            ...values.map((value) => RadioListTile<E?>(
              title: TextWrapper(value.name),
              value: value,
              groupValue: selectedValue,
              onChanged: (val) {
                onChanged(val);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }
}

/// Date range filter implementation
class DateRangeTableFilter<T> extends TableFilter<T> {
  final DateTime? from;
  final DateTime? to;
  final DateTime Function(T) getDate;
  final Function(DateTime?, DateTime?) onChanged;

  DateRangeTableFilter({
    required super.label,
    required super.id,
    required this.getDate,
    required this.onChanged,
    this.from,
    this.to,
  });

  @override
  bool apply(T item) {
    final date = getDate(item);
    if (from != null && date.isBefore(from!)) return false;
    if (to != null && date.isAfter(to!)) return false;
    return true;
  }

  @override
  Widget buildFilterChip(BuildContext context, VoidCallback onTap) {
    return FilterChip(
      label: TextWrapper(
        from == null && to == null ? '$label: All' : '$label: Filtered',
      ),
      selected: from != null || to != null,
      onSelected: (_) => onTap(),
    );
  }

  @override
  Future<void> showFilterDialog(BuildContext context) async {
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: from != null && to != null
          ? DateTimeRange(start: from!, end: to!)
          : null,
    );

    if (result != null) {
      onChanged(result.start, result.end);
    }
  }
}

/// Number range filter implementation
class NumberRangeTableFilter<T> extends TableFilter<T> {
  final num? min;
  final num? max;
  final num Function(T) getNumber;
  final Function(num?, num?) onChanged;

  NumberRangeTableFilter({
    required super.label,
    required super.id,
    required this.getNumber,
    required this.onChanged,
    this.min,
    this.max,
  });

  @override
  bool apply(T item) {
    final number = getNumber(item);
    if (min != null && number < min!) return false;
    if (max != null && number > max!) return false;
    return true;
  }

  @override
  Widget buildFilterChip(BuildContext context, VoidCallback onTap) {
    return FilterChip(
      label: TextWrapper(
        min == null && max == null
            ? '$label: All'
            : '$label: ${min ?? '0'}-${max ?? '∞'}',
      ),
      selected: min != null || max != null,
      onSelected: (_) => onTap(),
    );
  }

  @override
  Future<void> showFilterDialog(BuildContext context) async {
    num? tempMin = min;
    num? tempMax = max;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: TextWrapper('Filter by $label'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Min'),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: tempMin?.toString() ?? ''),
              onChanged: (value) => tempMin = num.tryParse(value),
            ),
            SizedBox(height: ThemeHelper.getIndent()),
            TextField(
              decoration: const InputDecoration(labelText: 'Max'),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: tempMax?.toString() ?? ''),
              onChanged: (value) => tempMax = num.tryParse(value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const TextWrapper('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onChanged(tempMin, tempMax);
              Navigator.pop(context);
            },
            child: const TextWrapper('Apply'),
          ),
        ],
      ),
    );
  }
}

/// Reusable Advanced Data Table Widget
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        return Column(
          children: [
            // Header with search and filters
            Container(
              padding: EdgeInsets.all(ThemeHelper.getIndent(2)),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer,
                border: Border(
                  bottom: BorderSide(
                    color: context.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(widget.titleIcon, color: context.colorScheme.primary),
                      SizedBox(width: ThemeHelper.getIndent()),
                      TextWrapper(
                        widget.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: context.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextWrapper(
                        '${_filteredData.length} of ${widget.data.length}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ThemeHelper.getIndent()),

                  // Search bar
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: context.colorScheme.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: context.colorScheme.outline.withValues(alpha: 0.3),
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(
                                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: context.colorScheme.primary,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () => _searchController.clear(),
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: ThemeHelper.getIndent(2),
                                vertical: ThemeHelper.getIndent(1.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (isWide && widget.onAdd != null) ...[
                        SizedBox(width: ThemeHelper.getIndent()),
                        ElevatedButton.icon(
                          onPressed: widget.onAdd,
                          icon: const Icon(Icons.add),
                          label: TextWrapper(widget.addButtonLabel ?? 'Add'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: ThemeHelper.getIndent(2),
                              vertical: ThemeHelper.getIndent(1.5),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Filters
                  if (widget.filters.isNotEmpty) ...[
                    SizedBox(height: ThemeHelper.getIndent()),
                    SizedBox(
                      height: 48,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var filter in widget.filters) ...[
                            filter.buildFilterChip(context, () async {
                              await filter.showFilterDialog(context);
                              setState(() {
                                _currentPage = 0;
                                _applyFiltersAndSort();
                              });
                            }),
                            SizedBox(width: ThemeHelper.getIndent()),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Table Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ThemeHelper.getIndent(2),
                vertical: ThemeHelper.getIndent(),
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                border: Border(
                  bottom: BorderSide(
                    color: context.colorScheme.outline,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  for (var column in widget.columns)
                    _buildHeader(column, context),
                  if (widget.onEdit != null || widget.onDelete != null)
                    const SizedBox(width: 80),
                ],
              ),
            ),

            // Table Body
            Expanded(
              child: _paginatedData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: context.colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                          SizedBox(height: ThemeHelper.getIndent(2)),
                          TextWrapper(
                            'No results found',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _paginatedData.length,
                      itemBuilder: (context, index) {
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
                            padding: EdgeInsets.symmetric(
                              horizontal: ThemeHelper.getIndent(2),
                              vertical: ThemeHelper.getIndent(1.5),
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? context.colorScheme.primaryContainer.withValues(alpha: 0.3)
                                  : widget.getRowColor?.call(item, context) ??
                                      (globalIndex.isEven
                                          ? context.colorScheme.surface
                                          : context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2)),
                              border: Border(
                                bottom: BorderSide(
                                  color: context.colorScheme.outline.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                for (var column in widget.columns)
                                  _buildCell(column, item, isSelected, context),
                                if (widget.onEdit != null || widget.onDelete != null)
                                  SizedBox(
                                    width: 80,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (widget.onEdit != null) ...[
                                          IconButton(
                                            icon: const Icon(Icons.edit, size: 20),
                                            onPressed: () => widget.onEdit!(item),
                                            tooltip: 'Edit',
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                          SizedBox(width: ThemeHelper.getIndent(0.5)),
                                        ],
                                        if (widget.onDelete != null)
                                          IconButton(
                                            icon: Icon(Icons.delete, size: 20, color: context.colorScheme.error),
                                            onPressed: () => widget.onDelete!(item),
                                            tooltip: 'Delete',
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Pagination Controls
            Container(
              padding: EdgeInsets.all(ThemeHelper.getIndent()),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                border: Border(
                  top: BorderSide(
                    color: context.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  TextWrapper(
                    'Rows per page:',
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(width: ThemeHelper.getIndent()),
                  DropdownButton<int>(
                    value: _rowsPerPage,
                    items: widget.rowsPerPageOptions.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: TextWrapper('$value'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _rowsPerPage = value!;
                        _currentPage = 0;
                      });
                    },
                  ),
                  const Spacer(),
                  TextWrapper(
                    'Page ${_currentPage + 1} of ${_totalPages == 0 ? 1 : _totalPages}',
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(TableColumn<T> column, BuildContext context) {
    final theme = Theme.of(context);
    final isActive = _sortColumn == column.id;

    final content = InkWell(
      onTap: column.sortable ? () => _sort(column.id) : null,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ThemeHelper.getIndent(),
          vertical: ThemeHelper.getIndent(0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: TextWrapper(
                column.label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isActive ? context.colorScheme.primary : context.colorScheme.onSurface,
                ),
              ),
            ),
            if (column.sortable) ...[
              SizedBox(width: ThemeHelper.getIndent(0.25)),
              Icon(
                isActive
                    ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                    : Icons.unfold_more,
                size: 16,
                color: isActive ? context.colorScheme.primary : context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ],
        ),
      ),
    );

    if (column.width != null) {
      return SizedBox(width: column.width, child: content);
    } else {
      return Expanded(flex: column.flex, child: content);
    }
  }

  Widget _buildCell(TableColumn<T> column, T item, bool isSelected, BuildContext context) {
    final theme = Theme.of(context);

    Widget cellContent;
    if (column.customBuilder != null) {
      cellContent = column.customBuilder!(item, context);
    } else {
      cellContent = TextWrapper(
        column.getValue(item),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: context.colorScheme.onSurface,
        ),
      );
    }

    final paddedContent = Padding(
      padding: EdgeInsets.only(left: ThemeHelper.getIndent()),
      child: cellContent,
    );

    if (column.width != null) {
      return SizedBox(width: column.width, child: paddedContent);
    } else {
      return Expanded(flex: column.flex, child: paddedContent);
    }
  }
}