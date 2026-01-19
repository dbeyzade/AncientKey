import '../database/app_database.dart';

class Ritual {
  final String id;
  final String name;
  final String civilization;
  final String description;
  final String? purpose;
  final String? timing;
  final String? participants;
  final String? location;
  final String? offerings;
  final String? imageUrl;

  Ritual({
    required this.id,
    required this.name,
    required this.civilization,
    required this.description,
    this.purpose,
    this.timing,
    this.participants,
    this.location,
    this.offerings,
    this.imageUrl,
  });

  factory Ritual.fromMap(Map<String, dynamic> map) {
    return Ritual(
      id: map['id'],
      name: map['title'] ?? '',
      civilization: map['civilization'] ?? 'Bilinmeyen',
      description: map['description'] ?? '',
      purpose: map['activities'],
      timing: map['time_of_day'],
      participants: map['season'],
      location: map['scene_type'],
      offerings: null,
      imageUrl: map['image_url'],
    );
  }
}

class RitualsService {
  Future<List<Ritual>> getAllRituals() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['ritual']);
    if (existing.isEmpty) {
      await insertSampleRituals();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['ritual'], orderBy: 'title ASC');
    return results.map((map) => Ritual.fromMap(map)).toList();
  }

  Future<void> insertSampleRituals() async {
    final db = await AppDatabase().database;
    
    final rituals = [
      {
        'id': 'ritual_1',
        'scene_type': 'ritual',
        'title': 'Dionysia Festivali',
        'civilization': 'Antik Yunan',
        'description': 'Şarap tanrısı Dionysos onuruna yapılan büyük tiyatro ve şenlik festivali. Tragedya ve komedya oyunları sergilenir.',
        'activities': 'Tiyatro yarışmaları, dini ayinler, toplu ziyafet',
        'time_of_day': 'Mart ayında, 5 gün sürer',
        'season': 'Atina, Dionysos Tiyatrosu',
      },
      {
        'id': 'ritual_2',
        'scene_type': 'ritual',
        'title': 'Eleusinian Gizemleri',
        'civilization': 'Antik Yunan',
        'description': 'Demeter ve Persephone onuruna gerçekleştirilen gizli mistik ayinler. Ölüm ve yeniden doğuşu simgeler.',
        'activities': 'Gizli törenler, başlatma ayinleri',
        'time_of_day': 'Eylül ve Ekim ayları',
        'season': 'Eleusis Tapınağı',
      },
      {
        'id': 'ritual_3',
        'scene_type': 'ritual',
        'title': 'Olimpiyat Oyunları',
        'civilization': 'Antik Yunan',
        'description': 'Zeus onuruna düzenlenen atletik yarışmalar. Tüm şehir devletleri arası savaşlar bu süre durur.',
        'activities': 'Atletik yarışlar, tanrılara kurban sunumu',
        'time_of_day': 'Her 4 yılda bir, yaz mevsimi',
        'season': 'Olympia',
      },
      {
        'id': 'ritual_4',
        'scene_type': 'ritual',
        'title': 'Opet Festivali',
        'civilization': 'Antik Mısır',
        'description': 'Firavunun ilahi gücünün yenilenmesi için yapılan büyük tören. Amun-Ra heykelinin Nil boyunca taşınması.',
        'activities': 'Rahipler, firavun, halk alayları',
        'time_of_day': 'İkinci ay, 11-27 gün arası',
        'season': 'Karnak Tapınağı, Luxor Tapınağı',
      },
      {
        'id': 'ritual_5',
        'scene_type': 'ritual',
        'title': 'Wep Ronpet (Yılbaşı)',
        'civilization': 'Antik Mısır',
        'description': 'Mısır yeni yılı kutlaması. Nil\'in taşması ve hasat döneminin başlangıcı.',
        'activities': 'Dini ayinler, ziyafetler, hediyeleşme',
        'time_of_day': 'Temmuz-Ağustos (Nil taşması)',
        'season': 'Tüm Mısır',
      },
      {
        'id': 'ritual_6',
        'scene_type': 'ritual',
        'title': 'Mumya Açılış Töreni',
        'civilization': 'Antik Mısır',
        'description': 'Ölen kişinin ruhunun bedenle iletişim kurabilmesi için ağız açma töreni.',
        'activities': 'Cenaze rahipleri, aile üyeleri',
        'time_of_day': 'Ölümden 70 gün sonra',
        'season': 'Mezar girişi',
      },
      {
        'id': 'ritual_7',
        'scene_type': 'ritual',
        'title': 'Akitu (Yeni Yıl Festivali)',
        'civilization': 'Mezopotamya',
        'description': 'Marduk tanrısı onuruna düzenlenen 12 günlük yeni yıl kutlaması. Kozmik düzenin yenilenmesi.',
        'activities': 'Kral, rahipler, yaratılış destanı okunması',
        'time_of_day': 'İlkbahar, 12 gün',
        'season': 'Babil, Esagila Tapınağı',
      },
      {
        'id': 'ritual_8',
        'scene_type': 'ritual',
        'title': 'Kutsal Evlilik Töreni',
        'civilization': 'Mezopotamya',
        'description': 'Kral ve yüksek rahibe arasında tanrısal evliliği simgeleyen tören. Bereketin sağlanması.',
        'activities': 'Kral, yüksek rahibe, tören müziği',
        'time_of_day': 'Yeni yıl festivali sırasında',
        'season': 'Zigguratın tepesi',
      },
      {
        'id': 'ritual_9',
        'scene_type': 'ritual',
        'title': 'Saturnalia',
        'civilization': 'Antik Roma',
        'description': 'Saturnus tanrısı onuruna yapılan şenlikli tatil. Sosyal rollerin tersine döndüğü festival.',
        'activities': 'Ziyafetler, hediye alışverişi, kumar',
        'time_of_day': '17-23 Aralık, 7 gün',
        'season': 'Tüm Roma İmparatorluğu',
      },
      {
        'id': 'ritual_10',
        'scene_type': 'ritual',
        'title': 'Vestalia',
        'civilization': 'Antik Roma',
        'description': 'Ocak tanrıçası Vesta onuruna kadınların kutladığı festival. Evlerin temizlenmesi.',
        'activities': 'Vestal bakireleri, Roma kadınları',
        'time_of_day': '7-15 Haziran',
        'season': 'Vesta Tapınağı, Forum Romanum',
      },
      {
        'id': 'ritual_11',
        'scene_type': 'ritual',
        'title': 'Lupercalia',
        'civilization': 'Antik Roma',
        'description': 'Bereket ve temizlik festivali. Kurt derisi kuşanan rahiplerin şehri dolaşması.',
        'activities': 'Luperci rahipleri, genç erkekler',
        'time_of_day': '15 Şubat',
        'season': 'Palatine Tepesi',
      },
      {
        'id': 'ritual_12',
        'scene_type': 'ritual',
        'title': 'Ashvamedha (At Kurbanı)',
        'civilization': 'Vedik Hindistan',
        'description': 'Kralın gücünü ispat etmek için yapılan büyük at kurban töreni. Bir yıl sürer.',
        'activities': 'Kral, Brahman rahipler, ordu',
        'time_of_day': 'Bir yıl sürer',
        'season': 'Krallık toprakları',
      },
      {
        'id': 'ritual_13',
        'scene_type': 'ritual',
        'title': 'Kumbh Mela',
        'civilization': 'Hindu',
        'description': 'Kutsal nehirlerde yapılan büyük hac töreni. Günahlardan arınma ve kurtuluş arayışı.',
        'activities': 'Milyonlarca hacı, sadhu\'lar, rahipler',
        'time_of_day': 'Her 12 yılda bir, 55 gün',
        'season': 'Ganj, Yamuna nehirleri',
      },
      {
        'id': 'ritual_14',
        'scene_type': 'ritual',
        'title': 'Diwali (Işıklar Festivali)',
        'civilization': 'Hindu',
        'description': 'İyiliğin kötülüğe galibiyetini kutlayan ışık festivali. Lakshmi tanrıçasına tapınma.',
        'activities': 'Mum yakma, havai fişek, aile ziyafetleri',
        'time_of_day': '5 gün, sonbahar',
        'season': 'Tüm Hindistan',
      },
      {
        'id': 'ritual_15',
        'scene_type': 'ritual',
        'title': 'Vesak (Buddha Günü)',
        'civilization': 'Budizm',
        'description': 'Buddha\'nın doğumu, aydınlanması ve ölümünü anma töreni.',
        'activities': 'Tapınaklarda meditasyon, fener yakma',
        'time_of_day': 'Mayıs ayı, dolunay',
        'season': 'Budist tapınakları',
      },
      {
        'id': 'ritual_16',
        'scene_type': 'ritual',
        'title': 'Tlacaxipehualiztli',
        'civilization': 'Aztek',
        'description': 'Xipe Totec tanrısı onuruna yapılan bahar festivali. Yeniden doğuş ve yenilenme töreni.',
        'activities': 'Gladyatör dövüşleri, kurban törenleri',
        'time_of_day': 'İlkbahar, 20 gün',
        'season': 'Templo Mayor, Tenochtitlan',
      },
      {
        'id': 'ritual_17',
        'scene_type': 'ritual',
        'title': 'Inti Raymi (Güneş Festivali)',
        'civilization': 'İnka',
        'description': 'Güneş tanrısı İnti onuruna düzenlenen kış gündönümü festivali.',
        'activities': 'İmparator, rahipler, lama kurbanı',
        'time_of_day': '24 Haziran, kış gündönümü',
        'season': 'Cusco, Qorikancha Tapınağı',
      },
      {
        'id': 'ritual_18',
        'scene_type': 'ritual',
        'title': 'Blót (Kurban Töreni)',
        'civilization': 'Viking/Norse',
        'description': 'Tanrılara hayvan kurbanı sunma töreni. Bereket ve zafer için yapılır.',
        'activities': 'Jarl, gothi (rahip), topluluk',
        'time_of_day': 'Mevsimsel değişimler',
        'season': 'Hov (tapınak) veya kutsal korulukar',
      },
      {
        'id': 'ritual_19',
        'scene_type': 'ritual',
        'title': 'Yule (Kış Kutlaması)',
        'civilization': 'Viking/Norse',
        'description': 'Kış gündönümü kutlaması. Domuz kurbanı ve ziyafet.',
        'activities': 'Tüm topluluk, şenlik ve içki',
        'time_of_day': 'Aralık sonu, 12 gün',
        'season': 'Longhouse (uzun ev)',
      },
      {
        'id': 'ritual_20',
        'scene_type': 'ritual',
        'title': 'Matsuri (Shinto Festivali)',
        'civilization': 'Antik Japonya',
        'description': 'Kami (ruhlar) onuruna düzenlenen Shinto festivali. Taşınabilir tapınak alayı.',
        'activities': 'Kannushi (rahip), mikoshi taşıyıcıları',
        'time_of_day': 'Mevsimsel, yıl boyunca',
        'season': 'Jinja (Shinto tapınakları)',
      },
    ];

    for (final ritual in rituals) {
      await db.insert('daily_life_scenes', {
        ...ritual,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
