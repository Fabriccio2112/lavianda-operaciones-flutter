# 🗺️ Configuración de Google Maps API

## ✅ API Key Configurada

**Google Maps API Key:** `AIzaSyBrbXX5PmDsDY2O6COmRmevJj1R1IC1L7E`

Esta API key ha sido tomada de la aplicación antigua y configurada en ambas plataformas.

---

## 📱 Configuración por Plataforma

### Android

**Archivo:** `android/app/src/main/AndroidManifest.xml`

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyBrbXX5PmDsDY2O6COmRmevJj1R1IC1L7E"/>
```

**Permisos configurados:**
- ✅ `ACCESS_FINE_LOCATION` - Ubicación precisa
- ✅ `ACCESS_COARSE_LOCATION` - Ubicación aproximada
- ✅ `ACCESS_BACKGROUND_LOCATION` - Ubicación en segundo plano
- ✅ `FOREGROUND_SERVICE` - Servicio en primer plano
- ✅ `FOREGROUND_SERVICE_LOCATION` - Servicio de ubicación
- ✅ `INTERNET` - Conexión a internet
- ✅ `CAMERA` - Acceso a cámara
- ✅ `READ_EXTERNAL_STORAGE` - Lectura de archivos
- ✅ `WRITE_EXTERNAL_STORAGE` - Escritura de archivos

**Dependencias en `android/app/build.gradle`:**
```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-maps:18.2.0'
    implementation 'com.google.android.gms:play-services-location:21.0.1'
}
```

---

### iOS

**Archivo:** `ios/Runner/AppDelegate.swift`

```swift
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBrbXX5PmDsDY2O6COmRmevJj1R1IC1L7E")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

**Archivo:** `ios/Runner/Info.plist`

**Permisos configurados:**
- ✅ `NSLocationWhenInUseUsageDescription` - Ubicación cuando se usa
- ✅ `NSLocationAlwaysAndWhenInUseUsageDescription` - Ubicación siempre
- ✅ `NSLocationAlwaysUsageDescription` - Ubicación en background
- ✅ `NSCameraUsageDescription` - Acceso a cámara
- ✅ `NSPhotoLibraryUsageDescription` - Acceso a galería
- ✅ `NSPhotoLibraryAddUsageDescription` - Guardar fotos

**Background modes:**
- ✅ `location` - Tracking de ubicación en background
- ✅ `fetch` - Obtención de datos en background

---

## 🔑 Uso de la API Key en el Código

**Archivo:** `lib/core/constants/app_constants.dart`

```dart
class AppConstants {
  // Google Maps
  static const String googleMapsApiKey = 'AIzaSyBrbXX5PmDsDY2O6COmRmevJj1R1IC1L7E';
  
  // ... otros constants
}
```

**Uso en widgets:**

```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_constants.dart';

// La API key se configura automáticamente en el AppDelegate (iOS)
// y AndroidManifest.xml (Android), no se necesita en el código Flutter
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(4.6097, -74.0817), // Bogotá
    zoom: 15.0,
  ),
  markers: markers,
  // ... otros parámetros
)
```

---

## 🚀 Pasos para Ejecutar

### 1. Instalar Dependencias

```bash
cd operaciones_flutter
flutter pub get
```

### 2. Ejecutar en Android

```bash
flutter run --release
```

### 3. Ejecutar en iOS

```bash
cd ios
pod install
cd ..
flutter run --release
```

---

## ⚠️ Nota Importante sobre la API Key

Esta API key es la **misma que se usa en la aplicación antigua** (React Native/Expo).

Si necesitas crear una nueva API key o configurar restricciones:

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona el proyecto
3. Ve a **APIs & Services** > **Credentials**
4. Encuentra la API key: `AIzaSyBrbXX5PmDsDY2O6COmRmevJj1R1IC1L7E`
5. Configura las restricciones:
   - **Application restrictions:** Android apps / iOS apps
   - **API restrictions:** Maps SDK for Android, Maps SDK for iOS
   - **Android:** Agrega el package name `com.lavianda.operaciones_flutter`
   - **iOS:** Agrega el bundle identifier `com.lavianda.operaciones-flutter`

---

## 🔍 Verificación

Para verificar que la API key está funcionando:

1. Ejecuta la app en un dispositivo/emulador
2. Abre la pantalla del mapa (`MapScreen`)
3. Deberías ver:
   - ✅ El mapa de Google Maps cargado correctamente
   - ✅ Marcadores de usuarios en tiempo real
   - ✅ Sin watermark "For development purposes only"
   - ✅ Todas las funcionalidades del mapa funcionando

Si ves el watermark o el mapa está gris, verifica:
- Que la API key esté correctamente configurada
- Que las APIs estén habilitadas en Google Cloud Console
- Que el paquete/bundle identifier esté en las restricciones

---

## 📊 APIs Necesarias en Google Cloud

Asegúrate de que estas APIs estén habilitadas:

- ✅ **Maps SDK for Android**
- ✅ **Maps SDK for iOS**
- ✅ **Geocoding API** (para direcciones)
- ✅ **Geolocation API** (para ubicación)
- ✅ **Places API** (opcional, para búsqueda de lugares)
- ✅ **Directions API** (opcional, para rutas)

---

## 💡 Tips

1. **Para desarrollo:** La API key actual funciona sin restricciones
2. **Para producción:** Considera crear una API key separada con restricciones
3. **Monitoreo:** Revisa el uso de la API en Google Cloud Console
4. **Costos:** Google Maps tiene un plan gratuito con $200/mes de crédito
5. **Seguridad:** NO subas la API key a repositorios públicos

---

## ✅ Checklist de Configuración

- [x] API Key configurada en `AndroidManifest.xml`
- [x] API Key configurada en `AppDelegate.swift`
- [x] API Key agregada a `app_constants.dart`
- [x] Permisos de ubicación en Android
- [x] Permisos de ubicación en iOS
- [x] Dependencias de Google Maps en `build.gradle`
- [x] Background modes en `Info.plist`
- [x] Google Maps plugin en `pubspec.yaml`

---

**🎉 ¡Todo configurado y listo para usar!**

La API key de Google Maps ha sido correctamente migrada de la app antigua a la nueva app Flutter.
