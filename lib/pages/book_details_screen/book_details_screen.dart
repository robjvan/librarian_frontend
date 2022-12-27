import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/pages/book_details_screen/book_details_screen_view_model.dart';
import 'package:librarian_frontend/pages/library_screen/widgets/dialogs/dialogs.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book _passedBook;
  final String heroTag;
  const BookDetailsScreen(this._passedBook, this.heroTag, {final Key? key})
      : super(key: key);

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  Widget _buildHeaderImage(final Book book) => ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
          imageUrl: book.thumbnail!,
          fit: BoxFit.cover,
          width: 200,
        ),
      );

  Widget _buildTitleRow(final BookDetailsScreenViewModel vm, final Book book) =>
      Text(
        book.title!,
        style: AppTextStyles.bookTitleStyle.copyWith(color: vm.textColor),
        textAlign: TextAlign.center,
      );

  Widget _buildAuthorsSection(
    final dynamic author,
    final BookDetailsScreenViewModel vm,
  ) =>
      Text(author,
          style: AppTextStyles.bookAuthorStyle.copyWith(color: vm.textColor));

  Widget _buildDescriptionSection(
    final BookDetailsScreenViewModel vm,
    final Book book,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          book.description!,
          style: TextStyle(color: vm.textColor, fontSize: 16),
        ),
      );

  Widget _buildPageCountPublisherRow(
    final BookDetailsScreenViewModel vm,
    final Book book,
  ) {
    final double _sw = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: _sw / 2.5,
            child: Text(
              'book-details-screen.page-count'.trParams(
                <String, String>{'pageCount': book.pageCount.toString()},
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: vm.textColor,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: _sw / 2.5,
            child: Text(
              'book-details-screen.publisher'.trParams(<String, String>{
                'publishYear': book.publishYear ?? '',
                'publisher': book.publisher ?? ''
              }),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: vm.textColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(final BookDetailsScreenViewModel vm) => Positioned(
        top: 0,
        left: 0,
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: vm.textColor),
          onPressed: Get.back,
        ),
      );

  Widget _buildRatingsBar(
    final BookDetailsScreenViewModel vm,
    final Book book,
  ) {
    final bool _isPortrait = 
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RatingBar(
            allowHalfRating: true,
            minRating: 0,
            initialRating: double.parse(book.rating.toString()),
            direction: Axis.horizontal,
            itemSize: _isPortrait ? 18 : 24,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            ratingWidget: RatingWidget(
              full: Icon(Icons.star, color: vm.textColor),
              half: Icon(Icons.star_half, color: vm.textColor),
              empty: Icon(Icons.star_border, color: vm.textColor),
            ),
            onRatingUpdate: (final double rating) => usersRef
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('books')
                .doc(book.id)
                .update(<String, double>{'rating': rating}),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(final BookDetailsScreenViewModel vm) =>
      Divider(thickness: 1, indent: 16, endIndent: 16, color: vm.textColor);

  Widget _buildBookToggles(
    final BookDetailsScreenViewModel vm,
    final Book book,
  ) {
    final double _sw = MediaQuery.of(context).size.width;

    Widget _buildInfoCell(final String key, {final bool rightBorder = false}) {
      late Function _action;
      String _label = '';
      bool _checked = false;

      switch (key) {
        case 'inFavesList':
          _checked = book.inFavesList;
          _label = 'book-details-screen.in-faves'.tr;
          _action = () {
            setState(() {
              usersRef
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('books')
                  .doc(book.id)
                  .update(<String, bool>{'inFavesList': !book.inFavesList});
            });
          };
          break;
        case 'inWishList':
          _checked = book.inWishList;
          _label = 'book-details-screen.in-wishlist'.tr;
          _action = () {
            setState(() {
              usersRef
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('books')
                  .doc(book.id)
                  .update(<String, bool>{'inWishList': !book.inWishList});
            });
          };
          break;
        case 'inShoppingList':
          _checked = book.inShoppingList;
          _label = 'book-details-screen.in-shopping-list'.tr;
          _action = () {
            setState(() {
              usersRef
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('books')
                  .doc(book.id)
                  .update(
                <String, bool>{'inShoppingList': !book.inShoppingList},
              );
            });
          };
          break;
        case 'haveRead':
          _checked = book.haveRead;
          _label = 'book-details-screen.have-read'.tr;
          _action = () {
            setState(() {
              usersRef
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('books')
                  .doc(book.id)
                  .update(<String, bool>{'haveRead': !book.haveRead});
            });
          };
          break;
      }
      return Container(
        width: (0.5 * _sw) - 16,
        decoration: rightBorder
            ? BoxDecoration(
                border:
                    Border(right: BorderSide(width: 1, color: vm.textColor)),
              )
            : null,
        child: Row(
          children: <Widget>[
            Checkbox(
              fillColor: MaterialStateProperty.all(vm.userColor),
              value: _checked,
              onChanged: (final bool? newVal) => _action(),
            ),
            Text(
              _label,
              style: TextStyle(color: vm.textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: vm.textColor),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildInfoCell('inFavesList', rightBorder: true),
              _buildInfoCell('inWishList'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildInfoCell('haveRead', rightBorder: true),
              _buildInfoCell('inShoppingList'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(
    final BookDetailsScreenViewModel vm,
    final Book book,
  ) =>
      Positioned(
        top: 12,
        right: 12,
        child: GestureDetector(
          child: const Icon(Icons.delete_outline, color: Colors.red),
          onTap: () async {
            final bool _confirmDelete =
                await Get.dialog(ConfirmDeleteDialog(book));

            if (_confirmDelete) {
              Get.back();
              vm.dispatch(RemoveBookFromCollectionAction(book.id));
            }
          },
        ),
      );

  @override
  Widget build(final BuildContext context) {
    final Future<QuerySnapshot<dynamic>> searchResultsFuture = FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('books')
        .get();
    return StoreConnector<GlobalAppState, BookDetailsScreenViewModel>(
      distinct: true,
      converter: BookDetailsScreenViewModel.create,
      builder:
          (final BuildContext context, final BookDetailsScreenViewModel vm) =>
              Scaffold(
        backgroundColor: vm.canvasColor,
        body: SafeArea(
          child: FutureBuilder<QuerySnapshot<Object?>>(
            future: searchResultsFuture,
            builder: (
              final BuildContext context,
              final AsyncSnapshot<QuerySnapshot<dynamic>> snapshot,
            ) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                final Book book = Book.fromFBJson(
                  snapshot.data!.docs.firstWhere(
                    (final QueryDocumentSnapshot<dynamic> element) =>
                        element.id == widget._passedBook.id,
                  ),
                );
                if (!snapshot.hasData) return Container();
                return Stack(
                  children: <Widget>[
                    ListView(
                      primary: false,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 32, 8, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _buildHeaderImage(book),
                              const SizedBox(height: 32),
                              _buildTitleRow(vm, book),
                              const SizedBox(height: 4),
                              for (String author in book.authors)
                                _buildAuthorsSection(author, vm),
                              _buildRatingsBar(vm, book),
                              const SizedBox(height: 16),
                              _buildBookToggles(vm, book),
                              const SizedBox(height: 16),
                              _buildDescriptionSection(vm, book),
                              _buildDivider(vm),
                              _buildPageCountPublisherRow(vm, book),
                            ],
                          ),
                        )
                      ],
                    ),
                    _buildBackButton(vm),
                    _buildDeleteButton(vm, book),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
