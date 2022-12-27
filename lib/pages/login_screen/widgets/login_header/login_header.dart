import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/login_screen/widgets/login_header/login_header_view_model.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(final BuildContext context) {
    return StoreConnector<GlobalAppState, LoginHeaderViewModel>(
      distinct: true,
      converter: LoginHeaderViewModel.create,
      builder: (final BuildContext context, final LoginHeaderViewModel vm) {
        final double _sh = MediaQuery.of(context).size.height;
        //
        return SizedBox(
          height: _sh / 3,
          child: Hero(
            tag: 'headerHero',
            child: Material(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset('assets/images/bookshelf.jpg', fit: BoxFit.cover),
                  Center(
                    child: Text(
                      'app-title'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.loginHeaderStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
