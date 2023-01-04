import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/pages/new_book_screen/new_book_screen_view_model.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';

class NewBookForm extends StatefulWidget {
  const NewBookForm({super.key});

  @override
  State<NewBookForm> createState() => _NewBookFormState();
}

class _NewBookFormState extends State<NewBookForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController pageCountController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  final TextEditingController publishYearController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    pageCountController.dispose();
    authorController.dispose();
    publisherController.dispose();
    publishYearController.dispose();
    super.dispose();
  }

  Widget _buildImageGrabber() => SizedBox(
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          // child: CachedNetworkImage(
          //   imageUrl: book.thumbnail!,
          //   fit: BoxFit.cover,
          //   width: 200,
          // ),
          child: Image.asset(
            'assets/images/image_placeholder.png',
          ),
        ),
      );

  Widget _buildDivider(final NewBookScreenViewModel vm) =>
      Divider(thickness: 1, indent: 16, endIndent: 16, color: vm.textColor);

  @override
  Widget build(final BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;

    return StoreConnector<GlobalAppState, NewBookScreenViewModel>(
      distinct: true,
      converter: NewBookScreenViewModel.create,
      builder: (
        final BuildContext context,
        final NewBookScreenViewModel vm,
      ) {
        Widget _formFieldChild({
          required final TextEditingController controller,
          required final String title,
          final bool? autoValidate,
          final TextInputType? keyboardType,
          final String? Function(String? s)? validatorFn,
          final bool? mini = false,
        }) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: sw,
                child: Text(
                  title,
                  style: TextStyle(
                    color: controller.value.text.isEmpty
                        ? vm.userColor.withAlpha(180)
                        : vm.userColor.withAlpha(255),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: mini! ? 100 : sw,
                child: TextFormField(
                  maxLength: mini ? 5 : 150,
                  autovalidateMode: autoValidate!
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  keyboardType: keyboardType ?? TextInputType.text,
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: vm.textColor.withAlpha(100),
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: vm.textColor,
                        width: 2,
                      ),
                    ),
                  ),
                  style: TextStyle(color: vm.textColor),
                  controller: controller,
                  validator: validatorFn ??
                      (final _) {
                        return null;
                      },
                ),
              ),
            ],
          );
        }

        Widget _buildFormField({
          required final TextEditingController controller,
          required final String title,
          final String? Function(String? s)? validatorFn,
          final bool? mini = false,
          final TextInputType? keyboardType,
          final bool? autoValidate = false,
        }) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                mini!
                    ? SizedBox(
                        width: 100,
                        child: _formFieldChild(
                          controller: controller,
                          autoValidate: autoValidate,
                          keyboardType: keyboardType,
                          mini: mini,
                          validatorFn: validatorFn,
                          title: title,
                        ),
                      )
                    : Expanded(
                        child: _formFieldChild(
                          controller: controller,
                          autoValidate: autoValidate,
                          keyboardType: keyboardType,
                          mini: mini,
                          validatorFn: validatorFn,
                          title: title,
                        ),
                      ),
              ],
            ),
          );
        }

        Widget _buildYearPicker() {
          return Container();
        }

        Widget _buildActionButtons() {
          return Container();
        }

        return SizedBox(
          width: sw,
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 48),

                // Image picker
                _buildImageGrabber(),

                const SizedBox(height: 8),

                // Title field
                _buildFormField(
                  title: 'new-book.title'.tr,
                  controller: titleController,
                  validatorFn: (final String? s) {
                    if (s!.isEmpty) {
                      return 'new-book.title-error'.tr;
                    }
                    return null;
                  },
                  autoValidate: true,
                ),

                const SizedBox(height: 8),

                // Author(s) field
                _buildFormField(
                  title: 'new-book.author'.tr,
                  controller: authorController,
                ),

                const SizedBox(height: 8),

                // Ratings bar
                // TODO(Rob): Add ratings bar
                // _buildRatinsBar(vm),

                const SizedBox(height: 8),

                // Checkboxes for bool fields
                // TODO(Rob): Add checkbox section
                // _buildCheckboxes(vm),

                const SizedBox(height: 8),

                // Publisher(s) field
                _buildFormField(
                  title: 'new-book.publisher'.tr,
                  controller: publisherController,
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Page count field
                    _buildFormField(
                      title: 'new-book.page-count'.tr,
                      controller: pageCountController,
                      mini: true,
                      keyboardType: TextInputType.number,
                      validatorFn: (s) {
                        // TODO: Fix RegExp validators
                        if (!RegExp('[a-zA-Z]').hasMatch(s!)) {
                          return 'Numbers only!';
                        }
                      },
                    ),
                    // PublishYear field
                    _buildFormField(
                      title: 'new-book.publish-year'.tr,
                      controller: publishYearController,
                      mini: true,
                      keyboardType: TextInputType.number,
                      validatorFn: (s) {
                        // TODO: Fix RegExp validators
                        if (!RegExp("?=.*[a-zA-Z]").hasMatch(s!)) {
                          return 'Numbers only!';
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                _buildActionButtons(),
              ],
            ),
          ),
        );
      },
    );
  }
}
