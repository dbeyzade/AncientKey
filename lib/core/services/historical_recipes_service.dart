import '../database/app_database.dart';

class HistoricalRecipe {
  final String id;
  final String name;
  final String civilization;
  final String period;
  final String description;
  final String? ingredients;
  final String? preparation;
  final String? culturalSignificance;
  final String? imageUrl;

  HistoricalRecipe({
    required this.id,
    required this.name,
    required this.civilization,
    required this.period,
    required this.description,
    this.ingredients,
    this.preparation,
    this.culturalSignificance,
    this.imageUrl,
  });

  factory HistoricalRecipe.fromMap(Map<String, dynamic> map) {
    return HistoricalRecipe(
      id: map['id'],
      name: map['title'] ?? '',
      civilization: map['civilization'] ?? 'Bilinmeyen',
      period: map['time_of_day'] ?? '',
      description: map['description'] ?? '',
      ingredients: map['activities'],
      preparation: map['season'],
      culturalSignificance: null,
      imageUrl: map['image_url'],
    );
  }
}

class HistoricalRecipesService {
  Future<List<HistoricalRecipe>> getAllRecipes() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['recipe']);
    if (existing.isEmpty) {
      await insertSampleRecipes();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['recipe'], orderBy: 'civilization ASC');
    return results.map((map) => HistoricalRecipe.fromMap(map)).toList();
  }

  Future<void> insertSampleRecipes() async {
    final db = await AppDatabase().database;
    
    final recipes = [
      // Antik Yunan
      {
        'scene_type': 'recipe',
        'id': 'recipe_1',
        'title': 'Moretum (Yunan Peynir Ezmesi)',
        'civilization': 'Antik Yunan',
        'description': 'Sarımsak, zeytinyağı, tuz ve peynirle yapılan antik Yunan mezesi. Ekmekle birlikte servis edilir.',
        'activities': 'Feta peyniri, sarımsak, zeytinyağı, tuz, kekik',
        'time_of_day': 'MÖ 500',
        'season': 'Havanda ezilerek karıştırılır, ekmekle servis edilir',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_2',
        'title': 'Melomeli (Ballı Şarap)',
        'civilization': 'Antik Yunan',
        'description': 'Bal ve şaraptan yapılan tatlı içecek. Tanrılara sunulur, özel törenlerde içilir.',
        'activities': 'Kırmızı şarap, bal, su',
        'time_of_day': 'MÖ 800-300',
        'season': 'Şarap ve bal karıştırılıp suyla seyreltilir',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_3',
        'title': 'Kykeon',
        'civilization': 'Antik Yunan',
        'description': 'Eleusinian gizemleri törenlerinde içilen kutsal içecek. Arpa, su, naneden yapılır.',
        'activities': 'Öğütülmüş arpa, su, nane',
        'time_of_day': 'MÖ 1500-400',
        'season': 'Karıştırılarak içilir, tören içeceği',
      },
      
      // Antik Roma
      {
        'scene_type': 'recipe',
        'id': 'recipe_4',
        'title': 'Garum (Balık Sosu)',
        'civilization': 'Antik Roma',
        'description': 'Fermente balık sosundan yapılan Roma\'nın en popüler lezzet artırıcısı. Her yemeğe eklenir.',
        'activities': 'Balık (hamsi, uskumru), tuz',
        'time_of_day': 'MÖ 100-MS 400',
        'season': 'Balık ve tuz güneşte aylarca fermente edilir',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_5',
        'title': 'Posca (Sirke İçeceği)',
        'civilization': 'Antik Roma',
        'description': 'Roma askerlerinin ve işçilerinin günlük içeceği. Ucuz, serinletici ve hijyenik.',
        'activities': 'Sirke, su, bazen bal veya baharat',
        'time_of_day': 'MÖ 300-MS 400',
        'season': 'Sirke suyla seyreltilir, soğuk içilir',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_6',
        'title': 'Libum (Cheesecake)',
        'civilization': 'Antik Roma',
        'description': 'Tanrılara sunulan peynirli tatlı. Roma\'nın en eski tatlılarından biri.',
        'activities': 'Ricotta peyniri, un, yumurta, bal, defne yaprağı',
        'time_of_day': 'MÖ 200',
        'season': 'Karıştırılıp defne yaprağı üzerinde pişirilir',
      },
      
      // Antik Mısır
      {
        'scene_type': 'recipe',
        'id': 'recipe_7',
        'title': 'Mısır Ekmeği',
        'civilization': 'Antik Mısır',
        'description': 'Emmer buğdayından yapılan günlük ekmek. Mısır mutfağının temeli.',
        'activities': 'Emmer buğdayı unu, maya, su, tuz',
        'time_of_day': 'MÖ 3000-30',
        'season': 'Hamur yoğrulup koni şeklinde fırında pişirilir',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_8',
        'title': 'Ta (Mısır Birası)',
        'civilization': 'Antik Mısır',
        'description': 'Mısırlıların günlük içeceği. Emmer buğdayından yapılan besleyici bira.',
        'activities': 'Emmer buğdayı, hurma, maya, su',
        'time_of_day': 'MÖ 3000-30',
        'season': 'Ekmek mayalanıp suyla karıştırılır, fermente edilir',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_9',
        'title': 'Hummus',
        'civilization': 'Antik Mısır',
        'description': 'Nohuttan yapılan ezme. Binlerce yıldır Orta Doğu\'nun vazgeçilmezi.',
        'activities': 'Nohut, tahin, sarımsak, limon, zeytinyağı',
        'time_of_day': 'MÖ 1500',
        'season': 'Haşlanan nohut ezilip diğer malzemelerle karıştırılır',
      },
      
      // Mezopotamya
      {
        'scene_type': 'recipe',
        'id': 'recipe_10',
        'title': 'Tuh\'u (Tahıl Lapası)',
        'civilization': 'Sümer',
        'description': 'Sümer mutfağının temel yemeği. Arpa veya buğdaydan yapılan lapa.',
        'activities': 'Arpa, soğan, sarımsak, yağ',
        'time_of_day': 'MÖ 3000',
        'season': 'Tahıl haşlanıp püre yapılır, baharat eklenir',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_11',
        'title': 'Mersu (Babil Çorbası)',
        'civilization': 'Babil',
        'description': 'Zengin et ve sebze çorbası. Babil sofralarının gözdesi.',
        'activities': 'Kuzu eti, soğan, pırasa, sarımsak, nohut, baharatlar',
        'time_of_day': 'MÖ 1700',
        'season': 'Et ve sebzeler uzun süre kaynatılır',
      },
      
      // Viking
      {
        'scene_type': 'recipe',
        'id': 'recipe_12',
        'title': 'Skyr (İzlanda Yoğurdu)',
        'civilization': 'Viking',
        'description': 'Yüksek proteinli Viking süt ürünü. Fermente inek sütünden yapılır.',
        'activities': 'Süt, peynir mayası',
        'time_of_day': 'MS 800-1100',
        'season': 'Süt ısıtılıp maya eklenir, süzülür',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_13',
        'title': 'Mead (Bal Şarabı)',
        'civilization': 'Viking',
        'description': 'Baldan yapılan alkollü içecek. Viking ziyafetlerinin vazgeçilmezi.',
        'activities': 'Bal, su, maya, bazen baharat',
        'time_of_day': 'MS 800-1100',
        'season': 'Bal suyla karıştırılıp fermente edilir',
      },
      
      // Çin
      {
        'scene_type': 'recipe',
        'id': 'recipe_14',
        'title': 'Jiaozi (Mantı)',
        'civilization': 'Han Çin',
        'description': 'Et ve sebze dolgulu hamur. Çin Yeni Yılı\'nın geleneksel yemeği.',
        'activities': 'Hamur, kıyma, lahana, zencefil, soya sosu',
        'time_of_day': 'MÖ 200',
        'season': 'İç malzeme hamura sarılıp haşlanır veya kızartılır',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_15',
        'title': 'Congee (Pirinç Lapası)',
        'civilization': 'Antik Çin',
        'description': 'Sabah kahvaltısının temeli. Besleyici pirinç lapa.',
        'activities': 'Pirinç, su, tuz, isteğe göre et veya sebze',
        'time_of_day': 'MÖ 1000',
        'season': 'Pirinç bol suda uzun süre kaynatılır',
      },
      
      // Japonya
      {
        'scene_type': 'recipe',
        'id': 'recipe_16',
        'title': 'Sushi (Eski Usul)',
        'civilization': 'Nara Dönemi Japonya',
        'description': 'Fermente balık ve pirinç. Modern sushinin atası.',
        'activities': 'Taze balık, pirinç, tuz, sirke',
        'time_of_day': 'MS 718',
        'season': 'Balık tuzlanıp pirinçle fermente edilir',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_17',
        'title': 'Miso Çorbası',
        'civilization': 'Heian Japonya',
        'description': 'Fermente soya fasulyesi pastasından yapılan besleyici çorba.',
        'activities': 'Miso pastası, dashi (balık suyu), tofu, deniz yosunu',
        'time_of_day': 'MS 900',
        'season': 'Dashi ısıtılır, miso eklenir, kaynatılmaz',
      },
      
      // Hint
      {
        'scene_type': 'recipe',
        'id': 'recipe_18',
        'title': 'Dal (Mercimek Çorbası)',
        'civilization': 'Antik Hindistan',
        'description': 'Mercimekten yapılan baharatlı çorba. Hint mutfağının temeli.',
        'activities': 'Mercimek, zerdeçal, kimyon, kişniş, zencefil, sarımsak',
        'time_of_day': 'MÖ 1000',
        'season': 'Mercimek baharatlarla haşlanır, tadına yağ gezdirilir',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_19',
        'title': 'Kheer (Sütlü Pirinç Tatlısı)',
        'civilization': 'Vedik Hindistan',
        'description': 'Törenlerde sunulan kutsal tatlı. Süt, pirinç ve şekerden yapılır.',
        'activities': 'Pirinç, süt, şeker, kakule, safran, kuru yemiş',
        'time_of_day': 'MÖ 1500',
        'season': 'Pirinç sütte pişirilir, şeker ve baharat eklenir',
      },
      
      // Maya-Aztek
      {
        'scene_type': 'recipe',
        'id': 'recipe_20',
        'title': 'Xocolatl (Aztek Kakaosu)',
        'civilization': 'Aztek',
        'description': 'Acı ve baharatlı kakao içeceği. Soyluların ve savaşçıların içeceği.',
        'activities': 'Kakao, acı biber, vanilya, mısır',
        'time_of_day': 'MS 1400',
        'season': 'Kakao köpürtülür, baharat eklenir, soğuk içilir',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_21',
        'title': 'Tamales',
        'civilization': 'Maya',
        'description': 'Mısır hamuru ve et dolması. Muz yaprağına sarılıp pişirilir.',
        'activities': 'Mısır hamuru, et, fasulye, biber, muz yaprağı',
        'time_of_day': 'MS 1000',
        'season': 'İç malzeme hamura sarılır, yaprağa sarılıp buharda pişirilir',
      },
      
      // Pers
      {
        'scene_type': 'recipe',
        'id': 'recipe_22',
        'title': 'Polo (Pers Pilavı)',
        'civilization': 'Pers İmparatorluğu',
        'description': 'Safranla tatlandırılmış pirinç. Pers mutfağının kralı.',
        'activities': 'Basmati pirinci, safran, tereyağı, tuz',
        'time_of_day': 'MÖ 500',
        'season': 'Pirinç özel teknikle pişirilir, altında çıtır tabaka oluşur',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_23',
        'title': 'Fesenjan (Nar Ekşili Tavuk)',
        'civilization': 'Pers İmparatorluğu',
        'description': 'Ceviz ve nar ekşili zengin et yemeği. Şah sofrasının baş tacı.',
        'activities': 'Tavuk, ceviz, nar ekşisi, soğan, baharat',
        'time_of_day': 'MÖ 400',
        'season': 'Ceviz ezilir, et ve nar ekşisiyle uzun süre pişirilir',
      },
      
      // Osmanlı
      {
        'scene_type': 'recipe',
        'id': 'recipe_24',
        'title': 'İmam Bayıldı',
        'civilization': 'Osmanlı',
        'description': 'Zeytinyağlı patlıcan dolması. Osmanlı saray mutfağından.',
        'activities': 'Patlıcan, soğan, domates, sarımsak, zeytinyağı',
        'time_of_day': 'MS 1600',
        'season': 'Patlıcan soğanla doldurulur, zeytinyağında pişirilir',
      },
      {
        'scene_type': 'recipe',
        'id': 'recipe_25',
        'title': 'Baklava',
        'civilization': 'Osmanlı',
        'description': 'Fıstık ve cevizli kat kat hamur tatlısı. Padişahların tatlısı.',
        'activities': 'Yufka, fıstık, ceviz, tereyağı, şerbet',
        'time_of_day': 'MS 1500',
        'season': 'Yufka katlar arasına fındık konur, pişirilir, şerbete batırılır',
      },
    ];

    for (final recipe in recipes) {
      await db.insert('daily_life_scenes', {
        ...recipe,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
