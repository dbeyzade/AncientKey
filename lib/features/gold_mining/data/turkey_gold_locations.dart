import 'package:latlong2/latlong.dart';
import '../models/gold_location.dart';

final List<GoldLocation> turkeyGoldLocations = [
  // Artvin
  GoldLocation(
    name: 'Çoruh Nehri',
    city: 'Artvin',
    type: 'Nehir',
    coordinates: const LatLng(40.9, 41.8),
    potentialLevel: 8,
    description: 'Türkiye\'nin en zengin altın yataklarından biri. Özellikle Borçka ve Yusufeli bölgelerinde yüksek altın potansiyeli.',
    recommendedMethod: 'Pan eldeme ve Sluice Box',
    bestSeason: 'Mayıs - Ekim (Düşük su seviyesi)',
    tips: [
      'Nehir kıvrımlarında ve kayalık alanların arkasında birikinti arayın',
      'Su seviyesi düşük olduğunda daha verimli',
      'Siyah kum (magnetit) ve ağır mineraller altın göstergesidir',
    ],
  ),
  GoldLocation(
    name: 'Madenköprübaşı Deresi',
    city: 'Artvin',
    type: 'Dere',
    coordinates: const LatLng(40.8, 41.7),
    potentialLevel: 7,
    description: 'Tarihi altın madeni bölgesine yakın dere. Placer altın yatakları içerir.',
    recommendedMethod: 'Pan eldeme',
    bestSeason: 'Haziran - Eylül',
    tips: [
      'Dere yatağındaki büyük kayaların arkasını kontrol edin',
      'Kırmızı ve siyah kumlar altın bulunabilir',
    ],
  ),

  // Erzincan
  GoldLocation(
    name: 'Fırat Nehri (Kemaliye)',
    city: 'Erzincan',
    type: 'Nehir',
    coordinates: const LatLng(39.2, 38.5),
    potentialLevel: 7,
    description: 'Kemaliye bölgesinde altın potansiyeli yüksek. Tarihi altın arama faaliyetleri yapılmış.',
    recommendedMethod: 'Pan eldeme ve Metal Dedektör',
    bestSeason: 'Haziran - Ekim',
    tips: [
      'Nehir kıyılarındaki eski terasları inceleyin',
      'Kuartz damarlarının olduğu bölgelere dikkat',
    ],
  ),
  GoldLocation(
    name: 'Karasu Deresi',
    city: 'Erzincan',
    type: 'Dere',
    coordinates: const LatLng(39.7, 38.3),
    potentialLevel: 6,
    description: 'Altın içeren alüvyonlarıyla bilinen dere sistemi.',
    recommendedMethod: 'Sluice Box',
    bestSeason: 'Temmuz - Eylül',
    tips: [
      'Dere yatağındaki çakıl tabakasını inceleyin',
    ],
  ),

  // Gümüşhane
  GoldLocation(
    name: 'Harşit Çayı',
    city: 'Gümüşhane',
    type: 'Çay',
    coordinates: const LatLng(40.5, 39.5),
    potentialLevel: 8,
    description: 'Gümüşhane\'nin en önemli altın potansiyeline sahip akarsuyu. Mastra ve Gümüşhane merkez arasında.',
    recommendedMethod: 'Pan eldeme ve Sluice Box',
    bestSeason: 'Mayıs - Ekim',
    tips: [
      'Çayın kıvrımları ve durgun bölgeleri en verimli alanlardır',
      'Kayalık yapıların arkasındaki çökeltileri kontrol edin',
      'Metal dedektör kullanımı ek avantaj sağlar',
    ],
  ),
  GoldLocation(
    name: 'Zigana Deresi',
    city: 'Gümüşhane',
    type: 'Dere',
    coordinates: const LatLng(40.6, 39.4),
    potentialLevel: 6,
    description: 'Zigana Dağları\'ndan inen altın taşıyan dere.',
    recommendedMethod: 'Pan eldeme',
    bestSeason: 'Haziran - Eylül',
    tips: [
      'Dağlardan gelen sedimentlerde arama yapın',
    ],
  ),

  // Kütahya
  GoldLocation(
    name: 'Alaçam Deresi',
    city: 'Kütahya',
    type: 'Dere',
    coordinates: const LatLng(39.3, 29.9),
    potentialLevel: 7,
    description: 'Türkiye\'nin batısındaki önemli altın yataklarından. Eskişehir sınırına yakın.',
    recommendedMethod: 'Sluice Box ve Metal Dedektör',
    bestSeason: 'Nisan - Ekim',
    tips: [
      'Volkanik kayaçların olduğu bölgelerde yoğunlaşın',
      'Kuartz damarlarını takip edin',
    ],
  ),

  // İzmir
  GoldLocation(
    name: 'Küçük Menderes Nehri',
    city: 'İzmir',
    type: 'Nehir',
    coordinates: const LatLng(38.1, 27.8),
    potentialLevel: 5,
    description: 'Ödemiş ve Kiraz bölgelerinde placer altın potansiyeli.',
    recommendedMethod: 'Pan eldeme',
    bestSeason: 'Mayıs - Eylül',
    tips: [
      'Nehir yatağındaki kum ve çakılları inceleyin',
      'Tarihi maden bölgelerine yakın alanları önceliklendirin',
    ],
  ),

  // Bolu
  GoldLocation(
    name: 'Gökçesu Deresi',
    city: 'Bolu',
    type: 'Dere',
    coordinates: const LatLng(40.7, 31.6),
    potentialLevel: 6,
    description: 'Bolu dağlarından inen altın içerikli dere.',
    recommendedMethod: 'Pan eldeme',
    bestSeason: 'Haziran - Eylül',
    tips: [
      'Dere yatağındaki ağır mineralleri toplayın',
    ],
  ),

  // Çanakkale
  GoldLocation(
    name: 'Kocabaş Çayı',
    city: 'Çanakkale',
    type: 'Çay',
    coordinates: const LatLng(39.6, 26.9),
    potentialLevel: 6,
    description: 'Biga Yarımadası\'ndaki altın yataklarından beslenen çay.',
    recommendedMethod: 'Sluice Box',
    bestSeason: 'Mayıs - Ekim',
    tips: [
      'Çayın kollarını da araştırın',
      'Tarihi madenlerin aşağı akış yönünü kontrol edin',
    ],
  ),

  // Balıkesir
  GoldLocation(
    name: 'Atikhisar Deresi',
    city: 'Balıkesir',
    type: 'Dere',
    coordinates: const LatLng(39.8, 27.9),
    potentialLevel: 5,
    description: 'Altın içeren kayaçlardan geçen dere sistemi.',
    recommendedMethod: 'Pan eldeme',
    bestSeason: 'Haziran - Eylül',
    tips: [
      'Dere yatağındaki siyah kumları inceleyin',
    ],
  ),

  // Eskişehir
  GoldLocation(
    name: 'Porsuk Çayı',
    city: 'Eskişehir',
    type: 'Çay',
    coordinates: const LatLng(39.8, 30.5),
    potentialLevel: 4,
    description: 'Düşük seviyede altın potansiyeli olan çay.',
    recommendedMethod: 'Pan eldeme',
    bestSeason: 'Temmuz - Eylül',
    tips: [
      'Kıvrımların iç kısımlarında arama yapın',
    ],
  ),

  // Muğla
  GoldLocation(
    name: 'Dalaman Çayı',
    city: 'Muğla',
    type: 'Çay',
    coordinates: const LatLng(37.0, 28.8),
    potentialLevel: 5,
    description: 'Güneybatı Anadolu\'daki altın potansiyelli akarsulardan.',
    recommendedMethod: 'Pan eldeme ve Metal Dedektör',
    bestSeason: 'Nisan - Ekim',
    tips: [
      'Çayın kaynak bölgelerine yakın alanlarda yoğunlaşın',
    ],
  ),

  // Denizli
  GoldLocation(
    name: 'Büyük Menderes Nehri',
    city: 'Denizli',
    type: 'Nehir',
    coordinates: const LatLng(37.8, 29.1),
    potentialLevel: 4,
    description: 'Tarihi altın yataklarından geçen nehir.',
    recommendedMethod: 'Sluice Box',
    bestSeason: 'Mayıs - Eylül',
    tips: [
      'Nehir teraslarını araştırın',
    ],
  ),

  // Giresun
  GoldLocation(
    name: 'Aksu Deresi',
    city: 'Giresun',
    type: 'Dere',
    coordinates: const LatLng(40.5, 38.4),
    potentialLevel: 6,
    description: 'Doğu Karadeniz bölgesindeki altın içerikli dere.',
    recommendedMethod: 'Pan eldeme',
    bestSeason: 'Haziran - Eylül',
    tips: [
      'Yüksek rakımlı kaynaklara yakın bölgeleri inceleyin',
    ],
  ),
];
