# APK Test Build - Saber Cristao

Este guia padroniza como gerar APK de teste Android conectado ao Supabase real.
Build mock so deve acontecer quando voce pedir explicitamente.

## 1) Onde ficam as chaves locais

Arquivo local real:

```text
.env.local
```

Arquivo de exemplo sem secrets:

```text
.env.example
```

O arquivo `.env.local` e apenas local, fica ignorado no Git e nunca deve ser commitado.

## 2) Como preencher o arquivo local

Copie o exemplo e preencha com os valores reais:

```env
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_ANON_KEY=eyJ...
ENABLE_GOOGLE_SIGN_IN=true
ENABLE_MOCK_AUTH=false
SHOW_DEV_BADGES=false
```

## 3) Como gerar APK conectado

Use o script PowerShell do projeto:

```powershell
.\scripts\build_apk_debug_connected.ps1
```

Esse script:
- le o `.env.local`
- valida configuracao obrigatoria
- roda `flutter clean`
- roda `flutter pub get`
- roda `flutter analyze`
- gera o APK debug conectado ao Supabase real

## 4) Onde o APK fica

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## 5) Instalar com ADB

```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

## 6) Como saber se o build esta correto

Confira no aparelho:
- o botao Google aparece ativo
- a tela nao mostra `Google em breve`
- login com email e senha tenta autenticar no Supabase real
- reset de senha envia e-mail real pelo Supabase
- app nao abre em fallback silencioso quando faltar configuracao

## 7) Modo mock

Modo mock nao e mais o padrao. Sem `SUPABASE_URL` e `SUPABASE_ANON_KEY`, o app
deve falhar na inicializacao, a menos que `ENABLE_MOCK_AUTH=true` tenha sido
configurado explicitamente em um build interno de mock.
