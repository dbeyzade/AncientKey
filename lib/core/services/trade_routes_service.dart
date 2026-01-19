import '../database/app_database.dart';

class TradeRoute {
  final String id;
  final String name;
  final String civilization;
  final String description;
  final String? goods;
  final String? distance;
  final String? duration;
  final String? imageUrl;

  TradeRoute({
    required this.id,
    required this.name,
    required this.civilization,
    required this.description,
    this.goods,
    this.distance,
    this.duration,
    this.imageUrl,
  });

  factory TradeRoute.fromMap(Map<String, dynamic> map) {
    return TradeRoute(
      id: map['id'],
      name: map['title'] ?? '',
      civilization: map['civilization'] ?? 'Bilinmeyen',
      description: map['description'] ?? '',
      goods: map['activities'],
      distance: map['time_of_day'],
      duration: map['season'],
      imageUrl: map['image_url'],
    );
  }
}

class TradeRoutesService {
  Future<List<TradeRoute>> getAllRoutes() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['trade_route']);
    if (existing.isEmpty) {
      await insertSampleRoutes();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['trade_route'], orderBy: 'title ASC');
    return results.map((map) => TradeRoute.fromMap(map)).toList();
  }

  Future<void> insertSampleRoutes() async {
    final db = await AppDatabase().database;
    
    final routes = [
      {
        'id': 'route_1',
        'scene_type': 'trade_route',
        'title': 'İpek Yolu',
        'civilization': 'Çin - Akdeniz',
        'description': 'Çin\'den Akdeniz\'e uzanan efsanevi ticaret yolu. İpek, baharat, porselen ve fikirler taşıdı.',
        'activities': 'İpek, baharat, cam, altın, değerli taşlar',
        'time_of_day': '6,400 km',
        'season': 'Kervanla 6-12 ay',
      },
      {
        'id': 'route_2',
        'scene_type': 'trade_route',
        'title': 'Baharat Yolu',
        'civilization': 'Hindistan - Arap',
        'description': 'Hindistan baharatlarını Ortadoğu ve Avrupa\'ya taşıyan deniz yolu.',
        'activities': 'Karabiber, tarçın, kakule, muskat, zencefil',
        'time_of_day': '3,500 km deniz yolu',
        'season': '3-6 ay (muson rüzgarları)',
      },
      {
        'id': 'route_3',
        'scene_type': 'trade_route',
        'title': 'Tuz Yolu',
        'civilization': 'Sahra',
        'description': 'Sahra Çölü boyunca tuz ve altın ticareti yapan deve kervanları yolu.',
        'activities': 'Tuz, altın, fildişi, köleler',
        'time_of_day': '2,000 km',
        'season': 'Deve kervanı ile 3-4 ay',
      },
      {
        'id': 'route_4',
        'scene_type': 'trade_route',
        'title': 'Kehribar Yolu',
        'civilization': 'Baltık - Akdeniz',
        'description': 'Baltık kehribarını güneye taşıyan kuzey-güney ticaret yolu.',
        'activities': 'Kehribar, kürk, bal, balmumu',
        'time_of_day': '2,500 km',
        'season': 'Kara yolu ile 4-5 ay',
      },
      {
        'id': 'route_5',
        'scene_type': 'trade_route',
        'title': 'Kral Yolu',
        'civilization': 'Pers İmparatorluğu',
        'description': 'Sardes\'ten Susa\'ya uzanan Pers İmparatorluğu\'nun ana yolu. Dünyanın ilk posta sistemi.',
        'activities': 'Haberler, vergiler, lüks mallar, askerler',
        'time_of_day': '2,699 km',
        'season': 'Atlı koşucularla 7 gün',
      },
      {
        'id': 'route_6',
        'scene_type': 'trade_route',
        'title': 'Tütsü Yolu',
        'civilization': 'Güney Arabistan',
        'description': 'Yemen\'den Akdeniz\'e tütsü ve mür taşıyan kervan yolu.',
        'activities': 'Tütsü, mür, baharat, değerli taşlar',
        'time_of_day': '2,400 km',
        'season': 'Deve kervanı ile 3 ay',
      },
      {
        'id': 'route_7',
        'scene_type': 'trade_route',
        'title': 'Via Appia (Appian Yolu)',
        'civilization': 'Antik Roma',
        'description': 'Roma\'dan Brindisi\'ye uzanan taş döşeli yol. "Yolların Kraliçesi".',
        'activities': 'Her türlü ticaret malı, asker, haberler',
        'time_of_day': '540 km',
        'season': 'Yürüyüşle 2 hafta',
      },
      {
        'id': 'route_8',
        'scene_type': 'trade_route',
        'title': 'Deniz Halkları Yolu',
        'civilization': 'Fenike',
        'description': 'Akdeniz boyunca Fenike ticaret kolonileri ağı.',
        'activities': 'Cam, mor boya, tekstil, gümüş, tahıl',
        'time_of_day': '4,000 km kıyı şeridi',
        'season': 'Gemiyle 3-6 ay',
      },
      {
        'id': 'route_9',
        'scene_type': 'trade_route',
        'title': 'Nil Nehri Yolu',
        'civilization': 'Antik Mısır',
        'description': 'Mısır\'ın damarı. Akdeniz\'den Nubya\'ya uzanan nehir ticareti.',
        'activities': 'Tahıl, papirüs, altın, granit, keten',
        'time_of_day': '1,200 km',
        'season': 'Nehir gemisiyle 2-3 hafta',
      },
      {
        'id': 'route_10',
        'scene_type': 'trade_route',
        'title': 'Viking Ticaret Yolu',
        'civilization': 'Viking/Norse',
        'description': 'Baltık\'tan Bizans\'a uzanan nehir ve deniz ticareti.',
        'activities': 'Kürk, köle, bal, balmumu, gümüş',
        'time_of_day': '3,000 km',
        'season': 'Longboat ile 2-3 ay',
      },
    ];

    for (final route in routes) {
      await db.insert('daily_life_scenes', {
        ...route,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
