import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

@immutable
class NewBookScreenViewModel {
  final Color textColor;
  final Color canvasColor;
  final Color userColor;
  final Function(dynamic) dispatch;
  final TextStyle titleStyle;
  final String? Function(String? s)? titleValidatorFn;
  final String? Function(String? s)? numberValidatorFn;
  final Function({
    required String title,
    String? author,
    String? description,
    String? publisher,
    int? isbn,
    int? publishYear,
    int? pageCount,
    double? rating,
    bool? addToFaves,
    bool? addToShoppingList,
    bool? addToWishlist,
    bool? alreadyRead,
    String? thumbnailUrl,
  }) submitFn;

  const NewBookScreenViewModel({
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

    dynamic _submitFn({
      required final String title,
      final String? author,
      final String? description,
      final String? publisher,
      final int? isbn,
      final int? publishYear,
      final int? pageCount,
      final double? rating,
      final bool? addToFaves,
      final bool? addToShoppingList,
      final bool? addToWishlist,
      final bool? alreadyRead,
      final String? thumbnailUrl,
    }) {
      const Uuid uuid = Uuid();
      final String _newId = uuid.v4();

      final String sortTitle = title.startsWith(RegExp('The '))
          //Title start with 'The'
          ? title.replaceFirst(RegExp('The '), '')
          // No 'The' in title,
          : title.startsWith(RegExp('A '))
              // Title starts with 'A'
              ? title.replaceFirst(RegExp('A '), '')
              // No 'The' or 'A' in title
              : title.startsWith(RegExp('An '))
                  // Title start with 'An'
                  ? title.replaceFirst(RegExp('An '), '')
                  // Title does not start with 'The', 'A', or 'An'
                  : title;

      String sortAuthor = '';
      if (author != null) {
        sortAuthor = author.split(' ').length > 1
            ? author.split(' ').length > 2
                ? '${author.split(" ")[2]}, ${author.split(" ")[0]} ${author.split(" ")[1]}'
                : '${author.split(" ")[1]}, ${author.split(" ")[0]}'
            : author;
      }

      final Book newBook = Book(
        title: title,
        sortTitle: sortTitle,
        authors: <String>[author ?? ''],
        sortAuthor: sortAuthor,
        description: description ?? '',
        haveRead: alreadyRead ?? false,
        inFavesList: addToFaves ?? false,
        inShoppingList: addToShoppingList ?? false,
        inWishList: addToWishlist ?? false,
        isMature: false,
        isbn10: isbn.toString().length == 10 ? isbn.toString() : '',
        isbn13: isbn.toString().length == 13 ? isbn.toString() : '',
        pageCount: pageCount,
        publishYear: publishYear.toString(),
        publisher: publisher ?? '',
        rating: rating ?? 0,
        readCount: 0,
        thumbnail: thumbnailUrl != ''
            ? thumbnailUrl
            : 'http://placekitten.com/200/300',
        id: _newId,
      );

      store.dispatch(AddBookToCollectionAction(newBook));
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
        if (s!.contains(' ') && s.contains('-') && s.contains('.')) {
          return 'Numbers only!';
        }
        return null;
        // if (s!.contains(RegExp('[0-9]'))) {
        //   return 'Numbers only!';
        // }
      },
      submitFn: _submitFn,
    );
  }
}
