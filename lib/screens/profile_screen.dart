import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vocaber/models/bottom_message.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vocaber/generated/l10n.dart';
import 'package:vocaber/models/appconfig.dart';

import '../models/dailystat.dart';
import '../models/profile.dart';
import '../models/word.dart';
import 'list_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  int streak = 0;
  String? username;
  String? profileImageUrl;
  String? preferredLanguage;
  List<DailyStat> dailyStats = [];

  int xp = 0;
  int level = 1;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  void _initializeProfile() {
    username = Profile.getUsername();
    profileImageUrl = Profile.getProfileImageUrl();
    preferredLanguage = Profile.getPreferredLanguage();

    _loadStats();
  }

  void _loadStats() {
    final box = Hive.box<DailyStat>('dailyStats');
    final stats = box.values.toList();

    final calculatedStreak = DailyStat.calculateStreak();

    stats.sort((a, b) => a.date.compareTo(b.date));

    setState(() {
      dailyStats = stats;
      streak = calculatedStreak;
      isLoading = false;
    });
  }

  Future<void> _showProfileDialog() async {
    final nameController = TextEditingController(text: username ?? '');
    final linkController = TextEditingController(
      text: (profileImageUrl != null && profileImageUrl!.startsWith('http'))
          ? profileImageUrl
          : '',
    );
    String selectedLanguage = preferredLanguage ?? 'en';
    String? imageUrl = profileImageUrl;
    File? imageFile;
    bool useLink = true;

    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            24,
            16,
            32 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              Future<void> pickImage() async {
                final picker = ImagePicker();
                final picked = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (picked != null) {
                  imageFile = File(picked.path);
                  imageUrl = null;
                  linkController.clear();
                  setModalState(() {});
                }
              }

              return SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.editProfile,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      style: const TextStyle(fontSize: 16),
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
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedLanguage,
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
                      style: const TextStyle(color: Colors.black, fontSize: 16),
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
                          setState(() {
                            selectedLanguage = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          backgroundImage: imageFile != null
                              ? FileImage(imageFile!)
                              : (imageUrl != null && imageUrl!.isNotEmpty
                                    ? (imageUrl!.startsWith('http')
                                          ? CachedNetworkImageProvider(
                                              imageUrl!,
                                            )
                                          : FileImage(File(imageUrl!)))
                                    : null),
                          child:
                              (imageFile == null && (imageUrl?.isEmpty ?? true))
                              ? Icon(
                                  Icons.person,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: useLink
                              ? TextField(
                                  controller: linkController,
                                  cursorColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(
                                      context,
                                    )!.imageUrl,
                                    labelStyle: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setModalState(() {
                                      imageUrl = value;
                                      imageFile = null;
                                    });
                                  },
                                )
                              : OutlinedButton.icon(
                                  onPressed: pickImage,
                                  icon: Icon(
                                    Icons.folder_open,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                  label: Text(
                                    AppLocalizations.of(context)!.uploadImage,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            useLink ? Icons.upload : Icons.link,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          tooltip: useLink
                              ? AppLocalizations.of(context)!.uploadImage
                              : AppLocalizations.of(context)!.useImageLink,
                          onPressed: () {
                            setModalState(() {
                              useLink = !useLink;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: Text(AppLocalizations.of(context)!.save),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          final name = nameController.text.trim().isEmpty
                              ? AppLocalizations.of(context)!.defaultUser
                              : nameController.text.trim();

                          final image = imageFile != null && !useLink
                              ? imageFile!.path
                              : (linkController.text.trim().isEmpty
                                    ? Profile.generateAvatarUrl(name)
                                    : linkController.text.trim());

                          Navigator.pop(context, {
                            'username': name,
                            'profileImageUrl': image,
                            'preferredLanguage': selectedLanguage,
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (result != null) {
      final name = result['username']!;
      final image = result['profileImageUrl']!;
      final language = result['preferredLanguage'] ?? 'en';
      Profile.save(name, image, language);
      setState(() {
        username = name;
        profileImageUrl = image;
        preferredLanguage = language;
      });
    }
  }

  List<FlSpot> _buildSpots(List<DailyStat> stats, DateTime earliest) {
    return stats.map((stat) {
      final date = DateTime.parse(stat.date);
      final x = date.difference(earliest).inDays.toDouble();
      final y = stat.count.toDouble();
      return FlSpot(x, y);
    }).toList();
  }

  Widget _buildProfileContent({
    required bool showGraph,
    List<DailyStat>? filteredStats,
  }) {
    final earliest = filteredStats != null && filteredStats.isNotEmpty
        ? filteredStats
              .map((d) => DateTime.parse(d.date))
              .reduce((a, b) => a.isBefore(b) ? a : b)
        : null;
    final latest = filteredStats != null && filteredStats.isNotEmpty
        ? filteredStats
              .map((d) => DateTime.parse(d.date))
              .reduce((a, b) => a.isAfter(b) ? a : b)
        : null;

    final spots = (filteredStats != null && earliest != null)
        ? _buildSpots(filteredStats, earliest)
        : <FlSpot>[];

    final minX = 0.0;
    final maxX = (earliest != null && latest != null)
        ? max(1.0, latest.difference(earliest).inDays.toDouble())
        : 1.0;

    int totalXP = dailyStats.fold(0, (sum, stat) => sum + stat.count);
    const int xpPerLevel = 100;
    int level = (totalXP ~/ xpPerLevel) + 1;
    int xpInCurrentLevel = totalXP % xpPerLevel;
    double progress = xpInCurrentLevel / xpPerLevel;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _showProfileDialog,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: profileImageUrl == null
                    ? const Icon(Icons.person, size: 80, color: Colors.grey)
                    : profileImageUrl!.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: profileImageUrl!,
                        fit: BoxFit.cover,
                        width: 160,
                        height: 160,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, size: 40),
                      )
                    : Image.file(
                        File(profileImageUrl!),
                        fit: BoxFit.cover,
                        width: 160,
                        height: 160,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, size: 40),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _showProfileDialog,
                child: Text(
                  username ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.deepOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$streak',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          Column(
            children: [
              SizedBox(
                width: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(
                  context,
                )!.levelXp(level, xpInCurrentLevel, xpPerLevel),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),

          const SizedBox(height: 30),

          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WordListScreen()),
              ),
              child: Text(AppLocalizations.of(context)!.myWords),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                onPressed: _exportWords,
                child: Text(AppLocalizations.of(context)!.export),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                onPressed: _importWords,
                child: Text(AppLocalizations.of(context)!.import),
              ),
            ],
          ),
          const SizedBox(height: 40),

          if (showGraph)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: AspectRatio(
                    aspectRatio: 1.6,
                    child: LineChart(
                      LineChartData(
                        minX: minX,
                        maxX: maxX,
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (touchedSpot) => Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.85),
                            getTooltipItems: (spots) => spots
                                .map((s) {
                                  final spotIndex = s.spotIndex;
                                  if (spotIndex < 0 ||
                                      spotIndex >= filteredStats!.length) {
                                    return null;
                                  }
                                  final stat = filteredStats[spotIndex];
                                  final date = DateTime.tryParse(stat.date);
                                  final label = date != null
                                      ? '${date.month}/${date.day}'
                                      : 'Invalid date';
                                  return LineTooltipItem(
                                    '${stat.count} swipes\n$label',
                                    TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  );
                                })
                                .whereType<LineTooltipItem>()
                                .toList(),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: Theme.of(context).colorScheme.secondary,
                            barWidth: 2,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.dailySwipeCount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final aMonthAgo = DateTime.now().subtract(const Duration(days: 30));
    final filteredStats = dailyStats.where((stat) {
      final date = DateTime.parse(stat.date);
      return !date.isBefore(aMonthAgo);
    }).toList();

    final showGraph = filteredStats.length >= 2;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _buildProfileContent(
        showGraph: showGraph,
        filteredStats: filteredStats,
      ),
    );
  }

  Future<void> _exportWords() async {
    final box = Hive.box<Word>('words');
    final words = box.values.toList();
    final exportList = words.map((w) => w.term).toList();
    final exportString = exportList.join('\n');
    await _copyToClipboard(exportString);
    if (mounted) {
      AppBottomSheet.show(
        context,
        message: AppLocalizations.of(context)!.exportedClipboard,
        type: BottomSheetType.info,
      );
    }
  }

  Future<void> _copyToClipboard(String text) async {
    final data = ClipboardData(text: text);
    await Clipboard.setData(data);
  }

  Future<bool> _showImportConfirmDialog(int count) async {
    final language = Profile.getPreferredLanguage();
    final languageLabel = AppConfig().supportedLanguages[language] ?? language;
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.confirmImportTitle),
            content: Text(
              AppLocalizations.of(
                context,
              )!.confirmImportContent(count, languageLabel),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(AppLocalizations.of(context)!.import),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _showImportProgressDialog(
    int total,
    ValueNotifier<int> progress,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ValueListenableBuilder<int>(
        valueListenable: progress,
        builder: (context, value, _) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.importingWordsTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: total > 0 ? value / total : 0),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.importedProgress(total, value),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _importWords() async {
    final data = await Clipboard.getData('text/plain');
    final text = data?.text ?? '';
    if (text.trim().isEmpty && mounted) {
      AppBottomSheet.show(
        context,
        message: AppLocalizations.of(context)!.clipboardEmpty,
        type: BottomSheetType.error,
      );
      return;
    }
    final terms = text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet();
    if (terms.isEmpty && mounted) {
      AppBottomSheet.show(
        context,
        message: AppLocalizations.of(context)!.noWordsToImport,
        type: BottomSheetType.error,
      );
      return;
    }

    final box = Hive.box<Word>('words');
    // Only keep words that are not already in the box
    final toImport = terms
        .where((term) => !box.containsKey(term.toLowerCase()))
        .toList();

    // Check how many words are actually new before confirming
    if (toImport.isEmpty && mounted) {
      AppBottomSheet.show(
        context,
        message: AppLocalizations.of(context)!.noWordsToImport,
        type: BottomSheetType.info,
      );
      return;
    }

    final shouldImport = await _showImportConfirmDialog(toImport.length);
    if (!shouldImport) return;

    final progress = ValueNotifier<int>(0);

    _showImportProgressDialog(toImport.length, progress);

    int imported = 0;
    for (final term in toImport) {
      try {
        final word = await Word.fromTerm(term);
        // Skip words with empty definitions
        if (word.definitions.isEmpty) {
          continue;
        }
        await box.put(term.toLowerCase(), word);
        imported++;
        progress.value = imported;
      } catch (_) {
        if (mounted) {
          AppBottomSheet.show(
            context,
            message: AppLocalizations.of(context)!.errorWhileImporting,
            type: BottomSheetType.error,
          );
        }
      }
    }

    // If no valid words were imported, cancel and inform the user
    if (imported == 0 && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      AppBottomSheet.show(
        context,
        message: AppLocalizations.of(context)!.noWordsToImport,
        type: BottomSheetType.info,
      );
      return;
    }

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      AppBottomSheet.show(
        context,
        message: AppLocalizations.of(context)!.importedNewWords(imported),
        type: BottomSheetType.info,
      );
    }
  }
}
