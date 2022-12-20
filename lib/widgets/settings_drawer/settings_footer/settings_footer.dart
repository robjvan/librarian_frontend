import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/utilities/authentication.dart';
import 'package:redux/redux.dart';

import '../../../state.dart';
import '../settings_drawer_view_model.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Route _routeToSignInScreen(vm) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(-1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    _aboutAppDialog(SettingsDrawerViewModel vm) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceAround,
        backgroundColor: vm.canvasColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Librarian', style: TextStyle(color: vm.textColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Doloremque deserunt adipisci alias occaecati omnis voluptas sint. Id omnis tempora vero dignissimos ducimus et explicabo doloribus dolor.',
                style: TextStyle(color: vm.textColor),
              ),
            ],
          ),
        ),
        actions: [
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

    return StoreConnector(
      distinct: true,
      converter: (Store<GlobalAppState> store) =>
          SettingsDrawerViewModel.create(store),
      builder: (context, SettingsDrawerViewModel vm) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ListTile(
              leading: Icon(Icons.info_outline, color: vm.textColor),
              title: Text(
                'drawer.about-app'.tr,
                style: TextStyle(color: vm.textColor),
              ),
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (_) => _aboutAppDialog(vm),
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
                Navigator.of(context).pushReplacement(_routeToSignInScreen(vm));
              },
            ),
          ],
        );
      },
    );
  }
}
