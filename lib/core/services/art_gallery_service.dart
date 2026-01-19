import '../database/app_database.dart';

class ArtPiece {
  final String id;
  final String title;
  final String artist;
  final String civilization;
  final String period;
  final String description;
  final String? technique;
  final String? material;
  final String? location;
  final String? imageUrl;

  ArtPiece({
    required this.id,
    required this.title,
    required this.artist,
    required this.civilization,
    required this.period,
    required this.description,
    this.technique,
    this.material,
    this.location,
    this.imageUrl,
  });

  factory ArtPiece.fromMap(Map<String, dynamic> map) {
    return ArtPiece(
      id: map['id'],
      title: map['title'] ?? '',
      artist: map['activities'] ?? 'Bilinmeyen Sanatçı',
      civilization: map['civilization'] ?? 'Bilinmeyen',
      period: map['time_of_day'] ?? '',
      description: map['description'] ?? '',
      technique: map['season'],
      material: null,
      location: map['season'],
      imageUrl: map['image_url'],
    );
  }
}

class ArtGalleryService {
  Future<List<ArtPiece>> getAllArtPieces() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['art']);
    if (existing.isEmpty) {
      await insertSampleArtPieces();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['art'], orderBy: 'civilization ASC');
    return results.map((map) => ArtPiece.fromMap(map)).toList();
  }

  Future<void> insertSampleArtPieces() async {
    final db = await AppDatabase().database;
    
    final artPieces = [
      // Yunan Sanatı
      {
        'scene_type': 'art',
        'id': 'art_1',
        'title': 'Parthenon Frizleri',
        'activities': 'Phidias',
        'civilization': 'Antik Yunan',
        'description': 'Parthenon tapınağının doğu frizinde yer alan Panathenaia alayı betimlemesi. Atina\'nın en büyük dini törenini gösteren baş yapıt.',
        'time_of_day': 'MÖ 447-432',
        'season': 'Mermer kabartma, British Museum',
      },
      {
        'scene_type': 'art',
        'id': 'art_2',
        'title': 'Diskobol (Disk Atan)',
        'activities': 'Myron',
        'civilization': 'Antik Yunan',
        'description': 'Atletik hareketi mükemmel bir anında yakalayan ünlü heykel. İdeal vücut oranlarını ve dengeyi yansıtır.',
        'time_of_day': 'MÖ 460-450',
        'season': 'Bronz (Roma kopyası mevcut)',
      },
      {
        'scene_type': 'art',
        'id': 'art_3',
        'title': 'Laokoön Grubu',
        'activities': 'Agesander, Athenodoros, Polydoros',
        'civilization': 'Helenistik Yunan',
        'description': 'Truva rahibi Laokoön ve oğullarının yılanlar tarafından boğulmasını betimleyen dramatik heykel.',
        'time_of_day': 'MÖ 200-70',
        'season': 'Mermer, Vatikan Müzeleri',
      },
      {
        'scene_type': 'art',
        'id': 'art_4',
        'title': 'Venüs de Milo',
        'activities': 'Bilinmeyen',
        'civilization': 'Helenistik Yunan',
        'description': 'Güzellik tanrıçası Afrodit\'in kolsuz heykeli. Klasik Yunan güzellik idealini temsil eder.',
        'time_of_day': 'MÖ 130-100',
        'season': 'Mermer, Louvre Müzesi',
      },
      {
        'scene_type': 'art',
        'id': 'art_5',
        'title': 'Kızıl Figürlü Amphora',
        'activities': 'Andokides Ressamı',
        'civilization': 'Antik Yunan',
        'description': 'Yeni kızıl figür tekniğinin ilk örnekleri. Herakles\'in on iki işinden sahneler içerir.',
        'time_of_day': 'MÖ 530-520',
        'season': 'Seramik, çeşitli müzeler',
      },
      
      // Mısır Sanatı
      {
        'scene_type': 'art',
        'id': 'art_6',
        'title': 'Nefertiti Büstü',
        'activities': 'Thutmose',
        'civilization': 'Antik Mısır',
        'description': 'Kraliçe Nefertiti\'nin büyüleyici portresi. Mısır sanatının zirvesi olarak kabul edilir.',
        'time_of_day': 'MÖ 1345',
        'season': 'Kireçtaşı ve alçı, Neues Museum, Berlin',
      },
      {
        'scene_type': 'art',
        'id': 'art_7',
        'title': 'Tutankhamun\'un Altın Maskesi',
        'activities': 'Saray Sanatçıları',
        'civilization': 'Antik Mısır',
        'description': 'Genç firavunun mumyasını kaplayan altın ölüm maskesi. Tarih\'in en ikonik eserlerinden.',
        'time_of_day': 'MÖ 1323',
        'season': 'Altın ve değerli taşlar, Kahire Müzesi',
      },
      {
        'scene_type': 'art',
        'id': 'art_8',
        'title': 'Ramses II Kolosal Heykeli',
        'activities': 'Saray Heykeltıraşları',
        'civilization': 'Antik Mısır',
        'description': 'Abu Simbel tapınağının girişindeki dev oturan Ramses II heykelleri. 20 metre yüksekliğinde.',
        'time_of_day': 'MÖ 1264',
        'season': 'Kayaya oyulmuş, Abu Simbel',
      },
      {
        'scene_type': 'art',
        'id': 'art_9',
        'title': 'Nebamun\'un Mezar Duvarı',
        'activities': 'Thebes Ressamları',
        'civilization': 'Antik Mısır',
        'description': 'Bataklıkta kuş avı sahnesi. Mısır\'ın doğal dünyayı betimlemedeki ustalığını gösterir.',
        'time_of_day': 'MÖ 1350',
        'season': 'Duvar resmi, British Museum',
      },
      
      // Roma Sanatı
      {
        'scene_type': 'art',
        'id': 'art_10',
        'title': 'Augustus Prima Porta',
        'activities': 'Bilinmeyen',
        'civilization': 'Antik Roma',
        'description': 'İmparator Augustus\'un propaganda amaçlı heykeli. Askeri gücü ve ilahi bağlantısını vurgular.',
        'time_of_day': 'MS 1. yy',
        'season': 'Mermer, Vatikan Müzeleri',
      },
      {
        'scene_type': 'art',
        'id': 'art_11',
        'title': 'Pompeii Duvar Freskleri',
        'activities': 'Pompeii Sanatçıları',
        'civilization': 'Antik Roma',
        'description': 'Yanardağ külleri altında korunan muhteşem fresk örnekleri. Günlük yaşam, mitoloji ve doğa sahneleri.',
        'time_of_day': 'MÖ 79',
        'season': 'Fresk, Pompeii arkeolojik alanı',
      },
      {
        'scene_type': 'art',
        'id': 'art_12',
        'title': 'Marcus Aurelius Atlı Heykeli',
        'activities': 'Bilinmeyen',
        'civilization': 'Antik Roma',
        'description': 'Filozof imparator Marcus Aurelius\'un bronz atlı heykeli. Ortaçağ\'da hayatta kalan tek Roma bronz atlı heykeli.',
        'time_of_day': 'MS 175',
        'season': 'Bronz, Capitoline Müzeleri',
      },
      
      // Mezopotamya Sanatı
      {
        'scene_type': 'art',
        'id': 'art_13',
        'title': 'Ur Standartı',
        'activities': 'Ur Sanatçıları',
        'civilization': 'Sümer',
        'description': 'Savaş ve barış sahnelerini gösteren mozaik kutı. Erken Sümer toplumunun detaylı betimlemesi.',
        'time_of_day': 'MÖ 2600',
        'season': 'Sedef ve lapis lazuli mozaik, British Museum',
      },
      {
        'scene_type': 'art',
        'id': 'art_14',
        'title': 'İştar Kapısı',
        'activities': 'Babil Sanatçıları',
        'civilization': 'Babil',
        'description': 'Ejderha ve boğa figürleriyle süslü görkemli mavi çinili kapı. Babil\'in ihtişamını yansıtır.',
        'time_of_day': 'MÖ 575',
        'season': 'Sırlı tuğla, Pergamon Müzesi, Berlin',
      },
      {
        'scene_type': 'art',
        'id': 'art_15',
        'title': 'Aslan Avı Kabartmaları',
        'activities': 'Ninova Sanatçıları',
        'civilization': 'Asur',
        'description': 'Kral Ashurbanipal\'in aslan avı sahneleri. Dramatik hareket ve anatomi bilgisiyle ünlü.',
        'time_of_day': 'MÖ 645-635',
        'season': 'Mermer kabartma, British Museum',
      },
      
      // Hint Sanatı
      {
        'scene_type': 'art',
        'id': 'art_16',
        'title': 'Ajanta Mağara Freskleri',
        'activities': 'Budist Rahip Sanatçılar',
        'civilization': 'Gupta Hindistan',
        'description': 'Buddha\'nın hayatını ve önceki yaşamlarını anlatan muhteşem mağara freskleri.',
        'time_of_day': 'MS 2-6. yy',
        'season': 'Fresk, Ajanta Mağaraları, Hindistan',
      },
      {
        'scene_type': 'art',
        'id': 'art_17',
        'title': 'Shiva Nataraja',
        'activities': 'Chola Bronz Dökümcüleri',
        'civilization': 'Chola Hindistan',
        'description': 'Dans eden Shiva heykeli. Kozmik dansıyla evrenin yaratılışını, korunmasını ve yok oluşunu temsil eder.',
        'time_of_day': 'MS 10-11. yy',
        'season': 'Bronz, çeşitli müzeler',
      },
      
      // Çin Sanatı
      {
        'scene_type': 'art',
        'id': 'art_18',
        'title': 'Terracotta Ordusu',
        'activities': 'Qin Saray Sanatçıları',
        'civilization': 'Qin Çin',
        'description': 'İmparator Qin Shi Huang\'ın mezarını koruyan 8000\'den fazla pişmiş toprak savaşçı heykeli.',
        'time_of_day': 'MÖ 210',
        'season': 'Terracotta, Xi\'an, Çin',
      },
      {
        'scene_type': 'art',
        'id': 'art_19',
        'title': 'Dağlarda Gezinti',
        'activities': 'Guo Xi',
        'civilization': 'Song Çin',
        'description': 'Şan Shui (dağ-su) manzara resminin klasik örneği. Doğa ile insan uyumunu yansıtır.',
        'time_of_day': 'MS 1072',
        'season': 'Tuval üzerine mürekkep, Taipei Saray Müzesi',
      },
      
      // Maya-Aztek Sanatı
      {
        'scene_type': 'art',
        'id': 'art_20',
        'title': 'Pakal\'ın Lahit Kapağı',
        'activities': 'Maya Sanatçıları',
        'civilization': 'Maya',
        'description': 'Kral Pakal\'ın mezar taşı. Yaşam ağacı ve kozmos betimlemesiyle Maya kozmolojisini gösterir.',
        'time_of_day': 'MS 683',
        'season': 'Oymalı taş, Palenque',
      },
      {
        'scene_type': 'art',
        'id': 'art_21',
        'title': 'Aztek Güneş Taşı',
        'activities': 'Aztek Taş İşçileri',
        'civilization': 'Aztek',
        'description': 'Aztek takvimi ve kozmolojisini gösteren dev dairesel taş. 24 ton ağırlığında.',
        'time_of_day': 'MS 1427',
        'season': 'Bazalt, Ulusal Antropoloji Müzesi, Mexico City',
      },
      
      // İslam Sanatı
      {
        'scene_type': 'art',
        'id': 'art_22',
        'title': 'Süleymaniye Camii Çinileri',
        'activities': 'İznik Çini Ustaları',
        'civilization': 'Osmanlı',
        'description': 'Mimar Sinan\'ın başyapıtındaki İznik çinileri. Geometrik ve bitkisel motiflerle süslü.',
        'time_of_day': 'MS 1550-1557',
        'season': 'Çini, Süleymaniye Camii, İstanbul',
      },
      {
        'scene_type': 'art',
        'id': 'art_23',
        'title': 'Şah Abbas Minyatürü',
        'activities': 'Reza Abbasi',
        'civilization': 'Safevi İran',
        'description': 'Safevi döneminin en büyük minyatür sanatçısının eseri. İnce çizgiler ve canlı renkler.',
        'time_of_day': 'MS 1627',
        'season': 'Minyatür, çeşitli koleksiyonlar',
      },
      
      // Japon Sanatı
      {
        'scene_type': 'art',
        'id': 'art_24',
        'title': 'Kanagawa\'da Büyük Dalga',
        'activities': 'Katsushika Hokusai',
        'civilization': 'Edo Japonya',
        'description': 'Dev dalganın arkasında Fuji Dağı\'nı gösteren ikonik ukiyo-e baskısı. Japon sanatının en tanınmış eseri.',
        'time_of_day': 'MS 1831',
        'season': 'Tahta baskı, çeşitli müzeler',
      },
      {
        'scene_type': 'art',
        'id': 'art_25',
        'title': 'Heian Emaki Parşömenleri',
        'activities': 'Heian Saray Ressamları',
        'civilization': 'Heian Japonya',
        'description': 'Genji Monogatari\'nin resimleri. Aristokrat yaşamını ve duygularını betimleyen resimlı el yazmaları.',
        'time_of_day': 'MS 12. yy',
        'season': 'Parşömen üzerine mürekkep, Tokugawa Müzesi',
      },
    ];

    for (final art in artPieces) {
      await db.insert('daily_life_scenes', {
        ...art,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
