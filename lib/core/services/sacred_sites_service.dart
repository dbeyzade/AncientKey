import '../database/app_database.dart';

class SacredSite {
  final String id;
  final String name;
  final String religion;
  final String location;
  final double? latitude;
  final double? longitude;
  final int? builtYear;
  final String? significance;
  final String? rituals;
  final String? architectureStyle;
  final String? imageUrl;

  SacredSite({
    required this.id,
    required this.name,
    required this.religion,
    required this.location,
    this.latitude,
    this.longitude,
    this.builtYear,
    this.significance,
    this.rituals,
    this.architectureStyle,
    this.imageUrl,
  });

  factory SacredSite.fromMap(Map<String, dynamic> map) {
    return SacredSite(
      id: map['id'],
      name: map['name'],
      religion: map['religion'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      builtYear: map['built_year'],
      significance: map['significance'],
      rituals: map['rituals'],
      architectureStyle: map['architecture_style'],
      imageUrl: map['image_url'],
    );
  }
}

class SacredSitesService {
  Future<List<SacredSite>> getAllSites() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('sacred_sites');
    if (existing.isEmpty) {
      await insertSampleSites();
    }
    
    final results = await db.query('sacred_sites', orderBy: 'name ASC');
    return results.map((map) => SacredSite.fromMap(map)).toList();
  }

  Future<List<SacredSite>> getSitesByReligion(String religion) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'sacred_sites',
      where: 'religion = ?',
      whereArgs: [religion],
      orderBy: 'name ASC',
    );
    return results.map((map) => SacredSite.fromMap(map)).toList();
  }

  Future<void> insertSampleSites() async {
    final db = await AppDatabase().database;
    
    final sites = [
      {'name': 'Ayasofya', 'religion': 'Hristiyanlık/İslam', 'location': 'İstanbul, Türkiye', 'latitude': 41.0086, 'longitude': 28.9802, 'built_year': 537, 'significance': 'Bizans İmparatorluğu\'nun en önemli kilisesi, sonradan camiye çevrildi', 'rituals': 'Hristiyan ayinleri, İslami ibadet', 'architecture_style': 'Bizans Mimarisi'},
      {'name': 'Kaaba', 'religion': 'İslam', 'location': 'Mekke, Suudi Arabistan', 'latitude': 21.4225, 'longitude': 39.8262, 'built_year': -2000, 'significance': 'İslam\'ın en kutsal yeri, Müslümanların kıble yönü', 'rituals': 'Hac, Tavaf, Umre', 'architecture_style': 'Küp şeklinde taş yapı'},
      {'name': 'Mescid-i Nebevi', 'religion': 'İslam', 'location': 'Medine, Suudi Arabistan', 'latitude': 24.4672, 'longitude': 39.6111, 'built_year': 622, 'significance': 'Hz. Muhammed\'in türbesinin bulunduğu kutsal mescit', 'rituals': 'Namaz, Ziyaret', 'architecture_style': 'İslami Mimari'},
      {'name': 'Süleymaniye Camii', 'religion': 'İslam', 'location': 'İstanbul, Türkiye', 'latitude': 41.0166, 'longitude': 28.9644, 'built_year': 1557, 'significance': 'Mimar Sinan\'ın şaheseri, Osmanlı\'nın en büyük camisi', 'rituals': 'Cuma namazı, günlük ibadet', 'architecture_style': 'Osmanlı Klasik Mimarisi'},
      {'name': 'El-Aksa Mescidi', 'religion': 'İslam', 'location': 'Kudüs, Filistin', 'latitude': 31.7756, 'longitude': 35.2353, 'built_year': 705, 'significance': 'İslam\'ın üçüncü kutsal mescidi', 'rituals': 'Namaz, Cuma hutbesi', 'architecture_style': 'Emevi Mimarisi'},
      
      {'name': 'Parthenon', 'religion': 'Yunan Politeizmi', 'location': 'Atina, Yunanistan', 'latitude': 37.9715, 'longitude': 23.7265, 'built_year': -438, 'significance': 'Tanrıça Athena\'ya adanmış en önemli antik tapınak', 'rituals': 'Panathenaia festivali, kurban törenleri', 'architecture_style': 'Doruk Düzeni'},
      {'name': 'Delfi Tapınağı', 'religion': 'Yunan Politeizmi', 'location': 'Delfi, Yunanistan', 'latitude': 38.4824, 'longitude': 22.5009, 'built_year': -800, 'significance': 'Apollo\'nun kehanet merkezi, antik dünyanın en önemli kutsal yeri', 'rituals': 'Kehanet danışma, Pythia törenleri', 'architecture_style': 'Yunan Klasik Mimari'},
      {'name': 'Olimpia Zeus Tapınağı', 'religion': 'Yunan Politeizmi', 'location': 'Olimpia, Yunanistan', 'latitude': 37.6379, 'longitude': 21.6300, 'built_year': -456, 'significance': 'Zeus\'a adanmış dev tapınak, Olimpiyat Oyunları\'nın merkezi', 'rituals': 'Olimpiyat Oyunları, kurban törenleri', 'architecture_style': 'Doruk Düzeni'},
      {'name': 'Efes Artemis Tapınağı', 'religion': 'Yunan Politeizmi', 'location': 'Efes, Türkiye', 'latitude': 37.9495, 'longitude': 27.3636, 'built_year': -550, 'significance': 'Antik Dünyanın Yedi Harikası\'ndan biri', 'rituals': 'Artemis festivalleri, kurban sunuları', 'architecture_style': 'İyonik Düzen'},
      
      {'name': 'Vatikan Aziz Petrus Bazilikası', 'religion': 'Hristiyanlık', 'location': 'Vatikan', 'latitude': 41.9022, 'longitude': 12.4539, 'built_year': 1626, 'significance': 'Katolik Kilisesi\'nin merkezi, Papa\'nın makamı', 'rituals': 'Ayin, Paskalya ve Noel törenleri', 'architecture_style': 'Rönesans ve Barok'},
      {'name': 'Notre Dame Katedrali', 'religion': 'Hristiyanlık', 'location': 'Paris, Fransa', 'latitude': 48.8530, 'longitude': 2.3499, 'built_year': 1345, 'significance': 'Gotik mimarinin başyapıtı', 'rituals': 'Ayin, Paskalya kutlamaları', 'architecture_style': 'Gotik Mimari'},
      {'name': 'Betlehem Doğuş Kilisesi', 'religion': 'Hristiyanlık', 'location': 'Betlehem, Filistin', 'latitude': 31.7044, 'longitude': 35.2073, 'built_year': 339, 'significance': 'İsa\'nın doğduğu yerin üzerine inşa edildi', 'rituals': 'Noel törenleri, hac ziyaretleri', 'architecture_style': 'Bizans Mimarisi'},
      {'name': 'Ortodoks Kutsal Kabir Kilisesi', 'religion': 'Hristiyanlık', 'location': 'Kudüs, İsrail', 'latitude': 31.7784, 'longitude': 35.2296, 'built_year': 335, 'significance': 'İsa\'nın çarmıha gerildiği ve gömüldüğü yer', 'rituals': 'Paskalya törenleri, hac ziyaretleri', 'architecture_style': 'Bizans ve Haçlı Mimarisi'},
      {'name': 'Canterbury Katedrali', 'religion': 'Hristiyanlık', 'location': 'Canterbury, İngiltere', 'latitude': 51.2799, 'longitude': 1.0832, 'built_year': 1077, 'significance': 'İngiltere Kilisesi\'nin merkezi', 'rituals': 'Anglikan ayinleri', 'architecture_style': 'Gotik ve Romanesk'},
      
      {'name': 'Mısır Karnak Tapınağı', 'religion': 'Antik Mısır', 'location': 'Luksor, Mısır', 'latitude': 25.7188, 'longitude': 32.6573, 'built_year': -2000, 'significance': 'Tanrı Amun-Ra\'ya adanmış dev tapınak kompleksi', 'rituals': 'Opet festivali, günlük tapınma törenleri', 'architecture_style': 'Mısır Tapınak Mimarisi'},
      {'name': 'Luksor Tapınağı', 'religion': 'Antik Mısır', 'location': 'Luksor, Mısır', 'latitude': 25.6992, 'longitude': 32.6392, 'built_year': -1400, 'significance': 'Firavonların taç giyme törenleri', 'rituals': 'Opet festivali, kraliyet törenleri', 'architecture_style': 'Yeni Krallık Mimarisi'},
      {'name': 'Abu Simbel Tapınakları', 'religion': 'Antik Mısır', 'location': 'Aswan, Mısır', 'latitude': 22.3372, 'longitude': 31.6258, 'built_year': -1264, 'significance': 'Ramses II\'nin dev tapınakları', 'rituals': 'Güneş festivali, kraliyet törenleri', 'architecture_style': 'Kaya oyma mimari'},
      {'name': 'Philae İsis Tapınağı', 'religion': 'Antik Mısır', 'location': 'Aswan, Mısır', 'latitude': 24.0258, 'longitude': 32.8846, 'built_year': -380, 'significance': 'Tanrıça İsis\'e adanmış tapınak', 'rituals': 'İsis kültü törenleri', 'architecture_style': 'Ptolemaios Mimarisi'},
      
      {'name': 'Kudüs Tapınağı (Ağlama Duvarı)', 'religion': 'Yahudilik', 'location': 'Kudüs, İsrail', 'latitude': 31.7767, 'longitude': 35.2345, 'built_year': -516, 'significance': 'İkinci Tapınağın kalıntısı, Yahudiliğin en kutsal yeri', 'rituals': 'Dua, Bar Mitzvah', 'architecture_style': 'Antik İsrail Mimarisi'},
      {'name': 'Davut Kulesi', 'religion': 'Yahudilik', 'location': 'Kudüs, İsrail', 'latitude': 31.7763, 'longitude': 35.2284, 'built_year': -1000, 'significance': 'Kral Davut\'un kalesi', 'rituals': 'Tarihi anma törenleri', 'architecture_style': 'Antik İsrail'},
      
      {'name': 'Angkor Wat', 'religion': 'Hinduizm/Budizm', 'location': 'Siem Reap, Kamboçya', 'latitude': 13.4125, 'longitude': 103.8670, 'built_year': 1150, 'significance': 'Dünyanın en büyük dini kompleksi', 'rituals': 'Hindu ve Budist törenleri', 'architecture_style': 'Khmer Mimarisi'},
      {'name': 'Borobudur', 'religion': 'Budizm', 'location': 'Java, Endonezya', 'latitude': -7.6079, 'longitude': 110.2038, 'built_year': 825, 'significance': 'Dünyanın en büyük Budist tapınağı', 'rituals': 'Vesak festivali,順時針 tavaf', 'architecture_style': 'Mahayana Budist Mimari'},
      {'name': 'Shwedagon Pagodası', 'religion': 'Budizm', 'location': 'Yangon, Myanmar', 'latitude': 16.7982, 'longitude': 96.1498, 'built_year': 600, 'significance': 'Buda\'nın saç tellerini içeren altın pagoda', 'rituals': 'Hac ziyareti, meditasyon', 'architecture_style': 'Myanmar Budist Mimarisi'},
      
      {'name': 'Varanasi Ganj Nehri', 'religion': 'Hinduizm', 'location': 'Varanasi, Hindistan', 'latitude': 25.3176, 'longitude': 83.0055, 'built_year': -1000, 'significance': 'Hindistan\'ın en kutsal nehri ve şehri', 'rituals': 'Ganga\'da yıkanma, kremasyon törenleri', 'architecture_style': 'Ghat mimarisi'},
      {'name': 'Tirumala Venkateswara Tapınağı', 'religion': 'Hinduizm', 'location': 'Andhra Pradesh, Hindistan', 'latitude': 13.6833, 'longitude': 79.3472, 'built_year': 300, 'significance': 'Dünyanın en çok ziyaret edilen dini merkezi', 'rituals': 'Darshan, prasadam dağıtımı', 'architecture_style': 'Dravidian Mimari'},
      {'name': 'Meenakshi Tapınağı', 'religion': 'Hinduizm', 'location': 'Madurai, Hindistan', 'latitude': 9.9195, 'longitude': 78.1193, 'built_year': 1623, 'significance': 'Tanrıça Meenakshi\'ye adanmış renkli tapınak', 'rituals': 'Günlük puja, festivaller', 'architecture_style': 'Dravidian Mimari'},
      {'name': 'Altın Tapınak (Harmandir Sahib)', 'religion': 'Sihizm', 'location': 'Amritsar, Hindistan', 'latitude': 31.6200, 'longitude': 74.8765, 'built_year': 1604, 'significance': 'Sihlerin en kutsal tapınağı', 'rituals': 'Ardas, langar (topluluk yemeği)', 'architecture_style': 'Sih Mimarisi'},
      
      {'name': 'Todai-ji Tapınağı', 'religion': 'Budizm', 'location': 'Nara, Japonya', 'latitude': 34.6890, 'longitude': 135.8398, 'built_year': 752, 'significance': 'Dev Buda heykeline ev sahipliği yapan tapınak', 'rituals': 'Omizutori festivali', 'architecture_style': 'Japon Budist Mimarisi'},
      {'name': 'Ise Jingu', 'religion': 'Şintoizm', 'location': 'Ise, Japonya', 'latitude': 34.4551, 'longitude': 136.7257, 'built_year': -4, 'significance': 'Şinto\'nun en kutsal tapınağı, her 20 yılda yeniden inşa edilir', 'rituals': 'Kagura dansı, yenileme törenleri', 'architecture_style': 'Geleneksel Japon'},
      {'name': 'Fushimi Inari Tapınağı', 'religion': 'Şintoizm', 'location': 'Kyoto, Japonya', 'latitude': 34.9671, 'longitude': 135.7727, 'built_year': 711, 'significance': 'Binlerce kırmızı tori kapısıyla ünlü', 'rituals': 'Hatsumode (yılbaşı ziyareti)', 'architecture_style': 'Şinto Mimarisi'},
    ];

    for (int i = 0; i < sites.length; i++) {
      final site = sites[i];
      await db.insert('sacred_sites', {
        'id': 'site_${i + 1}',
        ...site,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
