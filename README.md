# 🪲 InsectaID — Yapay Zeka Destekli Hububat Zararlısı Tanımlama Uygulaması

<div align="center">

![InsectaID Logo](assets/images/logo.png)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![TFLite](https://img.shields.io/badge/TensorFlow_Lite-2.x-FF6F00?logo=tensorflow)](https://www.tensorflow.org/lite)
[![License](https://img.shields.io/badge/Lisans-MIT-green)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android)](https://www.android.com)

**Hububat depolarındaki Coleoptera türlerini anında, çevrimdışı olarak tanımlar.**

[Özellikler](#-özellikler) · [Kurulum](#-kurulum) · [Kullanım](#-kullanım) · [Model](#-yapay-zeka-modeli) · [Katkı](#-katkıda-bulunma)

</div>

---

## 📖 Proje Hakkında

InsectaID, **TÜBİTAK 2209-A** programı kapsamında desteklenen lisans araştırma projesinin çıktısı olarak geliştirilen bir mobil uygulamadır. Hububat ve hububat mamulü depolarında ciddi kalite ve ağırlık kayıplarına yol açan dört Coleoptera türünü, uzman desteğine ve internet bağlantısına gerek duymadan **saniyeler içinde** tanımlar.

### Neden InsectID?

Depo zararlılarının teşhisi, morfolojik benzerlikler nedeniyle uzmanlık gerektiren bir süreçtir. Yanlış veya geç tanı; hatalı mücadele yöntemi seçimine ve telafisi güç ekonomik kayıplara yol açmaktadır. Tek bir çift *Tribolium castaneum*'un uygun koşullarda bir yıl içinde **328 milyarın üzerinde** bireye ulaşabileceği ve **13.000 tondan fazla** ürüne zarar verebileceği göz önünde bulundurulduğunda, erken ve doğru teşhisin önemi açıktır.

InsectID, MobileNetV2 tabanlı derin öğrenme modelini doğrudan cihaza gömerek bu teşhisi herkesin yapabilmesini sağlar.

---

## ✨ Özellikler

- **Çevrimdışı Çalışma** — TFLite modeli uygulamaya gömülüdür; internet bağlantısı gerekmez
- **Anında Tanımlama** — Kamera veya galeriden fotoğraf yükleyerek saniyeler içinde sonuç alın
- **4 Tür Desteği** — *S. granarius*, *S. oryzae*, *T. castaneum*, *T. confusum*
- **Güven Skoru** — Her tanımlama için tüm türlere ait güven skorlarını görüntüleyin
- **Böcek Ansiklopedisi** — Fiziksel tanım, ayırt edici özellikler, üreme ve biyolojik notlar
- **Analiz Geçmişi** — Geçmiş tanımlamaları tarih damgasıyla kaydedin ve görüntüleyin
- **%92+ Doğruluk** — TFLite test setinde %92,27 doğruluk, AUC = 0,9918

---

## 🪲 Tanımlanan Türler

| Tür | Türkçe Adı | Takım | Aile |
|-----|-----------|-------|------|
| *Sitophilus granarius* (L.) | Buğday Biti | Coleoptera | Curculionidae |
| *Sitophilus oryzae* (L.) | Pirinç Biti | Coleoptera | Curculionidae |
| *Tribolium castaneum* (Herbst) | Un Biti | Coleoptera | Tenebrionidae |
| *Tribolium confusum* (Du Val) | Kırma Biti | Coleoptera | Tenebrionidae |

---

## 📊 Model Performansı

| Metrik | Değer |
|--------|-------|
| 5-Fold CV Ortalama Doğrulama Doğruluğu | %93,50 ± %0,54 |
| En İyi Fold (Fold 1) Doğruluğu | %94,14 |
| PyTorch Holdout Test Doğruluğu | %88,09 |
| **TFLite Test Doğruluğu** | **%92,27** |
| TFLite AUC (Ortalama) | 0,9918 |

### Sınıf Bazında F1 Skorları (PyTorch)

| Tür | Kesinlik | Duyarlılık | F1 |
|-----|----------|------------|-----|
| *S. granarius* | %97 | %92 | %94 |
| *S. oryzae* | %94 | %96 | %95 |
| *T. castaneum* | %85 | %79 | %81 |
| *T. confusum* | %78 | %85 | %81 |

---

## 🛠️ Kurulum

### Gereksinimler

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android SDK (minSdkVersion 21 / Android 5.0+)
- Android Studio veya VS Code

### Adım Adım Kurulum

**1. Depoyu klonlayın**

```bash
git clone https://github.com/kullanici-adi/insecta-id.git
cd insecta-id
```

**2. Bağımlılıkları yükleyin**

```bash
flutter pub get
```

**3. Model dosyasını ekleyin**

Eğitilmiş TFLite modelinizi aşağıdaki konuma kopyalayın:

```
assets/model/model.tflite
```

**4. Böcek görsellerini ekleyin**

```
assets/images/
├── s_granarius.png
├── s_oryzae.png
├── t_castaneum.png
└── t_confusum.png
```



**5. Uygulamayı çalıştırın**

```bash
flutter run
```

---

## 📁 Proje Yapısı

```
lib/
├── main.dart                    # Uygulama giriş noktası
├── app_theme.dart               # Renkler ve tema
├── models/
│   ├── insect_species.dart      # Tür veri modeli
│   └── analysis_result.dart     # Analiz sonucu modeli
├── data/
│   └── insect_data.dart         # 4 türün biyolojik verileri
├── services/
│   ├── classifier_service.dart  # TFLite çıkarım servisi
│   └── history_service.dart     # Geçmiş kayıt/okuma servisi
└── screens/
    ├── home_screen.dart         # Ana ekran (kamera / galeri)
    ├── result_screen.dart       # Tanımlama sonucu
    ├── library_screen.dart      # Böcek ansiklopedisi
    └── history_screen.dart      # Analiz geçmişi
```

---

## 🤖 Yapay Zeka Modeli

### Mimari

- **Temel Model:** MobileNetV2 (ImageNet üzerinde önceden eğitilmiş)
- **Framework:** PyTorch → TensorFlow SavedModel → TFLite (Float32 / Float16)
- **Girdi:** 224×224 piksel, RGB, ImageNet normalizasyonu
- **Çıktı:** 4 sınıf softmax skoru

### Eğitim Süreci

İki aşamalı transfer öğrenme protokolü uygulanmıştır:

1. **Aşama 1 — Öznitelik Çıkarımı:** MobileNetV2 omurgası dondurularak yalnızca sınıflandırıcı başlığı eğitildi (Early stopping, patience=5)
2. **Aşama 2 — İnce Ayar:** Tüm katmanlar 10× daha düşük öğrenme oranıyla birlikte eğitildi

### Veri Seti

Her tür için stereo binoküler mikroskop altında kaydedilen yüksek çözünürlüklü video karelerinden elde edilmiştir:

| Tür | Görüntü Sayısı | Çözünürlük |
|-----|---------------|------------|
| *S. granarius* | ~980 | 1440×1080 |
| *S. oryzae* | ~980 | 1440×1080 |
| *T. castaneum* | ~980 | 2048×1536 |
| *T. confusum* | ~980 | 2048×1536 |

Veri artırma: rastgele döndürme (±30°), yatay/dikey çevirme, parlaklık-kontrast değişimleri.

---

## 📦 Kullanılan Paketler

| Paket | Sürüm | Amaç |
|-------|-------|------|
| `tflite_flutter` | ^0.10.4 | On-device TFLite çıkarımı |
| `image_picker` | ^1.0.7 | Kamera / galeri erişimi |
| `image` | ^4.1.7 | Görüntü ön işleme |
| `shared_preferences` | ^2.2.2 | Geçmiş verisi saklama |
| `permission_handler` | ^11.3.0 | Kamera izni yönetimi |
| `path_provider` | ^2.1.2 | Dosya sistemi erişimi |
| `intl` | ^0.19.0 | Tarih formatlama |


---


### Disiplinler Arası Ekip

- **Furkan AYDOĞMUŞ** — Veri Seti hazırlığı (Bitki Koruma, Kırşehir Ahi Evran Üniversitesi)
- **Cansu KARA** — Veri seti hazırlığı (Bitki Koruma, Kırşehir Ahi Evran Üniversitesi)
- **Zehra KOZAN** — Model eğitimi,mobil uygulama geliştiricisi (Bilgisayar Mühendisliği, Yozgat Bozok Üniversitesi)



---

## 📄 Lisans

Bu proje [MIT Lisansı](LICENSE) kapsamında lisanslanmıştır.

---

## 🤝 Katkıda Bulunma

Katkılarınızı memnuniyetle karşılıyoruz. Lütfen şu adımları izleyin:

1. Bu depoyu fork'layın
2. Yeni bir branch oluşturun (`git checkout -b ozellik/yeni-ozellik`)
3. Değişikliklerinizi commit'leyin (`git commit -m 'feat: yeni özellik eklendi'`)
4. Branch'inizi push'layın (`git push origin ozellik/yeni-ozellik`)
5. Pull Request açın

### Geliştirme Önerileri

- [ ] iOS desteği eklenmesi
- [ ] EfficientNetB0 / MobileNetV3 model karşılaştırması
- [ ] Eşik tabanlı ret mekanizması (güven < 0.70 → yeniden çekim uyarısı)
- [ ] Grad-CAM++ ısı haritası görselleştirmesi
- [ ] Çevrimdışı tam destek (on-device inference geliştirme)
- [ ] Artırılmış gerçeklik (AR) entegrasyonu
- [ ] Veri seti genişletme (farklı ışık koşulları ve çekim açıları)

---

<div align="center">

Geliştirici: [Zehra KOZAN ](https://github.com/ZehraKOZAN) 

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!

</div>
