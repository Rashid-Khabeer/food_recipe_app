import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/modals.dart';
import 'package:food_recipie_app/src/components/profile/profile_pic_widget.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/services/firebase_storage_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/utils/localized_mixin.dart';
import 'package:food_recipie_app/src/widgets/app_text_field.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';
import 'package:reusables/reusables.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with LocalizedStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.disabled;

  final _scrollController = ScrollController();

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  late ProfilePicController _picController;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name ?? '';
    _bioController.text = widget.user.bio ?? '';
    _picController = ProfilePicController(url: widget.user.profilePicture);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: lang.edit_profile,
        controller: _scrollController,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: Column(children: [
            Text(lang.edit_profile, style: kBoldW600f24Style),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: Center(
                child: ProfilePicWidget(picController: _picController),
              ),
            ),
            AppTextField(
              textEditingController: _nameController,
              hint: lang.name,
              label: lang.name,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              onSaved: (value) => widget.user.name = value ?? '',
              validator: InputValidator.required(
                message: 'Name is required',
              ),
            ),
            const SizedBox(height: 20),
            AppTextField(
              textEditingController: _bioController,
              hint: 'Enter Bio',
              onSaved: (value) => widget.user.bio = value ?? '',
              label: lang.bio,
              maxLines: 3,
              textInputAction: TextInputAction.go,
            ),
          ], crossAxisAlignment: CrossAxisAlignment.start),
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: _update,
          child: Text(lang.update),
        ),
      ],
    );
  }

  void _update() async {
    if (!_formKey.currentState!.validate()) {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    try {
      await Awaiter.process(
        future: _updateAction(),
        context: context,
        arguments: 'Updating...',
      );
      $showSnackBar(context, 'Profile Updated!');
      Navigator.of(context).pop();
    } catch (e) {
      $showErrorDialog(context, e.toString());
    }
  }

  Future<void> _updateAction() async {
    try {
      if (_picController.pickedFile?.path.isNotEmpty ?? false) {
        widget.user.profilePicture = await FirebaseStorageService.uploadFile(
          _picController.pickedFile!.path,
        );
      }
      await UserFirestoreService().updateFirestore(widget.user);
    } catch (_) {
      rethrow;
    }
  }
}
