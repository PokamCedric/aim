// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:aim/application/state/app_locale.dart';
import 'package:aim/presentation/navigation/app_menu_item.dart';
import 'package:aim/presentation/navigation/app_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppMenu {
  static RouteSettings metrics(String? route) {
    final key = switch (route) {
      AppRoute.accountRoute => '1',
      AppRoute.budgetRoute => '0',
      _ => '2',
    };
    return RouteSettings(name: AppRoute.metricsSearchRoute, arguments: {routeArguments.search: key});
  }

  static AppMenuItem getByIndex(int index) {
    return get()[index];
  }

  static List<AppMenuItem> get() {
    return [
      AppMenuItem(
        name: AppLocale.labels.homeHeadline,
        icon: Icons.home,
        route: AppRoute.homeRoute,
      ),
      if (![TargetPlatform.iOS, TargetPlatform.macOS, TargetPlatform.android].contains(defaultTargetPlatform))
        AppMenuItem(
          name: AppLocale.labels.subscriptionHeadline,
          icon: Icons.switch_access_shortcut_add_outlined,
          route: AppRoute.subscriptionRoute,
        ),
      AppMenuItem(
        name: AppLocale.labels.aboutHeadline,
        icon: Icons.question_answer_outlined,
        route: AppRoute.aboutRoute,
      ),
    ];
  }
}
