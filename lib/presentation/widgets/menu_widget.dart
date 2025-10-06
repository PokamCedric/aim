// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:aim/application/state/app_design.dart';
import 'package:aim/presentation/navigation/app_menu.dart';
import 'package:aim/presentation/navigation/app_menu_item.dart';
import 'package:aim/core/utils/screen_helper.dart';
import 'package:aim/core/theme/theme_helper.dart';
import 'package:aim/core/_ext/build_context_ext.dart';
import 'package:aim/presentation/design/wrapper/text_wrapper.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final Function setState;
  final FocusNode focus = FocusNode();

  MenuWidget({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.setState,
  });

  void _navigateToPage(NavigatorState nav, String routeName) {
    setState();
    nav.pop();
    nav.pushNamed(routeName);
  }

  void _onHover(bool isHovered) {
    if (isHovered) {
      setState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final indent = ThemeHelper.getIndent();
    final isWide = ScreenHelper.state().isWide;
    final ColorScheme colorScheme = context.colorScheme;
    final TextTheme textTheme = context.textTheme;
    final isSelected = selectedIndex == index;
    Color color = isSelected ? colorScheme.primary : colorScheme.secondary;
    AppMenuItem menu = AppMenu.getByIndex(index);
    NavigatorState nav = Navigator.of(context);

    return InkWell(
      onTap: () => _navigateToPage(nav, menu.route),
      focusNode: isSelected && !isWide ? (focus..requestFocus()) : focus,
      onHover: _onHover,
      child: Container(
        padding: EdgeInsets.all(indent),
        color: isSelected
            ? isWide
                ? colorScheme.surface
                : colorScheme.secondary.withValues(alpha: 0.1)
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: AppDesign.getAlignment<TextDirection>(),
          children: [
            Icon(menu.icon, color: color),
            Padding(
              padding: EdgeInsets.only(left: indent, right: indent),
              child: TextWrapper(
                menu.name,
                style: textTheme.headlineMedium?.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
