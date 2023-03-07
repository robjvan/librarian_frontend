import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/filter_bar/filter_bar_view_model.dart';
// import 'package:librarian/actions/actions.dart';
// import 'package:librarian/models/models.dart';
// import 'package:librarian/state.dart';
// import 'package:librarian/widgets/filter_bar/filter_bar_view_model.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({final Key? key}) : super(key: key);

  List<DropdownMenuItem<dynamic>> _buildSortMethodOptions(
    final FilterBarViewModel vm,
    final BuildContext context,
  ) {
    final Color _mainColor = vm.userColor;

    Widget _sortRow(
      final FilterBarViewModel vm,
      final String label,
      final String sortDirection,
    ) =>
        SizedBox(
          width: 160,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(label, style: TextStyle(color: _mainColor)),
              const Spacer(),
              Icon(
                sortDirection == 'desc'
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                size: 24,
                color: _mainColor,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    label.contains('Published')
                        ? sortDirection == 'desc'
                            ? 'filter-bar.new'.tr
                            : 'filter-bar.old'.tr
                        : sortDirection == 'desc'
                            ? 'Z'
                            : 'A',
                    style: TextStyle(
                      color: _mainColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label.contains('Published')
                        ? sortDirection == 'desc'
                            ? 'filter-bar.old'.tr
                            : 'filter-bar.new'.tr
                        : sortDirection == 'desc'
                            ? 'A'
                            : 'Z',
                    style: TextStyle(
                      color: _mainColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

    return <DropdownMenuItem<dynamic>>[
      DropdownMenuItem<dynamic>(
        value: SortMethod.authorAsc,
        child: _sortRow(vm, 'filter-bar.author-asc'.tr, 'asc'),
      ),
      DropdownMenuItem<dynamic>(
        value: SortMethod.authorDesc,
        child: _sortRow(vm, 'filter-bar.author-desc'.tr, 'desc'),
      ),
      DropdownMenuItem<dynamic>(
        value: SortMethod.titleAsc,
        child: _sortRow(vm, 'filter-bar.title-asc'.tr, 'asc'),
      ),
      DropdownMenuItem<dynamic>(
        value: SortMethod.titleDesc,
        child: _sortRow(vm, 'filter-bar.title-desc'.tr, 'desc'),
      ),
      DropdownMenuItem<dynamic>(
        value: SortMethod.publishYearAsc,
        child: _sortRow(vm, 'filter-bar.published-asc'.tr, 'asc'),
      ),
      DropdownMenuItem<dynamic>(
        value: SortMethod.publishYearDesc,
        child: _sortRow(vm, 'filter-bar.published-desc'.tr, 'desc'),
      ),
    ];
  }

  List<DropdownMenuItem<dynamic>> _buildFilterKeyOptions(
    final FilterBarViewModel vm,
    final BuildContext context,
  ) {
    Widget _filterRowItem(final String label) {
      return Text(
        label,
        style: TextStyle(color: vm.userColor),
      );
    }

    return <DropdownMenuItem<dynamic>>[
      DropdownMenuItem<dynamic>(
        value: FilterKey.all,
        child: _filterRowItem('filter-bar.all'.tr),
      ),
      DropdownMenuItem<dynamic>(
        value: FilterKey.faves,
        child: _filterRowItem('filter-bar.faves'.tr),
      ),
      DropdownMenuItem<dynamic>(
        value: FilterKey.wishlist,
        child: _filterRowItem('filter-bar.wishlist'.tr),
      ),
      DropdownMenuItem<dynamic>(
        value: FilterKey.unread,
        child: _filterRowItem('filter-bar.unread'.tr),
      ),
    ];
  }

  @override
  Widget build(final BuildContext context) {
    return StoreConnector<GlobalAppState, FilterBarViewModel>(
      distinct: true,
      converter: FilterBarViewModel.create,
      builder: (final BuildContext context, final FilterBarViewModel vm) =>
          vm.visibileFilterBar
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: vm.canvasColor,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset.zero,
                        spreadRadius: 0,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      const SizedBox(width: 8),
                      Text(
                        'filter-bar.show'.tr,
                        style: TextStyle(color: vm.textColor),
                      ),
                      const SizedBox(width: 4),
                      DropdownButton<dynamic>(
                        borderRadius: BorderRadius.circular(6),
                        underline: Container(),
                        dropdownColor: vm.canvasColor,
                        onChanged: (final dynamic val) =>
                            vm.dispatch(UpdateFilterKeyAction(val)),
                        value: vm.filterKey,
                        items: _buildFilterKeyOptions(vm, context),
                      ),
                      const Spacer(),
                      Text(
                        'filter-bar.sort'.tr,
                        style: TextStyle(color: vm.textColor),
                      ),
                      const SizedBox(width: 4),
                      DropdownButton<dynamic>(
                        borderRadius: BorderRadius.circular(6),
                        underline: Container(),
                        dropdownColor: vm.canvasColor,
                        onChanged: (final dynamic val) =>
                            vm.dispatch(ChangeSortMethodAction(val)),
                        value: vm.sortMethod,
                        items: _buildSortMethodOptions(vm, context),
                      ),
                    ],
                  ),
                )
              : AppBar(
                  backgroundColor: vm.canvasColor,
                  automaticallyImplyLeading: false,
                ),
    );
  }
}
