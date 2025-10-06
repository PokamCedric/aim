// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:aim/_classes/storage/app_preferences.dart';
import 'package:aim/_configs/design_type.dart';
import 'package:aim/l10n/index.dart';
import 'package:flutter/material.dart';

class AppDesign extends ValueNotifier<AppDesignType> {
  static AppDesignType _state = find(AppPreferences.get(AppPreferences.prefDesign)) ?? AppDesignType.global;

  AppDesign() : super(get());

  static AppDesignType get() => _state;

  static AppDesignType? find(String? name) => AppDesignType.values.where((e) => e.name == name).firstOrNull;

  static String fromLocale(Locale? value) => languageDesign(value?.languageCode);

  static bool isRightToLeft() => get() == AppDesignType.rtlGeneral;

  static T getAlignment<T extends Enum>() => switch (T) {
        const (MainAxisAlignment) => isRightToLeft() ? MainAxisAlignment.end : MainAxisAlignment.start,
        const (TextDirection) => isRightToLeft() ? TextDirection.rtl : TextDirection.ltr,
        _ => isRightToLeft() ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      } as T;

  static T getInverseAlignment<T extends Enum>() => switch (T) {
        const (MainAxisAlignment) => isRightToLeft() ? MainAxisAlignment.start : MainAxisAlignment.end,
        const (TextDirection) => isRightToLeft() ? TextDirection.ltr : TextDirection.rtl,
        _ => isRightToLeft() ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      } as T;

  Future<void> set(String newValue, [Function? callback]) async {
    final change = find(newValue);
    if (change != null && change != value) {
      value = change;
      _state = change;
      await AppPreferences.set(AppPreferences.prefDesign, newValue);
      if (callback != null) {
        callback();
      }
      notifyListeners();
    }
  }
}
