import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/pages/library_screen/library_screen_view_model.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/collection_view/collection_view.dart';
import 'package:librarian_frontend/widgets/settings_drawer/settings_drawer.dart';
import 'package:librarian_frontend/widgets/widgets.dart';
import 'package:redux/redux.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({final Key? key}) : super(key: key);

  void oninit(final Store<GlobalAppState> store) {
    store.dispatch(LoadLocalDataAction());
  }

  @override
  Widget build(final BuildContext context) => WillPopScope(
        onWillPop: () =>
            showExitPopup(context).then((final bool? value) => value!),
        child: StoreConnector<GlobalAppState, LibraryScreenViewModel>(
          onInit: oninit,
          distinct: true,
          converter: LibraryScreenViewModel.create,
          builder: (
            final BuildContext context,
            final LibraryScreenViewModel vm,
          ) {
            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection('books')
                  .snapshots(),
              builder: (
                final BuildContext context,
                final AsyncSnapshot<QuerySnapshot<dynamic>> snapshot,
              ) {
                if (FirebaseAuth.instance.currentUser != null) {
                  return vm.isLoading
                      ? const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        )
                      : Scaffold(
                          body: SizedBox(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (vm.filterBarVisible) const FilterBar(),
                                const Expanded(child: CollectionView()),
                              ],
                            ),
                          ),
                          // body: SafeArea(
                          //   child: Column(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //       const Text('Library Screen'),
                          //       ElevatedButton(
                          //         onPressed: () {
                          //           FirebaseAuth.instance.signOut();
                          //           ;
                          //         },
                          //         child: const Text('Logout'),
                          //       ),
                          //       const CollectionView()
                          //     ],
                          //   ),
                          // ),
                          drawer: SettingsDrawer(
                            user: FirebaseAuth.instance.currentUser,
                          ),
                          appBar: SearchBar(),
                          backgroundColor: vm.canvasColor,
                          floatingActionButton: const FancyFAB(),
                          // body: SizedBox(
                          //   child: Column(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: <Widget>[
                          //       if (vm.filterBarVisible) const FilterBar(),
                          //       const Expanded(child: CollectionView()),
                          //     ],
                          //   ),
                          // ),
                        );
                } else {
                  return Container();
                }
              },
            );
          },
        ),
      );
}
