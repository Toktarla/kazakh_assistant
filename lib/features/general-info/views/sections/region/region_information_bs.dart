import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RegionInformationBS extends StatelessWidget {
  final String regionId;
  final Color color;

  const RegionInformationBS(
      {super.key, required this.regionId, required this.color});

  static Future<void> show(BuildContext context,
      {required String regionId, required Color color}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RegionInformationBS(regionId: regionId, color: color),
    );
  }

  IconData _getRegionIcon(String id) {
    switch (id) {
      case 'south':
        return LucideIcons.sun;
      case 'north':
        return LucideIcons.snowflake;
      case 'central':
        return LucideIcons.flame;
      case 'west':
        return LucideIcons.fuel;
      case 'east':
        return LucideIcons.mountain;
      default:
        return LucideIcons.map;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = regionDetailData[regionId]!;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.9),
            color.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white24,
            child: Icon(
              _getRegionIcon(regionId),
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data['name'],
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Territory
          _infoRow(
            icon: LucideIcons.mapPin,
            label: 'Территория',
            value: '${data['territory']} км², ${data['territoryText']}',
          ),
          const SizedBox(height: 16),
          // Population
          _infoRow(
            icon: LucideIcons.users,
            label: 'Население',
            value: '${data['population']}',
          ),
          const SizedBox(height: 16),
          // Cities
          _infoRow(
            icon: LucideIcons.building,
            label: 'Города',
            value: (data['cities'] as List<String>).join(', '),
          ),
          const SizedBox(height: 16),
          // Popular places
          _infoRow(
            icon: LucideIcons.star,
            label: 'Популярные места',
            value: (data['popularPlaces'] as List<String>).join(', '),
          ),
          const SizedBox(height: 24),
          // See on map button
          // Смотреть на карте
          OutlinedButton(
            onPressed: () async {
              const url = 'https://www.google.com/maps/place/Kazakhstan';
              await launchUrlString(
                url,
                mode: LaunchMode.platformDefault,
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(
              'Смотреть на карте',
              style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
          ),

          const SizedBox(height: 10),

          OutlinedButton(
            onPressed: () async {
              final url = data['infoUrl'];
              await launchUrlString(
                url,
                mode: LaunchMode.platformDefault,
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(
              'Больше информации',
              style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final Map<String, Map<String, dynamic>> regionDetailData = {
  'south': {
    'name': 'Юг Казахстана',
    'territory': 300000,
    'territoryText': 'второй по величине',
    'population': '6 млн',
    'cities': ['Шымкент', 'Туркестан', 'Кызылорда'],
    'popularPlaces': ['Мавзолей Ходжи Ахмеда Ясави', 'Арал'],
    'infoUrl': 'https://ru.wikipedia.org/wiki/Южный_Казахстан',
  },
  'north': {
    'name': 'Север Казахстана',
    'territory': 250000,
    'territoryText': 'третий по величине',
    'population': '4 млн',
    'cities': ['Петропавловск', 'Кокшетау'],
    'popularPlaces': ['Бурабай', 'Национальный парк Кокшетау'],
    'infoUrl': 'https://ru.wikipedia.org/wiki/Северный_Казахстан',
  },
  'central': {
    'name': 'Центр',
    'territory': 297000,
    'territoryText': 'как 4 Южной Кореи',
    'population': 1800000,
    'cities': ['Караганда', 'Темиртау', 'Балхаш'],
    'popularPlaces': ['Горный музей', 'Озеро Балхаш'],
    'infoUrl': 'https://ru.wikipedia.org/wiki/Центральный_Казахстан',
  },
  'west': {
    'name': 'Запад',
    'territory': 350000,
    'territoryText': 'как 3 Испании',
    'population': 1200000,
    'cities': ['Атырау', 'Актау', 'Уральск'],
    'popularPlaces': ['Каспийское море', 'Пустыня Мангышлак'],
    'infoUrl': 'https://ru.wikipedia.org/wiki/Западный_Казахстан',
  },
  'east': {
    'name': 'Восток',
    'territory': 283000,
    'territoryText': 'как 2 Италии',
    'population': 1600000,
    'cities': ['Семей', 'Өскемен', 'Риддер'],
    'popularPlaces': ['Алтайские горы', 'Иртыш'],
    'infoUrl': 'https://ru.wikipedia.org/wiki/Восточный_Казахстан',
  },
};
