# AncientKey - Native Mobile Experience

## 🎯 Apple App Store Review için Hazırlanmış Özellikler

AncientKey, tarihi haritaları konum tabanlı ve interaktif deneyimlerle sunan **native mobile** bir uygulamadır. Apple'ın **Guideline 4.2.2 - Minimum Functionality** kriterlerini karşılamak için aşağıdaki özgün özellikler eklenmiştir:

### ✨ Native Özellikler

#### 1. **Offline Harita Desteği** 🗺️
- Haritaları cihaza indirerek internet olmadan kullanım
- Yerel veritabanı (SQLite) ile hızlı erişim
- Gezgin mode için optimize edilmiş deneyim

#### 2. **Push Notifications** 🔔
- Yakındaki tarihi yerler için akıllı bildirimler
- Konum tabanlı uyarılar
- Başarı ve seviye atlama bildirimleri

#### 3. **AR (Artırılmış Gerçeklik)** 📱
- Kamera ile tarihi yerleri tanıma
- 3D işaretleyiciler ile interaktif deneyim
- Real-time konum overlay

#### 4. **Kullanıcı İçeriği Oluşturma** 📸✍️
- Fotoğraf çekme ve galeri entegrasyonu
- Her yer için not ekleme
- Kişisel deneyimleri kaydetme

#### 5. **Gezilen Yerler Takibi** ✅
- Otomatik yer işaretleme
- İlerleme takibi
- Ziyaret geçmişi

#### 6. **Rota Planlama & Navigasyon** 🧭
- Tarihi yerlere navigasyon
- Mesafe ve süre hesaplama
- Apple Maps / Google Maps entegrasyonu

#### 7. **Achievement/Rozet Sistemi** 🏆
- Gamification elementleri
- 8 farklı başarı
- Seviye sistemi ve XP

#### 8. **Deneyim Paylaşma** 🌐
- İlerleme paylaşımı
- Sosyal medya entegrasyonu
- Ekran görüntüsü paylaşma

#### 9. **Kullanıcı Yorumları** ⭐
- Her harita için yorum ve puanlama
- Ortalama puan sistemi
- Kullanıcı etkileşimi

#### 10. **Offline Audio Rehber** 🎧
- Her harita için sesli anlatım
- Offline dinleme desteği
- Player kontrolleri (play, pause, seek)

#### 11. **360° Panoramik Görüntüler** 🔄
- Zoom ve rotate özellikleri
- Interaktif panorama galerisi
- Immersive deneyim

### 📊 Veritabanı Yapısı

Uygulama **SQLite** kullanarak aşağıdaki verileri yerel olarak saklar:

- Offline haritalar
- Kullanıcı notları
- Çekilen fotoğraflar
- Ziyaret edilen yerler
- Başarılar ve ilerleme
- Yorumlar ve puanlar
- Audio rehber metadata

### 🎮 Oyunlaştırma (Gamification)

- **Seviye Sistemi**: XP kazanarak seviye atlama
- **Başarılar**: 8 farklı achievement
- **İlerleme Takibi**: Ziyaret edilen yer sayısı
- **Sosyal Paylaşım**: Başarıları paylaşma

### 🔐 İzinler

**iOS:**
- Konum (background dahil)
- Kamera
- Fotoğraf Kütüphanesi
- Bildirimler

**Android:**
- Konum (background dahil)
- Kamera
- Depolama
- Bildirimler
- AR özellikleri

### 🚀 Kurulum

```bash
# Bağımlılıkları yükle
flutter pub get

# iOS için pod install
cd ios && pod install && cd ..

# Firebase yapılandırma (Production için gerekli)
# 1. Firebase Console'dan google-services.json (Android)
# 2. Firebase Console'dan GoogleService-Info.plist (iOS)
# indirip ilgili klasörlere yerleştirin

# Uygulamayı çalıştır
flutter run
```

### 📱 Minimum Gereksinimler

- **iOS**: 12.0 ve üzeri
- **Android**: API 21 (Android 5.0) ve üzeri
- İnternet bağlantısı (ilk yükleme için)
- GPS/Konum servisleri
- Kamera (AR özelliği için)

### 🎨 Teknolojiler

- **Flutter** 3.10+
- **Riverpod** - State Management
- **SQLite** - Yerel Veritabanı
- **Firebase** - Push Notifications
- **Flutter Map** - Harita görüntüleme
- **AR Flutter Plugin** - Artırılmış Gerçeklik
- **Audio Players** - Ses dosyası çalma
- **Image Picker** - Kamera ve galeri erişimi
- **Share Plus** - Sosyal paylaşım

### 📝 Apple Review Notları

Bu uygulama **Apple'ın Guideline 4.2.2** kriterlerini karşılamak için tasarlanmıştır:

✅ **Native Fonksiyonalite**: Kamera, GPS, AR, Push Notifications
✅ **Offline Çalışma**: İnternet olmadan kullanılabilir özellikler
✅ **Kullanıcı İçeriği**: Fotoğraf, not, yorum ekleme
✅ **Gamification**: Başarı, seviye, ilerleme sistemi
✅ **Interaktif Deneyim**: AR, navigasyon, audio rehber
✅ **Sosyal Özellikler**: Paylaşım ve yorum sistemi

### 🔄 Güncelleme Notları

**v1.1.0 (Mevcut)**
- ✅ Offline harita desteği
- ✅ Push notifications
- ✅ AR görünüm
- ✅ Kullanıcı içeriği oluşturma
- ✅ Rota planlama
- ✅ Achievement sistemi
- ✅ Audio rehber
- ✅ Panoramik görüntüler

### 📧 İletişim

Herhangi bir sorunuz için: [email@example.com](mailto:email@example.com)

### 📄 Lisans

Copyright © 2025 AncientKey. Tüm hakları saklıdır.
