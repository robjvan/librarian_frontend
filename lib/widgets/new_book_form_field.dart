import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/new_book_screen/new_book_screen_view_model.dart';

@immutable
class NewBookFormField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final NewBookScreenViewModel vm;
  final String? Function(String? s)? validatorFn;
  final bool? mini;
  final TextInputType? keyboardType;
  final bool? autoValidate;
  final int? maxLength;
  final double? width;
  final bool? forTitle;

  const NewBookFormField({
    required this.controller,
    required this.title,
    required this.vm,
    this.mini = false,
    this.validatorFn,
    this.keyboardType,
    this.autoValidate = false,
    this.maxLength,
    this.width,
    this.forTitle,
    super.key,
  });

  @override
  State<NewBookFormField> createState() => _NewBookFormFieldState();
}

class _NewBookFormFieldState extends State<NewBookFormField> {
  double fieldWidth = 100;

  Widget _formFieldChild({
    required final TextEditingController controller,
    required final String title,
    // required final double sw,
    required final NewBookScreenViewModel vm,
    final bool? autoValidate,
    final TextInputType? keyboardType,
    final String? Function(String? s)? validatorFn,
    final int? maxLength,
    final bool? forTitle,
    final double? width,
  }) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: Get.width,
          child: Text(
            title,
            style: vm.titleStyle,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: width ?? Get.width,
          child: TextFormField(
            maxLength: maxLength ?? 150,
            minLines: keyboardType == TextInputType.multiline ? 3 : 1,
            maxLines: keyboardType == TextInputType.multiline ? 5 : 1,
            autovalidateMode: autoValidate!
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            keyboardType: keyboardType ?? TextInputType.text,
            decoration: InputDecoration(
              hintText: forTitle != null ? '(required)' : '(optional)',
              hintStyle: TextStyle(
                color: vm.textColor.withOpacity(0.4),
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
              counterText: '',
              contentPadding:
                  const EdgeInsets.all(8),
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
            textAlign: maxLength != null ? TextAlign.center : TextAlign.start,
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

  @override
  Widget build(final BuildContext context) {
   
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          widget.mini!
              ? SizedBox(
                  width: widget.width ?? 100,
                  child: _formFieldChild(
                    controller: widget.controller,
                    autoValidate: widget.autoValidate,
                    keyboardType: widget.keyboardType,
                    validatorFn: widget.validatorFn,
                    title: widget.title,
                    vm: widget.vm,
                    // sw: sw,
                    maxLength: widget.maxLength,
                    width: widget.width,
                    forTitle: widget.forTitle,
                  ),
                )
              : Expanded(
                  child: _formFieldChild(
                    controller: widget.controller,
                    autoValidate: widget.autoValidate,
                    keyboardType: widget.keyboardType,
                    validatorFn: widget.validatorFn,
                    title: widget.title,
                    vm: widget.vm,
                    // sw: sw,
                    maxLength: widget.maxLength,
                    width: widget.width,
                    forTitle: widget.forTitle,
                  ),
                ),
        ],
      ),
    );
  }
}
