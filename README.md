# MediFinder — Sağlık Uzmanı Arama Uygulaması

MediFinder, hastaları dünya genelindeki doğrulanmış tıp uzmanlarıyla buluşturan bir sağlık keşif platformudur. Bu proje; liste, filtre ve detay olmak üzere 3 ekranlı bir sağlayıcı arama akışı uygular. Backend bağımlılığı olmaksızın Clean Architecture, Bloc state yönetimi, lokalizasyon (TR/EN) ve Material 3 temayı Flutter ile gösterir.

---

## Mimari

MediFinder, üç katmanlı **Clean Architecture** kullanır:

- **Domain** — saf Dart entity'leri (`ProviderEntity`, `FilterState`) ve soyut `ProviderRepository` arayüzü. Flutter import'u yoktur. Veri kaynakları veya UI hakkında bilgi sahibi değildir. Backend değişimlerine karşı kararlı çekirdektir.
- **Data** — `ProviderModel`, `ProviderEntity`'yi genişletir ve gelecek kullanım için `fromMap`/`toMap` ekler. `ProviderRepositoryImpl`, domain sözleşmesini yerine getirir: `connectivity_plus` ile ağ bağlantısını kontrol eder, 800 ms ağ gecikmesi simüle eder, ardından mock veri setini döner. Tüm veriler şu an `mockProviders` üzerinden mock'lanmıştır (UK ve UAE'den 26 kayıt).
- **Presentation** — Bloc tüm state geçişlerini yönetir. Ekranlar ve widget'lar tamamen reaktiftir, state'i doğrudan değiştirmez.

**Neden Clean Architecture?** Her katmanın tek bir değişim nedeni vardır. Mock veriyi gerçek bir REST API ile değiştirmek yalnızca data katmanına dokunmayı gerektirir. UI refaktörleri asla iş mantığına yansımaz. Her katman bağımsız olarak test edilebilir.

**Neden Bloc?**

| Konu | Bloc avantajı |
|---|---|
| İzlenebilirlik | Her kullanıcı aksiyonu açık bir `sealed class` event'idir — bağımsız olarak loglanabilir, tekrar oynatılabilir veya test edilebilir |
| Kapsamlı state'ler | `sealed class ProviderState`, her çağrı noktasında kapsamlı `switch` ifadelerini zorunlar — Dart 3 derleyicisi eksik case'leri yakalar |
| Birim testi | `bloc_test`'in `blocTest()` fonksiyonu herhangi bir state'i seed'lemenize, tek bir event göndermenize ve tam olarak emit edilen state'leri assert etmenize olanak tanır — widget tree gerekmez |
| Ölçeklenebilirlik | Yeni bir özellik eklemek (örn. yer imleri) mevcut handler'lara dokunmadan yalnızca bir event alt sınıfı ve bir state alt sınıfı eklemeyi gerektirir |

---

## State Yönetimi

**Event → Bloc → State akışı:**

```
Kullanıcı aksiyonu (örn. FilterSheet'te bir ülke filtresi seçer)
    │
    ▼
ProviderFilterApplied(FilterState(...))   ← FilterSheet'ten gönderilir
    │
    ▼
ProviderBloc._applyFilters(all, query, filter)
    │
    ▼
emit(ProviderLoaded(filteredProviders: [...], activeFilter: ...))
    │
    ▼
BlocBuilder, liste ve aktif filtre chip satırını yeniden oluşturur
```

**`FilterState` neden `ProviderLoaded` içinde ayrı bir Bloc değil:**

Filtreler asenkron yan etkisi olmayan, yalnızca kullanıcı etkileşiminden türetilen ve zaten yüklenmiş sağlayıcı listesine senkron uygulanan işlemlerdir. `FilterState`'i `ProviderLoaded` içine gömmek şunu sağlar:

- Filtrenin var olduğu ama sağlayıcıların yüklenmediği geçersiz bir state yoktur — türler bunu imkânsız kılar.
- Tek bir `BlocBuilder`, listeyi ve filtre badge'ini atomik olarak yeniden oluşturur; Bloc-to-Bloc iletişime gerek yoktur.
- `FilterState.isEmpty`, aktif filtre UI'ını gösterip gizlemek için tek doğruluk kaynağıdır.

---

## Lokalizasyon

MediFinder, Flutter'ın yerleşik `flutter_localizations` / `intl` pipeline'ı aracılığıyla **Türkçe ve İngilizce**'yi destekler.

- ARB kaynak dosyaları `lib/l10n/` altındadır (`app_tr.arb`, `app_en.arb`).
- Üretilen sınıflar (`AppLocalizations`, `AppLocalizationsEn`, `AppLocalizationsTr`) kaynak dosyalarla birlikte commit'lenir.
- `AppLocalizations` üzerindeki `SpecialtyL10n` extension'ı, ham İngilizce uzmanlık string'lerini (örn. `'Cardiologist'`) görüntüleme anında yerelleştirilmiş karşılıklarına dönüştürür — domain entity'leri her zaman kanonik İngilizce anahtarı saklar. Bu sayede filtre ve arama mantığı locale'den bağımsız kalır.
- Dil, uygulama başlığındaki küre ikonuyla çalışma zamanında değiştirilebilir; seçim `main.dart`'taki `ValueNotifier<Locale>` aracılığıyla korunur ve `SharedPreferences`'a kaydedilir.

---

## Arama ve Filtreleme

- **Arama** yalnızca sağlayıcı **ismine** göre çalışır.
- **Filtreler** (ülke, şehir, uzmanlık) arama ile bağımsız olarak birleşik uygulanır.
- **Uzmanlık chip'leri** filtre sheet'inde `SpecialtyL10n` aracılığıyla lokalize edilmiş etiketlerle gösterilir; ancak seçim/eşleştirme mantığı kanonik İngilizce key üzerinden çalışır.
- **Filtre chip satırı** (arama çubuğunun altında), aktif filtre kategorilerini gösterir; her kategoride X butonu ile tek kategorinin filtresini temizleyebilirsiniz.

---

## Responsive Grid

Sağlayıcı listesi `SliverLayoutBuilder` kullanarak ekran genişliğine göre uyum sağlar:

| Ekran genişliği | Sütun sayısı |
|---|---|
| ≤ 600 px | 2 sütun |
| > 600 px | 3 sütun |

---

## Klasör Yapısı

```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart           # ServerException, NetworkException, …
│   │   └── failures.dart             # Failure alt sınıfları (Equatable)
│   ├── router/
│   │   └── app_router.dart           # GoRouter — 2 route
│   ├── theme/
│   │   ├── app_theme.dart            # AppTheme.light / .dark (Material 3)
│   │   └── app_theme_extension.dart  # Spacing/radius token'ları + BuildContext ext
│   └── utils/
│       ├── constants.dart            # AppConstants (SharedPrefs key'leri)
│       ├── extensions.dart           # ContextX, StringX, NullableStringX
│       └── specialty_l10n.dart       # AppLocalizations üzerinde SpecialtyL10n extension'ı
│
├── features/
│   └── providers/
│       ├── data/
│       │   ├── mock/
│       │   │   └── mock_providers.dart         # 26 ProviderModel kaydı (UK & UAE)
│       │   ├── models/
│       │   │   └── provider_model.dart         # fromMap / toMap
│       │   └── repositories/
│       │       └── provider_repository_impl.dart  # bağlantı kontrolü + gecikme
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── provider_entity.dart        # Çekirdek entity (Equatable)
│       │   │   └── filter_state.dart           # Filtre data class'ı (Equatable)
│       │   └── repositories/
│       │       └── provider_repository.dart    # soyut arayüz
│       └── presentation/
│           ├── bloc/
│           │   ├── provider_bloc.dart
│           │   ├── provider_event.dart         # sealed class
│           │   └── provider_state.dart         # sealed class
│           ├── screens/
│           │   ├── provider_list_screen.dart
│           │   └── provider_detail_screen.dart
│           └── widgets/
│               ├── provider_avatar.dart        # CachedNetworkImage + baş harf fallback
│               ├── rating_stars.dart           # dolu / yarım / boş yıldız
│               ├── provider_card.dart          # Hero + kart düzeni
│               ├── filter_chip_group.dart      # Yeniden kullanılabilir chip grubu
│               ├── filter_sheet.dart           # Canlı sonuç sayılı DraggableScrollableSheet
│               ├── loading_shimmer.dart        # Tema uyumlu animasyonlu shimmer
│               ├── empty_state.dart            # Sonuç yok UI'ı
│               └── error_state.dart            # Hata + yeniden dene UI'ı
│
├── l10n/
│   ├── app_tr.arb                    # Türkçe string'ler
│   ├── app_en.arb                    # İngilizce string'ler
│   ├── app_localizations.dart        # Üretilen temel sınıf
│   ├── app_localizations_tr.dart     # Üretilen TR delegate
│   └── app_localizations_en.dart     # Üretilen EN delegate
│
└── main.dart   # MediFinderApp — BlocProvider + GoRouter + ValueNotifier<ThemeMode> + ValueNotifier<Locale>
```

---

## Nasıl Çalıştırılır

```bash
flutter pub get
flutter run
```

Flutter 3.x ve Dart 3.x gerektirir (Flutter 3.44.0 ile test edilmiştir).

---

## Temel Teknik Kararlar

- **GoRouter** — `ProviderEntity`'yi detay ekranına yeniden fetch etmeden type-safe `extra` ile aktarmak için bildirimsel yönlendirme. Derin bağlantı ve web desteği kutudan çıkar.
- **Hero animasyonu** — `provider.id`, hem `ProviderCard` hem de `ProviderDetailScreen`'deki `ProviderAvatar`'da Hero tag'i olarak kullanılır; sıfır ekstra kod ile doğal paylaşımlı element geçişi sağlanır.
- **Null safety** — Tüm nullable alanlar (`phone`, `website`, `bio`, `imageUrl`) `String?` tipindedir. Boş container göstermek yerine tüm UI bölümleri (iletişim, biyografi) null olduğunda gizlenir.
- **Tema token sistemi** — `AppThemeExtension` spacing ve radius token'ları, tüm özellik kodunda `context.appTheme` aracılığıyla kullanılır. Özellik katmanında hardcoded padding değeri yoktur.
- **Sealed class'lar** — Hem `ProviderEvent` hem de `ProviderState` `sealed`'dır. Build metodlarındaki `ProviderState` üzerindeki her `switch` kapsamlıdır — Dart 3 derleyicisi bütünlüğü zorunlar ve yeni bir alt sınıf eklenmesi durumunda hata verir.
- **Repository pattern** — `ProviderRepository` domain katmanı arayüzüdür; `ProviderRepositoryImpl` (data katmanı), veri döndürmeden önce `connectivity_plus` ile bağlantıyı kontrol eder, başarısızlıkta typed `NetworkException` fırlatır. Bloc bunu yakalar ve yerelleştirilmiş ipucuyla `ProviderError` emit eder.
- **Canlı filtre önizlemesi** — `FilterSheet`, kullanıcı chip'leri değiştirdikçe sonuç sayısını gerçek zamanlı hesaplar; "N Sonucu Göster" butonu her zaman Bloc'a commit edilmeden mevcut taslak filtreyi yansıtır.
- **Lokalizasyon** — Tüm kullanıcıya görünür string'ler ARB dosyalarına aktarılmıştır. Uzmanlık isimleri domain katmanında kanonik İngilizce key olarak saklanır ve `SpecialtyL10n` aracılığıyla render anında yerelleştirilir; bu sayede filtre/arama mantığı locale'den bağımsız kalır.
