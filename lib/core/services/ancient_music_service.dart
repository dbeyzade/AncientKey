import '../database/app_database.dart';

class AncientMusic {
  final String id;
  final String name;
  final String civilization;
  final String type;
  final String description;
  final String? usage;
  final String? materials;
  final String? soundCharacteristics;
  final String? imageUrl;

  AncientMusic({
    required this.id,
    required this.name,
    required this.civilization,
    required this.type,
    required this.description,
    this.usage,
    this.materials,
    this.soundCharacteristics,
    this.imageUrl,
  });

  factory AncientMusic.fromMap(Map<String, dynamic> map) {
    return AncientMusic(
      id: map['id'],
      name: map['title'] ?? '',
      civilization: map['civilization'] ?? 'Bilinmeyen',
      type: map['scene_type'] ?? 'Müzik',
      description: map['description'] ?? '',
      usage: map['activities'],
      materials: map['time_of_day'],
      soundCharacteristics: map['season'],
      imageUrl: map['image_url'],
    );
  }
}

class AncientMusicService {
  Future<List<AncientMusic>> getAllMusic() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['music']);
    if (existing.isEmpty) {
      await insertSampleMusic();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['music'], orderBy: 'civilization, title ASC');
    return results.map((map) => AncientMusic.fromMap(map)).toList();
  }

  Future<void> insertSampleMusic() async {
    final db = await AppDatabase().database;
    
    final musicItems = [
      // Antik Yunan
      {
        'id': 'music_1',
        'scene_type': 'music',
        'title': 'Lir (Lyre)',
        'civilization': 'Antik Yunan',
        'description': 'Apollo tanrısına atfedilen yedi telli kutsal enstrüman. Yunan müziğinin simgesi.',
        'activities': 'Şiir okuma, dinsel törenler, eğitim',
        'time_of_day': 'Ahşap, kaplumbağa kabuğu, hayvan bağırsağı teller',
        'season': 'Yumuşak, melodik, lirik ses',
      },
      {
        'id': 'music_2',
        'scene_type': 'music',
        'title': 'Aulos',
        'civilization': 'Antik Yunan',
        'description': 'Çift kamışlı üflemeli enstrüman. Dionysos kültü ve tiyatrolarda kullanılır.',
        'activities': 'Festivaller, tiyatro, askeri törenleri',
        'time_of_day': 'Kamış, kemik, ahşap',
        'season': 'Keskin, nüfuz edici, coşkulu ses',
      },
      {
        'id': 'music_3',
        'scene_type': 'music',
        'title': 'Kithara',
        'civilization': 'Antik Yunan',
        'description': 'Profesyonel müzisyenler tarafından kullanılan büyük lir. Olimpiyat şampiyonlarının enstrümanı.',
        'activities': 'Müzik yarışmaları, festivaller, saray törenleri',
        'time_of_day': 'Ahşap, hayvan derisi, metal teller',
        'season': 'Güçlü, zengin, rezonant ses',
      },
      {
        'id': 'music_4',
        'scene_type': 'music',
        'title': 'Salpinx (Trompet)',
        'civilization': 'Antik Yunan',
        'description': 'Bronz askeri trompet. Savaşta sinyal vermek ve Olimpiyatlarda kullanılır.',
        'activities': 'Askeri sinyaller, spor yarışmaları',
        'time_of_day': 'Bronz',
        'season': 'Yüksek perdeli, güçlü, uzağa ulaşan ses',
      },
      
      // Antik Roma
      {
        'id': 'music_5',
        'scene_type': 'music',
        'title': 'Tibia',
        'civilization': 'Antik Roma',
        'description': 'Yunan aulos\'unun Roma versiyonu. Tiyatro, gladyatör dövüşleri ve cenaze törenlerinde kullanılır.',
        'activities': 'Tiyatro, gladyatör gösterileri, dini ayinler',
        'time_of_day': 'Kemik, bronz, kamış',
        'season': 'Parlak, keskin, dramatik ses',
      },
      {
        'id': 'music_6',
        'scene_type': 'music',
        'title': 'Cornu',
        'civilization': 'Antik Roma',
        'description': 'G şeklinde büyük bronz boru. Lejyonlarda komut ve sinyal için kullanılır.',
        'activities': 'Askeri sinyaller, gladyatör oyunları, törenler',
        'time_of_day': 'Bronz',
        'season': 'Derin, güçlü, yankılanan ses',
      },
      {
        'id': 'music_7',
        'scene_type': 'music',
        'title': 'Lituus',
        'civilization': 'Antik Roma',
        'description': 'Kıvrık uçlu bronz trompet. Dini törenlerde rahipler tarafından kullanılır.',
        'activities': 'Dini ayinler, kehanet törenleri',
        'time_of_day': 'Bronz',
        'season': 'İnce, yüksek perdeli, gizemli ses',
      },
      {
        'id': 'music_8',
        'scene_type': 'music',
        'title': 'Hydraulis (Su Org)',
        'civilization': 'Antik Roma',
        'description': 'Dünyanın ilk org enstrümanı. Su basıncıyla çalışan karmaşık mekanik müzik aleti.',
        'activities': 'Arena gösterileri, imparatorluk törenleri',
        'time_of_day': 'Bronz, ahşap, deri, su mekanizması',
        'season': 'Güçlü, dolgun, çok sesli organ sesi',
      },
      
      // Antik Mısır
      {
        'id': 'music_9',
        'scene_type': 'music',
        'title': 'Sistrum',
        'civilization': 'Antik Mısır',
        'description': 'İsis tanrıçasının kutsal enstrümanı. Metal çıngırak sesli rahatsız edici enstrüman.',
        'activities': 'Tapınak törenleri, dini ayinler, İsis kültü',
        'time_of_day': 'Bronz, bakır, ahşap',
        'season': 'Çınlayan, titreşimli, ritmik ses',
      },
      {
        'id': 'music_10',
        'scene_type': 'music',
        'title': 'Ney (Antik Flüt)',
        'civilization': 'Antik Mısır',
        'description': '5000 yıllık kamış flüt. En eski bilinen müzik aletlerinden biri.',
        'activities': 'Pastoral müzik, eğlence, törenleri',
        'time_of_day': 'Kamış, ahşap',
        'season': 'Yumuşak, melodik, pastoral ses',
      },
      {
        'id': 'music_11',
        'scene_type': 'music',
        'title': 'Harp (Arpa)',
        'civilization': 'Antik Mısır',
        'description': 'Firavunların saraylarında çalınan kutsal enstrüman. Mezar resimleriyle tanınır.',
        'activities': 'Saray müziği, dini ayinler, cenaze törenleri',
        'time_of_day': 'Ahşap, deri, bağırsak teller',
        'season': 'Melodik, yumuşak, lirik ses',
      },
      {
        'id': 'music_12',
        'scene_type': 'music',
        'title': 'Tabla (Davul)',
        'civilization': 'Antik Mısır',
        'description': 'Çerçeve davul. Hathor tanrıçasının kutsal enstrümanı.',
        'activities': 'Danslar, dinsel törenler, eğlence',
        'time_of_day': 'Ahşap çerçeve, hayvan derisi',
        'season': 'Ritmik, derin, yankılanan davul sesi',
      },
      
      // Mezopotamya
      {
        'id': 'music_13',
        'scene_type': 'music',
        'title': 'Lilis (Kral Liri)',
        'civilization': 'Mezopotamya',
        'description': 'Ur kazılarında bulunan altın ve lapis lazuli kaplı muhteşem lir. 4500 yıllık.',
        'activities': 'Saray törenleri, dini ayinler, kraliyet ziyafetleri',
        'time_of_day': 'Gümüş, altın, lapis lazuli, ahşap',
        'season': 'Zengin, melodik, aristokrat ses',
      },
      {
        'id': 'music_14',
        'scene_type': 'music',
        'title': 'Balag (Büyük Davul)',
        'civilization': 'Mezopotamya',
        'description': 'Tapınak törenlerinde kullanılan dev davul. Tanrılara seslenme aracı.',
        'activities': 'Tapınak törenleri, festival ritüelleri',
        'time_of_day': 'Bronz, ahşap, hayvan derisi',
        'season': 'Çok derin, güçlü, gök gürültüsü gibi ses',
      },
      {
        'id': 'music_15',
        'scene_type': 'music',
        'title': 'Gisgu (Uzun Boyunlu Lavta)',
        'civilization': 'Mezopotamya',
        'description': 'İki-üç telli uzun lavta. Akadca metinlerde geçer.',
        'activities': 'Şarkı eşliği, eğlence müziği',
        'time_of_day': 'Ahşap, deri, bağırsak teller',
        'season': 'İnce, parlak, melodik ses',
      },
      
      // Antik Çin
      {
        'id': 'music_16',
        'scene_type': 'music',
        'title': 'Guqin (Yedi Telli Siter)',
        'civilization': 'Antik Çin',
        'description': 'Konfüçyüs\'ün dört sanatından biri. 3000 yıllık bilge enstrümanı.',
        'activities': 'Meditasyon, bilge toplantıları, sanat ritüeli',
        'time_of_day': 'Katalpa ağacı, ipek teller',
        'season': 'Derin, felsefi, zen ses',
      },
      {
        'id': 'music_17',
        'scene_type': 'music',
        'title': 'Bianzhong (Bronz Çanlar)',
        'civilization': 'Antik Çin',
        'description': 'Asılı bronz çanlar seti. Qin İmparatoru\'nun mezarında 65 çan bulundu.',
        'activities': 'Saray törenleri, dini ritüeller, askeri müzik',
        'time_of_day': 'Bronz',
        'season': 'Kristal berrak, harmonik, çan sesi',
      },
      {
        'id': 'music_18',
        'scene_type': 'music',
        'title': 'Xun (Toprak Ocarina)',
        'civilization': 'Antik Çin',
        'description': '7000 yıllık pişmiş toprak flüt. En eski Çin enstrümanlarından.',
        'activities': 'Pastoral müzik, halk müziği',
        'time_of_day': 'Pişmiş toprak, seramik',
        'season': 'Boğuk, melankolik, pastoral ses',
      },
      {
        'id': 'music_19',
        'scene_type': 'music',
        'title': 'Sheng (Ağız Orgı)',
        'civilization': 'Antik Çin',
        'description': 'Bambu borular ve serbest kamışlar içeren eski üflemeli enstrüman.',
        'activities': 'Orkestra müziği, saray konserleri',
        'time_of_day': 'Bambu, bronz kamışlar',
        'season': 'Harmonik, çok sesli, organ benzeri ses',
      },
      
      // Hindistan
      {
        'id': 'music_20',
        'scene_type': 'music',
        'title': 'Veena',
        'civilization': 'Vedik Hindistan',
        'description': 'Saraswati tanrıçasının kutsal enstrümanı. 5000 yıllık telli enstrüman.',
        'activities': 'Klasik müzik, tapınak törenleri, meditasyon',
        'time_of_day': 'Ahşap, bal kabağı, pirinç',
        'season': 'Derin, rezonant, ruhani ses',
      },
      {
        'id': 'music_21',
        'scene_type': 'music',
        'title': 'Mridangam',
        'civilization': 'Vedik Hindistan',
        'description': 'Çift başlı silindirik davul. Karnatik müziğinin kalbi.',
        'activities': 'Tapınak müziği, dans eşliği, klasik performanslar',
        'time_of_day': 'Ahşap, keçi derisi, pirinç pastası',
        'season': 'Kompleks, ritmik, bas-tiz dengeli ses',
      },
      {
        'id': 'music_22',
        'scene_type': 'music',
        'title': 'Bansuri (Bambu Flüt)',
        'civilization': 'Vedik Hindistan',
        'description': 'Krishna\'nın mitolojik enstrümanı. Bambudan yapılma transvers flüt.',
        'activities': 'Pastoral müzik, bhakti şarkıları',
        'time_of_day': 'Bambu',
        'season': 'Yumuşak, melodik, pastoral ses',
      },
      {
        'id': 'music_23',
        'scene_type': 'music',
        'title': 'Shankha (Konik Kabuk)',
        'civilization': 'Vedik Hindistan',
        'description': 'Deniz kabuğundan yapılma kutsal boru. Vishnu\'nun simgesi.',
        'activities': 'Tapınak törenleri, puja ritüelleri, savaş sinyali',
        'time_of_day': 'Doğal deniz kabuğu',
        'season': 'Derin, uzun, kutsal boru sesi',
      },
      
      // Maya
      {
        'id': 'music_24',
        'scene_type': 'music',
        'title': 'Ocarina (Toprak Flüt)',
        'civilization': 'Maya',
        'description': 'Hayvan şekillerinde seramik flüt. Jaguar, kuş, insan figürleri.',
        'activities': 'Dini törenler, ritüeller',
        'time_of_day': 'Pişmiş toprak, seramik',
        'season': 'Yüksek perdeli, kuş benzeri ses',
      },
      {
        'id': 'music_25',
        'scene_type': 'music',
        'title': 'Tunkul (Yılan Derisi Davul)',
        'civilization': 'Maya',
        'description': 'Ahşap gövdeli, yılan derisi kaplı davul. Maya tapınaklarında kullanılır.',
        'activities': 'Tapınak törenleri, savaş dansları',
        'time_of_day': 'Ahşap, yılan derisi',
        'season': 'Keskin, ritmik, gizemli davul sesi',
      },
    ];

    for (final music in musicItems) {
      await db.insert('daily_life_scenes', {
        ...music,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
