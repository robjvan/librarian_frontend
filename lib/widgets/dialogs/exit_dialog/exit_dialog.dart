import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/dialogs/exit_dialog/exit_dialog_view_model.dart';

Future<bool?> showExitPopup(final BuildContext context) async => showDialog(
      context: context,
      builder: (final BuildContext context) =>
          StoreConnector<GlobalAppState, ExitDialogViewModel>(
        distinct: true,
        converter: ExitDialogViewModel.create,
        builder: (final BuildContext context, final ExitDialogViewModel vm) {
          return AlertDialog(
            backgroundColor: vm.canvasColor,
            title: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'exit-confirmation-message'.tr,
                    style: TextStyle(color: vm.textColor, fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(primary: vm.canvasColor),
                    child: Text('no'.tr, style: TextStyle(color: vm.textColor)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => exit(0),
                    style:
                        ElevatedButton.styleFrom(primary: Colors.red.shade800),
                    child: Text('yes'.tr),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
