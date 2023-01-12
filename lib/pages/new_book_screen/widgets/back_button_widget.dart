import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/new_book_screen/new_book_screen_view_model.dart';
import 'package:librarian_frontend/state.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(final BuildContext context) {
    return StoreConnector<GlobalAppState, NewBookScreenViewModel>(
      distinct: true,
      converter: NewBookScreenViewModel.create,
      builder: (final BuildContext context, final NewBookScreenViewModel vm) {
        return Positioned(
          top: 0,
          left: 0,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: vm.textColor),
            onPressed: Get.back,
          ),
        );
      },
    );
  }
}
