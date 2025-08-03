import 'package:flutter/material.dart';
import 'package:vocaber/models/bottom_message.dart';
import 'package:hive/hive.dart';
import 'package:vocaber/models/appconfig.dart';

import '../generated/l10n.dart';
import '../models/word.dart';
import 'detail_screen.dart';

class DefinitionScreen extends StatefulWidget {
  const DefinitionScreen({super.key});

  @override
  State<DefinitionScreen> createState() => _DefinitionScreenState();
}

class _DefinitionScreenState extends State<DefinitionScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String _language = AppConfig().prefs.getString('language') ?? 'en';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectLanguage() async {
    final Map<String, String> supportedLanguages =
        AppConfig().supportedLanguages;
    final selected = await showModalBottomSheet<String>(
      context: context,
      constraints: BoxConstraints(
        maxHeight: supportedLanguages.length * 60.0 + 20,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: supportedLanguages.entries.map((entry) {
            return ListTile(
              leading: const Icon(Icons.language),
              title: Text(entry.value),
              trailing: _language == entry.key ? const Icon(Icons.check) : null,
              onTap: () {
                Navigator.pop(context, entry.key);
              },
            );
          }).toList(),
        );
      },
    );

    if (selected != null && selected != _language) {
      AppConfig().prefs.setString('language', selected);
      setState(() {
        _language = selected;
      });
    }
  }

  void _showSnackbar(String message) {
    AppBottomSheet.show(context, message: message, type: BottomSheetType.error);
  }

  void _getDefinition() async {
    String input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() => _isLoading = true);

    final box = Hive.box<Word>('words');
    final key = input.toLowerCase();

    Word? word;

    if (box.containsKey(key)) {
      final existingWord = box.get(key);
      if (existingWord != null && existingWord.language == _language) {
        word = existingWord;
      }
    }

    if (word == null) {
      word = await Word.fromTerm(input);

      if (word.definitions.isEmpty) {
        if (mounted) {
          _showSnackbar(
            AppLocalizations.of(context)!.noDefinitionsFound(input),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      await box.put(key, word);
    }

    setState(() => _isLoading = false);
    _controller.clear();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(word: word!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  onPressed: _selectLanguage,
                  icon: Icon(
                    Icons.language,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(
                    _language.toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.enterWord,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isLoading ? null : _getDefinition,
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : Text(AppLocalizations.of(context)!.getDefinition),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
