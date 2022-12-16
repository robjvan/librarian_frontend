import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/main.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/pages/login_screen/login_screen.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/widgets.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

final List<Middleware<GlobalAppState>> middleware =
    <Middleware<GlobalAppState>>[
  TypedMiddleware<GlobalAppState, AddBookToCollectionAction>(
    handleAddBookToFirebaseRequest(),
  ),
];

Middleware<GlobalAppState> handleAddBookToFirebaseRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) async {
      final Book _tempBook = action.addedBook;
      const Uuid uuid = Uuid();
      final String _newId = uuid.v4();
      log('Book title: ${_tempBook.title}');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('books')
          .where('sortTitle', isEqualTo: _tempBook.sortTitle)
          .where('sortAuthor', isEqualTo: _tempBook.sortAuthor)
          .get()
          .then((final QuerySnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black87,
              action: SnackBarAction(
                label: 'OK',
                textColor: store.state.userSettings.userColor,
                onPressed: () {},
              ),
              content: const Text(
                'This ISBN is already in library!  Try a different book.',
              ),
            ),
          );
        } else {
          //* Book does NOT exist in DB, do this:
          usersRef
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('books')
              .doc(_newId)
              .set(<String, dynamic>{
            'authors': _tempBook.authors,
            'description': _tempBook.description,
            'haveRead': _tempBook.haveRead,
            'id': _newId,
            'inFavesList': _tempBook.inFavesList,
            'inShoppingList': _tempBook.inShoppingList,
            'inWishList': _tempBook.inWishList,
            'isMature': _tempBook.isMature,
            'isbn10': _tempBook.isbn10,
            'isbn13': _tempBook.isbn13,
            'pageCount': _tempBook.pageCount,
            'publishYear': _tempBook.publishYear,
            'publisher': _tempBook.publisher,
            'rating': _tempBook.rating,
            'readCount': _tempBook.readCount,
            'sortAuthor': _tempBook.sortAuthor,
            'sortTitle': _tempBook.sortTitle,
            'thumbnail': _tempBook.thumbnail,
            'title': _tempBook.title,
          });
        }
      });
    };

Middleware<GlobalAppState> handleDeleteBookRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) async {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('books')
            .doc(action.bookId)
            .delete();
      } on Exception {
        log('Error deleting book, try again later');
      }
    };

Middleware<GlobalAppState> handleToggleInFavesListRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) async {
      try {
        log('handleToggleInFavesListRequest fired: ${action.newState}');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('books')
            .doc(action.bookId)
            .update(<String, dynamic>{'inFavesList': action.newState});
      } on Exception {
        log('Error deleting book, try again later');
      }
    };

Middleware<GlobalAppState> handleToggleInWishlistRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) async {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('books')
            .doc(action.bookId)
            .update(<String, dynamic>{'inWishList': false});
      } on Exception {
        log('Error deleting book, try again later');
      }
    };
