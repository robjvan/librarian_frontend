import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/new_book_screen/new_book_screen_view_model.dart';
import 'package:librarian_frontend/pages/new_book_screen/widgets/new_book_form.dart';
import 'package:librarian_frontend/state.dart';

class NewBookScreen extends StatelessWidget {
  const NewBookScreen({super.key});

  Widget _buildBackButton(final NewBookScreenViewModel vm) => Positioned(
        top: 0,
        left: 0,
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: vm.textColor),
          onPressed: Get.back,
        ),
      );

  @override
  Widget build(final BuildContext context) {
    final Future<QuerySnapshot<dynamic>> searchResultsFuture = FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('books')
        .get();

    return StoreConnector<GlobalAppState, NewBookScreenViewModel>(
      distinct: true,
      converter: NewBookScreenViewModel.create,
      builder: (
        final BuildContext context,
        final NewBookScreenViewModel vm,
      ) {
        return Scaffold(
          backgroundColor: vm.canvasColor,
          body: SafeArea(
            child: FutureBuilder<QuerySnapshot<Object?>>(
              future: searchResultsFuture,
              builder: (
                final BuildContext context,
                final AsyncSnapshot<QuerySnapshot<dynamic>> snapshot,
              ) {
                return Stack(
                  children: <Widget>[
                    const NewBookForm(),
                    _buildBackButton(vm),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
