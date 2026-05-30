# Android Build Setup

## Estado atual do projeto

- `applicationId` atual: `com.sabercristao.app`
- `namespace` atual: `com.sabercristao.app`
- nome exibido atual: `Saber Cristão`

Este package name final deve ser usado na Play Console, AdMob e produtos de
compra interna.

Para trocar:

- `android/app/build.gradle.kts`: `applicationId` e `namespace`
- `android/app/src/main/AndroidManifest.xml`: `android:label`
- `android/app/src/main/kotlin/com/sabercristao/app/MainActivity.kt`: package Android

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

Checklist para celular fisico:

- ativar opcoes de desenvolvedor;
- ativar depuracao USB;
- conectar via cabo;
- aceitar a autorizacao RSA no aparelho;
- confirmar o device em `flutter devices`;
- usar `flutter run -d <device-id>`.

## Gerar APK debug
```bash
flutter build apk --debug
```

O APK debug costuma sair em:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Para instalar manualmente:

```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

## Futuro App Bundle release
```bash
flutter build appbundle --release
```

## Onde configurar no Android
- `applicationId`: `android/app/build.gradle.kts` ou `build.gradle`
- nome do app: `android/app/src/main/AndroidManifest.xml`
- package Kotlin: `android/app/src/main/kotlin/com/sabercristao/app/MainActivity.kt`
- icone e splash: serao configurados depois

## Observacoes importantes
- AdMob e `in_app_purchase` devem ser testados em Android/iOS, nao no Chrome
- para IAP Android, o ideal e emulador com Play Store ou aparelho fisico
- para anuncios, usar apenas IDs de teste em debug
- compras sandbox exigem build instalado a partir de uma trilha de teste da Play Console
- o Chrome deve continuar usando fallback/mock para compras
