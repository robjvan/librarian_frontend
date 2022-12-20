import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:redux/redux.dart';

import '../../../actions/actions.dart';
import '../../../models/data_models/search_params.dart';
import '../../../state.dart';
import 'manual_search_dialog_view_model.dart';

class ManualSearchDialog extends StatefulWidget {
  const ManualSearchDialog({Key? key}) : super(key: key);

  @override
  State<ManualSearchDialog> createState() => _ManualSearchDialogState();
}

class _ManualSearchDialogState extends State<ManualSearchDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode? keywordNode;
  FocusNode? titleNode;
  FocusNode? authorNode;
  FocusNode? publisherNode;
  FocusNode? isbnNode;
  FocusNode? buttonNode;

  @override
  void initState() {
    super.initState();
    keywordNode = FocusNode();
    titleNode = FocusNode();
    authorNode = FocusNode();
    publisherNode = FocusNode();
    isbnNode = FocusNode();
    buttonNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _publisherController.dispose();
    _isbnController.dispose();

    keywordNode!.dispose();
    titleNode!.dispose();
    authorNode!.dispose();
    publisherNode!.dispose();
    isbnNode!.dispose();
    buttonNode!.dispose();

    super.dispose();
  }

  _buildHeaderWidget(ManualSearchDialogViewModel vm) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'manual-search-dialog.title'.tr,
              style: TextStyle(
                color: vm.textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'manual-search-dialog.body'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: vm.textColor, fontSize: 18),
            )
          ],
        ),
      );

  _buildSearchForm(ManualSearchDialogViewModel vm) {
    _genericRow(
      TextEditingController controller,
      String labelText,
      FocusNode? node,
    ) =>
        Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: node,
                style: TextStyle(color: vm.textColor),
                controller: controller,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: TextStyle(color: vm.textColor.withOpacity(0.7)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: vm.userColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: vm.userColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            )
          ],
        );

    final List<Widget> searchRows = [
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _genericRow(
          _yearController,
          'manual-search-dialog.search-row-labels.keywords'.tr,
          keywordNode,
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _genericRow(
          _titleController,
          'manual-search-dialog.search-row-labels.title'.tr,
          titleNode,
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _genericRow(
          _authorController,
          'manual-search-dialog.search-row-labels.author'.tr,
          authorNode,
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _genericRow(
          _publisherController,
          'manual-search-dialog.search-row-labels.publisher'.tr,
          publisherNode,
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _genericRow(
          _isbnController,
          'manual-search-dialog.search-row-labels.isbn'.tr,
          isbnNode,
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: [...searchRows]),
    );
  }

  Widget _buildBottomButtons(final ManualSearchDialogViewModel vm) => Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              child: Text('cancel'.tr, style: TextStyle(color: vm.textColor)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              focusNode: buttonNode,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'search'.tr,
                style: TextStyle(color: vm.textColor, fontSize: 18),
              ),
              onPressed: () {
                SearchParams _searchParams = SearchParams.createEmpty();
                // ensure at least ONE of the fields is populated
                if (_titleController.text.isNotEmpty ||
                    _authorController.text.isNotEmpty ||
                    _publisherController.text.isNotEmpty ||
                    _yearController.text.isNotEmpty ||
                    _isbnController.text.isNotEmpty) {
                  _searchParams = _searchParams.copyWith(
                    title: _titleController.text,
                    author: _authorController.text,
                    year: _yearController.text,
                    publisher: _publisherController.text,
                    isbn: _isbnController.text,
                  ) as SearchParams;
                  vm.dispatch(KeywordSearchAction(_searchParams));
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: StoreConnector(
          distinct: true,
          converter: (Store<GlobalAppState> store) =>
              ManualSearchDialogViewModel.create(store),
          builder: (context, ManualSearchDialogViewModel vm) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: vm.canvasColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _buildHeaderWidget(vm),
                      _buildSearchForm(vm),
                      _buildBottomButtons(vm),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
}
