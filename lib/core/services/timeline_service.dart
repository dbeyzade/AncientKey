import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

final timelineServiceProvider = Provider((ref) => TimelineService());

class TimelineEvent {
  final String id;
  final String mapId;
  final String title;
  final String? description;
  final int yearStart;
  final int? yearEnd;
  final String? era;
  final String? civilization;
  final String? category;
  final String? imageUrl;
  final DateTime createdAt;

  TimelineEvent({
    required this.id,
    required this.mapId,
    required this.title,
    this.description,
    required this.yearStart,
    this.yearEnd,
    this.era,
    this.civilization,
    this.category,
    this.imageUrl,
    required this.createdAt,
  });

  factory TimelineEvent.fromMap(Map<String, dynamic> map) {
    return TimelineEvent(
      id: map['id'],
      mapId: map['map_id'],
      title: map['title'],
      description: map['description'],
      yearStart: map['year_start'],
      yearEnd: map['year_end'],
      era: map['era'],
      civilization: map['civilization'],
      category: map['category'],
      imageUrl: map['image_url'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}

class TimelineService {
  final _uuid = const Uuid();

  Future<void> addEvent(TimelineEvent event) async {
    final db = await AppDatabase().database;
    await db.insert('timeline_events', {
      'id': event.id,
      'map_id': event.mapId,
      'title': event.title,
      'description': event.description,
      'year_start': event.yearStart,
      'year_end': event.yearEnd,
      'era': event.era,
      'civilization': event.civilization,
      'category': event.category,
      'image_url': event.imageUrl,
      'created_at': event.createdAt.millisecondsSinceEpoch,
    });
  }

  Future<List<TimelineEvent>> getEventsForMap(String mapId) async {
    final db = await AppDatabase().database;

    // Check if sample data is needed
    final count = await db.rawQuery(
      'SELECT COUNT(*) as count FROM timeline_events',
    );
    if ((count.first['count'] as int) == 0) {
      await insertSampleEvents();
    }

    final results = await db.query(
      'timeline_events',
      where: 'map_id = ? OR map_id = ?', // Include 'general' events too
      whereArgs: [mapId, 'general'],
      orderBy: 'year_start ASC',
    );
    return results.map((e) => TimelineEvent.fromMap(e)).toList();
  }

  Future<List<TimelineEvent>> getAllEvents() async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'timeline_events',
      orderBy: 'year_start ASC',
    );

    if (results.isEmpty) {
      await insertSampleEvents();
      return getAllEvents();
    }

    return results.map((e) => TimelineEvent.fromMap(e)).toList();
  }

  Future<List<TimelineEvent>> getEventsByCivilization(
    String civilization,
  ) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'timeline_events',
      where: 'civilization = ?',
      whereArgs: [civilization],
      orderBy: 'year_start ASC',
    );
    return results.map((e) => TimelineEvent.fromMap(e)).toList();
  }

  Future<List<TimelineEvent>> getEventsByEra(String era) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'timeline_events',
      where: 'era = ?',
      whereArgs: [era],
      orderBy: 'year_start ASC',
    );
    return results.map((e) => TimelineEvent.fromMap(e)).toList();
  }

  Future<List<String>> getAllCivilizations() async {
    final db = await AppDatabase().database;
    final results = await db.rawQuery(
      'SELECT DISTINCT civilization FROM timeline_events WHERE civilization IS NOT NULL ORDER BY civilization ASC',
    );
    return results.map((e) => e['civilization'] as String).toList();
  }

  Future<List<String>> getAllEras() async {
    final db = await AppDatabase().database;
    final results = await db.rawQuery(
      'SELECT DISTINCT era FROM timeline_events WHERE era IS NOT NULL ORDER BY era ASC',
    );
    return results.map((e) => e['era'] as String).toList();
  }

  Future<void> insertSampleEvents() async {
    final db = await AppDatabase().database;
    final now = DateTime.now().millisecondsSinceEpoch;

    final events = [
      // Antik Yunan
      {
        'id': 'timeline_1',
        'map_id': 'general',
        'title': 'Truva Savaşı',
        'description':
            'Homeros\'un İlyada destanında anlatılan efsanevi savaş. Agamemnon liderliğindeki Akha birliği Truva\'yı kuşattı.',
        'year_start': -1200,
        'year_end': -1180,
        'era': 'Tunç Çağı',
        'civilization': 'Antik Yunan',
        'category': 'Savaş',
      },
      {
        'id': 'timeline_2',
        'map_id': 'general',
        'title': 'İlk Olimpiyat Oyunları',
        'description':
            'Zeus onuruna Olympia\'da düzenlenen ilk atletik yarışmalar. Antik dünyanın en önemli spor etkinliği.',
        'year_start': -776,
        'year_end': null,
        'era': 'Arkaik Dönem',
        'civilization': 'Antik Yunan',
        'category': 'Kültür',
      },
      {
        'id': 'timeline_3',
        'map_id': 'general',
        'title': 'Atina Demokrasisi',
        'description':
            'Kleisthenes reformlarıyla Atina\'da ilk demokrasi sistemi kuruldu. Halk meclisi ve jüri sistemi başladı.',
        'year_start': -508,
        'year_end': null,
        'era': 'Klasik Dönem',
        'civilization': 'Antik Yunan',
        'category': 'Siyaset',
      },
      {
        'id': 'timeline_4',
        'map_id': 'general',
        'title': 'Maraton Savaşı',
        'description':
            'Atinalılar Pers ordusunu yendi. Pheidippides zafer haberini getirmek için Maraton\'dan Atina\'ya koştu.',
        'year_start': -490,
        'year_end': null,
        'era': 'Klasik Dönem',
        'civilization': 'Antik Yunan',
        'category': 'Savaş',
      },
      {
        'id': 'timeline_5',
        'map_id': 'general',
        'title': 'Parthenon İnşası',
        'description':
            'Athena tapınağı Akropol\'de inşa edildi. Dor mimarisinin en mükemmel örneği, Phidias heykelleri.',
        'year_start': -447,
        'year_end': -432,
        'era': 'Klasik Dönem',
        'civilization': 'Antik Yunan',
        'category': 'Mimari',
      },
      {
        'id': 'timeline_6',
        'map_id': 'general',
        'title': 'Büyük İskender\'in Fethi',
        'description':
            'Makedonya Kralı İskender Büyük Pers İmparatorluğu\'nu yıkarak Hindistan\'a kadar uzanan devasa bir imparatorluk kurdu.',
        'year_start': -334,
        'year_end': -323,
        'era': 'Helenistik Dönem',
        'civilization': 'Makedonya',
        'category': 'Savaş',
      },

      // Antik Roma
      {
        'id': 'timeline_7',
        'map_id': 'general',
        'title': 'Roma\'nın Kuruluşu',
        'description':
            'Efsaneye göre Romulus ve Remus tarafından kuruldu. Tiber nehri kıyısında 7 tepe üzerinde şehir inşa edildi.',
        'year_start': -753,
        'year_end': null,
        'era': 'Krallık Dönemi',
        'civilization': 'Antik Roma',
        'category': 'Kuruluş',
      },
      {
        'id': 'timeline_8',
        'map_id': 'general',
        'title': 'Roma Cumhuriyeti',
        'description':
            'Son kral Tarquinius Superbus kovuldu. Senato ve konsül sistemiyle cumhuriyet ilan edildi.',
        'year_start': -509,
        'year_end': null,
        'era': 'Cumhuriyet Dönemi',
        'civilization': 'Antik Roma',
        'category': 'Siyaset',
      },
      {
        'id': 'timeline_9',
        'map_id': 'general',
        'title': 'Pön Savaşları',
        'description':
            'Roma ile Kartaca arasındaki üç savaş. Hannibal\'in Alpler\'i aşması, Scipio\'nun zaferi.',
        'year_start': -264,
        'year_end': -146,
        'era': 'Cumhuriyet Dönemi',
        'civilization': 'Antik Roma',
        'category': 'Savaş',
      },
      {
        'id': 'timeline_10',
        'map_id': 'general',
        'title': 'Julius Caesar Suikastı',
        'description':
            'Senato\'da Brutus ve komplocular tarafından öldürüldü. "Et tu, Brute?" sözleri tarihe geçti.',
        'year_start': -44,
        'year_end': null,
        'era': 'Cumhuriyet Sonu',
        'civilization': 'Antik Roma',
        'category': 'Siyaset',
      },
      {
        'id': 'timeline_11',
        'map_id': 'general',
        'title': 'Augustus İmparatoru',
        'description':
            'Octavianus ilk Roma İmparatoru oldu. Pax Romana (Roma Barışı) dönemi başladı.',
        'year_start': -27,
        'year_end': null,
        'era': 'İmparatorluk Dönemi',
        'civilization': 'Antik Roma',
        'category': 'Siyaset',
      },
      {
        'id': 'timeline_12',
        'map_id': 'general',
        'title': 'Kolezyum İnşası',
        'description':
            'Flavius Hanedanı tarafından inşa edildi. 50,000 seyirci kapasiteli amfitiyatro, gladyatör dövüşleri.',
        'year_start': 70,
        'year_end': 80,
        'era': 'İmparatorluk Dönemi',
        'civilization': 'Antik Roma',
        'category': 'Mimari',
      },
      {
        'id': 'timeline_13',
        'map_id': 'general',
        'title': 'Hristiyanlığın Yayılması',
        'description':
            'Konstantinus Milano Fermanı ile Hristiyanlığı serbest bıraktı. Devlet dini oldu.',
        'year_start': 313,
        'year_end': null,
        'era': 'Geç İmparatorluk',
        'civilization': 'Antik Roma',
        'category': 'Din',
      },
      {
        'id': 'timeline_14',
        'map_id': 'general',
        'title': 'Roma\'nın Düşüşü',
        'description':
            'Batı Roma İmparatorluğu son buldu. Cermen kavimleri istilası, Romulus Augustulus tahttan indirildi.',
        'year_start': 476,
        'year_end': null,
        'era': 'Geç İmparatorluk',
        'civilization': 'Antik Roma',
        'category': 'Çöküş',
      },

      // Antik Mısır
      {
        'id': 'timeline_15',
        'map_id': 'general',
        'title': 'Mısır\'ın Birleşmesi',
        'description':
            'Kral Narmer (Menes) Yukarı ve Aşağı Mısır\'ı birleştirdi. İlk hanedanı kurdu.',
        'year_start': -3100,
        'year_end': null,
        'era': 'Erken Hanedanlar',
        'civilization': 'Antik Mısır',
        'category': 'Kuruluş',
      },
      {
        'id': 'timeline_16',
        'map_id': 'general',
        'title': 'Keops Piramidi',
        'description':
            'Giza\'da Büyük Piramit inşa edildi. 2.3 milyon taş blok, 146 metre yükseklik, 7 harika.',
        'year_start': -2560,
        'year_end': -2540,
        'era': 'Eski Krallık',
        'civilization': 'Antik Mısır',
        'category': 'Mimari',
      },
      {
        'id': 'timeline_17',
        'map_id': 'general',
        'title': 'Hyksos İstilası',
        'description':
            'Asya kökenli Hyksos kavimleri Mısır\'ı istila etti. At arabası ve kompozit yay getirdiler.',
        'year_start': -1650,
        'year_end': -1550,
        'era': 'İkinci Ara Dönem',
        'civilization': 'Antik Mısır',
        'category': 'Savaş',
      },
      {
        'id': 'timeline_18',
        'map_id': 'general',
        'title': 'Hatshepsut Kraliçesi',
        'description':
            'Kadın firavun olarak tahta çıktı. Punt seferleri, Deir el-Bahari tapınağı, ekonomik refah.',
        'year_start': -1479,
        'year_end': -1458,
        'era': 'Yeni Krallık',
        'civilization': 'Antik Mısır',
        'category': 'Siyaset',
      },
      {
        'id': 'timeline_19',
        'map_id': 'general',
        'title': 'Akhenaton Reformu',
        'description':
            'Amenhotep IV tek tanrılı Aton dinini getirdi. Başkenti Amarna\'ya taşıdı, sanat devrimi.',
        'year_start': -1353,
        'year_end': -1336,
        'era': 'Yeni Krallık',
        'civilization': 'Antik Mısır',
        'category': 'Din',
      },
      {
        'id': 'timeline_20',
        'map_id': 'general',
        'title': 'Tutankhamun Mezarı',
        'description':
            'Genç firavun öldü. Howard Carter 1922\'de bozulmamış mezarı keşfetti, altın maske.',
        'year_start': -1323,
        'year_end': null,
        'era': 'Yeni Krallık',
        'civilization': 'Antik Mısır',
        'category': 'Arkeoloji',
      },
      {
        'id': 'timeline_21',
        'map_id': 'general',
        'title': 'Ramses II Dönemi',
        'description':
            'En güçlü firavun, 67 yıl hüküm sürdü. Abu Simbel tapınakları, Kadeş Savaşı, barış antlaşması.',
        'year_start': -1279,
        'year_end': -1213,
        'era': 'Yeni Krallık',
        'civilization': 'Antik Mısır',
        'category': 'Siyaset',
      },
      {
        'id': 'timeline_22',
        'map_id': 'general',
        'title': 'Kleopatra VII',
        'description':
            'Son Ptolemaios hükümdarı. Caesar ve Antonius ile ilişkileri, Roma\'ya karşı mücadele.',
        'year_start': -51,
        'year_end': -30,
        'era': 'Ptolemaios Dönemi',
        'civilization': 'Antik Mısır',
        'category': 'Siyaset',
      },

      // Mezopotamya
      {
        'id': 'timeline_23',
        'map_id': 'general',
        'title': 'Sümer Şehir Devletleri',
        'description':
            'İlk yazı (çivi yazısı) icat edildi. Uruk, Ur, Lagaş şehir devletleri kuruldu.',
        'year_start': -3500,
        'year_end': null,
        'era': 'Tunç Çağı',
        'civilization': 'Sümer',
        'category': 'Kuruluş',
      },
      {
        'id': 'timeline_24',
        'map_id': 'general',
        'title': 'Hammurabi Kanunları',
        'description':
            'Babil kralı ilk yazılı hukuk sistemini oluşturdu. "Göze göz, dişe diş" prensibi.',
        'year_start': -1750,
        'year_end': null,
        'era': 'Eski Babil',
        'civilization': 'Babil',
        'category': 'Hukuk',
      },
      {
        'id': 'timeline_25',
        'map_id': 'general',
        'title': 'Asur İmparatorluğu',
        'description':
            'Mezopotamya\'nın en güçlü askeri devleti. Ninova başkent, kütüphane, demir silahlar.',
        'year_start': -911,
        'year_end': -609,
        'era': 'Demir Çağı',
        'civilization': 'Asur',
        'category': 'Siyaset',
      },
      {
        'id': 'timeline_26',
        'map_id': 'general',
        'title': 'Babil\'in Asma Bahçeleri',
        'description':
            'Nebukadnezar II eşi için inşa etti. Dünyanın 7 harikasından biri, teraslı bahçeler.',
        'year_start': -600,
        'year_end': null,
        'era': 'Yeni Babil',
        'civilization': 'Babil',
        'category': 'Mimari',
      },

      // Çin
      {
        'id': 'timeline_27',
        'map_id': 'general',
        'title': 'Çin Seddi İnşası',
        'description':
            'Qin Shi Huang kuzeyli göçebelere karşı duvarı birleştirdi. 21,000 km uzunluğunda.',
        'year_start': -221,
        'year_end': -206,
        'era': 'Qin Hanedanı',
        'civilization': 'Çin',
        'category': 'Mimari',
      },
      {
        'id': 'timeline_28',
        'map_id': 'general',
        'title': 'Terracotta Ordusu',
        'description':
            'İlk imparator Qin Shi Huang\'ın mezarında 8,000 kil savaşçı heykeli keşfedildi.',
        'year_start': -210,
        'year_end': null,
        'era': 'Qin Hanedanı',
        'civilization': 'Çin',
        'category': 'Arkeoloji',
      },
      {
        'id': 'timeline_29',
        'map_id': 'general',
        'title': 'İpek Yolu',
        'description':
            'Han Hanedanı Çin ile Roma arasında ticaret yolunu açtı. İpek, baharat, seramik ticareti.',
        'year_start': -130,
        'year_end': null,
        'era': 'Han Hanedanı',
        'civilization': 'Çin',
        'category': 'Ticaret',
      },

      // Anadolu
      {
        'id': 'timeline_30',
        'map_id': 'general',
        'title': 'Hitit İmparatorluğu',
        'description':
            'Anadolu\'nun ilk büyük devleti. Hattusa başkent, demir metalurjisi, Kadeş antlaşması.',
        'year_start': -1600,
        'year_end': -1178,
        'era': 'Tunç Çağı',
        'civilization': 'Hitit',
        'category': 'Siyaset',
      },
      {
        'id': 'timeline_31',
        'map_id': 'general',
        'title': 'Lidya Krallığı',
        'description':
            'İlk parayı Lidyalılar bastı. Zengin Kral Kroisos, altın madenleri, Sardes başkent.',
        'year_start': -680,
        'year_end': -546,
        'era': 'Demir Çağı',
        'civilization': 'Lidya',
        'category': 'Ekonomi',
      },
      {
        'id': 'timeline_32',
        'map_id': 'general',
        'title': 'Efes Artemis Tapınağı',
        'description':
            'Dünyanın 7 harikasından biri. İyon mimarisinin şaheseri, 127 mermer sütun.',
        'year_start': -550,
        'year_end': null,
        'era': 'Arkaik Dönem',
        'civilization': 'İyon',
        'category': 'Mimari',
      },
    ];

    for (final event in events) {
      await db.insert('timeline_events', {...event, 'created_at': now});
    }
  }

  Future<List<TimelineEvent>> getEventsByCivilization(
    String civilization,
  ) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'timeline_events',
      where: 'civilization = ?',
      whereArgs: [civilization],
      orderBy: 'year_start ASC',
    );
    return results.map((e) => TimelineEvent.fromMap(e)).toList();
  }

  Future<List<TimelineEvent>> getEventsByEra(String era) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'timeline_events',
      where: 'era = ?',
      whereArgs: [era],
      orderBy: 'year_start ASC',
    );
    return results.map((e) => TimelineEvent.fromMap(e)).toList();
  }

  Future<List<TimelineEvent>> getEventsByYearRange(
    int startYear,
    int endYear,
  ) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'timeline_events',
      where: 'year_start >= ? AND year_start <= ?',
      whereArgs: [startYear, endYear],
      orderBy: 'year_start ASC',
    );
    return results.map((e) => TimelineEvent.fromMap(e)).toList();
  }

  Future<List<String>> getAllCivilizations() async {
    final db = await AppDatabase().database;
    final results = await db.rawQuery(
      'SELECT DISTINCT civilization FROM timeline_events WHERE civilization IS NOT NULL ORDER BY civilization',
    );
    return results.map((e) => e['civilization'] as String).toList();
  }

  Future<List<String>> getAllEras() async {
    final db = await AppDatabase().database;
    final results = await db.rawQuery(
      'SELECT DISTINCT era FROM timeline_events WHERE era IS NOT NULL ORDER BY era',
    );
    return results.map((e) => e['era'] as String).toList();
  }

  Future<List<TimelineEvent>> getAllEvents() async {
    final db = await AppDatabase().database;

    // İlk çalıştırmada sample data ekle
    final count = await db.rawQuery(
      'SELECT COUNT(*) as count FROM timeline_events',
    );
    if ((count.first['count'] as int) == 0) {
      await insertSampleEvents();
    }

    final results = await db.query(
      'timeline_events',
      orderBy: 'year_start ASC',
    );
    return results.map((e) => TimelineEvent.fromMap(e)).toList();
  }
}
