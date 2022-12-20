import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:librarian_frontend/widgets/search_bar/grid_resize_modal/grid_resize_modal.dart';
import 'package:librarian_frontend/widgets/search_bar/search_bar_view_model.dart';
import 'package:redux/redux.dart';

class SearchBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  SearchBar({Key? key})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  Widget _buildSearchBox(SearchBarViewModel vm, double _sw) => Container(
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: vm.textColor),
        ),
        child: TextFormField(
          autofocus: true,
          onChanged: (val) => vm.updateSearchTerm(_searchController.text),
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'search-collection'.tr,
            hintStyle: const TextStyle(color: grey, fontSize: 16),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? InkWell(
                    borderRadius: BorderRadius.circular(25),
                    child: Icon(Icons.cancel, color: vm.textColor),
                    onTap: () {
                      vm.clearSearchTerm(_searchController);
                    },
                  )
                : null,
            isDense: true,
            contentPadding: const EdgeInsets.fromLTRB(12, 4, 0, 0),
          ),
          style: TextStyle(color: vm.textColor, fontSize: 18),
        ),
      );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _sw = MediaQuery.of(context).size.width;

    return StoreConnector(
      distinct: true,
      converter: (Store<GlobalAppState> store) =>
          SearchBarViewModel.create(store),
      builder: (context, SearchBarViewModel vm) => AppBar(
        elevation: vm.filterBarVisible ? 0 : 4,
        backgroundColor: vm.canvasColor,
        leading: IconButton(
          icon: Icon(Icons.menu, color: vm.textColor),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        titleSpacing: 0,
        title: vm.searchBoxVisible ? _buildSearchBox(vm, _sw) : null,
        actions: [
          IconButton(
            color: vm.searchBoxVisible ? vm.userColor : vm.textColor,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.search),
            onPressed: () => vm.toggleSearchBox(),
          ),
          IconButton(
            color: vm.filterBarVisible ? vm.userColor : vm.textColor,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.filter_alt),
            onPressed: () => vm.toggleFilterBar(),
          ),
          if (vm.useGridView)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: FaIcon(
                FontAwesomeIcons.upRightAndDownLeftFromCenter,
                color: vm.resizeModalVisible ? vm.userColor : vm.textColor,
                size: 18,
              ),
              onPressed: () async {
                await showDialog<double>(
                  context: context,
                  builder: (final BuildContext context) =>
                      const GridResizeModal(),
                );
              },
            ),
          // if (vm.useGridView)
          //   if (vm.resizeModalVisible) GridResizeModal(),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: vm.useGridView
                ? Icon(Icons.view_list_sharp, color: vm.textColor)
                : Icon(Icons.grid_view_sharp, color: vm.textColor),
            onPressed: () => vm.toggleGridView(),
          )
        ],
      ),
    );
  }
}
