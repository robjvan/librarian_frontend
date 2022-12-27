import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/library_screen/widgets/dialogs/search_results_dialog/search_results_dialog_view_model.dart';
import 'package:librarian_frontend/state.dart';

class SearchResultsDialog extends StatelessWidget {
  final List<dynamic>? results;
  // ignore: use_key_in_widget_constructors
  const SearchResultsDialog(this.results);

  Widget _buildDialogHeader(
    final SearchResultsDialogViewModel vm,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Text(
              'search-results-dialog.title'.tr,
              style: TextStyle(
                color: vm.textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'search-results-dialog.body'.tr,
              style: TextStyle(color: vm.textColor, fontSize: 18),
            )
          ],
        ),
      );

  Widget _buildResultsBox(
    final BuildContext context,
    final SearchResultsDialogViewModel vm,
  ) =>
      DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: vm.userColor),
          boxShadow: <BoxShadow>[
            const BoxShadow(color: Colors.black54),
            BoxShadow(
              color: vm.canvasColor,
              spreadRadius: -1,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: GridView.builder(
          itemCount: results!.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (final BuildContext ctx, final int i) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black26),
              ),
              padding: const EdgeInsets.all(1),
              child: GestureDetector(
                onTap: () => Navigator.pop(context, i),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: GridTile(
                    child: Center(
                      child: results![i].thumbnail != 'null'
                          ? CachedNetworkImage(
                              imageUrl: results![i].thumbnail,
                              fit: BoxFit.fitHeight,
                            )
                          : Text(
                              results![i].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: vm.textColor),
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget _buildBottomButtons(
    final BuildContext context,
    final SearchResultsDialogViewModel vm,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextButton(
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: vm.userColor),
            ),
            onPressed: () => Navigator.pop(context, -1),
          ),
        ],
      );

  @override
  Widget build(final BuildContext context) {
    final double _sh = MediaQuery.of(context).size.height;
    final double _sw = MediaQuery.of(context).size.width;

    return StoreConnector<GlobalAppState, SearchResultsDialogViewModel>(
      distinct: true,
      converter: SearchResultsDialogViewModel.create,
      builder: (
        final BuildContext context,
        final SearchResultsDialogViewModel vm,
      ) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                color: vm.canvasColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16.0),
              width: _sw * .95,
              height: _sh * .8,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _buildDialogHeader(vm),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: _buildResultsBox(context, vm),
                    ),
                  ),
                  _buildBottomButtons(context, vm),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
