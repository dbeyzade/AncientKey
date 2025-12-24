# AncientKey

Konum tabanlı tarihi haritaları siber/neo-fütüristik bir tasarım ile gösteren Flutter uygulaması.

## Özellikler
- GPS ile yakınındaki antik yol ve kent katmanlarını ön plana çıkarır.
- Harita listesi, arama çubuğu (adres/il/antik kent) ve favorilere kaydetme.
- FlutterMap üzerinde neon marker'lar, konum oku ve ekran görüntüsü alma.
- Detay sayfasında antik harita görseli üzerinde bulunduğun noktayı işaretleme.
- Türkçe açıklamalar, neon temalı tasarım ve hızlı erişim durum chip'leri.
- Açılışta tam siyah ekranda `assets/videos/antq.mp4` videosu otomatik oynar, ardından alıntı gösterilip uygulamaya geçilir (play tuşu yok).

## Çalıştırma
1) Gerekli araçlar: Flutter SDK (stable), Xcode/Android Studio platform araçları.
2) Bağımlılıkları indir: `flutter pub get`
3) Çalıştır: `flutter run` (iOS için simülatör veya bağlı cihazda, Android için emulator/cihazda).

> Not: `assets/videos/antq.mp4` dosyasını bu klasöre ekleyin (video ekli değil). Dosya yoksa giriş ekranı video yerine direkt uygulamaya geçer.

## İzinler
- Konum: Yakındaki antik harita katmanlarını hesaplamak için `ACCESS_FINE_LOCATION` (Android) ve `NSLocationWhenInUseUsageDescription` (iOS) açıklamaları eklendi.

## Klasörler
- `lib/features/maps`: Harita verileri, sağlayıcılar ve ekranlar.
- `lib/features/location`: Konum servisi ve sağlayıcısı.
- `lib/features/favorites`: Favori yönetimi.
- `assets/maps`: Antik harita çizimleri (SVG).
