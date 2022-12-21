import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/settings_drawer/settings_drawer_view_model.dart';

class SettingsHeader extends StatelessWidget {
  final User? user;
  const SettingsHeader({final Key? key, this.user}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> booksStream =
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('books')
            .snapshots();

    Widget _buildBookCountWidget(
      final SettingsDrawerViewModel vm,
      final AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
    ) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8.0),
        child: Text(
          snapshot.hasData
              ? snapshot.data!.docs.length < 2
                  ? snapshot.data!.docs.length == 1
                      ? 'drawer.1-book-msg'.tr
                      : 'drawer.no-books-msg'.tr
                  : 'drawer.num-books-msg'.trParams(
                      <String, String>{
                        'numBooks': '${snapshot.data!.docs.length}'
                      },
                    )
              // args: ['${snapshot.data!.docs.length}'],

              : '',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            color: vm.textColor,
          ),
        ),
      );
    }

    Widget _exitButton(final SettingsDrawerViewModel vm) {
      return Positioned(
        top: 0,
        right: 0,
        child: IconButton(
          icon: Icon(Icons.close, color: vm.textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    }

    Widget _userInfoRow(final SettingsDrawerViewModel vm) {
      return Row(
        children: <Widget>[
          const Spacer(),
          user!.photoURL == null
              ? const CircleAvatar(
                  minRadius: 32,
                  maxRadius: 32,
                  foregroundImage:
                      AssetImage('assets/images/image_placeholder.png'),
                )
              : CachedNetworkImage(
                  placeholder: (
                    final BuildContext context,
                    final String url,
                  ) =>
                      const SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (
                    final BuildContext context,
                    final String url,
                    final dynamic error,
                  ) =>
                      const Icon(Icons.error),
                  fit: BoxFit.contain,
                  imageUrl: user!.photoURL!,
                  imageBuilder: (
                    final BuildContext context,
                    final ImageProvider<Object> imageProvider,
                  ) {
                    return CircleAvatar(
                      minRadius: 32,
                      maxRadius: 32,
                      foregroundImage: NetworkImage(user!.photoURL!),
                    );
                  },
                ),
          const SizedBox(width: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'drawer.signed-in-as'.tr,
                style: TextStyle(
                  color: vm.textColor,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user!.displayName ?? user!.email ?? '',
                style: TextStyle(
                  color: vm.textColor,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      );
    }

    Widget _appTitleHeader(final SettingsDrawerViewModel vm) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Text(
            'Librarian',
            style: TextStyle(
              fontFamily: 'CarroisSC',
              fontSize: 42,
              color: vm.textColor,
            ),
          ),
        ),
      );
    }

    return StoreConnector<GlobalAppState, SettingsDrawerViewModel>(
      distinct: true,
      converter: SettingsDrawerViewModel.create,
      builder: (final BuildContext context, final SettingsDrawerViewModel vm) {
        final double _sw = MediaQuery.of(context).size.width;
        return StreamBuilder<QuerySnapshot<dynamic>>(
          stream: booksStream,
          builder: (
            final BuildContext context,
            final AsyncSnapshot<QuerySnapshot<dynamic>> snapshot,
          ) {
            if (!snapshot.hasData) return Container();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: _sw,
                  child: Stack(
                    children: <Widget>[
                      _exitButton(vm),
                      _appTitleHeader(vm),
                    ],
                  ),
                ),
                _userInfoRow(vm),
                _buildBookCountWidget(vm, snapshot),
              ],
            );
          },
        );
      },
    );
  }
}
