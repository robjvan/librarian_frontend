import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:redux/redux.dart';

import '../../../state.dart';
import '../settings_drawer_view_model.dart';

class SettingsHeader extends StatelessWidget {
  final User? user;
  const SettingsHeader({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var booksStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('books')
        .snapshots();

    _buildBookCountWidget(
      SettingsDrawerViewModel vm,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
    ) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8.0),
        child: Text(
          snapshot.hasData
              ? snapshot.data!.docs.length < 2
                  ? snapshot.data!.docs.length == 1
                      ? 'drawer.1-book-msg'.tr
                      : 'drawer.no-books-msg'.tr
                  : 'drawer.num-books-msg'
                      .trParams({'numBooks': '${snapshot.data!.docs.length}'})
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

    _exitButton(SettingsDrawerViewModel vm) {
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

    _userInfoRow(SettingsDrawerViewModel vm) {
      return Row(
        children: [
          const Spacer(),
          user!.photoURL == null
              ? const CircleAvatar(
                  minRadius: 32,
                  maxRadius: 32,
                  foregroundImage:
                      AssetImage('assets/images/image_placeholder.png'),
                )
              : CachedNetworkImage(
                  placeholder: (context, url) => const SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.contain,
                  imageUrl: user!.photoURL!,
                  imageBuilder: (context, imageProvider) {
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
            children: [
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

    _appTitleHeader(SettingsDrawerViewModel vm) {
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

    return StoreConnector(
      distinct: true,
      converter: (Store<GlobalAppState> store) =>
          SettingsDrawerViewModel.create(store),
      builder: (context, SettingsDrawerViewModel vm) {
        final double _sw = MediaQuery.of(context).size.width;
        return StreamBuilder<QuerySnapshot>(
          stream: booksStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: _sw,
                  child: Stack(
                    children: [
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
