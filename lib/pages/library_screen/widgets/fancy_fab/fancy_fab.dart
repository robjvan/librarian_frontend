import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/librarian_icons.dart';
import 'package:librarian_frontend/pages/library_screen/widgets/dialogs/manual_search_dialog/manual_search_dialog.dart';
import 'package:librarian_frontend/pages/library_screen/widgets/fancy_fab/fancy_fab_view_model.dart';

class FancyFAB extends StatefulWidget {
  const FancyFAB({final Key? key}) : super(key: key);

  @override
  FancyFABState createState() => FancyFABState();
}

class FancyFABState extends State<FancyFAB> {
  List<SpeedDialChild> _buildSpeedDialChildren(final FancyFABViewModel vm) =>
      <SpeedDialChild>[
        SpeedDialChild(
          onTap: () => vm.dispatch(ScanIsbnAction()),
          elevation: 0,
          backgroundColor: vm.canvasColor,
          labelWidget: Text(
            'fancy-fab.barcode-search'.tr,
            style: TextStyle(color: vm.textColor),
          ),
          child: SvgPicture.asset(
            LibrarianIcons.barcode,
            height: 32,
            color: vm.textColor,
          ),
        ),
        SpeedDialChild(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (final BuildContext ctx) => const ManualSearchDialog(),
            );
          },
          elevation: 0,
          backgroundColor: vm.canvasColor,
          labelWidget: Text(
            'fancy-fab.keyword-search'.tr,
            style: TextStyle(color: vm.textColor),
          ),
          child: SvgPicture.asset(
            LibrarianIcons.keywordSearch,
            height: 32,
            color: vm.textColor,
          ),
        ),
        SpeedDialChild(
          onTap: () {},
          elevation: 0,
          backgroundColor: vm.canvasColor,
          labelWidget: Text(
            'fancy-fab.add-book-manually'.tr,
            style: TextStyle(color: vm.textColor),
          ),
          child: SvgPicture.asset(
            LibrarianIcons.textField,
            height: 32,
            color: vm.textColor,
          ),
        ),
      ];

  @override
  Widget build(final BuildContext context) =>
      StoreConnector<GlobalAppState, FancyFABViewModel>(
        distinct: true,
        converter: FancyFABViewModel.create,
        builder: (
          final BuildContext context,
          final FancyFABViewModel vm,
        ) =>
            SpeedDial(
          backgroundColor: vm.userColor,
          buttonSize: const Size(48, 48),
          icon: Icons.add,
          foregroundColor: vm.textColor,
          activeIcon: Icons.close,
          renderOverlay: true,
          overlayColor: vm.canvasColor,
          overlayOpacity: 0.8,
          children: _buildSpeedDialChildren(vm),
        ),
      );
}
