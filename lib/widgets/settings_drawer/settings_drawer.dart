import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/settings_drawer/settings_drawer_view_model.dart';
import 'package:librarian_frontend/widgets/settings_drawer/settings_footer/settings_footer.dart';
import 'package:librarian_frontend/widgets/settings_drawer/settings_header/settings_header.dart';
import 'package:librarian_frontend/widgets/settings_drawer/settings_section/settings_section.dart';
import 'package:redux/redux.dart';

class SettingsDrawer extends StatefulWidget {
  final User? user;
  const SettingsDrawer({final Key? key, this.user}) : super(key: key);

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  _buildDivider(final SettingsDrawerViewModel vm) =>
      Divider(indent: 16, endIndent: 16, thickness: 2, color: vm.textColor);

  @override
  Widget build(final BuildContext context) {
    final double _sw = MediaQuery.of(context).size.width;
    final double _sh = MediaQuery.of(context).size.height;
    final booksStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user!.uid)
        .collection('books')
        .snapshots();

    return StoreConnector(
      distinct: true,
      converter: (final Store<GlobalAppState> store) =>
          SettingsDrawerViewModel.create(store),
      builder: (final context, final SettingsDrawerViewModel vm) => Padding(
        padding: EdgeInsets.only(left: (_sw * 0.1) / 2, top: (_sh * 0.025)),
        child: Container(
          width: _sw * 0.9,
          height: _sh * 0.9,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(0, 0),
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
            color: vm.canvasColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: booksStream,
              builder: (final context, final snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      SettingsHeader(user: widget.user),
                      _buildDivider(vm),
                      const SettingsSection(),
                      const Spacer(),
                      _buildDivider(vm),
                      const SettingsFooter(),
                    ],
                  );
                }
                return const Center(
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
