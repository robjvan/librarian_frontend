import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/pages/settings_drawer/settings_drawer_view_model.dart';
import 'package:librarian_frontend/services/authentication.dart';
import 'package:librarian_frontend/state.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({final Key? key}) : super(key: key);

  Widget _buildClearLibTile(final SettingsDrawerViewModel vm) {
    return ListTile(
      leading: Icon(Icons.clear, color: vm.textColor),
      title: Text(
        'drawer.clear-library'.tr,
        style: TextStyle(color: vm.textColor),
      ),
      onTap: vm.clearUserLibrary,
    );
  }

  Widget _buildAboutAppTile(final SettingsDrawerViewModel vm) {
    return ListTile(
      leading: Icon(Icons.info_outline, color: vm.textColor),
      title: Text(
        'drawer.about-app'.tr,
        style: TextStyle(color: vm.textColor),
      ),
      onTap: vm.showAboutDialog,
    );
  }

  Widget _buildSignOutTile(
    final SettingsDrawerViewModel vm,
    final BuildContext context,
  ) {
    return ListTile(
      leading: Icon(Icons.logout, color: vm.textColor),
      title: Text(
        'drawer.sign-out'.tr,
        style: TextStyle(color: vm.textColor),
      ),
      onTap: () => vm.signOut(context),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return StoreConnector<GlobalAppState, SettingsDrawerViewModel>(
      distinct: true,
      converter: SettingsDrawerViewModel.create,
      builder: (final BuildContext context, final SettingsDrawerViewModel vm) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildClearLibTile(vm),
            _buildAboutAppTile(vm),
            _buildSignOutTile(vm, context),
          ],
        );
      },
    );
  }
}
