import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/authentication.dart';
import 'package:librarian_frontend/widgets/settings_drawer/settings_drawer_view_model.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    // Route<dynamic> _routeToSignInScreen() {
    //   return PageRouteBuilder<dynamic>(
    //     pageBuilder: (
    //       final BuildContext context,
    //       final Animation<double> animation,
    //       final Animation<double> secondaryAnimation,
    //     ) =>
    //         const LoginScreen(),
    //     transitionsBuilder: (
    //       final BuildContext context,
    //       final Animation<double> animation,
    //       final Animation<double> secondaryAnimation,
    //       final Widget child,
    //     ) {
    //       const Offset begin = Offset(-1.0, 0.0);
    //       const Offset end = Offset.zero;
    //       const Cubic curve = Curves.ease;

    //       final Animatable<Offset> tween = Tween<Offset>(begin: begin, end: end)
    //           .chain(CurveTween(curve: curve));

    //       return SlideTransition(
    //         position: animation.drive(tween),
    //         child: child,
    //       );
    //     },
    //   );
    // }

    Widget _aboutAppDialog(final SettingsDrawerViewModel vm) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceAround,
        backgroundColor: vm.canvasColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Librarian', style: TextStyle(color: vm.textColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Doloremque deserunt adipisci alias occaecati omnis voluptas sint. Id omnis tempora vero dignissimos ducimus et explicabo doloribus dolor.',
                style: TextStyle(color: vm.textColor),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Text(
            '© 2022 Rob Vandelinder',
            style: TextStyle(color: vm.textColor, fontSize: 12),
          ),
          MaterialButton(
            color: vm.userColor,
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Ok', style: TextStyle(color: vm.textColor)),
          ),
        ],
      );
    }

    return StoreConnector<GlobalAppState, SettingsDrawerViewModel>(
      distinct: true,
      converter: SettingsDrawerViewModel.create,
      builder: (final BuildContext context, final SettingsDrawerViewModel vm) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.info_outline, color: vm.textColor),
              title: Text(
                'drawer.about-app'.tr,
                style: TextStyle(color: vm.textColor),
              ),
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (final _) => _aboutAppDialog(vm),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: vm.textColor),
              title: Text(
                'drawer.sign-out'.tr,
                style: TextStyle(color: vm.textColor),
              ),
              onTap: () async {
                await Authentication.signOut(context: context);
                unawaited(
                  // Navigator.of(context).pushReplacement(
                  //   _routeToSignInScreen(),
                  // ),
                  Get.offAll(() => const LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
