import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

final ancientLanguagesProvider = FutureProvider<List<AncientLanguage>>((ref) async {
  final service = AncientLanguagesService(ref);
  return await service.getAllLanguages();
});

class AncientLanguage {
  final String id;
  final String name;
  final String civilization;
  final String description;
  final String period;
  final String writingSystem;
  final String difficulty;
  final List<LanguageLetter> alphabet;
  final List<LanguageWord> vocabulary;
  final List<LanguagePhrase> phrases;

  AncientLanguage({
    required this.id,
    required this.name,
    required this.civilization,
    required this.description,
    required this.period,
    required this.writingSystem,
    required this.difficulty,
    required this.alphabet,
    required this.vocabulary,
    required this.phrases,
  });

  factory AncientLanguage.fromMap(Map<String, dynamic> map) {
    return AncientLanguage(
      id: map['id'] as String,
      name: map['title'] as String,
      civilization: map['civilization'] as String,
      description: map['description'] as String,
      period: map['time_of_day'] as String,
      writingSystem: map['activities'] as String,
      difficulty: map['season'] as String,
      alphabet: [],
      vocabulary: [],
      phrases: [],
    );
  }
}

class LanguageLetter {
  final String symbol;
  final String transliteration;
  final String pronunciation;
  final String meaning;

  LanguageLetter({
    required this.symbol,
    required this.transliteration,
    required this.pronunciation,
    required this.meaning,
  });
}

class LanguageWord {
  final String ancient;
  final String modern;
  final String pronunciation;
  final String category;

  LanguageWord({
    required this.ancient,
    required this.modern,
    required this.pronunciation,
    required this.category,
  });
}

class LanguagePhrase {
  final String ancient;
  final String modern;
  final String pronunciation;
  final String context;

  LanguagePhrase({
    required this.ancient,
    required this.modern,
    required this.pronunciation,
    required this.context,
  });
}

class AncientLanguagesService {
  final Ref ref;
  final _uuid = const Uuid();

  AncientLanguagesService(this.ref);

  Future<List<AncientLanguage>> getAllLanguages() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['language']);
    if (existing.isEmpty) {
      await insertSampleLanguages();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['language']);
    final languages = results.map((map) => AncientLanguage.fromMap(map)).toList();
    
    // Her dil için alfabe, kelime ve cümle bilgilerini yükle
    for (var language in languages) {
      language.alphabet.addAll(await _getAlphabetForLanguage(language.id));
      language.vocabulary.addAll(await _getVocabularyForLanguage(language.id));
      language.phrases.addAll(await _getPhrasesForLanguage(language.id));
    }
    
    return languages;
  }

  Future<List<LanguageLetter>> _getAlphabetForLanguage(String languageId) async {
    // Alfabe bilgilerini hardcoded olarak döndürüyoruz
    // Gerçek uygulamada bunlar da veritabanında olabilir
    final alphabets = _getAlphabetData();
    return alphabets[languageId] ?? [];
  }

  Future<List<LanguageWord>> _getVocabularyForLanguage(String languageId) async {
    final vocabulary = _getVocabularyData();
    return vocabulary[languageId] ?? [];
  }

  Future<List<LanguagePhrase>> _getPhrasesForLanguage(String languageId) async {
    final phrases = _getPhrasesData();
    return phrases[languageId] ?? [];
  }

  Map<String, List<LanguageLetter>> _getAlphabetData() {
    return {
      'lang_1': [ // Latince
        LanguageLetter(symbol: 'A', transliteration: 'A', pronunciation: 'a', meaning: 'Alfa harfi'),
        LanguageLetter(symbol: 'B', transliteration: 'B', pronunciation: 'b', meaning: 'Beta harfi'),
        LanguageLetter(symbol: 'C', transliteration: 'C', pronunciation: 'k/s', meaning: 'Ce harfi'),
        LanguageLetter(symbol: 'V', transliteration: 'V', pronunciation: 'w/v', meaning: 'Ve harfi'),
      ],
      'lang_2': [ // Antik Yunanca
        LanguageLetter(symbol: 'Α α', transliteration: 'Alpha', pronunciation: 'a', meaning: 'Alfa'),
        LanguageLetter(symbol: 'Β β', transliteration: 'Beta', pronunciation: 'b', meaning: 'Beta'),
        LanguageLetter(symbol: 'Γ γ', transliteration: 'Gamma', pronunciation: 'g', meaning: 'Gama'),
        LanguageLetter(symbol: 'Δ δ', transliteration: 'Delta', pronunciation: 'd', meaning: 'Delta'),
        LanguageLetter(symbol: 'Ω ω', transliteration: 'Omega', pronunciation: 'o', meaning: 'Omega'),
      ],
      'lang_3': [ // Mısır Hiyeroglifleri (basit örnekler)
        LanguageLetter(symbol: '𓀀', transliteration: 'A', pronunciation: 'a', meaning: 'Oturan adam - A sesi'),
        LanguageLetter(symbol: '𓃀', transliteration: 'B', pronunciation: 'b', meaning: 'Ayak - B sesi'),
        LanguageLetter(symbol: '𓅓', transliteration: 'M', pronunciation: 'm', meaning: 'Baykuş - M sesi'),
        LanguageLetter(symbol: '𓈖', transliteration: 'N', pronunciation: 'n', meaning: 'Su dalgası - N sesi'),
      ],
    };
  }

  Map<String, List<LanguageWord>> _getVocabularyData() {
    return {
      'lang_1': [ // Latince
        LanguageWord(ancient: 'salve', modern: 'merhaba', pronunciation: 'salwe', category: 'Selamlaşma'),
        LanguageWord(ancient: 'vale', modern: 'hoşça kal', pronunciation: 'vale', category: 'Selamlaşma'),
        LanguageWord(ancient: 'gratias', modern: 'teşekkürler', pronunciation: 'gratias', category: 'Nezaket'),
        LanguageWord(ancient: 'pax', modern: 'barış', pronunciation: 'paks', category: 'Kavramlar'),
        LanguageWord(ancient: 'amor', modern: 'aşk', pronunciation: 'amor', category: 'Kavramlar'),
        LanguageWord(ancient: 'veritas', modern: 'gerçek', pronunciation: 'veritas', category: 'Kavramlar'),
        LanguageWord(ancient: 'aqua', modern: 'su', pronunciation: 'akwa', category: 'Doğa'),
        LanguageWord(ancient: 'sol', modern: 'güneş', pronunciation: 'sol', category: 'Doğa'),
        LanguageWord(ancient: 'luna', modern: 'ay', pronunciation: 'luna', category: 'Doğa'),
        LanguageWord(ancient: 'terra', modern: 'toprak/dünya', pronunciation: 'terra', category: 'Doğa'),
        LanguageWord(ancient: 'homo', modern: 'insan', pronunciation: 'homo', category: 'İnsanlar'),
        LanguageWord(ancient: 'familia', modern: 'aile', pronunciation: 'familia', category: 'İnsanlar'),
        LanguageWord(ancient: 'rex', modern: 'kral', pronunciation: 'reks', category: 'Toplum'),
        LanguageWord(ancient: 'imperator', modern: 'imparator', pronunciation: 'imperator', category: 'Toplum'),
        LanguageWord(ancient: 'gladius', modern: 'kılıç', pronunciation: 'gladius', category: 'Savaş'),
      ],
      'lang_2': [ // Antik Yunanca
        LanguageWord(ancient: 'χαῖρε', modern: 'merhaba', pronunciation: 'khaire', category: 'Selamlaşma'),
        LanguageWord(ancient: 'εὐχαριστῶ', modern: 'teşekkürler', pronunciation: 'efharisto', category: 'Nezaket'),
        LanguageWord(ancient: 'φιλοσοφία', modern: 'felsefe', pronunciation: 'philosophia', category: 'Bilim'),
        LanguageWord(ancient: 'δημοκρατία', modern: 'demokrasi', pronunciation: 'demokratia', category: 'Politika'),
        LanguageWord(ancient: 'ἀγορά', modern: 'pazar/meydan', pronunciation: 'agora', category: 'Yerler'),
        LanguageWord(ancient: 'θεός', modern: 'tanrı', pronunciation: 'theos', category: 'Din'),
        LanguageWord(ancient: 'λόγος', modern: 'söz/akıl', pronunciation: 'logos', category: 'Kavramlar'),
        LanguageWord(ancient: 'σοφία', modern: 'bilgelik', pronunciation: 'sophia', category: 'Kavramlar'),
        LanguageWord(ancient: 'ἀρετή', modern: 'erdem', pronunciation: 'arete', category: 'Kavramlar'),
        LanguageWord(ancient: 'πόλις', modern: 'şehir devleti', pronunciation: 'polis', category: 'Toplum'),
        LanguageWord(ancient: 'ὕδωρ', modern: 'su', pronunciation: 'hydor', category: 'Doğa'),
        LanguageWord(ancient: 'ἥλιος', modern: 'güneş', pronunciation: 'helios', category: 'Doğa'),
        LanguageWord(ancient: 'σελήνη', modern: 'ay', pronunciation: 'selene', category: 'Doğa'),
        LanguageWord(ancient: 'γῆ', modern: 'toprak/dünya', pronunciation: 'ge', category: 'Doğa'),
        LanguageWord(ancient: 'ἄνθρωπος', modern: 'insan', pronunciation: 'anthropos', category: 'İnsanlar'),
      ],
      'lang_3': [ // Mısır Hiyeroglifleri
        LanguageWord(ancient: '𓊃𓈖𓃀', modern: 'sağlık', pronunciation: 'seneb', category: 'Sağlık'),
        LanguageWord(ancient: '𓊵𓏏𓊪', modern: 'ekmek', pronunciation: 'ta', category: 'Yiyecek'),
        LanguageWord(ancient: '𓇳', modern: 'güneş/Ra', pronunciation: 'ra', category: 'Tanrılar'),
        LanguageWord(ancient: '𓈖𓏏𓂋', modern: 'tanrı', pronunciation: 'netjer', category: 'Din'),
        LanguageWord(ancient: '𓅓𓂝𓇋', modern: 'doğru/gerçek', pronunciation: 'maat', category: 'Kavramlar'),
        LanguageWord(ancient: '𓇋𓏠𓈖', modern: 'gizli', pronunciation: 'imen', category: 'Kavramlar'),
        LanguageWord(ancient: '𓈖𓆑𓂋', modern: 'güzel', pronunciation: 'nefer', category: 'Sıfatlar'),
        LanguageWord(ancient: '𓋹𓈖𓐍', modern: 'yaşam', pronunciation: 'ankh', category: 'Kavramlar'),
      ],
      'lang_4': [ // Sümer Çivi Yazısı
        LanguageWord(ancient: '𒀭', modern: 'tanrı', pronunciation: 'dingir', category: 'Din'),
        LanguageWord(ancient: '𒈗', modern: 'kral', pronunciation: 'lugal', category: 'Toplum'),
        LanguageWord(ancient: '𒅆', modern: 'gece', pronunciation: 'gi6', category: 'Zaman'),
        LanguageWord(ancient: '𒌓', modern: 'gün', pronunciation: 'ud', category: 'Zaman'),
        LanguageWord(ancient: '𒀀', modern: 'su', pronunciation: 'a', category: 'Doğa'),
        LanguageWord(ancient: '𒆠', modern: 'yer/toprak', pronunciation: 'ki', category: 'Doğa'),
        LanguageWord(ancient: '𒊩', modern: 'kadın', pronunciation: 'munus', category: 'İnsanlar'),
        LanguageWord(ancient: '𒉡', modern: 'insan', pronunciation: 'lu', category: 'İnsanlar'),
      ],
      'lang_5': [ // Akkadca
        LanguageWord(ancient: 'šarru', modern: 'kral', pronunciation: 'sharru', category: 'Toplum'),
        LanguageWord(ancient: 'ilum', modern: 'tanrı', pronunciation: 'ilum', category: 'Din'),
        LanguageWord(ancient: 'mātu', modern: 'ülke', pronunciation: 'matu', category: 'Coğrafya'),
        LanguageWord(ancient: 'awīlum', modern: 'adam/özgür kişi', pronunciation: 'awilum', category: 'İnsanlar'),
        LanguageWord(ancient: 'bītu', modern: 'ev', pronunciation: 'bitu', category: 'Yerler'),
        LanguageWord(ancient: 'umu', modern: 'gün', pronunciation: 'umu', category: 'Zaman'),
        LanguageWord(ancient: 'šamû', modern: 'gök', pronunciation: 'shamu', category: 'Doğa'),
        LanguageWord(ancient: 'erṣetu', modern: 'toprak', pronunciation: 'ersetu', category: 'Doğa'),
      ],
    };
  }

  Map<String, List<LanguagePhrase>> _getPhrasesData() {
    return {
      'lang_1': [ // Latince
        LanguagePhrase(
          ancient: 'Carpe diem',
          modern: 'Günü yaşa',
          pronunciation: 'karpe diem',
          context: 'Zamanı en iyi şekilde değerlendirmek için kullanılır',
        ),
        LanguagePhrase(
          ancient: 'Veni, vidi, vici',
          modern: 'Geldim, gördüm, yendim',
          pronunciation: 'veni vidi viki',
          context: 'Julius Caesar\'ın zafer sözü',
        ),
        LanguagePhrase(
          ancient: 'Alea iacta est',
          modern: 'Zar atıldı',
          pronunciation: 'alea yakta est',
          context: 'Geri dönüşü olmayan bir karar alındığında',
        ),
        LanguagePhrase(
          ancient: 'Et tu, Brute?',
          modern: 'Sen de mi Brutus?',
          pronunciation: 'et tu brute',
          context: 'İhanet durumunda söylenen ünlü söz',
        ),
        LanguagePhrase(
          ancient: 'Memento mori',
          modern: 'Ölümü hatırla',
          pronunciation: 'memento mori',
          context: 'İnsanın ölümlü olduğunu hatırlatan söz',
        ),
        LanguagePhrase(
          ancient: 'Cogito, ergo sum',
          modern: 'Düşünüyorum, öyleyse varım',
          pronunciation: 'kogito ergo sum',
          context: 'Descartes\'ın ünlü felsefe sözü (Latince\'ye çevrilmiş)',
        ),
        LanguagePhrase(
          ancient: 'Per aspera ad astra',
          modern: 'Zorluklardan yıldızlara',
          pronunciation: 'per aspera ad astra',
          context: 'Zorlukları aşarak başarıya ulaşmak',
        ),
      ],
      'lang_2': [ // Antik Yunanca
        LanguagePhrase(
          ancient: 'Γνῶθι σεαυτόν',
          modern: 'Kendini bil',
          pronunciation: 'gnothi seauton',
          context: 'Delphi tapınağındaki ünlü yazıt',
        ),
        LanguagePhrase(
          ancient: 'Εὐρηκα!',
          modern: 'Buldum!',
          pronunciation: 'eureka',
          context: 'Arşimet\'in ünlü sözü',
        ),
        LanguagePhrase(
          ancient: 'Πάντα ῥεῖ',
          modern: 'Her şey akar',
          pronunciation: 'panta rhei',
          context: 'Herakleitos\'un değişim felsefesi',
        ),
        LanguagePhrase(
          ancient: 'Μηδὲν ἄγαν',
          modern: 'Aşırıya kaçma',
          pronunciation: 'meden agan',
          context: 'Yunan ölçülülük felsefesi',
        ),
      ],
      'lang_3': [ // Mısır Hiyeroglifleri
        LanguagePhrase(
          ancient: '𓋹𓈖𓐍 𓅱𓏴𓊃𓈖𓃀',
          modern: 'Yaşam, refah ve sağlık',
          pronunciation: 'ankh wedja seneb',
          context: 'Mısır\'da selamlaşma ve dilek ifadesi',
        ),
        LanguagePhrase(
          ancient: '𓇳𓏤 𓁦',
          modern: 'Ra güneşi doğurur',
          pronunciation: 'ra-kheper',
          context: 'Güneşin doğuşunu kutlayan ifade',
        ),
      ],
      'lang_4': [ // Sümer Çivi Yazısı
        LanguagePhrase(
          ancient: '𒀭𒈗𒁀',
          modern: 'Tanrı kralın efendisidir',
          pronunciation: 'dingir lugal-ba',
          context: 'Tanrısal otoriteyi ifade eden cümle',
        ),
      ],
    };
  }

  Future<void> insertSampleLanguages() async {
    final db = await AppDatabase().database;
    
    final languages = [
      {
        'id': 'lang_1',
        'scene_type': 'language',
        'title': 'Latince',
        'civilization': 'Roma',
        'description': 'Antik Roma İmparatorluğu\'nun resmi dili olan Latince, Avrupa dillerinin atası sayılır. Bilim, hukuk ve kilise dili olarak uzun süre kullanılmıştır. Modern İtalyanca, İspanyolca, Fransızca ve Portekizce gibi Roman dillerinin temeli Latince\'dir.',
        'time_of_day': 'MÖ 75 - MS 200',
        'activities': 'Latin Alfabesi - 23 harf',
        'season': 'Başlangıç',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'lang_2',
        'scene_type': 'language',
        'title': 'Antik Yunanca',
        'civilization': 'Yunanistan',
        'description': 'Antik Yunanca, felsefe, bilim ve edebiyatın dili olarak altın çağını yaşamıştır. Platon, Aristoteles ve Homer gibi düşünürlerin eserleri bu dilde yazılmıştır. Modern Yunanca\'nın atası olan bu dil, batı medeniyetinin temel taşlarından biridir.',
        'time_of_day': 'MÖ 800 - MS 300',
        'activities': 'Yunan Alfabesi - 24 harf',
        'season': 'Orta',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'lang_3',
        'scene_type': 'language',
        'title': 'Mısır Hiyeroglifleri',
        'civilization': 'Mısır',
        'description': 'Hiyeroglifler, Antik Mısır\'ın kutsal yazı sistemidir. Resimsel sembollerden oluşan bu sistem, tapınak duvarlarında ve papirüs üzerinde kullanılmıştır. 1822\'de Champollion tarafından Rosetta Taşı sayesinde çözülmüştür.',
        'time_of_day': 'MÖ 3200 - MS 400',
        'activities': 'Hiyeroglifik Yazı - 700+ sembol',
        'season': 'İleri',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'lang_4',
        'scene_type': 'language',
        'title': 'Sümer Çivi Yazısı',
        'civilization': 'Mezopotamya',
        'description': 'Çivi yazısı, insanlık tarihinin bilinen en eski yazı sistemidir. Sümerler tarafından MÖ 3200 civarında geliştirilmiştir. Kil tabletler üzerine kamış uçlarıyla yazılırdı. Gılgamış Destanı bu yazıyla yazılmıştır.',
        'time_of_day': 'MÖ 3200 - MS 100',
        'activities': 'Çivi Yazısı - 600+ işaret',
        'season': 'İleri',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'lang_5',
        'scene_type': 'language',
        'title': 'Akkadca',
        'civilization': 'Mezopotamya',
        'description': 'Akkadca, Sami dil ailesine ait bir dildir ve Mezopotamya\'da geniş bir coğrafyada kullanılmıştır. Hammurabi Kanunları Akkadca yazılmıştır. Sümer çivi yazısını uyarlayarak kendi dilini yazmıştır.',
        'time_of_day': 'MÖ 2500 - MÖ 100',
        'activities': 'Çivi Yazısı (Akkadca uyarlaması)',
        'season': 'Orta',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'lang_6',
        'scene_type': 'language',
        'title': 'Sanskrit',
        'civilization': 'Hindistan',
        'description': 'Sanskrit, Hint-Avrupa dil ailesinin en eski üyelerinden biridir. Vedalar ve Upanişadlar gibi kutsal metinler bu dilde yazılmıştır. Modern Hint dillerinin ve birçok Avrupa dilinin atası sayılır.',
        'time_of_day': 'MÖ 1500 - Günümüz',
        'activities': 'Devanagari Alfabesi',
        'season': 'İleri',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'lang_7',
        'scene_type': 'language',
        'title': 'Eski Çince',
        'civilization': 'Çin',
        'description': 'Eski Çince, Zhou ve Han hanedanlıkları döneminde konuşulan dildir. Konfüçyüs ve Lao Tzu\'nun eserleri bu dilde yazılmıştır. Modern Çince karakterlerinin temeli Eski Çince\'den gelmektedir.',
        'time_of_day': 'MÖ 1000 - MS 200',
        'activities': 'Çin Karakterleri',
        'season': 'İleri',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'lang_8',
        'scene_type': 'language',
        'title': 'Fenikece',
        'civilization': 'Fenike',
        'description': 'Fenikece, Akdeniz ticaretinin dilidir. Fenikeli tüccarlar tarafından geliştirilen alfabe, modern Latin ve Yunan alfabelerinin atası sayılır. İlk fonetik alfabeyi oluşturarak yazı tarihinde devrim yapmıştır.',
        'time_of_day': 'MÖ 1050 - MÖ 300',
        'activities': 'Fenike Alfabesi - 22 harf',
        'season': 'Başlangıç',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
    ];

    for (final language in languages) {
      await db.insert('daily_life_scenes', language);
    }
  }
}
