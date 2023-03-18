import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/services/authentication.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class SettingsDrawerViewModel {
  final Function(dynamic) dispatch;
  final Function toggleDarkMode;
  final Color textColor;
  final Color canvasColor;
  final bool isLoading;
  final bool useDarkMode;
  final Color userColor;
  final Color inactiveBgColor;
  final Function() clearUserLibrary;
  final Function(BuildContext context) signOut;
  final Function() showAboutDialog;

  SettingsDrawerViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.userColor,
    required this.isLoading,
    required this.useDarkMode,
    required this.dispatch,
    required this.toggleDarkMode,
    required this.inactiveBgColor,
    required this.clearUserLibrary,
    required this.signOut,
    required this.showAboutDialog,
  });

  factory SettingsDrawerViewModel.create(final Store<GlobalAppState> store) {
    bool _checkDarkMode() {
      return store.state.userSettings.useDarkMode;
    }

    Color getTextColor() {
      return _checkDarkMode()
          ? AppColors.darkModeTextColor
          : AppColors.lightModeTextColor;
    }

    Color getBgColor() {
      return _checkDarkMode()
          ? AppColors.darkModeBgColor
          : AppColors.lightModeBgColor;
    }

    Future<void> clearUserLibrary() async {
      bool confirmClear = false;

      try {
        final bool? userConfirmed = await Get.dialog(
          AlertDialog(
            backgroundColor: getBgColor(),
            title: Text(
              'drawer.clear-library'.tr,
              style: TextStyle(color: getTextColor()),
            ),
            content: RichText(
              text: TextSpan(
                style: TextStyle(color: getTextColor()),
                children: <TextSpan>[
                  TextSpan(text: 'drawer.confirm-clear'.tr),
                  TextSpan(
                    text: 'drawer.cannot-be-undone'.tr,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Get.back(result: false),
                style: TextButton.styleFrom(),
                child: Text('cancel'.tr),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(),
                child: Text('drawer.clear-library'.tr),
              ),
            ],
          ),
        );

        if (userConfirmed != null && userConfirmed) {
          confirmClear = true;
        }
      } on Exception {
        print('Could not confirm library deletion, aborting.');
      }

      if (confirmClear) {
        store.dispatch(ClearLibraryAction());
      }
    }

    Future<void> signOut(final BuildContext context) async {
      await AuthService.signOut(context: context);
      unawaited(Get.offAll(() => const LoginScreen()));
    }

    Widget _aboutAppDialog() {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceAround,
        backgroundColor: getBgColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('app-title'.tr, style: TextStyle(color: getTextColor())),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'drawer.about-app-blurb'.tr,
                style: TextStyle(color: getTextColor()),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Text(
            'credits'.tr,
            style: TextStyle(color: getTextColor(), fontSize: 12),
          ),
          MaterialButton(
            color: store.state.userSettings.userColor,
            onPressed: Get.back,
            child: Text('ok'.tr, style: TextStyle(color: getTextColor())),
          ),
        ],
      );
    }

    return SettingsDrawerViewModel(
      useDarkMode: _checkDarkMode(),
      userColor: store.state.userSettings.userColor,
      isLoading: store.state.loadingStatus == LoadingStatus.loading,
      canvasColor: getBgColor(),
      textColor: getTextColor(),
      dispatch: store.dispatch,
      toggleDarkMode: () => store.dispatch(ToggleDarkModeAction()),
      inactiveBgColor: store.state.userSettings.useDarkMode
          ? const Color(0xFF303030)
          : AppColors.lightGrey,
      clearUserLibrary: clearUserLibrary,
      signOut: signOut,
      showAboutDialog: () => Get.dialog(_aboutAppDialog()),
    );
  }
}
