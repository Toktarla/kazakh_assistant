import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'app_colors.dart';

var pathToFirebaseAdminSdk = dotenv.env['PATH_TO_FIREBASE_ADMIN_SDK'];
var senderId = dotenv.env['SENDER_ID'];
var geminiApiKey = dotenv.env['GEMINI_API_KEY'];

TextStyle kanitStyle = GoogleFonts.kanit();
const defaultUserPhotoUrl = 'https://toppng.com/uploads/preview/instagram-default-profile-picture-11562973083brycehrmyv.png';
const String defaultImagePath = 'https://t4.ftcdn.net/jpg/01/86/29/31/360_F_186293166_P4yk3uXQBDapbDFlR17ivpM6B1ux0fHG.jpg';
const String defaultNoImageUrl = 'https://static.vecteezy.com/system/resources/thumbnails/004/141/669/small_2x/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg';

final Map<String, List<Map<String, String>>> regionWords = {
  'west': [
    {'dialect': 'шекер', 'standard': 'қант', 'russian': 'сахар', 'word': 'қант'},
    {'dialect': 'көрпе', 'standard': 'жамылғы', 'russian': 'одеяло', 'word': 'жамылғы'},
    {'dialect': 'бәтеңке', 'standard': 'аяқ киім', 'russian': 'обувь', 'word': 'аяқ киім'},
    {'dialect': 'күйеу бала', 'standard': 'жігіт', 'russian': 'жених', 'word': 'жігіт'},
    {'dialect': 'шақпақ', 'standard': 'сіріңке', 'russian': 'спички', 'word': 'сіріңке'},
  ],
  'south': [
    {'dialect': 'қант', 'standard': 'қант', 'russian': 'сахар', 'word': 'қант'},
    {'dialect': 'жамылғы', 'standard': 'жамылғы', 'russian': 'одеяло', 'word': 'жамылғы'},
    {'dialect': 'аяқ киім', 'standard': 'аяқ киім', 'russian': 'обувь', 'word': 'аяқ киім'},
    {'dialect': 'жігіт', 'standard': 'жігіт', 'russian': 'жених', 'word': 'жігіт'},
    {'dialect': 'сіріңке', 'standard': 'сіріңке', 'russian': 'спички', 'word': 'сіріңке'},
  ],
  'north': [
    {'dialect': 'қант', 'standard': 'қант', 'russian': 'сахар', 'word': 'қант'},
    {'dialect': 'көрпе', 'standard': 'жамылғы', 'russian': 'одеяло', 'word': 'жамылғы'},
  ],
  'central': [
    {'dialect': 'шекер', 'standard': 'қант', 'russian': 'сахар', 'word': 'қант'},
    {'dialect': 'шақпақ', 'standard': 'сіріңке', 'russian': 'спички', 'word': 'сіріңке'},
  ],
  'east': [
    {'dialect': 'қант', 'standard': 'қант', 'russian': 'сахар', 'word': 'қант'},
    {'dialect': 'аяқ киім', 'standard': 'аяқ киім', 'russian': 'обувь', 'word': 'аяқ киім'},
  ],
};

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

final List<Map<String, dynamic>> dialectTypes = [
  {'key': 'fillers', 'title': 'Слова-связки', 'icon': LucideIcons.messageCircle},
  {'key': 'body', 'title': 'Одежда и тело', 'icon': LucideIcons.shirt},
  {'key': 'animals', 'title': 'Животные и природа', 'icon': LucideIcons.cat},
  {'key': 'household', 'title': 'Домашние вещи', 'icon': LucideIcons.home},
  {'key': 'food', 'title': 'Еда и кухня', 'icon': LucideIcons.utensilsCrossed},
  {'key': 'kinship', 'title': 'Семья и родство', 'icon': LucideIcons.users},
  {'key': 'life', 'title': 'Быт и жизнь', 'icon': LucideIcons.sun},
  {'key': 'phrases', 'title': 'Фразы', 'icon': LucideIcons.wholeWord},
  {'key': 'objects', 'title': 'Предметы', 'icon': LucideIcons.package},
  {'key': 'expressions', 'title': 'Выражения', 'icon': LucideIcons.smile},
];

final Map<String, String> typeTitles = {
  'fillers': 'Слова-связки и сленг',
  'body': 'Одежда и части тела',
  'animals': 'Животные и природа',
  'household': 'Домашние вещи',
  'food': 'Еда и кухня',
  'kinship': 'Семейные слова',
  'life': 'Быт и жизнь',
  'phrases': 'Повседневные фразы',
  'objects': 'Обычные предметы',
  'expressions': 'Разговорные выражения',
};

final Map<String, List<Map<String, String>>> mockWords = {
  'fillers': [
    {'dialect': 'бәке', 'standard': 'сонымен', 'russian': 'ну'},
    {'dialect': 'ей', 'standard': 'айтшы', 'russian': 'слушай'},
    {'dialect': 'ғой', 'standard': 'же', 'russian': 'же'},
  ],
  'body': [
    {'dialect': 'жейде', 'standard': 'көйлек', 'russian': 'рубашка'},
    {'dialect': 'дамбал', 'standard': 'шалбар', 'russian': 'штаны'},
    {'dialect': 'шәлі', 'standard': 'орамал', 'russian': 'платок'},
  ],
  'animals': [
    {'dialect': 'тал', 'standard': 'ағаш', 'russian': 'дерево'},
    {'dialect': 'ақ ұлпа', 'standard': 'қар', 'russian': 'снег'},
    {'dialect': 'ірі қара', 'standard': 'сиыр', 'russian': 'корова'},
  ],
  'household': [
    {'dialect': 'салқындатқыш', 'standard': 'желдеткіш', 'russian': 'вентилятор'},
    {'dialect': 'самауыр', 'standard': 'шәйнек', 'russian': 'самовар'},
    {'dialect': 'төсек', 'standard': 'кереует', 'russian': 'кровать'},
  ],
  'food': [
    {'dialect': 'сүзбе', 'standard': 'айран', 'russian': 'творог'},
    {'dialect': 'шелпек', 'standard': 'бауырсақ', 'russian': 'лепешка'},
    {'dialect': 'көже', 'standard': 'сорпа', 'russian': 'суп'},
  ],
  'kinship': [
    {'dialect': 'көке', 'standard': 'аға', 'russian': 'дядя'},
    {'dialect': 'қайын ене', 'standard': 'ене', 'russian': 'свекровь'},
    {'dialect': 'немере аға', 'standard': 'туысқан', 'russian': 'двоюродный брат'},
  ],
  'life': [
    {'dialect': 'әйнек', 'standard': 'терезе', 'russian': 'окно'},
    {'dialect': 'жамылғы', 'standard': 'көрпе', 'russian': 'одеяло'},
    {'dialect': 'конак бөлмесі', 'standard': 'бөлме', 'russian': 'гостиная'},
  ],
  'phrases': [
    {'dialect': 'Неғып жүрсің?', 'standard': 'Не істеп жатсың?', 'russian': 'Что делаешь?'},
    {'dialect': 'Бол, жылдам!', 'standard': 'Тезірек бол!', 'russian': 'Поторопись!'},
    {'dialect': 'Кім білсін', 'standard': 'Білмеймін', 'russian': 'Кто знает'},
  ],
  'objects': [
    {'dialect': 'кебіс', 'standard': 'тәпішке', 'russian': 'тапочки'},
    {'dialect': 'машина', 'standard': 'көлік', 'russian': 'машина'},
    {'dialect': 'шайқасық', 'standard': 'қасық', 'russian': 'чайная ложка'},
  ],
  'expressions': [
    {'dialect': 'Жаның тыныш па?', 'standard': 'Қал-жағдайың қалай?', 'russian': 'Как ты?'},
    {'dialect': 'Мал-жаның аман ба?', 'standard': 'Барлығы жақсы ма?', 'russian': 'Все в порядке?'},
    {'dialect': 'Е, қойшы!', 'standard': 'Сенбейм', 'russian': 'Да ладно!'},
  ],
};

final List<Color> lightCardColors = [
  Colors.lightBlue[100]!,
  Colors.lightGreen[100]!,
  Colors.pink[100]!,
  Colors.yellow[100]!,
  Colors.cyan[100]!,
  Colors.amber[100]!,
  Colors.teal[100]!,
];

final List<Color> darkCardColors = [
  Colors.blueGrey[800]!,
  AppColors.darkBlueColor,
  Colors.purple[800]!,
  AppColors.unSelectedBottomBarColorLight,
  Colors.blueGrey[800]!,
  AppColors.blackBrightColor,
  Colors.brown[800]!,
];

final List<IconData> learnIcons = [
  Icons.auto_stories,
  Icons.record_voice_over,
  LineIcons.chalkboardTeacher,
  Icons.menu_book,
  Icons.library_books,
  Icons.map,
  Icons.book,
];

final List<IconData> infoIcons = [
  Icons.menu_book,
  Icons.library_books,
  Icons.map,
  Icons.book,
];