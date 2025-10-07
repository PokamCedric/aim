// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:aim/core/_ext/build_context_ext.dart';
import 'package:aim/core/theme/theme_helper.dart';
import 'package:aim/presentation/design/wrapper/text_wrapper.dart';
import 'package:aim/presentation/pages/base/abstract_page_state.dart';
import 'package:flutter/material.dart';

enum Gender { male, female }

class UserAddPage extends StatefulWidget {
  const UserAddPage({super.key});

  @override
  UserAddPageState createState() => UserAddPageState();
}

class UserAddPageState extends AbstractPageState<UserAddPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _photoController = TextEditingController();
  
  // Form state
  Gender _selectedGender = Gender.male;
  DateTime? _dateOfBirth;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  @override
  String getTitle() => 'Add User';

  @override
  String getButtonName() => 'Save';

  @override
  String? getHelperName() => null;

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      // Create user model
      // final user = UserModel(
      //   id: '', // Generate ID
      //   firstName: _firstNameController.text,
      //   lastName: _lastNameController.text,
      //   email: _emailController.text.isEmpty ? null : _emailController.text,
      //   phone: _phoneController.text.isEmpty ? null : _phoneController.text,
      //   photo: _photoController.text.isEmpty ? null : _photoController.text,
      //   gender: _selectedGender,
      //   createdAt: DateTime.now(),
      //   dateOfBirth: _dateOfBirth,
      // );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User saved successfully!')),
      );
      
      Navigator.pop(context);
    }
  }

  @override
  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    return FloatingActionButton.extended(
      heroTag: 'save_user_button',
      onPressed: _saveUser,
      icon: const Icon(Icons.save),
      label: TextWrapper(getButtonName()),
      tooltip: 'Save user',
    );
  }

  @override
  Widget buildContent(BuildContext context, BoxConstraints constraints) {
    final theme = Theme.of(context);
    final width = constraints.maxWidth;
    final formWidth = width > 600 ? 600.0 : width * 0.9;

    return Container(
      color: context.colorScheme.surface,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(ThemeHelper.getIndent(2)),
        child: Center(
          child: SizedBox(
            width: formWidth,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(ThemeHelper.getIndent(2)),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person_add, color: context.colorScheme.primary, size: 32),
                        SizedBox(width: ThemeHelper.getIndent()),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWrapper(
                                'New User',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              TextWrapper(
                                'Fill in the information below',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: context.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ThemeHelper.getIndent(3)),

                  // Personal Information Section
                  TextWrapper(
                    'Personal Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: ThemeHelper.getIndent()),

                  // First Name
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name *',
                      hintText: 'Enter first name',
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: ThemeHelper.getIndent(2)),

                  // Last Name
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name *',
                      hintText: 'Enter last name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: ThemeHelper.getIndent(2)),

                  // Gender Selection
                  Container(
                    padding: EdgeInsets.all(ThemeHelper.getIndent(2)),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.colorScheme.outline),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWrapper(
                          'Gender *',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text('Male'),
                                value: _selectedGender == Gender.male,
                                onChanged: (checked) {
                                  if (checked == true) {
                                    setState(() => _selectedGender = Gender.male);
                                  }
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text('Female'),
                                value: _selectedGender == Gender.female,
                                onChanged: (checked) {
                                  if (checked == true) {
                                    setState(() => _selectedGender = Gender.female);
                                  }
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ThemeHelper.getIndent(2)),

                  // Date of Birth
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _dateOfBirth ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _dateOfBirth = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: 'Select date of birth',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: const OutlineInputBorder(),
                      ),
                      child: TextWrapper(
                        _dateOfBirth == null
                            ? 'Not selected'
                            : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ),

                  SizedBox(height: ThemeHelper.getIndent(3)),

                  // Contact Information Section
                  TextWrapper(
                    'Contact Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: ThemeHelper.getIndent()),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter email address',
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: ThemeHelper.getIndent(2)),

                  // Phone
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      hintText: 'Enter phone number',
                      prefixIcon: const Icon(Icons.phone),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),

                  SizedBox(height: ThemeHelper.getIndent(3)),

                  // Additional Information Section
                  TextWrapper(
                    'Additional Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: ThemeHelper.getIndent()),

                  // Photo URL
                  TextFormField(
                    controller: _photoController,
                    decoration: InputDecoration(
                      labelText: 'Photo URL',
                      hintText: 'Enter photo URL',
                      prefixIcon: const Icon(Icons.photo),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.url,
                  ),

                  SizedBox(height: ThemeHelper.getIndent(3)),

                  // Required fields note
                  Container(
                    padding: EdgeInsets.all(ThemeHelper.getIndent()),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: context.colorScheme.primary,
                        ),
                        SizedBox(width: ThemeHelper.getIndent()),
                        Expanded(
                          child: TextWrapper(
                            '* Required fields',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ThemeHelper.getIndent(8)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}