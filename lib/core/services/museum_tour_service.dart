import '../database/app_database.dart';

class Museum {
  final String id;
  final String name;
  final String location;
  final String country;
  final String description;
  final String? specialCollection;
  final String? yearFounded;
  final String? famousExhibits;
  final String? imageUrl;

  Museum({
    required this.id,
    required this.name,
    required this.location,
    required this.country,
    required this.description,
    this.specialCollection,
    this.yearFounded,
    this.famousExhibits,
    this.imageUrl,
  });

  factory Museum.fromMap(Map<String, dynamic> map) {
    return Museum(
      id: map['id'],
      name: map['title'] ?? '',
      location: map['season'] ?? '',
      country: map['civilization'] ?? '',
      description: map['description'] ?? '',
      specialCollection: map['activities'],
      yearFounded: map['time_of_day'],
      famousExhibits: null,
      imageUrl: map['image_url'],
    );
  }
}

class MuseumTourService {
  Future<List<Museum>> getAllMuseums() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['museum']);
    if (existing.isEmpty) {
      await insertSampleMuseums();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['museum'], orderBy: 'civilization ASC');
    return results.map((map) => Museum.fromMap(map)).toList();
  }

  Future<void> insertSampleMuseums() async {
    final db = await AppDatabase().database;
    
    final museums = [
      {
        'scene_type': 'museum',
        'id': 'museum_1',
        'title': 'British Museum',
        'season': 'Londra',
        'civilization': 'İngiltere',
        'description': 'Dünyanın en büyük ve en kapsamlı müzelerinden biri. 8 milyon eserlik koleksiyonu ile insan kültür tarihini sergiler.',
        'activities': 'Antik Mısır, Yunan, Roma, Mezopotamya eserleri',
        'time_of_day': '1753',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_2',
        'title': 'Louvre Müzesi',
        'season': 'Paris',
        'civilization': 'Fransa',
        'description': 'Dünyanın en çok ziyaret edilen müzesi. Eski kraliyet sarayında 380.000\'den fazla eser ve 35.000 sanat eseri sergilenir.',
        'activities': 'Mona Lisa, Venüs de Milo, Hammurabi Kanunları',
        'time_of_day': '1793',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_3',
        'title': 'Mısır Müzesi (Kahire)',
        'civilization': 'Mısır',
        'season': 'Kahire',
        'description': 'Antik Mısır eserlerinin en büyük koleksiyonu. 120.000\'den fazla eser, Tutankhamun\'un hazinelerini içerir.',
        'activities': 'Tutankhamun altın maskesi, firavun mumyaları',
        'time_of_day': '1902',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_4',
        'title': 'Vatikan Müzeleri',
        'civilization': 'Vatikan',
        'season': 'Vatikan Şehri',
        'description': 'Papa\'nın koleksiyonu. Sistine Şapeli ve Michelangelo\'nun freskleri dahil muhteşem Rönesans sanatı.',
        'activities': 'Sistine Şapeli, Laokoön Grubu, Rafaello Odaları',
        'time_of_day': '1506',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_5',
        'title': 'Metropolitan Sanat Müzesi',
        'civilization': 'ABD',
        'season': 'New York',
        'description': 'Amerika\'nın en büyük sanat müzesi. 5000 yıllık dünya sanatından 2 milyon eser barındırır.',
        'activities': 'Mısır Tapınağı, Avrupa resimleri, silah-zırh koleksiyonu',
        'time_of_day': '1870',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_6',
        'title': 'Akropolis Müzesi',
        'civilization': 'Yunanistan',
        'season': 'Atina',
        'description': 'Akropolis tepesinden çıkan buluntuları sergiler. Parthenon heykel ve frizlerinin en kapsamlı koleksiyonu.',
        'activities': 'Parthenon frizleri, Karyatidler, arkaik heykeller',
        'time_of_day': '2009',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_7',
        'title': 'Hermitage Müzesi',
        'civilization': 'Rusya',
        'season': 'St. Petersburg',
        'description': 'Rusya\'nın en büyük müzesi. Kış Sarayı\'nda 3 milyon eserlik koleksiyonuyla dünya\'nın en büyük müzelerinden.',
        'activities': 'Rembrandt, Leonardo da Vinci, İtalyan Rönesans eserleri',
        'time_of_day': '1764',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_8',
        'title': 'Ulusal Antropoloji Müzesi',
        'civilization': 'Meksika',
        'season': 'Mexico City',
        'description': 'Kolomb öncesi Mezoamerika medeniyetlerinin en büyük koleksiyonu. Maya, Aztek, Olmek eserleri.',
        'activities': 'Aztek Güneş Taşı, Pakal Lahdi, Maya yazıtları',
        'time_of_day': '1964',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_9',
        'title': 'Pergamon Müzesi',
        'civilization': 'Almanya',
        'season': 'Berlin',
        'description': 'Antik mimari yapıların sergilendiği benzersiz müze. İştar Kapısı ve Pergamon Sunağı gibi anıtsal eserler.',
        'activities': 'İştar Kapısı, Pergamon Sunağı, Babil Süreç Yolu',
        'time_of_day': '1930',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_10',
        'title': 'Topkapı Sarayı Müzesi',
        'civilization': 'Türkiye',
        'season': 'İstanbul',
        'description': 'Osmanlı padişahlarının yaşadığı saray. Kutsal emanetler, sultan hazinesi ve görkemli saray koleksiyonu.',
        'activities': 'Kaşıkçı Elması, Hz. Muhammed\'in kılıcı, İmparatorluk hazinesi',
        'time_of_day': '1924',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_11',
        'title': 'Ulusal Arkeoloji Müzesi',
        'civilization': 'Yunanistan',
        'season': 'Atina',
        'description': 'Yunanistan\'ın en büyük arkeoloji müzesi. Prehistorik çağlardan Roma dönemine kadar Yunan eserleri.',
        'activities': 'Agamemnon\'un Maskesi, Poseidon Bronz Heykeli, Antikythera Mekanizması',
        'time_of_day': '1829',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_12',
        'title': 'Uffizi Galerisi',
        'civilization': 'İtalya',
        'season': 'Floransa',
        'description': 'Rönesans sanatının kalbi. Botticelli, Michelangelo, Leonardo da Vinci\'nin başyapıtları.',
        'activities': 'Venüs\'ün Doğuşu, İlkbahar, Kutsal Aile',
        'time_of_day': '1581',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_13',
        'title': 'Sadberk Hanım Müzesi',
        'civilization': 'Türkiye',
        'season': 'İstanbul',
        'description': 'Türkiye\'nin ilk özel müzesi. Anadolu medeniyetlerinden Osmanlı\'ya çeşitli eserler.',
        'activities': 'Anadolu arkeolojisi, Osmanlı kıyafetleri ve takıları',
        'time_of_day': '1980',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_14',
        'title': 'Ulusal Saray Müzesi (Taipei)',
        'civilization': 'Tayvan',
        'season': 'Taipei',
        'description': 'Çin imparatorluk hazinesinin en kapsamlı koleksiyonu. 8000 yıllık Çin sanatı ve tarihi.',
        'activities': 'Jade lahana, Çin porselen, kaligrafi',
        'time_of_day': '1925',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_15',
        'title': 'Tokyo Ulusal Müzesi',
        'civilization': 'Japonya',
        'season': 'Tokyo',
        'description': 'Asya\'nın en büyük müzesi. Japon ve Doğu Asya sanatının en kapsamlı koleksiyonu.',
        'activities': 'Samuray zırhları, ukiyo-e baskılar, Budist heykeller',
        'time_of_day': '1872',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_16',
        'title': 'Prado Müzesi',
        'civilization': 'İspanya',
        'season': 'Madrid',
        'description': 'İspanyol kraliyet koleksiyonu. Velázquez, Goya, El Greco\'nun başyapıtları.',
        'activities': 'Las Meninas, Goya\'nın Karanlık Resimleri',
        'time_of_day': '1819',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_17',
        'title': 'Anadolu Medeniyetleri Müzesi',
        'civilization': 'Türkiye',
        'season': 'Ankara',
        'description': 'Avrupa\'nın Yılın Müzesi (1997). Anadolu\'nun Paleolitik çağdan Roma dönemine tarih',
        'activities': 'Hitit güneş kursu, Çatalhöyük buluntuları, Frigyalı altın eserler',
        'time_of_day': '1921',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_18',
        'title': 'Rijksmuseum',
        'civilization': 'Hollanda',
        'season': 'Amsterdam',
        'description': 'Hollanda ulusal müzesi. Hollanda Altın Çağı sanatı ve tarihi.',
        'activities': 'Rembrandt\'ın Gece Nöbeti, Vermeer\'in Sütçü Kız',
        'time_of_day': '1800',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_19',
        'title': 'Zeugma Mozaik Müzesi',
        'civilization': 'Türkiye',
        'season': 'Gaziantep',
        'description': 'Dünyanın en büyük mozaik müzesi. Roma döneminden muhteşem zemin mozaikleri.',
        'activities': 'Çingene Kızı mozaiği, Poseidon mozaiği',
        'time_of_day': '2011',
      },
      {
        'scene_type': 'museum',
        'id': 'museum_20',
        'title': 'Ulusal Irak Müzesi',
        'civilization': 'Irak',
        'season': 'Bağdat',
        'description': 'Mezopotamya medeniyetlerinin koleksiyonu. Sümer, Babil, Asur eserlerinin ana merkezi.',
        'activities': 'Ur hazineleri, Asur kabartmaları, çivi yazılı tabletler',
        'time_of_day': '1926',
      },
    ];

    for (final museum in museums) {
      await db.insert('daily_life_scenes', {
        ...museum,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
