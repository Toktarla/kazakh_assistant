import 'package:flutter/material.dart';

import '../features/general-info/models/dialect_word.dart';

const List<String> rankTitlesEn = [
  "Newbie",
  "Learner",
  "Starter",
  "Beginner",
  "Pre-Intermediate",
  "Explorer",
  "Listener",
  "Word Finder",
  "Phrase User",
  "Intermediate",
  "Grammar Scout",
  "Conjugator",
  "Sentence Maker",
  "Conversationalist",
  "Upper-Intermediate",
  "Speaker",
  "Advanced",
  "Idiom Catcher",
  "Cultural Insider",
  "Language Warrior",
  "Kazakh Fan",
  "Fluent",
  "Native Mind",
  "Expert",
  "Pro",
  "Abay Follower",
  "Aitys Master",
  "Kazakh Soul",
  "Language Legend"
];

const List<String> rankTitlesKk = [
  "Жаңадан бастаушы",
  "Үйренуші",
  "Бастау",
  "Бастауыш",
  "Бастапқы деңгей",
  "Зерттеуші",
  "Тыңдаушы",
  "Сөз іздеуші",
  "Тіркес қолданушы",
  "Орта деңгей",
  "Грамматика зерттеуші",
  "Етістік меңгеруші",
  "Сөйлем құрастырушы",
  "Сөйлесуші",
  "Жоғары орта",
  "Сөйлейтін",
  "Жетілген",
  "Тұрақты тіркес білуші",
  "Мәдениетке ену",
  "Тіл жауынгері",
  "Қазақ тілі жанашыры",
  "Еркін сөйлейтін",
  "Ана тілі санада",
  "Сарапшы",
  "Кәсіпқой",
  "Абай ізімен",
  "Айтыс шебері",
  "Қазақ рухы",
  "Тіл аңызы"
];

const List<String> rankTitlesRu = [
  "Новичок",
  "Ученик",
  "Начало",
  "Начинающий",
  "Предсредний",
  "Исследователь",
  "Слушатель",
  "Охотник за словами",
  "Пользователь фраз",
  "Средний уровень",
  "Скаут грамматики",
  "Мастер глаголов",
  "Создатель предложений",
  "Собеседник",
  "Выше среднего",
  "Говорящий",
  "Продвинутый",
  "Знаток идиом",
  "Погружённый в культуру",
  "Воин языка",
  "Фанат казахского",
  "Свободная речь",
  "Мыслящий на языке",
  "Эксперт",
  "Профи",
  "Последователь Абая",
  "Мастер айтыса",
  "Душа казаха",
  "Легенда языка"
];

const List<Color> rankBaseColors = [
  Colors.grey, Colors.blue, Colors.green, Colors.orange, Colors.red,
  Colors.purple, Colors.amber, Colors.cyan, Colors.deepPurple, Colors.brown,
  Colors.lightBlue, Colors.lime, Colors.teal, Colors.deepOrange, Colors.pink,
  Colors.lightGreen, Colors.indigo, Colors.yellow, Colors.white, Colors.black,
];

final List<DialectWord> dialectWords = [
  DialectWord(
    localizations: {'kk': 'өсімдік майы', 'ru': 'растительное масло', 'en': 'vegetable oil'},
    regionDialects: {
      'west': 'Шағу май',
      'south': 'Сумай',
      'north': 'Сұйық май',
      'central': 'Шемішке май',
      'east': 'Шемішке май',
    },
    meanings: {
      'kk': 'Тамақ дайындауға қолданылатын сұйық май.',
      'ru': 'Жидкое масло, используемое для приготовления пищи.',
      'en': 'Liquid oil used for cooking.',
    },
    examples: {
      'kk': ['Ас үйде шағу май таусылып қалыпты.'],
      'ru': ['На кухне закончилось сумаи.'],
      'en': ['We ran out of cooking oil in the kitchen.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'орамал', 'ru': 'полотенце', 'en': 'towel'},
    regionDialects: {
      'west': 'Сулық',
      'south': 'Cүлгі',
      'north': 'Орамал',
      'central': 'Орамал',
      'east': 'Шашық',
    },
    meanings: {
      'kk': 'Қол не бетті сүртуге арналған мата.',
      'ru': 'Ткань для вытирания рук или лица.',
      'en': 'Cloth used to wipe hands or face.',
    },
    examples: {
      'kk': ['Жуынған соң сулықпен сүртінді.'],
      'ru': ['После умывания он вытерся сулык.'],
      'en': ['He wiped his face with a towel after washing.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'шәйнек шыныаяқ', 'ru': 'чашка', 'en': 'cup'},
    regionDialects: {
      'west': 'Кәсе',
      'south': 'Шыны',
      'north': 'Шыны',
      'central': 'Шыны',
      'east': 'Пиала',
    },
    meanings: {
      'kk': 'Шай ішуге арналған кіші ыдыс.',
      'ru': 'Небольшая посуда для чая.',
      'en': 'Small dish used for drinking tea.',
    },
    examples: {
      'kk': ['Әжем маған кәсе толы шәй құйып берді.'],
      'ru': ['Бабушка налила мне полную чашку чая.'],
      'en': ['Grandma poured me a full cup of tea.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'үлкен', 'ru': 'большой', 'en': 'big'},
    regionDialects: {
      'west': 'Нән',
      'south': 'Дәу',
      'north': 'Үлкен',
      'central': 'Дәу',
      'east': 'әйдік',
    },
    meanings: {
      'kk': 'Көлемі не шамасы үлкен зат.',
      'ru': 'Предмет большого размера или масштаба.',
      'en': 'Something of large size or scale.',
    },
    examples: {
      'kk': ['Нән қарбыз алып келіпті.'],
      'ru': ['Он принёс нән арбуз.'],
      'en': ['He brought a huge watermelon.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'сіріңке', 'ru': 'спички', 'en': 'matches'},
    regionDialects: {
      'west': 'Шырпы',
      'south': 'Шырпы',
      'north': 'Оттық',
      'central': 'Ши',
      'east': 'Сіріңке',
    },
    meanings: {
      'kk': 'От жағуға арналған құрал.',
      'ru': 'Инструмент для розжига огня.',
      'en': 'Tool used to light a fire.',
    },
    examples: {
      'kk': ['От жағу үшін шырпы керек.'],
      'ru': ['Нужны шырпы, чтобы зажечь огонь.'],
      'en': ['We need matches to light the fire.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'қауын', 'ru': 'дыня', 'en': 'melon'},
    regionDialects: {
      'west': 'Қауын',
      'south': 'Қауын',
      'north': 'Дарбыз',
      'central': 'Дарбыз',
      'east': 'Қауын',
    },
    meanings: {
      'kk': 'Жазда өсетін тәтті жеміс',
      'ru': 'Сладкий плод, растущий летом',
      'en': 'Sweet fruit that grows in summer',
    },
    examples: {
      'kk': ['Базардан дарбыз сатып алдық.'],
      'ru': ['Мы купили дарбыз на базаре.'],
      'en': ['We bought a melon at the market.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'апай', 'ru': 'тётя', 'en': 'aunt / older woman'},
    regionDialects: {
      'west': 'Апа',
      'south': 'Тәте/Әпше',
      'north': 'Тәте',
      'central': 'Көке',
      'east': 'Апай',
    },
    meanings: {
      'kk': 'Жасы үлкен әйел адамға құрмет білдіру сөз',
      'ru': 'Форма уважения к пожилой женщине',
      'en': 'A respectful way to address an older woman',
    },
    examples: {
      'kk': ['Апа, көмектесіп жіберші.'],
      'ru': ['Апа, помогите мне.'],
      'en': ['Auntie, could you help me?'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'қияр', 'ru': 'огурец', 'en': 'cucumber'},
    regionDialects: {
      'west': 'Бәдірен',
      'south': 'Қияр',
      'north': 'Қияр',
      'central': 'Қияр',
      'east': 'Әгүршік',
    },
    meanings: {
      'kk': 'Жасыл түсті көкөніс, салаттарға қосылады',
      'ru': 'Зелёный овощ, используется в салатах',
      'en': 'Green vegetable commonly used in salads',
    },
    examples: {
      'kk': ['Салатқа бәдірен турадым.'],
      'ru': ['Я порезал бәдірен в салат.'],
      'en': ['I chopped cucumber for the salad.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'пияз', 'ru': 'лук', 'en': 'onion'},
    regionDialects: {
      'west': 'Жуа',
      'south': 'Жуа',
      'north': 'Пияз',
      'central': 'Пияз',
      'east': 'Сарымсақ',
    },
    meanings: {
      'kk': 'Ас дайындауда қолданылатын көкөніс',
      'ru': 'Овощ, используемый в кулинарии',
      'en': 'Vegetable used in cooking',
    },
    examples: {
      'kk': ['Жуа турап жатырмын.'],
      'ru': ['Я режу жуа.'],
      'en': ['I am chopping an onion.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'таз', 'ru': 'тазик', 'en': 'basin'},
    regionDialects: {
      'west': 'Табақ',
      'south': 'Шылапшын',
      'north': 'Шара',
      'central': 'Шара',
      'east': 'Кірші',
    },
    meanings: {
      'kk': 'Су немесе ыдыс жууға арналған ыдыс',
      'ru': 'Ёмкость для воды или мытья посуды',
      'en': 'Container used for water or washing dishes',
    },
    examples: {
      'kk': ['Шылапшынға су құй.'],
      'ru': ['Налей воды в шылапшын.'],
      'en': ['Pour water into the basin.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'жастық', 'ru': 'подушка', 'en': 'pillow'},
    regionDialects: {
      'west': 'көпшік',
      'south': 'жастық',
      'north': 'жастық',
      'central': 'жастық',
      'east': 'жастық',
    },
    meanings: {
      'kk': 'Ұйықтағанда бас қоятын жұмсақ зат',
      'ru': 'Мягкий предмет, на который кладут голову во время сна',
      'en': 'Soft item used to rest the head while sleeping',
    },
    examples: {
      'kk': ['Көпшігімді көтеріп қойдым.'],
      'ru': ['Я положил голову на көпшік.'],
      'en': ['I laid my head on the pillow.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'кішкентай', 'ru': 'маленький', 'en': 'small'},
    regionDialects: {
      'west': 'құрттай',
      'south': 'кіттай',
      'north': 'кішкентай',
      'central': 'кішкентай',
      'east': 'кішкентай',
    },
    meanings: {
      'kk': 'Өлшемі немесе жасы кішкене нәрсе',
      'ru': 'Что-то маленькое по размеру или возрасту',
      'en': 'Something small in size or age',
    },
    examples: {
      'kk': ['Мына бала құрттай екен.'],
      'ru': ['Этот ребёнок прям құрттай.'],
      'en': ['This kid is really small.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'ауыр', 'ru': 'тяжёлый', 'en': 'heavy'},
    regionDialects: {
      'west': 'зілдей',
      'south': 'ауыр',
      'north': 'ауыр',
      'central': 'ауыр',
      'east': 'ауыр',
    },
    meanings: {
      'kk': 'Көтеруге қиын нәрсе',
      'ru': 'Тяжело поднимать',
      'en': 'Difficult to lift',
    },
    examples: {
      'kk': ['Бұл сөмке зілдей екен.'],
      'ru': ['Эта сумка прям зілдей.'],
      'en': ['This bag is really heavy.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'бағана', 'ru': 'только что', 'en': 'just now / earlier'},
    regionDialects: {
      'west': 'мана',
      'south': 'бағана',
      'north': 'бағана',
      'central': 'бағана',
      'east': 'бағана',
    },
    meanings: {
      'kk': 'Жақында ғана болған әрекетке сілтеме',
      'ru': 'Ссылка на недавнее событие',
      'en': 'Refers to a recent action',
    },
    examples: {
      'kk': ['Мана келіп едім.'],
      'ru': ['Я мана приходил.'],
      'en': ['I was here just now.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'мысалы', 'ru': 'например', 'en': 'for example'},
    regionDialects: {
      'west': 'айталық',
      'south': 'мысалы',
      'north': 'мысалы',
      'central': 'айталық',
      'east': 'мысалы',
    },
    meanings: {
      'kk': 'Бір нәрсені түсіндіру үшін мысал келтіру',
      'ru': 'Приведение примера для объяснения',
      'en': 'Giving an example to explain something',
    },
    examples: {
      'kk': ['Мысалы, бұл сөзді қалай қолданамыз?'],
      'ru': ['Например, как использовать это слово?'],
      'en': ['For example, how do we use this word?'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'Шыққыш', 'ru': 'Шыққыш', 'en': 'Shykkish'},
    regionDialects: {
      'west': 'Шыққыш',
      'south': 'Іләкар',
      'north': 'Ауан',
      'central': 'Шыққыш',
      'east': 'Ауан',
    },
    meanings: {
      'kk': 'Шыдамсыз, өткір мінезді',
      'ru': 'Нетерпеливый, резкий по характеру',
      'en': 'Impatient, sharp-tempered',
    },
    examples: {
      'kk': ['Ол өте шыққыш адам, тез ашуланады.'],
      'ru': ['Он очень шыққыш человек, быстро раздражается.'],
      'en': ['He is very shykkish, quickly gets angry.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'Іләкар', 'ru': 'Іләкар', 'en': 'Ilekar'},
    regionDialects: {
      'west': 'Жалған',
      'south': 'Іләкар',
      'north': 'Жалған',
      'central': 'Жалған',
      'east': 'Іләкар',
    },
    meanings: {
      'kk': 'Қажетке әрең жарап тұрған, жоқтан бар қылып жасалған',
      'ru': 'Сделанный с трудом, едва пригодный',
      'en': 'Barely useful, made out of nothing',
    },
    examples: {
      'kk': ['Бұл зат тым іләкар, ұзаққа бармайды.'],
      'ru': ['Эта вещь слишком іләкар, долго не прослужит.'],
      'en': ['This item is quite ilekar, won’t last long.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'Жише', 'ru': 'Жише', 'en': 'Jishe'},
    regionDialects: {
      'west': 'Апа',
      'south': 'Жише',
      'north': 'Женше',
      'central': 'Женше',
      'east': 'Женше',
    },
    meanings: {
      'kk': 'Жеңгеге жұмсартып айтылатын сөз',
      'ru': 'Смягченное слово для обозначения жены брата',
      'en': 'Polite way to say sister-in-law',
    },
    examples: {
      'kk': ['Бүгін Жуалыда тұратын жишем қонаққа шақырды.'],
      'ru': ['Сегодня меня пригласила жише из Жуалы.'],
      'en': ['Today my jishe from Zhauyly invited me.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'Бертәшкі', 'ru': 'Бертәшкі', 'en': 'Bertashki'},
    regionDialects: {
      'west': 'Бертәшкі',
      'south': 'Бертәшкі',
      'north': 'Ауру',
      'central': 'Вертячка',
      'east': 'Вертячка',
    },
    meanings: {
      'kk': 'Вертячка ауруының қазақша бейімделген атауы',
      'ru': 'Адаптированное название заболевания вертячка',
      'en': 'Adapted Kazakh name for vertigo disease',
    },
    examples: {
      'kk': ['Ленгірдің рокерлері бертәшкі секілді айналып жүр.'],
      'ru': ['Рокеры Ленгира ходят как при бертәшкі.'],
      'en': ['Lengir’s rockers walk as if having bertashki.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'Шылапшын', 'ru': 'Легень', 'en': 'Shylapshyn'},
    regionDialects: {
      'west': 'Тазик',
      'south': 'Леген',
      'north': 'Легень',
      'central': 'Тазик',
      'east': 'Шылапшын',
    },
    meanings: {
      'kk': 'Кір қол жууға арналған түбі таяз, металдан жасалған ыдыс',
      'ru': 'Металлический неглубокий таз для стирки рук',
      'en': 'Shallow metal basin for washing hands',
    },
    examples: {
      'kk': ['Жуындым деген соң шылапшынға қолымды алдым.'],
      'ru': ['Я помыл руки в шылапшын.'],
      'en': ['I washed my hands in the shylapshyn.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'бас', 'ru': 'голова', 'en': 'head'},
    regionDialects: {
      'west': 'бас',
      'south': 'төбе',
      'north': 'бас',
      'central': 'бас',
      'east': 'бас',
    },
    meanings: {
      'kk': 'Адам денесінің жоғарғы бөлігі',
      'ru': 'Верхняя часть тела человека',
      'en': 'The upper part of the human body',
    },
    examples: {
      'kk': ['Ол басын жарақаттап алды.'],
      'ru': ['Он повредил голову.'],
      'en': ['He injured his head.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'жылқы', 'ru': 'лошадь', 'en': 'horse'},
    regionDialects: {
      'west': 'ат',
      'south': 'жылқы',
      'north': 'жылқы',
      'central': 'ат',
      'east': 'жылқы',
    },
    meanings: {
      'kk': 'Тұяқты, жаяу жүретін үй жануары',
      'ru': 'Домашнее животное с копытами, ходящее пешком',
      'en': 'A hoofed domesticated animal used for riding or work',
    },
    examples: {
      'kk': ['Жылқы даланы бағындырды.'],
      'ru': ['Лошадь покорила степь.'],
      'en': ['The horse conquered the steppe.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'терезе', 'ru': 'окно', 'en': 'window'},
    regionDialects: {
      'west': 'әйнек',
      'south': 'терезе',
      'north': 'терезе',
      'central': 'әйнек',
      'east': 'терезе',
    },
    meanings: {
      'kk': 'Бөлмеге жарық түсіретін құрылғы',
      'ru': 'Устройство для пропуска света в комнату',
      'en': 'An opening fitted with glass for light and air in a room',
    },
    examples: {
      'kk': ['Терезені ашып қой.'],
      'ru': ['Открой окно.'],
      'en': ['Open the window.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'айран', 'ru': 'кефир', 'en': 'kefir'},
    regionDialects: {
      'west': 'айран',
      'south': 'қымыз',
      'north': 'айран',
      'central': 'айран',
      'east': 'айран',
    },
    meanings: {
      'kk': 'Сүттен жасалған қышқыл сусын',
      'ru': 'Кисломолочный напиток из молока',
      'en': 'A fermented milk drink',
    },
    examples: {
      'kk': ['Мен айран ішкім келеді.'],
      'ru': ['Я хочу пить кефир.'],
      'en': ['I want to drink kefir.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'ана', 'ru': 'мама', 'en': 'mother'},
    regionDialects: {
      'west': 'шеше',
      'south': 'анашым',
      'north': 'ана',
      'central': 'шеше',
      'east': 'ана',
    },
    meanings: {
      'kk': 'Баланың анасы',
      'ru': 'Мать ребёнка',
      'en': 'The mother of a child',
    },
    examples: {
      'kk': ['Менің шешем тамақ пісіріп жатыр.'],
      'ru': ['Моя мама готовит еду.'],
      'en': ['My mother is cooking food.'],
    },
  ),

  DialectWord(
    localizations: {'kk': 'барып кел', 'ru': 'сходи', 'en': 'go and come back'},
    regionDialects: {
      'west': 'жүгіріп кел',
      'south': 'барып кел',
      'north': 'барып кел',
      'central': 'жүгіріп кел',
      'east': 'барып кел',
    },
    meanings: {
      'kk': 'Қысқа уақытта барып қайту',
      'ru': 'Быстро сходить и вернуться',
      'en': 'To go and come back quickly',
    },
    examples: {
      'kk': ['Ауылға барып келші.'],
      'ru': ['Сходи в деревню.'],
      'en': ['Go to the village and come back.'],
    },
  ),
];

const Map<String, Map<String, String>> localizedRegions = {
  'west': {'kk': 'Батыс', 'ru': 'Запад', 'en': 'West'},
  'south': {'kk': 'Оңтүстік', 'ru': 'Юг', 'en': 'South'},
  'north': {'kk': 'Солтүстік', 'ru': 'Север', 'en': 'North'},
  'central': {'kk': 'Орталық', 'ru': 'Центр', 'en': 'Central'},
  'east': {'kk': 'Шығыс', 'ru': 'Восток', 'en': 'East'},
};

const Map<String, Map<String, String>> localizedStrings = {
  'dialect': {'kk': 'Диалект', 'ru': 'Диалект', 'en': 'Dialect'},
  'standard': {'kk': 'Стандартты', 'ru': 'Стандартный', 'en': 'Standard'},
  'category': {'kk': 'Санат', 'ru': 'Категория', 'en': 'Category'},
  'noWords': {
    'kk': 'Бұл санатқа сөздер жоқ',
    'ru': 'Нет слов для этой категории',
    'en': 'No words for this category',
  },
};

const Map<String, Map<String, String>> localizedCompareStrings = {
  'compareDialects': {'kk': 'Диалекттерді салыстыру', 'ru': 'Сравнение диалектов', 'en': 'Compare Dialects'},
  'vs': {'kk': 'VS', 'ru': 'VS', 'en': 'VS'},
  'interestingFact': {
    'kk': 'Қызықты факт: Батыс диалектілерінде татар және башқұрт тілінен көп сөздер бар.',
    'ru': 'Интересный факт: В западных диалектах часто встречается заимствование из татарского и башкирского языков.',
    'en': 'Interesting fact: Western dialects often borrow from Tatar and Bashkir languages.'
  }
};