import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/pages/book_details_screen/book_details_screen.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/book_grid_tile/book_grid_tile_view_model.dart';
import 'package:librarian_frontend/widgets/dialogs/confirm_delete_dialog/confirm_delete_dialog.dart';

class BookGridTile extends StatelessWidget {
  final Book book;
  const BookGridTile(this.book, {final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) =>
      StoreConnector<GlobalAppState, BookGridTileViewModel>(
        converter: BookGridTileViewModel.create,
        builder: (final BuildContext context, final BookGridTileViewModel vm) {
          Widget _buildDeleteButton() => Positioned(
                top: 1,
                right: 1,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black45,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      bool? _confirmDelete = false;
                      try {
                        _confirmDelete = await showDialog(
                          context: context,
                          builder: (final BuildContext context) =>
                              ConfirmDeleteDialog(book),
                        );

                        if (_confirmDelete!) {
                          vm.dispatch(
                            RemoveBookFromCollectionAction(book.id),
                          );
                        }
                      } on Exception catch (e) {
                        _confirmDelete = false;
                        log(e.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Could not process your delete request, please try again',
                              style: TextStyle(color: vm.textColor),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              );

          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // boxShadow: const <BoxShadow>[
              //   BoxShadow(
              //     spreadRadius: 0,
              //     color: Colors.black87,
              //     blurRadius: 3,
              //   )
              // ],
            ),
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Get.to(BookDetailsScreen(book, book.id)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: GridTile(
                      child: Center(
                        child: SizedBox(
                          width: vm.gridItemSize,
                          child: CachedNetworkImage(
                            imageUrl: book.thumbnail!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildDeleteButton(),
              ],
            ),
          );
        },
      );
}
