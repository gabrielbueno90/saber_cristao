# Store Products Setup

## Product IDs usados no app
- `premium_monthly`
- `premium_yearly`
- `credits_10`
- `credits_50`
- `credits_150`

Os IDs precisam bater exatamente com o que for criado na loja.

## Google Play Console
Criar:
- assinatura `premium_monthly`
- assinatura `premium_yearly`
- consumivel `credits_10`
- consumivel `credits_50`
- consumivel `credits_150`

Tambem configurar:
- `Internal testing` ou `Closed testing`
- `License testers`
- app com assinatura e faturamento habilitados

## App Store Connect
Criar:
- auto-renewable subscription `premium_monthly`
- auto-renewable subscription `premium_yearly`
- consumable `credits_10`
- consumable `credits_50`
- consumable `credits_150`

Tambem configurar:
- `Sandbox tester`
- grupo de subscriptions
- `Restore purchases` testado em device iOS

## Observacoes de teste
- `in_app_purchase` real nao e testado no Chrome
- compras reais/sandbox precisam de Android ou iOS
- para Android, usar device/emulador com Play Store
- para iOS, usar device/simulador com conta sandbox quando suportado

## O que falta antes de testar real
- criar os produtos nas lojas
- subir build interna
- vincular testadores
- implementar a validacao segura via backend/Edge Function
