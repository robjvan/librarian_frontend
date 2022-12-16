import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/dialogs/error_dialog/error_dialog_view_model.dart';

class ErrorDialog extends StatelessWidget {
  final String errorMessage;
  // ignore: use_key_in_widget_constructors
  const ErrorDialog(this.errorMessage);

  @override
  Widget build(final BuildContext context) {
    return StoreConnector<GlobalAppState, ErrorDialogViewModel>(
      distinct: true,
      converter: ErrorDialogViewModel.create,
      builder: (final BuildContext context, final dynamic vm) {
        return AlertDialog(
          backgroundColor: vm.canvasColor,
          title: Text(
            'No results found!  $errorMessage', // TODO: Add translations
            style: TextStyle(color: vm.textColor),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: vm.userColor),
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: vm.textColor)),
            ),
          ],
        );
      },
    );
  }
}