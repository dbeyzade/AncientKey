import '../database/app_database.dart';

class ArchaeologicalLayer {
  final String id;
  final String mapId;
  final String layerName;
  final int depthCm;
  final String? period;
  final String? findings;
  final String? dateEstimated;
  final String? imageUrl;

  ArchaeologicalLayer({
    required this.id,
    required this.mapId,
    required this.layerName,
    required this.depthCm,
    this.period,
    this.findings,
    this.dateEstimated,
    this.imageUrl,
  });

  factory ArchaeologicalLayer.fromMap(Map<String, dynamic> map) {
    return ArchaeologicalLayer(
      id: map['id'],
      mapId: map['map_id'],
      layerName: map['layer_name'],
      depthCm: map['depth_cm'],
      period: map['period'],
      findings: map['findings'],
      dateEstimated: map['date_estimated'],
      imageUrl: map['image_url'],
    );
  }
}

class ArchaeologicalLayersService {
  Future<List<ArchaeologicalLayer>> getAllLayers() async {
    final db = await AppDatabase().database;
    
    // Check if layers exist
    final existing = await db.query('archaeological_layers');
    if (existing.isEmpty) {
      await insertSampleLayers();
    }
    
    final results = await db.query('archaeological_layers', orderBy: 'depth_cm ASC');
    return results.map((map) => ArchaeologicalLayer.fromMap(map)).toList();
  }

  Future<void> insertSampleLayers() async {
    final db = await AppDatabase().database;
    
    final layers = [
      {
        'id': 'layer_1',
        'map_id': 'default',
        'layer_name': 'Modern Toprak Katmanı',
        'depth_cm': 0,
        'period': 'Modern Dönem',
        'findings': 'Günümüz bitki kökleri, modern atıklar',
        'date_estimated': '1900-Günümüz',
      },
      {
        'id': 'layer_2',
        'map_id': 'default',
        'layer_name': 'Osmanlı Dönemi Katmanı',
        'depth_cm': 50,
        'period': 'Osmanlı İmparatorluğu',
        'findings': 'Seramik parçaları, metal objeler, sikke kalıntıları',
        'date_estimated': '1299-1922 MS',
      },
      {
        'id': 'layer_3',
        'map_id': 'default',
        'layer_name': 'Bizans Dönemi Katmanı',
        'depth_cm': 120,
        'period': 'Doğu Roma İmparatorluğu',
        'findings': 'Mozaik parçaları, bronz objeler, dini eşyalar',
        'date_estimated': '330-1453 MS',
      },
      {
        'id': 'layer_4',
        'map_id': 'default',
        'layer_name': 'Roma Dönemi Katmanı',
        'depth_cm': 200,
        'period': 'Roma İmparatorluğu',
        'findings': 'Mermer heykeller, amphora parçaları, Roma sikkeleri',
        'date_estimated': 'MÖ 27 - MS 476',
      },
      {
        'id': 'layer_5',
        'map_id': 'default',
        'layer_name': 'Helenistik Dönem Katmanı',
        'depth_cm': 280,
        'period': 'Helenistik Dönem',
        'findings': 'Yunan seramiği, bronz aletler, yazıtlı taşlar',
        'date_estimated': 'MÖ 323-31',
      },
      {
        'id': 'layer_6',
        'map_id': 'default',
        'layer_name': 'Klasik Yunan Katmanı',
        'depth_cm': 350,
        'period': 'Klasik Yunan',
        'findings': 'Kırmızı ve siyah figürlü vazolar, heykel parçaları',
        'date_estimated': 'MÖ 480-323',
      },
      {
        'id': 'layer_7',
        'map_id': 'default',
        'layer_name': 'Arkaik Dönem Katmanı',
        'depth_cm': 420,
        'period': 'Arkaik Yunan',
        'findings': 'İlkel çanak çömlek, obsidyen aletler',
        'date_estimated': 'MÖ 800-480',
      },
      {
        'id': 'layer_8',
        'map_id': 'default',
        'layer_name': 'Demir Çağı Katmanı',
        'depth_cm': 500,
        'period': 'Demir Çağı',
        'findings': 'Demir aletler, basit seramikler, ocak kalıntıları',
        'date_estimated': 'MÖ 1200-800',
      },
      {
        'id': 'layer_9',
        'map_id': 'default',
        'layer_name': 'Tunç Çağı Katmanı',
        'depth_cm': 600,
        'period': 'Tunç Çağı',
        'findings': 'Bronz silahlar, süs eşyaları, ticaret malları',
        'date_estimated': 'MÖ 3000-1200',
      },
      {
        'id': 'layer_10',
        'map_id': 'default',
        'layer_name': 'Kalkolitik Dönem Katmanı',
        'depth_cm': 700,
        'period': 'Bakır-Taş Çağı',
        'findings': 'Bakır aletler, ilkel çanak çömlek, taş aletler',
        'date_estimated': 'MÖ 5500-3000',
      },
      {
        'id': 'layer_11',
        'map_id': 'default',
        'layer_name': 'Neolitik Dönem Katmanı',
        'depth_cm': 800,
        'period': 'Yontma Taş Çağı (Geç)',
        'findings': 'Obsidyen bıçaklar, cilalı taş baltalar, el yapımı çömlek',
        'date_estimated': 'MÖ 10000-5500',
      },
      {
        'id': 'layer_12',
        'map_id': 'default',
        'layer_name': 'Mezolitik Dönem Katmanı',
        'depth_cm': 900,
        'period': 'Orta Taş Çağı',
        'findings': 'Mikrolitler (küçük taş aletler), hayvan kemikleri',
        'date_estimated': 'MÖ 15000-10000',
      },
      {
        'id': 'layer_13',
        'map_id': 'default',
        'layer_name': 'Paleolitik Dönem Katmanı',
        'depth_cm': 1000,
        'period': 'Eski Taş Çağı',
        'findings': 'Yontma taş aletler, ateş kalıntıları, mamut kemikleri',
        'date_estimated': 'MÖ 2.5 milyon-15000',
      },
      {
        'id': 'layer_14',
        'map_id': 'default',
        'layer_name': 'Temel Kaya Katmanı',
        'depth_cm': 1200,
        'period': 'Jeolojik Dönem',
        'findings': 'Doğal kaya formasyonları, fosiller',
        'date_estimated': 'Milyonlarca yıl önce',
      },
    ];

    for (var layer in layers) {
      await db.insert('archaeological_layers', {
        ...layer,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
