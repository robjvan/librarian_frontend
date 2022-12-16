import 'package:librarian_frontend/models/models.dart';

/// Add book to collection
class AddBookToCollectionAction {
  final Book addedBook;
  const AddBookToCollectionAction(this.addedBook);

  @override
  String toString() => 'AddBookToCollectionAction{addedBook: $addedBook}';
}

/// Remove book from collection
class RemoveBookFromCollectionAction {
  final String bookId;
  const RemoveBookFromCollectionAction(this.bookId);

  @override
  String toString() => 'RemoveBookFromCollectionAction{bookId: $bookId}';
}

class ConnectToFirebaseAction {}

/// Add/remove book from favorites list
class ToggleInFavesListAction {
  final String bookId;
  final bool newState;
  const ToggleInFavesListAction(this.bookId, this.newState);

  @override
  String toString() => 'ToggleInFavesListAction{bookId: $bookId}';
}

/// Add/remove book from wishlist
class ToggleInWishlistAction {
  final String bookId;
  const ToggleInWishlistAction(this.bookId);

  @override
  String toString() => 'ToggleInWishlistAction{bookId: $bookId}';
}

/// Add/remove book from shopping list
class ToggleInShoppingListAction {
  final String bookId;
  const ToggleInShoppingListAction(this.bookId);

  @override
  String toString() => 'ToggleInShoppingListAction{bookId: $bookId}';
}

/// Add/remove book from "have read" list
class ToggleHaveReadAction {
  final String bookId;
  const ToggleHaveReadAction(this.bookId);

  @override
  String toString() => 'ToggleHaveReadAction{bookId: $bookId}';
}
