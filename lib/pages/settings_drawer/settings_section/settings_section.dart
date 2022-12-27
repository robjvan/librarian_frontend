import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/pages/settings_drawer/settings_drawer_view_model.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({final dynamic key}) : super(key: key);

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  @override
  Widget build(final BuildContext context) {
    final double _sw = MediaQuery.of(context).size.width;

    Widget _buildDarkModeToggle(
      final SettingsDrawerViewModel vm,
      final double _sw,
    ) {
      int _index = 0;
      final double halfSw = (_sw - 64) / 3;
      if (vm.useDarkMode) {
        _index = 1;
      } else {
        _index = 0;
      }
      return Column(
        children: <Widget>[
          ToggleSwitch(
            customWidths: <double>[halfSw, halfSw],
            initialLabelIndex: _index,
            labels: <String>[
              'drawer.settings.light-mode'.tr,
              'drawer.settings.dark-mode'.tr
            ],
            totalSwitches: 2,
            onToggle: (final _) => <dynamic>{vm.toggleDarkMode()},
            animate: true,
            curve: Curves.easeInOut,
            animationDuration: 250,
            inactiveFgColor: vm.textColor,
            activeBgColor: <Color>[vm.userColor],
            inactiveBgColor:
                vm.useDarkMode ? const Color(0xFF303030) : lightGrey,
          )
        ],
      );
    }

    Widget _buildColorChooser(
      final SettingsDrawerViewModel vm,
      final double _sw,
    ) {
      Color _newColor = vm.userColor;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'color-picker.label'.tr,
              style: TextStyle(color: vm.textColor),
            ),
            GestureDetector(
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: vm.canvasColor,
                    title: Text(
                      'color-picker.title'.tr,
                      style: TextStyle(color: vm.textColor),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _newColor,
                        ),
                        child: Text(
                          'submit'.tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                    content: BlockPicker(
                      useInShowDialog: true,
                      pickerColor: vm.userColor,
                      onColorChanged: (final Color selectedColor) {
                        setState(() => _newColor = selectedColor);
                        vm.dispatch(
                          ChangeUserColorAction(selectedColor),
                        );
                      },
                    ),
                  ),
                );
              },
              // onTap: () async => showDialog(
              //   context: context,
              //   builder: (final BuildContext ctx) => StatefulBuilder(
              //     builder: (
              //       final BuildContext context,
              //       final Function(void Function()) setState,
              //     ) =>
              //         AlertDialog(
              //       backgroundColor: vm.canvasColor,
              //       title: Text(
              //         'color-picker.title'.tr,
              //         style: TextStyle(color: vm.textColor),
              //       ),
              //       actions: <Widget>[
              //         ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: _newColor,
              //           ),
              //           child: Text(
              //             'submit'.tr,
              //             style: const TextStyle(color: Colors.white),
              //           ),
              //           onPressed: () => Navigator.pop(context),
              //         )
              //       ],
              //       content: BlockPicker(
              //         useInShowDialog: true,
              //         pickerColor: vm.userColor,
              //         onColorChanged: (final Color selectedColor) {
              //           setState(() => _newColor = selectedColor);
              //           vm.dispatch(
              //             ChangeUserColorAction(selectedColor),
              //           );
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: vm.textColor),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: vm.textColor.withOpacity(0.1))
                  ],
                ),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(color: vm.userColor),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return StoreConnector<GlobalAppState, SettingsDrawerViewModel>(
      distinct: true,
      converter: SettingsDrawerViewModel.create,
      builder: (final BuildContext context, final dynamic vm) =>
          SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'drawer.settings.title'.tr,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  color: vm.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildDarkModeToggle(vm, _sw),
            _buildColorChooser(vm, _sw),
          ],
        ),
      ),
    );
  }
}
