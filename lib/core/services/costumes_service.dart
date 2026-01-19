import '../database/app_database.dart';

class Costume {
  final String id;
  final String name;
  final String civilization;
  final String period;
  final String description;
  final String? socialClass;
  final String? materials;
  final String? colors;
  final String? occasion;
  final String? imageUrl;

  Costume({
    required this.id,
    required this.name,
    required this.civilization,
    required this.period,
    required this.description,
    this.socialClass,
    this.materials,
    this.colors,
    this.occasion,
    this.imageUrl,
  });

  factory Costume.fromMap(Map<String, dynamic> map) {
    return Costume(
      id: map['id'],
      name: map['title'] ?? '',
      civilization: map['civilization'] ?? 'Bilinmeyen',
      period: map['time_of_day'] ?? '',
      description: map['description'] ?? '',
      socialClass: map['activities'],
      materials: map['season'],
      colors: null,
      occasion: null,
      imageUrl: map['image_url'],
    );
  }
}

class CostumesService {
  Future<List<Costume>> getAllCostumes() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['costume']);
    if (existing.isEmpty) {
      await insertSampleCostumes();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['costume'], orderBy: 'civilization ASC');
    return results.map((map) => Costume.fromMap(map)).toList();
  }

  Future<void> insertSampleCostumes() async {
    final db = await AppDatabase().database;
    
    final costumes = [
      // Antik Yunan
      {
        'scene_type': 'costume',
        'id': 'costume_1',
        'title': 'Yunan Chiton',
        'civilization': 'Antik Yunan',
        'description': 'Yunanlıların temel giysisi. Omuzlardan broşlarla tutturulan dikişsiz kumaş parçası. Hem erkekler hem kadınlar giyer.',
        'activities': 'Tüm sosyal sınıflar',
        'time_of_day': 'MÖ 500-300',
        'season': 'Keten veya yün, beyaz veya doğal renkler',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_2',
        'title': 'Yunan Himation',
        'civilization': 'Antik Yunan',
        'description': 'Chiton üzerine giyilen büyük dikdörtgen pelerin. Vücuda çeşitli şekillerde sarılır, statü göstergesi.',
        'activities': 'Vatandaşlar, filozoflar',
        'time_of_day': 'MÖ 500-300',
        'season': 'Yün, genellikle beyaz veya mor',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_3',
        'title': 'Yunan Peplos',
        'civilization': 'Antik Yunan',
        'description': 'Kadınların giydiği, bele kemerle bağlanan ve üst kısmı kıvrılan uzun giysi. Daha muhafazakar görünüm.',
        'activities': 'Evli kadınlar, aristokrat kadınlar',
        'time_of_day': 'MÖ 800-300',
        'season': 'Yün, çeşitli renkler ve desenler',
      },
      
      // Antik Mısır
      {
        'scene_type': 'costume',
        'id': 'costume_4',
        'title': 'Mısır Shendyt (Peştamal)',
        'civilization': 'Antik Mısır',
        'description': 'Erkeklerin bel ve kalçalarına sardıkları kısa etek benzeri giysi. Sıcak iklim için pratik.',
        'activities': 'İşçiler, askerler, firavunlar',
        'time_of_day': 'MÖ 3000-30',
        'season': 'Keten, beyaz',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_5',
        'title': 'Mısır Kalasiris',
        'civilization': 'Antik Mısır',
        'description': 'Kadınların giydiği vücuda oturan, askılı uzun elbise. Şeffaf keten kumaştan yapılır.',
        'activities': 'Soylu kadınlar',
        'time_of_day': 'MÖ 2000-30',
        'season': 'İnce keten, beyaz veya renkli',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_6',
        'title': 'Firavun Nemes Başlığı',
        'civilization': 'Antik Mısır',
        'description': 'Firavunun sembolik çizgili başlığı. Mavi-altın renkli, yılan figürü (uraeus) ile süslü.',
        'activities': 'Sadece Firavun',
        'time_of_day': 'MÖ 3000-30',
        'season': 'Kumaş veya altın, mavi ve altın çizgili',
      },
      
      // Antik Roma
      {
        'scene_type': 'costume',
        'id': 'costume_7',
        'title': 'Roma Toga',
        'civilization': 'Antik Roma',
        'description': 'Roma vatandaşlarının resmi giysisi. Yarım daire şeklinde, karmaşık şekilde sarılan beyaz yün kumaş.',
        'activities': 'Erkek Roma vatandaşları',
        'time_of_day': 'MÖ 500-MS 300',
        'season': 'Yün, beyaz (senatörler için mor şeritli)',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_8',
        'title': 'Roma Stola',
        'civilization': 'Antik Roma',
        'description': 'Evli Roma kadınlarının uzun, dökümlü elbisesi. Tunica üzerine giyilir, statü ve saygınlık göstergesi.',
        'activities': 'Evli Roma kadınları',
        'time_of_day': 'MÖ 200-MS 300',
        'season': 'Keten veya yün, çeşitli renkler',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_9',
        'title': 'Centurion Zırhı',
        'civilization': 'Antik Roma',
        'description': 'Roma subaylarının kas şeklinde dövülmüş metal göğüs zırhı. Kırmızı pelerin ve süslü miğfer ile.',
        'activities': 'Ordu subayları',
        'time_of_day': 'MÖ 100-MS 300',
        'season': 'Bronz veya pirinç, kırmızı yün pelerin',
      },
      
      // Mezopotamya
      {
        'scene_type': 'costume',
        'id': 'costume_10',
        'title': 'Sümer Kaunakes',
        'civilization': 'Sümer',
        'description': 'Püsküllü veya yünlü dokulu etek benzeri giysi. Koyun yününden yapılır, statü göstergesi.',
        'activities': 'Rahipler, krallar',
        'time_of_day': 'MÖ 3000-2000',
        'season': 'Yün, doğal renkler',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_11',
        'title': 'Asur Kralı Kaftanı',
        'civilization': 'Asur',
        'description': 'Zengin işlemeli, uzun kollu kaftan. Saçaklı şal ve silindirik taçla tamamlanır.',
        'activities': 'Kral ve saray mensupları',
        'time_of_day': 'MÖ 900-600',
        'season': 'İşlemeli kumaş, mor ve altın',
      },
      
      // Viking/Norse
      {
        'scene_type': 'costume',
        'id': 'costume_12',
        'title': 'Viking Tunik ve Pantolon',
        'civilization': 'Viking',
        'description': 'Yünden yapılma uzun tunik ve dar pantolon. Kemerle bağlanır, deri ayakkabılar ile giyilir.',
        'activities': 'Viking erkekleri',
        'time_of_day': 'MS 800-1100',
        'season': 'Yün, doğal renkler (kahverengi, gri, yeşil)',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_13',
        'title': 'Viking Kadın Apron Elbisesi',
        'civilization': 'Viking',
        'description': 'İki parçalı: alt kısımda uzun tunik, üstünde oval broşlarla tutulan önlük elbise.',
        'activities': 'Viking kadınları',
        'time_of_day': 'MS 800-1100',
        'season': 'Yün ve keten, renkli',
      },
      
      // Japon
      {
        'scene_type': 'costume',
        'id': 'costume_14',
        'title': 'Heian Dönemi Juni-hitoe',
        'civilization': 'Heian Japonya',
        'description': 'Saray kadınlarının 12 katmanlı kimonosu. Her katman farklı renk, uyumlu renk seçimi sanat.',
        'activities': 'Saray aristokrat kadınları',
        'time_of_day': 'MS 794-1185',
        'season': 'İpek, çoklu renkler',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_15',
        'title': 'Samuray Yoroi Zırhı',
        'civilization': 'Feudal Japonya',
        'description': 'Lakalı metal plakaların iple bağlandığı esnek zırh. Kabuto (miğfer) ve menpo (yüz maskesi) ile.',
        'activities': 'Samuray savaşçılar',
        'time_of_day': 'MS 1000-1600',
        'season': 'Metal plakalar, deri, ipek kordonlar',
      },
      
      // Çin
      {
        'scene_type': 'costume',
        'id': 'costume_16',
        'title': 'Han Hanfu',
        'civilization': 'Han Çin',
        'description': 'Geniş kollu, çapraz yakalı uzun elbise. Kuşakla bağlanır, Çin kültürünün sembolü.',
        'activities': 'Tüm sosyal sınıflar',
        'time_of_day': 'MÖ 206-MS 220',
        'season': 'İpek veya pamuk, çeşitli renkler',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_17',
        'title': 'Ming İmparatoru Ejderha Cüppesi',
        'civilization': 'Ming Çin',
        'description': 'Altın ejderha işlemeli sarı ipek cüppe. Sadece imparator tarafından giyilir, gücün sembolü.',
        'activities': 'Sadece İmparator',
        'time_of_day': 'MS 1368-1644',
        'season': 'İpek, sarı (imparatorluk rengi)',
      },
      
      // Hint
      {
        'scene_type': 'costume',
        'id': 'costume_18',
        'title': 'Antik Hint Dhoti',
        'civilization': 'Antik Hindistan',
        'description': 'Erkeklerin beline sarıp bacaklar arasından geçirdiği uzun kumaş parçası. Sıcak iklim için ideal.',
        'activities': 'Erkekler, tüm sınıflar',
        'time_of_day': 'MÖ 1500-günümüz',
        'season': 'Pamuk veya ipek, beyaz veya renkli',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_19',
        'title': 'Hint Sari',
        'civilization': 'Antik Hindistan',
        'description': 'Kadınların vücuduna sardığı 5-9 metre uzunluğunda kumaş. Zarif kıvrımlar oluşturulur.',
        'activities': 'Kadınlar, tüm sınıflar',
        'time_of_day': 'MÖ 2800-günümüz',
        'season': 'Pamuk veya ipek, renkli ve desenli',
      },
      
      // Maya-Aztek
      {
        'scene_type': 'costume',
        'id': 'costume_20',
        'title': 'Maya Rahip Pelerini',
        'civilization': 'Maya',
        'description': 'Tüylerle süslü renkli pelerin ve başlık. Görkemli tören kıyafeti, jade ve altın süslemeli.',
        'activities': 'Rahipler, krallar',
        'time_of_day': 'MS 250-900',
        'season': 'Pamuk, quetzal kuşu tüyleri, jade',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_21',
        'title': 'Aztek Savaşçı Kostümü',
        'civilization': 'Aztek',
        'description': 'Pamuktan yapılma dolgulu zırh ve hayvan postundan başlık (jaguar, kartal). Rütbe göstergesi.',
        'activities': 'Savaşçılar',
        'time_of_day': 'MS 1300-1521',
        'season': 'Dolgulu pamuk, hayvan postu, tüyler',
      },
      
      // Osmanlı
      {
        'scene_type': 'costume',
        'id': 'costume_22',
        'title': 'Osmanlı Kaftan',
        'civilization': 'Osmanlı',
        'description': 'Uzun, geniş kollu, önden açık üst giysi. Zengin kumaş ve işlemelerle süslü, statü göstergesi.',
        'activities': 'Padişah, vezirler, zenginler',
        'time_of_day': 'MS 1299-1922',
        'season': 'İpek, kadife, altın işlemeli',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_23',
        'title': 'Osmanlı Şalvar',
        'civilization': 'Osmanlı',
        'description': 'Geniş, bol pantolon. Hem erkekler hem kadınlar tarafından giyilir, rahat ve muhafazakar.',
        'activities': 'Tüm sınıflar',
        'time_of_day': 'MS 1299-1922',
        'season': 'Pamuk veya ipek, çeşitli renkler',
      },
      
      // Pers
      {
        'scene_type': 'costume',
        'id': 'costume_24',
        'title': 'Pers Kandys',
        'civilization': 'Pers İmparatorluğu',
        'description': 'Uzun kollu, dökümlü palto benzeri giysi. Genellikle omuzlara atılır, kollar boş kalır.',
        'activities': 'Soylu Persler',
        'time_of_day': 'MÖ 550-330',
        'season': 'İpek, mor ve altın',
      },
      {
        'scene_type': 'costume',
        'id': 'costume_25',
        'title': 'Pers Başlığı (Tiara)',
        'civilization': 'Pers İmparatorluğu',
        'description': 'Dik, silindirik şapka. Rütbeye göre yükseklik değişir, kral en yükseği giyer.',
        'activities': 'Pers aristokratları',
        'time_of_day': 'MÖ 550-330',
        'season': 'Keçe, çeşitli renkler',
      },
    ];

    for (final costume in costumes) {
      await db.insert('daily_life_scenes', {
        ...costume,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
