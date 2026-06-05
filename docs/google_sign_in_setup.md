# Google Sign-In Setup (Android + Supabase) - Saber Cristao

Este guia ativa o fluxo real de `Entrar com Google` no APK Android usando Supabase Auth.

## 1) Pre-requisitos

- `package name` Android final: `com.sabercristao.app`
- `SUPABASE_URL` e `SUPABASE_ANON_KEY` validos
- Build com:
  - `--dart-define=ENABLE_GOOGLE_SIGN_IN=true`
  - `--dart-define=SHOW_DEV_BADGES=false`

## 2) Configurar Google Provider no Supabase

No Supabase Dashboard:

1. Acesse `Authentication` -> `Providers` -> `Google`.
2. Ligue `Enable sign in with Google`.
3. Copie a callback URL exibida no painel do provider. O padrao e:
   - `https://<project-ref>.supabase.co/auth/v1/callback`
4. Preencha:
   - `Client ID` (Google Cloud OAuth Web Client)
   - `Client Secret` (Google Cloud OAuth Web Client)
5. Salve.

## 3) Configurar Google Cloud Console

### 3.1 Criar projeto e consent screen

1. Abra `Google Cloud Console`.
2. Crie ou selecione um projeto.
3. Acesse `APIs & Services` -> `OAuth consent screen`.
4. Configure:
   - App name: `Saber Cristao`
   - User type: `External` (para testes)
   - Test users: adicione seus emails de teste

### 3.2 Criar OAuth Client (obrigatorio para Supabase)

1. `APIs & Services` -> `Credentials` -> `Create Credentials` -> `OAuth client ID`.
2. Tipo: `Web application`.
3. Em `Authorized redirect URIs`, adicione EXATAMENTE:
   - `https://<project-ref>.supabase.co/auth/v1/callback`
4. Crie, copie `Client ID` e `Client Secret`.
5. Cole esses dados no Provider Google do Supabase.

## 4) Redirect/Deep link Android usado no app

Fluxo escolhido no app:

- `redirectTo`: `com.sabercristao.app://login-callback/`
- Android `AndroidManifest.xml` com `intent-filter`:
  - `scheme`: `com.sabercristao.app`
  - `host`: `login-callback`

No Supabase (`Authentication` -> `URL Configuration`), adicione em Redirect URLs:

- `com.sabercristao.app://login-callback/`

## 5) Como resolver "Unsupported provider: provider is not enabled"

Se esse erro aparecer, revise:

1. Provider Google esta realmente `enabled` no Supabase.
2. `Client ID` e `Client Secret` sao do OAuth Client `Web application`.
3. Redirect URI no Google Cloud bate 100% com:
   - `https://<project-ref>.supabase.co/auth/v1/callback`
4. Redirect URL no Supabase inclui:
   - `com.sabercristao.app://login-callback/`
5. APK foi gerado com `ENABLE_GOOGLE_SIGN_IN=true`.

## 6) Comandos de build

### Google login ativo

```powershell
flutter clean
flutter pub get
flutter analyze
flutter build apk --debug `
  --dart-define=SUPABASE_URL=SUA_URL `
  --dart-define=SUPABASE_ANON_KEY=SUA_ANON_KEY `
  --dart-define=ENABLE_GOOGLE_SIGN_IN=true `
  --dart-define=SHOW_DEV_BADGES=false
```

### Google login desativado temporariamente

```powershell
flutter build apk --debug `
  --dart-define=SUPABASE_URL=SUA_URL `
  --dart-define=SUPABASE_ANON_KEY=SUA_ANON_KEY `
  --dart-define=ENABLE_GOOGLE_SIGN_IN=false `
  --dart-define=SHOW_DEV_BADGES=false
```

## 7) Teste no Android

1. Instale o APK no emulador/celular.
2. Abra app -> `LoginScreen`.
3. Clique `Entrar com Google`.
4. Escolha conta Google.
5. Valide retorno para o app (deep link).
6. Valide redirecionamento para `Home`.
7. Valide no Supabase:
   - tabela `profiles` com `auth_provider = google`
   - tabela `user_progress` criada/carregada

## 8) Regra de UX

- Usuario final nunca deve ver JSON cru ou erro tecnico.
- Em falha, mostrar mensagem amigavel:
  - `Nao foi possivel entrar com Google agora. Tente novamente ou use email e senha.`
