import 'package:aim/core/theme/theme_helper.dart';
import 'package:flutter/material.dart';

/// Configuration for a filter
abstract class TableFilter<T> {
  final String label;
  final String id;

  TableFilter({required this.label, required this.id});

  bool apply(T item);
  String getDisplayText();
  Future<void> showFilterDialog(BuildContext context);
  bool get isActive;
  void clear(); // Add clear method
}

/// Enum filter implementation
class EnumTableFilter<T, E extends Enum> extends TableFilter<T> {
  E? _selectedValue;
  final List<E> values;
  final E? Function(T) getEnum;

  EnumTableFilter({
    required super.label,
    required super.id,
    required this.values,
    required this.getEnum,
    E? selectedValue,
  }) : _selectedValue = selectedValue;


  @override
  bool apply(T item) {
    if (_selectedValue == null) return true;
    return getEnum(item) == _selectedValue;
  }

  @override
  String getDisplayText() {
    return _selectedValue == null ? '$label: All' : '$label: ${_selectedValue!.name}';
  }

  @override
  bool get isActive => _selectedValue != null;

  @override
  void clear() {
    _selectedValue = null;
  }

  @override
  Future<void> showFilterDialog(BuildContext context) async {
    E? tempValue = _selectedValue;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter by $label'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  title: const Text('All'),
                  value: tempValue == null,
                  onChanged: (checked) {
                    if (checked == true) {
                      setState(() => tempValue = null);
                    }
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                ...values.map((value) => CheckboxListTile(
                  title: Text(value.name),
                  value: tempValue == value,
                  onChanged: (checked) {
                    if (checked == true) {
                      setState(() => tempValue = value);
                    }
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                )),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _selectedValue = tempValue;
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

/// Date range filter implementation
class DateRangeTableFilter<T> extends TableFilter<T> {
  DateTime? _from;
  DateTime? _to;
  final DateTime Function(T) getDate;

  DateRangeTableFilter({
    required super.label,
    required super.id,
    required this.getDate,
    DateTime? from,
    DateTime? to,
  }) : _from = from, _to = to;


  @override
  bool apply(T item) {
    final date = getDate(item);
    if (_from != null && date.isBefore(_from!)) return false;
    if (_to != null && date.isAfter(_to!)) return false;
    return true;
  }

  @override
  String getDisplayText() {
    return _from == null && _to == null ? '$label: All' : '$label: Filtered';
  }

  @override
  bool get isActive => _from != null || _to != null;

  @override
  void clear() {
    _from = null;
    _to = null;
  }

  @override
  Future<void> showFilterDialog(BuildContext context) async {
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _from != null && _to != null
          ? DateTimeRange(start: _from!, end: _to!)
          : null,
    );

    if (result != null) {
      _from = result.start;
      _to = result.end;
    }
  }
}

/// Number range filter implementation
class NumberRangeTableFilter<T> extends TableFilter<T> {
  num? _min;
  num? _max;
  final num Function(T) getNumber;

  NumberRangeTableFilter({
    required super.label,
    required super.id,
    required this.getNumber,
    num? min,
    num? max,
  }) : _min = min, _max = max;

  @override
  bool apply(T item) {
    final number = getNumber(item);
    if (_min != null && number < _min!) return false;
    if (_max != null && number > _max!) return false;
    return true;
  }

  @override
  String getDisplayText() {
    return _min == null && _max == null
        ? '$label: All'
        : '$label: ${_min ?? '0'}-${_max ?? '∞'}';
  }

  @override
  bool get isActive => _min != null || _max != null;

  @override
  void clear() {
    _min = null;
    _max = null;
  }

  @override
  Future<void> showFilterDialog(BuildContext context) async {
    num? tempMin = _min;
    num? tempMax = _max;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter by $label'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
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
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _min = tempMin;
              _max = tempMax;
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
