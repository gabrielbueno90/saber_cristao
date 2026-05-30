# Edge Functions Setup

## Funcao criada

```text
supabase/functions/validate_purchase/index.ts
```

Objetivo:

- receber `platform`, `product_id`, `transaction_id` e `purchase_token`;
- validar usuario autenticado;
- preparar validacao futura com Google Play e App Store;
- impedir concessao real de premium/creditos sem validacao da loja.

## Instalar Supabase CLI

Windows:

```powershell
winget install Supabase.CLI
```

Conferir:

```bash
supabase --version
```

## Rodar localmente

```bash
supabase start
supabase functions serve validate_purchase --env-file ./supabase/.env.local
```

Arquivo local de ambiente sugerido, sem commit:

```text
ALLOW_DEV_PURCHASE_VALIDATION=true
```

## Deploy

```bash
supabase functions deploy validate_purchase
```

## Secrets futuros

Configurar somente no ambiente da Edge Function:

```bash
supabase secrets set ALLOW_DEV_PURCHASE_VALIDATION=false
supabase secrets set GOOGLE_PLAY_PACKAGE_NAME=com.sabercristao.app
supabase secrets set GOOGLE_PLAY_SERVICE_ACCOUNT_JSON=...
supabase secrets set APPLE_BUNDLE_ID=...
supabase secrets set APPLE_SHARED_SECRET=...
```

Nunca colocar secrets no Flutter.

## Chamada pelo Flutter

Depois que a validacao real estiver pronta, o app deve chamar:

```dart
await supabase.functions.invoke(
  'validate_purchase',
  body: {
    'platform': 'android',
    'product_id': 'credits_10',
    'transaction_id': 'TRANSACTION_ID',
    'purchase_token': 'PURCHASE_TOKEN',
  },
);
```

## Estado atual da funcao

- valida metodo `POST`;
- exige usuario autenticado;
- valida campos obrigatorios;
- por padrao retorna `valid: false` com `production_guard`;
- aceita modo dev apenas se `ALLOW_DEV_PURCHASE_VALIDATION=true`;
- nao concede premium;
- nao concede creditos;
- nao insere compras.

## Proxima evolucao obrigatoria

Antes de dinheiro real em producao:

- validar recibo/token com Google Play;
- validar recibo com Apple;
- inserir `purchases` usando service role somente na Edge Function;
- conceder creditos consumiveis somente apos compra valida;
- atualizar `profiles.is_premium` e `profiles.premium_until` somente no backend;
- evitar duplicidade por `transaction_id` ou `purchase_token`.
