import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'package:librarian/actions/user_settings_actions.dart';
// import 'package:librarian/screens/library_screen/library_screen_view_model.dart';
// import 'package:librarian/state.dart';
// import 'package:librarian/widgets/exit_dialog/exit_dialog.dart';
// import 'package:librarian/widgets/widgets.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/pages/library_screen/library_screen_view_model.dart';
import 'package:librarian_frontend/state.dart';
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
          ) =>
              vm.isLoading
                  ? const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    )
                  : const Scaffold(
                      body: Center(child: Text('Library Screen')),
                      // drawer: SettingsDrawer(
                      //   user: FirebaseAuth.instance.currentUser,
                      // ),
                      // appBar: SearchBar(),
                      // backgroundColor: vm.canvasColor,
                      // floatingActionButton: const FancyFAB(),
                      // body: SizedBox(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: <Widget>[
                      //       if (vm.filterBarVisible) const FilterBar(),
                      //       const Expanded(child: CollectionView()),
                      //     ],
                      //   ),
                      // ),
                    ),
        ),
      );
}
