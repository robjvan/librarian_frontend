import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/dialogs/confirm_delete_dialog/confirm_delete_dialog_view_model.dart';

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
            'Confirm Delete',
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
                        const TextSpan(
                          text: 'Are you sure you want to delete "',
                        ),
                        TextSpan(
                          text: book.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: '"?  This cannot be undone.',
                          style: TextStyle(fontStyle: FontStyle.italic),
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
                          'Cancel',
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
                          'Delete',
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
