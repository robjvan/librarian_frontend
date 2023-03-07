import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/data_models/search_params.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/dialogs/manual_search_dialog/manual_search_dialog_view_model.dart';

class ManualSearchDialog extends StatefulWidget {
  const ManualSearchDialog({final Key? key}) : super(key: key);

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
  // FocusNode? keywordNode;
  // FocusNode? titleNode;
  // FocusNode? authorNode;
  // FocusNode? publisherNode;
  // FocusNode? isbnNode;
  // FocusNode? buttonNode;

  @override
  void initState() {
    super.initState();
    // keywordNode = FocusNode();
    // titleNode = FocusNode();
    // authorNode = FocusNode();
    // publisherNode = FocusNode();
    // isbnNode = FocusNode();
    // buttonNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _publisherController.dispose();
    _isbnController.dispose();

    // keywordNode!.dispose();
    // titleNode!.dispose();
    // authorNode!.dispose();
    // publisherNode!.dispose();
    // isbnNode!.dispose();
    // buttonNode!.dispose();

    super.dispose();
  }

  Widget _buildHeaderWidget(final ManualSearchDialogViewModel vm) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
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

  Widget _buildSearchForm(final ManualSearchDialogViewModel vm) {
    Widget _genericRow(
      final TextEditingController controller,
      final String labelText,
      // final FocusNode? node,
    ) =>
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                // focusNode: node,
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

    final List<Widget> searchRows = <Widget>[
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _genericRow(
          _yearController,
          'manual-search-dialog.search-row-labels.keywords'.tr,
          // keywordNode,
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _genericRow(
          _titleController,
          'manual-search-dialog.search-row-labels.title'.tr,
          // titleNode,
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _genericRow(
          _authorController,
          'manual-search-dialog.search-row-labels.author'.tr,
          // authorNode,
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _genericRow(
          _publisherController,
          'manual-search-dialog.search-row-labels.publisher'.tr,
          // publisherNode,
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _genericRow(
          _isbnController,
          'manual-search-dialog.search-row-labels.isbn'.tr,
          // isbnNode,
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[...searchRows],
      ),
    );
  }

  Widget _buildBottomButtons(final ManualSearchDialogViewModel vm) => Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextButton(
              onPressed: Get.back,
              child: Text('cancel'.tr, style: TextStyle(color: vm.textColor)),
            ),
            ElevatedButton(
              // focusNode: buttonNode,
              style: ElevatedButton.styleFrom(
                backgroundColor: vm.userColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'search'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 16),
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
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: StoreConnector<GlobalAppState, ManualSearchDialogViewModel>(
          distinct: true,
          converter: ManualSearchDialogViewModel.create,
          builder: (
            final BuildContext context,
            final ManualSearchDialogViewModel vm,
          ) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: vm.canvasColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
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
