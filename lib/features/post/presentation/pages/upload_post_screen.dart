import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/l10n/app_localizations.dart';

import '../../../block_report/presentation/widgets/custom_snack_bar.dart';
import '../../domain/entities/post_upload_dto.dart';
import '../../domain/entities/post_view_dto.dart';
import '../providers/post_provider.dart';

class AddPostScreen extends StatefulWidget {
  final PostViewDto? postViewDto;

  const AddPostScreen({
    super.key,
    this.postViewDto,
  });

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool _isLoading = false;
  List<File> selectedImages = [];
  final picker = ImagePicker();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool get isEditing => widget.postViewDto != null;

  Future getImages() async {
    final List<XFile> pickedFiles = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (pickedFiles.isNotEmpty) {
      setState(() {
        for (var xfile in pickedFiles) {
          selectedImages.add(File(xfile.path));
        }
      });
    } else {
      CustomSnackBar.show(context, 'No images selected');
    }
  }

  void clearImage() {
    setState(() {
      selectedImages = [];
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _titleController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.postViewDto?.post.title ?? '');
    _descriptionController = TextEditingController(text: widget.postViewDto?.post.description ?? '');
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, double screenWidth, double screenHeight, AppLocalizations localization) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        isEditing ? localization.modify : localization.write_post,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      leading: _buildBackButton(context, screenWidth, screenHeight),
      actions: [
        _buildUploadButton(context, screenWidth, screenHeight, localization)
      ],
    );
  }

  Widget _buildBackButton(BuildContext context, double screenWidth, double screenHeight) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Image.asset(
        'assets/images/chevron_left.png',
        width: screenWidth * 0.058248,
        height: screenHeight * 0.026232,
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context, double screenWidth, double screenHeight, AppLocalizations localization) {
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.038832),
      child: TextButton(
        onPressed: _isLoading
            ? null
            : () async {
                if (_titleController.text.isEmpty) {
                  CustomSnackBar.show(context, '제목을 입력해주세요.');
                  return;
                }

                setState(() {
                  _isLoading = true;
                });

                try {
                  if (isEditing) {
                    final updatedPost = widget.postViewDto!.post.copyWith(
                      title: _titleController.text.trim(),
                      description: _descriptionController.text.trim(),
                    );
                    await Provider.of<PostProvider>(context, listen: false).updatePost(context, updatedPost);
                  } else {
                    final PostUploadDto dto = PostUploadDto(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      images: selectedImages,
                    );
                    await Provider.of<PostProvider>(context, listen: false).uploadPost(context, dto);
                  }

                  if (!isEditing) {
                    _titleController.clear();
                    _descriptionController.clear();
                    clearImage();
                  }

                  if (mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  CustomSnackBar.show(context, e.toString());
                } finally {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
        child: _isLoading
            ? Container(
                width: screenWidth * 0.038832,
                height: screenHeight * 0.017488,
                padding: EdgeInsets.all(2),
                child: CircularProgressIndicator(
                  color: Color(0xFF582AB2),
                  strokeWidth: 2.0,
                ),
              )
            : Text(
                isEditing ? localization.apply : localization.upload,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF582AB2),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _buildTitleField(double screenWidth, AppLocalizations localization) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.001093 * 54,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.038832),
      decoration: _buildInputDecoration(screenWidth),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: localization.title,
                border: InputBorder.none,
              ),
              style: _getInputTextStyle(),
            ),
          ),
          Text(
            '*',
            style: TextStyle(
              color: Color(0xFFFF0C0C),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              letterSpacing: -4.80,
            ),
          ),
        ],
      ),
    );
  }

  ShapeDecoration _buildInputDecoration(double screenWidth) {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: screenWidth * 0.002427, color: Color(0xFF89949F)),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  TextStyle _getInputTextStyle() {
    return TextStyle(
      color: Colors.black.withOpacity(0.5),
      fontSize: 16,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
    );
  }

  Widget _buildContentField(double screenWidth, double screenHeight, AppLocalizations localization) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: screenHeight * 0.001093 * 320,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.038832),
      decoration: _buildInputDecoration(screenWidth),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: TextField(
            controller: _descriptionController,
            maxLines: null,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: localization.content_body,
              border: InputBorder.none,
            ),
            style: _getInputTextStyle(),
          ),
        ),
      ]),
    );
  }

  Widget _buildImageAttachmentButton(double screenWidth, double screenHeight, AppLocalizations localization) {
    if (isEditing) return SizedBox.shrink();

    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: screenHeight * 0.001093 * 66,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.038832),
      decoration: _buildInputDecoration(screenWidth),
      child: TextButton(
          onPressed: getImages,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/image.png',
                width: screenWidth * 0.058248,
                height: screenHeight * 0.026232,
              ),
              SizedBox(width: screenWidth * 0.007281),
              Text(
                localization.attach_photo,
                style: _getInputTextStyle(),
              )
            ],
          )),
    );
  }

  Widget _buildImageGrid(double screenHeight, double screenWidth) {
    if (isEditing) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005465, horizontal: screenWidth * 0.012135),
      child: SizedBox(
        height: screenHeight * 0.2186,
        child: GridView.builder(
          itemCount: selectedImages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.file(
                selectedImages[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(double screenWidth, double screenHeight, AppLocalizations localization) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04854),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.006558),
            Divider(),
            SizedBox(height: screenHeight * 0.02186),
            _buildTitleField(screenWidth, localization),
            SizedBox(height: screenHeight * 0.034976),
            _buildContentField(screenWidth, screenHeight, localization),
            SizedBox(height: screenHeight * 0.026232),
            _buildImageAttachmentButton(screenWidth, screenHeight, localization),
            _buildImageGrid(screenHeight, screenWidth),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context, screenWidth, screenHeight, localization),
        body: _buildBody(screenWidth, screenHeight, localization),
      ),
    );
  }
}
