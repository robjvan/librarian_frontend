import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/pages/library_screen/widgets/dialogs/confirm_delete_dialog/confirm_delete_dialog_view_model.dart';
import 'package:librarian_frontend/state.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final Book book;
  const ConfirmDeleteDialog(
    this.book, {
    final Key? key,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) =>
      StoreConnector<GlobalAppState, ConfirmDeleteDialogViewModel>(
        converter: ConfirmDeleteDialogViewModel.create,
        distinct: true,
        builder: (
          final BuildContext context,
          final ConfirmDeleteDialogViewModel vm,
        ) =>
            SimpleDialog(
          backgroundColor: vm.canvasColor,
          title: Text(
            'confirm-delete'.tr,
            style: TextStyle(color: vm.textColor),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          spreadRadius: 0,
                          color: Colors.black87,
                          blurRadius: 2,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: book.thumbnail!,
                        fit: BoxFit.cover,
                        width: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: vm.textColor),
                      children: <TextSpan>[
                        TextSpan(text: 'delete-book-confirm-pt1'.tr),
                        TextSpan(
                          text: book.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'delete-book-confirm-pt2'.tr,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextButton(
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(color: vm.textColor),
                        ),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vm.userColor,
                        ),
                        child: Text(
                          'delete'.tr,
                          style: TextStyle(color: vm.textColor),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
}
