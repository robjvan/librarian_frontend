import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:redux/redux.dart';

import '../../../state.dart';
import 'search_results_dialog_view_model.dart';

class SearchResultsDialog extends StatelessWidget {
  final List<dynamic>? results;
  // ignore: use_key_in_widget_constructors
  const SearchResultsDialog(this.results);

  _buildDialogHeader(SearchResultsDialogViewModel vm) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
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

  _buildResultsBox(BuildContext context, SearchResultsDialogViewModel vm) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: vm.userColor),
          boxShadow: [
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
          itemBuilder: (ctx, i) {
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

  _buildBottomButtons(BuildContext context, SearchResultsDialogViewModel vm) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
  Widget build(BuildContext context) {
    final double _sh = MediaQuery.of(context).size.height;
    final double _sw = MediaQuery.of(context).size.width;

    return StoreConnector(
      distinct: true,
      converter: (Store<GlobalAppState> store) =>
          SearchResultsDialogViewModel.create(store),
      builder: (context, SearchResultsDialogViewModel vm) => Scaffold(
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
              children: [
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
      ),
    );
  }
}
