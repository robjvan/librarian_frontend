import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

@immutable
class NewBookScreenViewModel {
  final Color textColor;
  final Color canvasColor;
  final Color userColor;
  final Function(dynamic) dispatch;
  final TextStyle titleStyle;
  final String? Function(String? s)? titleValidatorFn;
  final String? Function(String? s)? numberValidatorFn;
  final Function(dynamic) submitFn;

  NewBookScreenViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.userColor,
    required this.dispatch,
    required this.titleStyle,
    required this.titleValidatorFn,
    required this.numberValidatorFn,
    required this.submitFn,
  });

  factory NewBookScreenViewModel.create(final Store<GlobalAppState> store) {
    bool _checkDarkMode() => store.state.userSettings.useDarkMode;

    Color _getTextColor() => _checkDarkMode()
        ? AppColors.darkModeTextColor
        : AppColors.lightModeTextColor;

    dynamic _submitFn(dynamic) {
      return () {
        // if (formKey.currentState!.validate()) {
        //   final Book newBook = Book(authors: []);
        //   vm.dispatch(AddBookToCollectionAction(newBook));
        // }
      };
    }

    return NewBookScreenViewModel(
      canvasColor: _checkDarkMode()
          ? AppColors.darkModeBgColor
          : AppColors.lightModeBgColor,
      textColor: _getTextColor(),
      userColor: store.state.userSettings.userColor,
      dispatch: store.dispatch,
      titleStyle: TextStyle(
        color: store.state.userSettings.userColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      titleValidatorFn: (final String? s) {
        if (s!.isEmpty) {
          return 'new-book.title-error'.tr;
        }
        return null;
      },
      numberValidatorFn: (final String? s) {
        // TODO: Fix RegExp validators
        if (!RegExp('[!a-zA-Z]').hasMatch(s!)) {
          return 'Numbers only!';
        }
      },
      submitFn: _submitFn,
    );
  }
}
