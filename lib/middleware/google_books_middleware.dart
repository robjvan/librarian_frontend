import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/api/api_utils.dart';
import 'package:librarian_frontend/api/apis.dart';
import 'package:librarian_frontend/main.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/providers/providers.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/widgets.dart';
import 'package:redux/redux.dart';

Middleware<GlobalAppState> handleSearchIsbnRequest() {
  return (
    final Store<GlobalAppState> store,
    final dynamic action,
    final dynamic next,
  ) async {
    final GoogleBooksApi gBooks =
        GoogleBooksApi(const GoogleBooksApiProvider());
    final String scannedISBN = action.isbn;
    List<dynamic>? results = <dynamic>[];
    Book? selectedBook;

    try {
      final APIResponse<dynamic> apiResults =
          await gBooks.searchWithIsbn(scannedISBN);
      results = await apiResults.result;
    } on Exception catch (e) {
      log('Could not fetch details from gbooks api - $e');
    }

    try {
      if (results!.isNotEmpty) {
        int? selectedIndex;

        if (results.length > 1) {
          selectedIndex = await Get.dialog(SearchResultsDialog(results));
          if (selectedIndex != -1) {
            selectedBook = results[selectedIndex!];
          }
        } else {
          selectedBook = results[0];
        }
        if (selectedBook != null) {
          store.dispatch(AddBookToCollectionAction(selectedBook));
        }
      } else {
        unawaited(
          Get.dialog(
            ErrorDialog('search-error.barcode'.tr),
          ),
        );
      }
    } on Exception {
      unawaited(
        Get.dialog(
          ErrorDialog('search-error.barcode'.tr),
        ),
      );
    }
  };
}

Middleware<GlobalAppState> handleKeywordSearchRequest() {
  return (
    final Store<GlobalAppState> store,
    final dynamic action,
    final dynamic next,
  ) async {
    final GoogleBooksApi gBooks =
        GoogleBooksApi(const GoogleBooksApiProvider());
    List<dynamic>? results = <dynamic>[];
    String queryString = '';
    Book? selectedBook;

    if (action.searchParams.isbn!.isNotEmpty &&
        action.searchParams.isbn != '-1') {
      store.dispatch(SearchIsbnAction(action.searchParams.isbn));
    } else {
      if (action.searchParams.year!.isNotEmpty) {
        queryString += action.searchParams.year!;
      }
      if (action.searchParams.author!.isNotEmpty) {
        queryString += '+inauthor:${action.searchParams.author}';
      }
      if (action.searchParams.publisher!.isNotEmpty) {
        queryString += '+inpublisher:${action.searchParams.publisher}';
      }
      if (action.searchParams.title!.isNotEmpty) {
        queryString += '+intitle:${action.searchParams.title}';
      }

      try {
        final APIResponse<dynamic> apiResults =
            await gBooks.querySearch(queryString);
        results = await apiResults.result;
      } on Exception catch (e) {
        log('Could not fetch details from gbooks api - $e');
      }

      try {
        if (results!.isNotEmpty) {
          int selectedIndex = -1;

          if (results.length > 1) {
            selectedIndex = await Get.dialog(
              SearchResultsDialog(results),
            );

            if (selectedIndex != -1) {
              selectedBook = results[selectedIndex];
            }
          } else {
            selectedBook = results[0];
          }
          if (selectedBook != null) {
            store.dispatch(AddBookToCollectionAction(selectedBook));
          }
        } else {
          await showDialog(
            context: navigatorKey.currentContext!,
            builder: (final _) => ErrorDialog('search-error.barcode'.tr),
          );
        }
      } on Exception {
        await showDialog(
          context: navigatorKey.currentContext!,
          builder: (final _) => ErrorDialog('search-error.barcode'.tr),
        );
      }
    }
  };
}
