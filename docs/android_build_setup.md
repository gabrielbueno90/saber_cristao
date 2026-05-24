# Android Build Setup

## Rodar no Android Emulator
1. Abrir um emulador Android com Google Play quando possivel.
2. Listar devices:
```bash
flutter devices
```
3. Rodar:
```bash
flutter run -d emulator-5554
```

## Rodar em celular fisico
1. Ativar modo desenvolvedor e depuracao USB.
2. Conectar o aparelho.
3. Confirmar em `flutter devices`.
4. Rodar:
```bash
flutter run -d <device-id>
```

## Gerar APK debug
```bash
flutter build apk --debug
```

## Futuro App Bundle release
```bash
flutter build appbundle --release
```

## Onde configurar no Android
- `applicationId`: `android/app/build.gradle.kts` ou `build.gradle`
- nome do app: `android/app/src/main/AndroidManifest.xml`
- icone e splash: serao configurados depois

## Observacoes importantes
- AdMob e `in_app_purchase` devem ser testados em Android/iOS, nao no Chrome
- para IAP Android, o ideal e emulador com Play Store ou aparelho fisico
- para anuncios, usar apenas IDs de teste em debug
