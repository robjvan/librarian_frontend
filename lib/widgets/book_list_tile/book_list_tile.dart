import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/book_list_tile/book_list_tile_view_model.dart';
import 'package:redux/redux.dart';

class BookListTile extends StatelessWidget {
  final Book book;
  const BookListTile(this.book, {final Key? key}) : super(key: key);

  Widget _buildBookThumbnail(final BuildContext context, final Book book) =>
      GestureDetector(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (final _) => BookDetailsScreen(book, book.id),
          //   ),
          // );
        },
        child: SizedBox(
          width: 40,
          child: Hero(
            tag: book.id,
            child: CachedNetworkImage(
              imageUrl: book.thumbnail!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

  Widget _buildTitleBox(
    final BuildContext context,
    final Book book,
    final BookListTileViewModel vm,
  ) =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (final _) => BookDetailsScreen(book, book.id),
              //   ),
              // );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    book.title!,
                    style: TextStyle(
                      color: vm.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    book.authors[0],
                    style: TextStyle(color: vm.textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildRatingsBar(
    final Book book,
    final BookListTileViewModel vm,
    final bool isPortrait,
  ) =>
      SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RatingBar(
              allowHalfRating: true,
              minRating: 0,
              initialRating: double.parse(book.rating.toString()),
              direction: Axis.horizontal,
              itemSize: isPortrait ? 16 : 24,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              ratingWidget: RatingWidget(
                full: Icon(Icons.star, color: vm.textColor),
                half: Icon(Icons.star_half, color: vm.textColor),
                empty: Icon(Icons.star_border, color: vm.textColor),
              ),
              onRatingUpdate: (final rating) => usersRef
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('books')
                  .doc(book.id.toString())
                  .update({'rating': rating}),
            ),
          ],
        ),
      );

  @override
  Widget build(final BuildContext context) {
    final bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return StoreConnector<GlobalAppState, BookListTileViewModel>(
      distinct: true,
      converter: BookListTileViewModel.create,
      builder: (final BuildContext context, final BookListTileViewModel vm) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Colors.black.withOpacity(0.8),
                width: 1,
              ),
              left: BorderSide(
                color: Colors.black.withOpacity(0.8),
                width: 1,
              ),
              right: BorderSide(
                color: Colors.black.withOpacity(0.8),
                width: 1,
              ),
            ),
          ),
          height: 60,
          child: Row(
            children: [
              _buildBookThumbnail(context, book),
              const SizedBox(width: 8),
              _buildTitleBox(context, book, vm),
              _buildRatingsBar(book, vm, _isPortrait),
            ],
          ),
        );
      },
    );
  }
}
