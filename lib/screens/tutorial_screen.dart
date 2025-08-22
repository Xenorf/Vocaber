import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vocaber/models/bottom_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vocaber/generated/l10n.dart';
import 'package:vocaber/models/appconfig.dart';
import 'package:vocaber/models/profile.dart';

class TutorialScreen extends StatefulWidget {
  final VoidCallback? onFinish;

  const TutorialScreen({super.key, this.onFinish});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_TutorialStep> _steps = [
    _TutorialStep(
      icon: Icons.search,
      titleKey: 'navDefine',
      descriptionKey: 'tutorialDefine',
    ),
    _TutorialStep(
      icon: Icons.view_carousel,
      titleKey: 'navReview',
      descriptionKey: 'tutorialReview',
    ),
    _TutorialStep(
      icon: Icons.person,
      titleKey: 'navProfile',
      descriptionKey: 'tutorialProfile',
    ),
    _TutorialStep(
      icon: Icons.settings,
      titleKey: null,
      descriptionKey: 'tutorialLocal',
    ),
    _TutorialStep(
      icon: Icons.person_add,
      titleKey: 'profileSetup',
      descriptionKey: 'tutorialProfileSetup',
    ),
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  String _selectedLanguage = 'en';
  bool _useImageLink = true;
  File? _imageFile;
  bool _profileSaved = false;
  bool _showUsernameError = false;
  String? _avatarUrl;

  String _getTitle(BuildContext context, String? key) {
    if (key == null) return AppLocalizations.of(context)!.tutorialLocalTitle;
    switch (key) {
      case 'navDefine':
        return AppLocalizations.of(context)!.navDefine;
      case 'navReview':
        return AppLocalizations.of(context)!.navReview;
      case 'navProfile':
        return AppLocalizations.of(context)!.navProfile;
      case 'profileSetup':
        return AppLocalizations.of(context)!.createProfile;
      default:
        return "";
    }
  }

  String _getDescription(BuildContext context, String key) {
    switch (key) {
      case 'tutorialDefine':
        return AppLocalizations.of(context)!.tutorialDefine;
      case 'tutorialReview':
        return AppLocalizations.of(context)!.tutorialReview;
      case 'tutorialProfile':
        return AppLocalizations.of(context)!.tutorialProfile;
      case 'tutorialLocal':
        return AppLocalizations.of(context)!.tutorialLocal;
      case 'tutorialProfileSetup':
        return AppLocalizations.of(context)!.tutorialProfileSetup;
      default:
        return "";
    }
  }

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (_steps[_currentPage].titleKey == 'profileSetup' && !_profileSaved) {
        AppBottomSheet.show(
          context,
          message: AppLocalizations.of(context)!.save,
          type: BottomSheetType.error,
        );
        return;
      }
      if (widget.onFinish != null) widget.onFinish!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _steps.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  if (step.titleKey == 'profileSetup') {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 24.0,
                        ),
                        child: _buildProfileSetup(context),
                      ),
                    );
                  } else {
                    return SizedBox.expand(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                            vertical: 24.0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: theme.colorScheme.secondary
                                    .withValues(alpha: 0.1),
                                child: Icon(
                                  step.icon,
                                  size: 48,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                _getTitle(context, step.titleKey),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.secondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _getDescription(context, step.descriptionKey),
                                style: theme.textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_steps.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.secondary.withValues(alpha: 0.3),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                  onPressed: () {
                    if (_currentPage < _steps.length - 1) {
                      _nextPage();
                    } else {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) {
                        setState(() {
                          _showUsernameError = true;
                        });
                        return;
                      }

                      final image = _imageFile != null && !_useImageLink
                          ? _imageFile!.path
                          : (_linkController.text.trim().isEmpty
                                ? 'https://api.dicebear.com/9.x/pixel-art/png?seed=$name'
                                : _linkController.text.trim());

                      Profile.save(name, image, _selectedLanguage);
                      setState(() {
                        _profileSaved = true;
                        _showUsernameError = false;
                      });

                      if (widget.onFinish != null) widget.onFinish!();
                    }
                  },
                  child: Text(
                    _currentPage < _steps.length - 1
                        ? AppLocalizations.of(context)!.next
                        : AppLocalizations.of(context)!.finish,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSetup(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.person_add,
                            size: 48,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.createProfile,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.tutorialProfileSetup,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.username,
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 16,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            errorText:
                                _showUsernameError &&
                                    _nameController.text.trim().isEmpty
                                ? ''
                                : null,
                          ),
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          style: const TextStyle(fontSize: 16),
                          onChanged: (_) {
                            setState(() {
                              if (_showUsernameError) {
                                _showUsernameError = false;
                              }
                              final name = _nameController.text.trim();
                              if (name.isNotEmpty) {
                                _avatarUrl = Profile.generateAvatarUrl(name);
                              } else {
                                _avatarUrl = null;
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedLanguage,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(
                              context,
                            )!.preferredLanguage,
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 16,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          items: AppConfig().supportedLanguages.entries
                              .map(
                                (entry) => DropdownMenuItem(
                                  value: entry.key,
                                  child: Text(
                                    entry.value,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedLanguage = value);
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[200],
                              backgroundImage:
                                  !_useImageLink && _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : (_useImageLink &&
                                            _linkController.text
                                                .trim()
                                                .isNotEmpty
                                        ? NetworkImage(
                                            _linkController.text.trim(),
                                          )
                                        : (_avatarUrl != null
                                              ? NetworkImage(_avatarUrl!)
                                              : null)),
                              child:
                                  (_imageFile == null &&
                                      (_linkController.text.trim().isEmpty ||
                                          !_useImageLink) &&
                                      _avatarUrl == null)
                                  ? const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.folder_open),
                                    label: Text(
                                      AppLocalizations.of(context)!.uploadImage,
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      side: BorderSide(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                      ),
                                      foregroundColor: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                    onPressed: () async {
                                      final picker = ImagePicker();
                                      final picked = await picker.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          _imageFile = File(picked.path);
                                          _useImageLink = false;
                                          _linkController.clear();
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.link),
                                    label: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.useImageLink,
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      side: BorderSide(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                      ),
                                      foregroundColor: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                    onPressed: () async {
                                      final url = await showDialog<String>(
                                        context: context,
                                        builder: (context) {
                                          final controller =
                                              TextEditingController();
                                          return Dialog(
                                            insetPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 40,
                                                  vertical: 24,
                                                ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: controller,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.imageUrl,
                                                      labelStyle: TextStyle(
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.secondary,
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                    ),
                                                    cursorColor: Theme.of(
                                                      context,
                                                    ).colorScheme.secondary,
                                                    onSubmitted: (value) =>
                                                        Navigator.pop(
                                                          context,
                                                          value.trim(),
                                                        ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              context,
                                                              controller.text
                                                                  .trim(),
                                                            ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          foregroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSecondary,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  16,
                                                                ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          MaterialLocalizations.of(
                                                            context,
                                                          ).okButtonLabel,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                      if (url != null && url.isNotEmpty) {
                                        setState(() {
                                          _avatarUrl = url;
                                          _imageFile = null;
                                          _useImageLink = true;
                                          _linkController.text = url;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TutorialStep {
  final IconData icon;
  final String? titleKey;
  final String descriptionKey;

  _TutorialStep({
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
  });
}
