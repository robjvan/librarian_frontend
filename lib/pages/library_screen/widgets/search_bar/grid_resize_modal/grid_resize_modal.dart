// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/user_settings_actions.dart';
import 'package:librarian_frontend/pages/library_screen/widgets/search_bar/search_bar_view_model.dart';
import 'package:librarian_frontend/state.dart';

class GridResizeModal extends StatefulWidget {
  const GridResizeModal();

  @override
  State<GridResizeModal> createState() => _GridResizeModalState();
}

class _GridResizeModalState extends State<GridResizeModal> {
  double? returnValue = 0;

  @override
  Widget build(final BuildContext context) =>
      StoreConnector<GlobalAppState, SearchBarViewModel>(
        distinct: true,
        converter: SearchBarViewModel.create,
        builder: (final BuildContext context, final SearchBarViewModel vm) {
          returnValue = vm.gridItemSize;

          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: vm.canvasColor,
            title: Text(
              'grid-resize-modal.title'.tr,
              style: TextStyle(color: vm.textColor, fontSize: 16),
            ),
            content: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: vm.userColor,
                activeTrackColor: vm.userColor,
                activeTickMarkColor: vm.userColor,
                inactiveTrackColor: vm.userColor.withOpacity(0.3),
              ),
              child: StatefulBuilder(
                builder: (final BuildContext context, final dynamic setState) =>
                    SizedBox(
                  height: 64,
                  child: Slider(
                    value: returnValue!,
                    min: 60,
                    max: 200,
                    onChanged: (final double newVal) => setState(() {
                      returnValue = newVal;
                      vm.dispatch(SetGridItemSizeAction(newVal));
                    }),
                  ),
                ),
              ),
            ),
          );
        },
      );
}
