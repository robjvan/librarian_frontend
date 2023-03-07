import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/widgets/collection_view/collection_view_view_model.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/widgets.dart';

// final CollectionReference<Map<String, dynamic>> usersRef =
//     FirebaseFirestore.instance.collection('users');

class CollectionView extends StatelessWidget {
  const CollectionView({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) =>
      StoreConnector<GlobalAppState, CollectionViewViewModel>(
        converter: CollectionViewViewModel.create,
        builder:
            (final BuildContext context, final CollectionViewViewModel vm) =>
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('books')
              .snapshots(),
          builder: (
            final BuildContext context,
            final AsyncSnapshot<QuerySnapshot<dynamic>> snapshot,
          ) {
            List<DocumentSnapshot<dynamic>?> searchResults =
                <DocumentSnapshot<Object?>?>[];
            if (!snapshot.hasData) {
              return const Center(
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            /// Apply search term strings
            if (vm.searchTerm != '') {
              for (final QueryDocumentSnapshot<dynamic> doc
                  in snapshot.data!.docs) {
                final String bookTitle = doc.get('title');
                final List<dynamic>? authors = doc.get('authors');
                if (bookTitle
                    .toLowerCase()
                    .contains(vm.searchTerm.toLowerCase())) {
                  searchResults.add(doc);
                } else if (authors!.any(
                  (final dynamic e) =>
                      e.toLowerCase().contains(vm.searchTerm.toLowerCase()),
                )) {
                  searchResults.add(doc);
                }
              }
            } else {
              for (final QueryDocumentSnapshot<dynamic> doc
                  in snapshot.data!.docs) {
                searchResults.add(doc);
              }
            }

            /// Apply filters
            switch (vm.filterKey) {
              case FilterKey.all:
                searchResults = searchResults;
                break;
              case FilterKey.wishlist:
                searchResults = searchResults
                    .where(
                      (final DocumentSnapshot<Object?>? result) =>
                          result!.get('inWishList') == true,
                    )
                    .toList();
                break;
              case FilterKey.faves:
                final List<DocumentSnapshot<Object?>?> results = searchResults
                    .where(
                      (final DocumentSnapshot<Object?>? result) =>
                          result!.get('inFavesList') == true,
                    )
                    .toList();
                searchResults = results;
                break;
              case FilterKey.unread:
                searchResults = searchResults
                    .where(
                      (final DocumentSnapshot<Object?>? result) =>
                          result!.get('haveRead') == false,
                    )
                    .toList();
                break;
            }

            /// Apply sort method
            switch (vm.sortMethod) {
              case SortMethod.authorAsc:
                searchResults.sort(
                  (
                    final DocumentSnapshot<dynamic>? a,
                    final DocumentSnapshot<dynamic>? b,
                  ) =>
                      a!.get('sortAuthor').compareTo(b!.get('sortAuthor')),
                );
                break;
              case SortMethod.authorDesc:
                searchResults.sort(
                  (
                    final DocumentSnapshot<dynamic>? a,
                    final DocumentSnapshot<dynamic>? b,
                  ) =>
                      b!.get('sortAuthor').compareTo(a!.get('sortAuthor')),
                );
                break;
              case SortMethod.titleAsc:
                searchResults.sort(
                  (
                    final DocumentSnapshot<dynamic>? a,
                    final DocumentSnapshot<dynamic>? b,
                  ) =>
                      a!.get('sortTitle').compareTo(b!.get('sortTitle')),
                );
                break;
              case SortMethod.titleDesc:
                searchResults.sort(
                  (
                    final DocumentSnapshot<dynamic>? a,
                    final DocumentSnapshot<dynamic>? b,
                  ) =>
                      b!.get('sortTitle').compareTo(a!.get('sortTitle')),
                );
                break;
              case SortMethod.publishYearAsc:
                searchResults.sort(
                  (
                    final DocumentSnapshot<dynamic>? a,
                    final DocumentSnapshot<dynamic>? b,
                  ) =>
                      a!.get('publishYear').compareTo(b!.get('publishYear')),
                );
                break;
              case SortMethod.publishYearDesc:
                searchResults.sort(
                  (
                    final DocumentSnapshot<dynamic>? a,
                    final DocumentSnapshot<dynamic>? b,
                  ) =>
                      b!.get('publishYear').compareTo(a!.get('publishYear')),
                );
                break;
            }

            return vm.useGridView
                ? GridView.builder(
                    itemCount: searchResults.length,
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: vm.gridItemSize!,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    shrinkWrap: true,
                    itemBuilder:
                        (final BuildContext context, final int index) =>
                            BookGridTile(
                      Book.fromFBJson(searchResults[index]!.data()),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResults.length,
                    itemBuilder:
                        (final BuildContext context, final int index) =>
                            BookListTile(
                      Book.fromFBJson(searchResults[index]!.data()),
                    ),
                  );
          },
        ),
      );
}
