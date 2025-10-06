import 'package:flutter/material.dart';
import 'package:aim/_configs/screen_helper.dart';
import 'package:aim/design/wrapper/input_controller_wrapper.dart';



class CustomDrawer extends Drawer {
  CustomDrawer({
    super.key,
    required int selectedMenu,
    required Widget navigation,
    required Function(int) onMenuSelected,
  }) : super(
    child: _CustomDrawerContent(
      selectedMenu: selectedMenu,
      navigation: navigation,
      onMenuSelected: onMenuSelected,
    ),
  );
}

class _CustomDrawerContent extends StatelessWidget {
  final int selectedMenu;
  final Widget navigation;
  final Function(int) onMenuSelected;

  const _CustomDrawerContent({
    required this.selectedMenu,
    required this.navigation,
    required this.onMenuSelected,
  });


  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      shape: Border.all(width: 0),
      child: ScreenHelper.state().isWide
          ? navigation
          : InputControllerWrapper(
              child: navigation,
            ),
    );
  }
}
