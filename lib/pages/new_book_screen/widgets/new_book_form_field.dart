import 'package:flutter/material.dart';
import 'package:librarian_frontend/pages/new_book_screen/new_book_screen_view_model.dart';

@immutable
class NewBookFormField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final double sw;
  final NewBookScreenViewModel vm;
  final String? Function(String? s)? validatorFn;
  final bool? mini;
  final TextInputType? keyboardType;
  final bool? autoValidate;
  final int? maxLength;
  final bool? forIsbn;
  final bool? forTitle;

  const NewBookFormField({
    required this.controller,
    required this.title,
    required this.sw,
    required this.vm,
    this.mini = false,
    this.validatorFn,
    this.keyboardType,
    this.autoValidate = false,
    this.maxLength,
    this.forIsbn,
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
    required final double sw,
    required final NewBookScreenViewModel vm,
    final bool? autoValidate,
    final TextInputType? keyboardType,
    final String? Function(String? s)? validatorFn,
    final int? maxLength,
    final bool? forIsbn,
    final bool? forTitle,
  }) {
    if (maxLength != null) {
      if (maxLength == 13) {
        fieldWidth = 150;
      } else if (maxLength < 10) {
        fieldWidth = 100;
      }
    } else {
      fieldWidth = sw;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: sw,
          child: Text(
            title,
            style: vm.titleStyle,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: fieldWidth,
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
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  width: fieldWidth,
                  child: _formFieldChild(
                    controller: widget.controller,
                    autoValidate: widget.autoValidate,
                    keyboardType: widget.keyboardType,
                    validatorFn: widget.validatorFn,
                    title: widget.title,
                    vm: widget.vm,
                    sw: widget.sw,
                    maxLength: widget.maxLength,
                    forIsbn: widget.forIsbn,
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
                    sw: widget.sw,
                    maxLength: widget.maxLength,
                    forIsbn: widget.forIsbn,
                    forTitle: widget.forTitle,
                  ),
                ),
        ],
      ),
    );
  }
}
