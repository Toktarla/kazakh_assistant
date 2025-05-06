import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../config/variables.dart';

class RegionComparePage extends StatefulWidget {
  const RegionComparePage({super.key});

  @override
  State<RegionComparePage> createState() => _RegionComparePageState();
}

class _RegionComparePageState extends State<RegionComparePage> {
  final List<String> regions = ["west", "east", "north", "south", "central"];
  String regionA = "west";
  String regionB = "east";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          _buildBackgroundEffects(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 36,
                          ))),
                  Text(
                    "Сравнение диалектов",
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 20),
                  _buildRegionSelectors(theme),
                  const SizedBox(height: 20),
                  Expanded(child: _buildWordComparisonList(theme)),
                  const SizedBox(height: 20),
                  _buildFooter(theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundEffects() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -50,
          child: _coloredBlurCircle(Colors.purpleAccent.withValues(alpha: 0.3), 300),
        ),
        Positioned(
          bottom: -100,
          right: -50,
          child: _coloredBlurCircle(Colors.cyanAccent.withValues(alpha: 0.3), 300),
        ),
      ],
    );
  }

  Widget _coloredBlurCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }

  Widget _buildRegionSelectors(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _glassDropdown(value: regionA, onChanged: (v) => setState(() => regionA = v!)),
        const SizedBox(width: 12),
        Text("VS", style: theme.textTheme.titleMedium),
        const SizedBox(width: 12),
        _glassDropdown(value: regionB, onChanged: (v) => setState(() => regionB = v!)),
      ],
    );
  }

  Widget _glassDropdown({required String value, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Theme.of(context).cardColor,
          iconEnabledColor: Theme.of(context).primaryColor,
          style: Theme.of(context).textTheme.titleLarge,
          value: value,
          onChanged: onChanged,
          items: regions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
        ),
      ),
    );
  }

  Widget _buildWordComparisonList(ThemeData theme) {
    final wordCount = regionWords[regionA]?.length ?? 0;
    return ListView.separated(
      itemCount: wordCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final a = regionWords[regionA]![index];
        final b = regionWords[regionB]!.firstWhere((e) => e['word'] == a['word'], orElse: () => {});
        return _glassWordCard(a['dialect'] ?? '-', a['word'] ?? '-', b['dialect'] ?? '-', theme);
      },
    );
  }

  Widget _glassWordCard(String left, String center, String right, ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(child: Text(left, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge)),
              Container(width: 1, height: 24, color: Theme.of(context).primaryColor),
              Expanded(child: Text(center, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge)),
              Container(width: 1, height: 24, color: Theme.of(context).primaryColor),
              Expanded(child: Text(right, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            "Интересный факт: В западных диалектах часто встречается заимствование из татарского и башкирского языков.",
            style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}