import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/pages/new_book_screen/new_book_screen_view_model.dart';
import 'package:librarian_frontend/pages/new_book_screen/widgets/new_book_form_field.dart';
import 'package:librarian_frontend/state.dart';

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
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  double bookRating = 0;
  bool isMature = false;
  bool addToWishlist = false;
  bool alreadyRead = false;
  bool addToFaves = false;
  bool addToShoppingList = false;
  String coverImageUrl = '';

  void submitFn(final NewBookScreenViewModel vm) {
    if (formKey.currentState!.validate()) {
      final Book newBook = Book.createEmpty();

      vm.dispatch(AddBookToCollectionAction(newBook));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    pageCountController.dispose();
    authorController.dispose();
    publisherController.dispose();
    publishYearController.dispose();
    isbnController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Widget _buildImageGrabber(final NewBookScreenViewModel vm) => SizedBox(
        height: 200,
        child: GestureDetector(
          onTap: () async {
            String newImageUrl = '';
            try {
              newImageUrl = await Get.defaultDialog(
                confirm: ElevatedButton(
                  onPressed: () {
                    Get.back(result: 'Button pressed -> Dialog closed OK');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vm.userColor,
                  ),
                  child: Text(
                    'ok'.tr,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );

              print(newImageUrl);
              // TODO(Rob): Continue image grabber logic

            } on Exception catch (_) {}

            if (newImageUrl != '') {
              coverImageUrl = newImageUrl;
            }
          },
          child:
              // coverImageUrl.isEmpty
              //     ?
              Image.asset(
            'assets/images/image_placeholder.png',
          )
          // : CachedNetworkImage(
          //     imageUrl: coverImageUrl,
          //     fit: BoxFit.cover,
          //     width: 200,
          //   )
          ,
        ),
      );

  Widget _buildRatingsBar(
    final NewBookScreenViewModel vm,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: <Widget>[
          Text(
            'new-book.rating'.tr,
            style: vm.titleStyle,
          ),
          const Spacer(),
          RatingBar(
            allowHalfRating: true,
            minRating: 0,
            initialRating: bookRating,
            direction: Axis.horizontal,
            itemSize: 24,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            ratingWidget: RatingWidget(
              full: Icon(Icons.star, color: vm.textColor),
              half: Icon(Icons.star_half, color: vm.textColor),
              empty: Icon(Icons.star_border, color: vm.textColor),
            ),
            onRatingUpdate: (final double rating) {
              bookRating = rating;
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBookToggles(
    final NewBookScreenViewModel vm,
    final double sw,
  ) {
    Widget _buildInfoCell(final String key, {final bool rightBorder = false}) {
      late Function _action;
      String _label = '';
      bool _checked = false;

      switch (key) {
        case 'inFavesList':
          _checked = addToFaves;
          _label = 'new-book.add-to-faves'.tr;
          _action = () {
            setState(() {
              addToFaves = !addToFaves;
            });
          };
          break;
        case 'inWishList':
          _checked = addToWishlist;
          _label = 'new-book.add-to-wishlist'.tr;
          _action = () {
            setState(() {
              addToWishlist = !addToWishlist;
            });
          };
          break;
        case 'inShoppingList':
          _checked = addToShoppingList;
          _label = 'new-book.add-to-shopping-list'.tr;
          _action = () {
            setState(() {
              addToShoppingList = !addToShoppingList;
            });
          };
          break;
        case 'haveRead':
          _checked = alreadyRead;
          _label = 'new-book.have-read'.tr;
          _action = () {
            setState(() {
              alreadyRead = !alreadyRead;
            });
          };
          break;
      }
      return Container(
        width: (0.5 * sw) - 16,
        decoration: rightBorder
            ? BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 1,
                    color: vm.textColor.withOpacity(0.4),
                  ),
                ),
              )
            : null,
        child: Row(
          children: <Widget>[
            Checkbox(
              fillColor: MaterialStateProperty.all(vm.userColor),
              value: _checked,
              onChanged: (final bool? newVal) => _action(),
            ),
            Text(
              _label,
              style: TextStyle(
                color: _checked ? vm.textColor : vm.textColor.withOpacity(0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: vm.textColor.withOpacity(0.4)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildInfoCell('inFavesList', rightBorder: true),
                _buildInfoCell('inWishList'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildInfoCell('haveRead', rightBorder: true),
                _buildInfoCell('inShoppingList'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(final NewBookScreenViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextButton(
          onPressed: Get.back,
          child: Text(
            'cancel'.tr,
            style: TextStyle(color: vm.textColor),
          ),
        ),
        ElevatedButton(
          onPressed: () => submitFn(vm),
          style: ElevatedButton.styleFrom(
            backgroundColor: vm.userColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            'save'.tr,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        )
      ],
    );
  }

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
        return SizedBox(
          width: sw,
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 48),
                // Image picker
                _buildImageGrabber(vm),
                const SizedBox(height: 16),
                // Title field
                NewBookFormField(
                  controller: titleController,
                  title: 'new-book.title'.tr,
                  validatorFn: vm.titleValidatorFn,
                  autoValidate: true,
                  forTitle: true,
                  sw: sw,
                  vm: vm,
                ),
                const SizedBox(height: 16),
                // Author(s) field
                NewBookFormField(
                  title: 'new-book.author'.tr,
                  controller: authorController,
                  sw: sw,
                  vm: vm,
                ),
                const SizedBox(height: 16),
                NewBookFormField(
                  controller: descriptionController,
                  title: 'new-book.description'.tr,
                  sw: sw,
                  vm: vm,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 16),
                // Ratings bar
                _buildRatingsBar(vm),
                // _buildRatinsBar(vm),
                const SizedBox(height: 16),
                _buildBookToggles(vm, sw),
                const SizedBox(height: 16),
                // Publisher(s) field
                NewBookFormField(
                  title: 'new-book.publisher'.tr,
                  controller: publisherController,
                  sw: sw,
                  vm: vm,
                ),
                const SizedBox(height: 16),
                // Page count and Publish year row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    NewBookFormField(
                      title: 'new-book.page-count'.tr,
                      controller: pageCountController,
                      mini: true,
                      keyboardType: TextInputType.number,
                      validatorFn: vm.numberValidatorFn,
                      sw: sw,
                      vm: vm,
                      maxLength: 5,
                    ),
                    NewBookFormField(
                      title: 'new-book.publish-year'.tr,
                      controller: publishYearController,
                      mini: true,
                      keyboardType: TextInputType.number,
                      validatorFn: vm.numberValidatorFn,
                      sw: sw,
                      vm: vm,
                      maxLength: 4,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // ISBN field
                Row(
                  children: <Widget>[
                    const Spacer(),
                    NewBookFormField(
                      title: 'new-book.isbn'.tr,
                      controller: isbnController,
                      mini: true,
                      keyboardType: TextInputType.number,
                      validatorFn: vm.numberValidatorFn,
                      sw: sw,
                      vm: vm,
                      maxLength: 13,
                      forIsbn: true,
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 48),
                _buildActionButtons(vm),
                const SizedBox(height: 48),
              ],
            ),
          ),
        );
      },
    );
  }
}