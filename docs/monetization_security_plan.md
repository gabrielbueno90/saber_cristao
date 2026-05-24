# Monetization Security Plan

## Producao: principios obrigatorios
- `service_role` nunca vai para o app Flutter
- compras sempre passam por backend/Edge Function
- anuncios recompensados sempre passam por backend/Edge Function
- `credits` nao podem ser alterados livremente pelo client
- `is_premium` e `premium_until` so podem ser alterados por backend
- `purchases` nao podem ser inseridas pelo client
- `ad_rewards` nao podem ser inseridas livremente pelo client

## Edge Functions planejadas

### 1) `validate_purchase`
Entrada:
- `platform`
- `product_id`
- `transaction_id`
- `purchase_token`

Responsabilidades:
- validar compra com Google Play ou App Store
- inserir registro em `purchases`
- atualizar `profiles.is_premium` e `profiles.premium_until`
- conceder creditos consumiveis quando aplicavel

Saida:
- compra valida ou invalida
- premium concedido ou creditos concedidos

### 2) `grant_ad_reward`
Entrada:
- `ad_type`
- `placement`
- `reward_type`
- `reward_amount`

Responsabilidades:
- validar origem do evento recompensado
- inserir em `ad_rewards`
- conceder vida, credito, hint ou continue
- bloquear abuso basico

### 3) `spend_credit`
Entrada:
- `amount`
- `reason`

Responsabilidades:
- validar saldo atual
- debitar credito com seguranca
- responder com saldo atualizado
- impedir corrida e duplicidade

## Estado atual do app
- Ads: modo teste/no-op, sem IDs reais de producao
- Purchases: estrutura pronta + fallback mock/sandbox
- Premium dev: pode ser simulado em debug
- Creditos dev: ainda podem ser concedidos localmente para testes

## Antes da publicacao
1. implementar `validate_purchase`
2. implementar `grant_ad_reward`
3. implementar `spend_credit`
4. remover mutacoes diretas de creditos pelo client
5. remover concessao local de premium
6. bloquear qualquer escrita client-side em `purchases` e `ad_rewards`
