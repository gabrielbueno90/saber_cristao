# Store Products Setup

## Product IDs usados no app
- `premium_monthly`
- `premium_yearly`
- `credits_10`
- `credits_50`
- `credits_150`

Os IDs precisam bater exatamente com o que for criado na loja.

## Google Play Console
Passo a passo pratico:

1. Criar o app na Play Console.
2. Usar o package name Android `com.sabercristao.app`.
3. Configurar informacoes basicas do app.
4. Criar uma trilha em `Internal testing`.
5. Adicionar testadores em `License testers`.
6. Subir um build assinado para teste interno.
7. Criar os produtos consumiveis:
   - `credits_10`
   - `credits_50`
   - `credits_150`
8. Criar as assinaturas:
   - `premium_monthly`
   - `premium_yearly`
9. Ativar precos, regioes e status dos produtos.
10. Instalar o app pelo link de teste interno.
11. Testar compras com uma conta incluida como tester.

## App Store Connect
Passo a passo pratico:

1. Criar Bundle ID no Apple Developer.
2. Criar o app no App Store Connect com o Bundle ID iOS definitivo.
3. Criar um grupo de assinaturas.
4. Criar as assinaturas auto-renewable:
   - `premium_monthly`
   - `premium_yearly`
5. Criar os consumiveis:
   - `credits_10`
   - `credits_50`
   - `credits_150`
6. Criar sandbox tester.
7. Configurar acordos, impostos e dados bancarios quando exigido.
8. Testar em device iOS com sandbox/TestFlight.
9. Testar `Restore purchases`.

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

## Comportamento atual no app

- Chrome: usa fallback/mock.
- Android/iOS com loja disponivel: tenta carregar produtos reais.
- Produtos nao encontrados: mostra mensagem amigavel e usa fallback visual.
- Compra enviada: retorna estado `pending` enquanto a loja processa.
- Compra concluida/restaurada em debug: aplica fluxo dev temporario.

Antes da publicacao, compras precisam ser validadas pela Edge Function
`validate_purchase` e os beneficios nao devem ser concedidos diretamente pelo
client Flutter.
