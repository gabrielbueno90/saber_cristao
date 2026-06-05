# APK Test Build - Saber Cristao

Este guia padroniza como gerar e validar APK de teste para Android com e sem
Supabase configurado.

## 1) Build com Supabase real (Google desativado)

### Windows CMD

```cmd
flutter build apk --debug ^
  --dart-define=SUPABASE_URL=SUA_URL ^
  --dart-define=SUPABASE_ANON_KEY=SUA_ANON_KEY ^
  --dart-define=ENABLE_GOOGLE_SIGN_IN=false ^
  --dart-define=SHOW_DEV_BADGES=false
```

### Windows PowerShell

```powershell
flutter build apk --debug `
  --dart-define=SUPABASE_URL=SUA_URL `
  --dart-define=SUPABASE_ANON_KEY=SUA_ANON_KEY `
  --dart-define=ENABLE_GOOGLE_SIGN_IN=false `
  --dart-define=SHOW_DEV_BADGES=false
```

## 2) Build com Supabase real (Google ativado)

### Windows CMD

```cmd
flutter build apk --debug ^
  --dart-define=SUPABASE_URL=SUA_URL ^
  --dart-define=SUPABASE_ANON_KEY=SUA_ANON_KEY ^
  --dart-define=ENABLE_GOOGLE_SIGN_IN=true ^
  --dart-define=SHOW_DEV_BADGES=false
```

### Windows PowerShell

```powershell
flutter build apk --debug `
  --dart-define=SUPABASE_URL=SUA_URL `
  --dart-define=SUPABASE_ANON_KEY=SUA_ANON_KEY `
  --dart-define=ENABLE_GOOGLE_SIGN_IN=true `
  --dart-define=SHOW_DEV_BADGES=false
```

## 3) Build em modo mock (sem Supabase)

```bash
flutter build apk --debug
```

Regra:
- mesmo sem `SUPABASE_URL` e `SUPABASE_ANON_KEY`, o app deve abrir e seguir em
  fallback mock, sem crash.

## 4) Onde o APK fica

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## 5) Instalar APK manualmente

### Com ADB

```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

### Sem ADB

- enviar o arquivo por WhatsApp/Drive;
- abrir no Android e instalar manualmente.

## 6) Como testar abertura minima

1. Instalar APK.
2. Abrir app.
3. Confirmar Splash.
4. Confirmar tela de Login.
5. Confirmar que nao fecha sozinho.

## 7) Como saber se esta em Supabase real ou mock

Com `SHOW_DEV_BADGES=false`, os indicadores tecnicos ficam ocultos por padrao.

Para validar modo real:
- faca login/cadastro e confira dados no Supabase (`profiles`, `user_progress`).

## 8) Teste funcional rapido apos abrir

1. Login.
2. Home abre.
3. Entrar no quiz.
4. Confirmar perguntas carregando.
5. Finalizar fase e validar resultado.

## 9) O que fazer se crashar novamente

1. Limpar logs:
```bash
adb logcat -c
```
2. Abrir app e capturar erro:
```powershell
adb logcat | Select-String "AndroidRuntime|FATAL EXCEPTION|com.sabercristao.app|MainActivity|FlutterActivity|Supabase|AdMob|MissingPluginException|Resources$NotFoundException|XmlPullParserException|IllegalStateException|RuntimeException"
```
3. Se nao capturar no filtro, rodar `adb logcat` completo e buscar:
- `FATAL EXCEPTION`
- `AndroidRuntime`
- `com.sabercristao.app`

## 10) Comandos de pre-build recomendados

```bash
flutter clean
flutter pub get
flutter analyze
```

## 11) Requisitos de ambiente Android

- JDK 17 configurado no Flutter:
```bash
flutter config --jdk-dir "C:\Program Files\Eclipse Adoptium\jdk-17.0.19.10-hotspot"
```
- Android SDK com:
  - `platforms;android-34`
  - `build-tools`
  - `platform-tools`
  - `cmdline-tools (latest)`
