// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:aim/core/_ext/build_context_ext.dart';
import 'package:aim/presentation/design/wrapper/text_wrapper.dart';
import 'package:aim/presentation/pages/base/abstract_page_state.dart';
import 'package:aim/presentation/widgets/data_table.dart';

// Example 1: Using the table with Person entity
class PeopleTablePage extends StatefulWidget {
  const PeopleTablePage({super.key});

  @override
  PeopleTablePageState createState() => PeopleTablePageState();
}

class PeopleTablePageState extends AbstractPageState<PeopleTablePage> {
  final List<Person> _people = [
    Person(id: 1, name: 'Alice Martin', email: 'alice@example.com', age: 28, role: Role.developer, hireDate: DateTime(2022, 3, 15)),
    Person(id: 2, name: 'Bob Durant', email: 'bob@example.com', age: 34, role: Role.designer, hireDate: DateTime(2021, 7, 22)),
    Person(id: 3, name: 'Charlie Dubois', email: 'charlie@example.com', age: 29, role: Role.manager, hireDate: DateTime(2020, 1, 10)),
  ];

  Role? _filterRole;
  DateTime? _filterDateFrom;
  DateTime? _filterDateTo;
  num? _filterAgeMin;
  num? _filterAgeMax;

  @override
  String getTitle() => 'People Table';

  @override
  String getButtonName() => 'Add Person';

  @override
  String? getHelperName() => null;

  @override
  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    return const SizedBox.shrink(); // Handled by table
  }

  @override
  Widget buildContent(BuildContext context, BoxConstraints constraints) {
    return AdvancedDataTable<Person>(
      data: _people,
      title: 'People Directory',
      titleIcon: Icons.people,
      addButtonLabel: 'Add Person',
      onAdd: () {
        setState(() {
          _people.add(Person(
            id: _people.length + 1,
            name: 'New Person',
            email: 'new@example.com',
            age: 25,
            role: Role.developer,
            hireDate: DateTime.now(),
          ));
        });
      },
      columns: [
        TableColumn<Person>(
          label: 'ID',
          id: 'id',
          width: 60,
          getValue: (p) => p.id.toString(),
        ),
        TableColumn<Person>(
          label: 'Name',
          id: 'name',
          flex: 2,
          getValue: (p) => p.name,
          searchable: true,
        ),
        TableColumn<Person>(
          label: 'Email',
          id: 'email',
          flex: 3,
          getValue: (p) => p.email,
          searchable: true,
        ),
        TableColumn<Person>(
          label: 'Age',
          id: 'age',
          width: 60,
          getValue: (p) => p.age.toString(),
        ),
        TableColumn<Person>(
          label: 'Role',
          id: 'role',
          flex: 1,
          getValue: (p) => p.role.name,
          customBuilder: (person, context) {
            return TextWrapper(
              person.role.name,
              style: TextStyle(
                color: _getRoleColor(person.role, context),
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
        TableColumn<Person>(
          label: 'Hire Date',
          id: 'hireDate',
          width: 100,
          getValue: (p) => '${p.hireDate.day}/${p.hireDate.month}/${p.hireDate.year}',
        ),
      ],
      filters: [
        EnumTableFilter<Person, Role>(
          label: 'Role',
          id: 'role',
          values: Role.values,
          getEnum: (p) => p.role,
          selectedValue: _filterRole,
          onChanged: (value) {
            setState(() => _filterRole = value);
          },
        ),
        NumberRangeTableFilter<Person>(
          label: 'Age',
          id: 'age',
          getNumber: (p) => p.age,
          min: _filterAgeMin,
          max: _filterAgeMax,
          onChanged: (min, max) {
            setState(() {
              _filterAgeMin = min;
              _filterAgeMax = max;
            });
          },
        ),
        DateRangeTableFilter<Person>(
          label: 'Hire Date',
          id: 'hireDate',
          getDate: (p) => p.hireDate,
          from: _filterDateFrom,
          to: _filterDateTo,
          onChanged: (from, to) {
            setState(() {
              _filterDateFrom = from;
              _filterDateTo = to;
            });
          },
        ),
      ],
      onRowTap: (person) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: ${person.name}')),
        );
      },
      onEdit: (person) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit: ${person.name}')),
        );
      },
      onDelete: (person) {
        setState(() {
          _people.removeWhere((p) => p.id == person.id);
        });
      },
    );
  }

  Color _getRoleColor(Role role, BuildContext context) {
    switch (role) {
      case Role.developer:
        return context.colorScheme.primary;
      case Role.designer:
        return context.colorScheme.tertiary;
      case Role.manager:
        return context.colorScheme.secondary;
    }
  }
}

// Example 2: Using the table with Product entity
class ProductsTablePage extends StatefulWidget {
  const ProductsTablePage({super.key});

  @override
  ProductsTablePageState createState() => ProductsTablePageState();
}

class ProductsTablePageState extends AbstractPageState<ProductsTablePage> {
  final List<Product> _products = [
    Product(id: 1, name: 'Laptop', price: 999.99, stock: 15, category: Category.electronics, createdAt: DateTime(2023, 1, 15)),
    Product(id: 2, name: 'Chair', price: 149.99, stock: 30, category: Category.furniture, createdAt: DateTime(2023, 5, 20)),
    Product(id: 3, name: 'Notebook', price: 5.99, stock: 100, category: Category.stationery, createdAt: DateTime(2023, 8, 10)),
  ];

  Category? _filterCategory;
  num? _filterPriceMin;
  num? _filterPriceMax;

  @override
  String getTitle() => 'Products Table';

  @override
  String getButtonName() => 'Add Product';

  @override
  String? getHelperName() => null;

  @override
  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildContent(BuildContext context, BoxConstraints constraints) {
    return AdvancedDataTable<Product>(
      data: _products,
      title: 'Product Inventory',
      titleIcon: Icons.inventory,
      addButtonLabel: 'Add Product',
      onAdd: () {
        setState(() {
          _products.add(Product(
            id: _products.length + 1,
            name: 'New Product',
            price: 0,
            stock: 0,
            category: Category.electronics,
            createdAt: DateTime.now(),
          ));
        });
      },
      columns: [
        TableColumn<Product>(
          label: 'ID',
          id: 'id',
          width: 60,
          getValue: (p) => p.id.toString(),
        ),
        TableColumn<Product>(
          label: 'Name',
          id: 'name',
          flex: 2,
          getValue: (p) => p.name,
          searchable: true,
        ),
        TableColumn<Product>(
          label: 'Price',
          id: 'price',
          width: 100,
          getValue: (p) => '\$${p.price.toStringAsFixed(2)}',
        ),
        TableColumn<Product>(
          label: 'Stock',
          id: 'stock',
          width: 80,
          getValue: (p) => p.stock.toString(),
          customBuilder: (product, context) {
            final color = product.stock < 10
                ? context.colorScheme.error
                : product.stock < 20
                    ? Colors.orange
                    : context.colorScheme.primary;
            return TextWrapper(
              product.stock.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        TableColumn<Product>(
          label: 'Category',
          id: 'category',
          flex: 1,
          getValue: (p) => p.category.name,
        ),
        TableColumn<Product>(
          label: 'Created',
          id: 'createdAt',
          width: 100,
          getValue: (p) => '${p.createdAt.day}/${p.createdAt.month}/${p.createdAt.year}',
        ),
      ],
      filters: [
        EnumTableFilter<Product, Category>(
          label: 'Category',
          id: 'category',
          values: Category.values,
          getEnum: (p) => p.category,
          selectedValue: _filterCategory,
          onChanged: (value) {
            setState(() => _filterCategory = value);
          },
        ),
        NumberRangeTableFilter<Product>(
          label: 'Price',
          id: 'price',
          getNumber: (p) => p.price,
          min: _filterPriceMin,
          max: _filterPriceMax,
          onChanged: (min, max) {
            setState(() {
              _filterPriceMin = min;
              _filterPriceMax = max;
            });
          },
        ),
      ],
      onDelete: (product) {
        setState(() {
          _products.removeWhere((p) => p.id == product.id);
        });
      },
      getRowColor: (product, context) {
        if (product.stock < 10) {
          return context.colorScheme.errorContainer.withValues(alpha: 0.1);
        }
        return null;
      },
    );
  }
}

// Data Models
enum Role { developer, designer, manager }

class Person {
  final int id;
  final String name;
  final String email;
  final int age;
  final Role role;
  final DateTime hireDate;

  Person({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.role,
    required this.hireDate,
  });
}

enum Category { electronics, furniture, stationery }

class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final Category category;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.createdAt,
  });
}