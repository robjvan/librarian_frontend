import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/new_book_screen/new_book_screen_view_model.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/widgets.dart';

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
  int isbn = -1;
  int publishYear = -1;
  int pageCount = -1;

  // void submitFn(final NewBookScreenViewModel vm) {
  //   if (formKey.currentState!.validate()) {
  //     final Book newBook = Book.createEmpty();

  //     vm.dispatch(AddBookToCollectionAction(newBook));
  //   }
  // }

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

  Widget _buildImageGrabber(final NewBookScreenViewModel vm) {
    return SizedBox(
        // height: 200,
        child: Row(
          children: <Widget>[
            const Spacer(),
            GestureDetector(
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
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );

                  // print(newImageUrl);
                  // TODO(Rob): Continue image grabber logic
                } on Exception catch (_) {}

                // if (newImageUrl != '') {
                //   coverImageUrl = newImageUrl;
                // }
              },
              child:
                  // coverImageUrl.isEmpty
                  //     ?
                  ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  width: 200,
                  fit: BoxFit.cover,
                  'assets/images/image_placeholder.png',
                ),
              )
              // : CachedNetworkImage(
              //     imageUrl: coverImageUrl,
              //     fit: BoxFit.cover,
              //     width: 200,
              //   )
              ,
            ),
            const Spacer(),
          ],
        ),
      );
  }

  Widget _buildRatingsBar(
    final NewBookScreenViewModel vm,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 150,
            child: Text(
              'new-book.rating'.tr,
              style: vm.titleStyle,
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: 48,
            child: Center(
              child: RatingBar(
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
            ),
          ),
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
          onPressed: () {
            if (isbnController.value.text.contains(' ') ||
                isbnController.value.text.contains('-') ||
                isbnController.value.text == '') {
              // do nothing
            } else {
              isbn = int.parse(isbnController.value.text);
            }

            if (publishYearController.value.text.contains(' ') ||
                publishYearController.value.text.contains('-') ||
                publishYearController.value.text == '') {
              // do nothing
            } else {
              publishYear = int.parse(publishYearController.value.text);
            }

            if (pageCountController.value.text.contains(' ') ||
                pageCountController.value.text.contains('-') ||
                pageCountController.value.text == '') {
              // do nothing
            } else {
              pageCount = int.parse(pageCountController.value.text);
            }

            if (formKey.currentState!.validate()) {
              vm.submitFn(
                title: titleController.value.text,
                author: authorController.value.text,
                description: descriptionController.value.text,
                publisher: publisherController.value.text,
                isbn: isbn,
                publishYear: publishYear,
                pageCount: pageCount,
                rating: bookRating,
                addToFaves: addToFaves,
                addToShoppingList: addToShoppingList,
                addToWishlist: addToWishlist,
                alreadyRead: alreadyRead,
                thumbnailUrl: coverImageUrl,
              );

              Get.back();
            }
          },
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
                  vm: vm,
                ),
                const SizedBox(height: 16),
                // Author(s) field
                NewBookFormField(
                  title: 'new-book.author'.tr,
                  controller: authorController,
                  vm: vm,
                ),
                const SizedBox(height: 16),
                NewBookFormField(
                  controller: descriptionController,
                  title: 'new-book.description'.tr,
                  vm: vm,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 16),
                _buildBookToggles(vm, sw),
                const SizedBox(height: 16),
                // Publisher(s) field
                NewBookFormField(
                  title: 'new-book.publisher'.tr,
                  controller: publisherController,
                  vm: vm,
                ),
                const SizedBox(height: 16),
                // ISBN field
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    NewBookFormField(
                      title: 'new-book.isbn'.tr,
                      controller: isbnController,
                      mini: true,
                      keyboardType: TextInputType.number,
                      validatorFn: vm.numberValidatorFn,
                      vm: vm,
                      maxLength: 13,
                      width: 150,
                    ),
                    NewBookFormField(
                      title: 'new-book.publish-year'.tr,
                      controller: publishYearController,
                      mini: true,
                      keyboardType: TextInputType.number,
                      validatorFn: vm.numberValidatorFn,
                      vm: vm,
                      maxLength: 4,
                      width: 100,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Page count and Publish year row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Ratings bar
                    _buildRatingsBar(vm),
                    NewBookFormField(
                      title: 'new-book.page-count'.tr,
                      controller: pageCountController,
                      mini: true,
                      keyboardType: TextInputType.number,
                      validatorFn: vm.numberValidatorFn,
                      vm: vm,
                      maxLength: 5,
                      width: 100,
                    ),
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
