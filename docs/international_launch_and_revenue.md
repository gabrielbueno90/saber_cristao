# International Launch and Revenue

Este documento organiza o plano de lancamento internacional e as frentes de
receita do app `Saber Cristao`.

## Estrategia de lancamento por paises e idiomas

Ordem recomendada para reduzir risco e aumentar previsibilidade:

1. Android Brasil (`pt-BR`)
2. Android paises de lingua portuguesa
3. Android paises de lingua espanhola
4. iOS (com base validada no Android)
5. Ingles (`en`) em Android e iOS

Objetivo dessa ordem:

- validar retencao e monetizacao no publico principal primeiro;
- ajustar conteudo, funil e paywall com custo menor;
- escalar somente depois de estabilidade tecnica e comercial.

## Requisitos por idioma

Para cada idioma/regiao nova, garantir:

1. Interface traduzida
- textos de UI no app (`login`, `home`, `quiz`, `paywall`, `store`, erros).
- revisao de terminologia biblica e doutrinaria.

2. Conteudo de perguntas no banco
- perguntas em `public.questions` com `language` correto (`pt-BR`, `es`, `en`).
- `review_status = approved` e `is_active = true`.
- distribuicao equilibrada por nivel e dificuldade.

3. Textos das lojas
- titulo, subtitulo, descricao curta e longa.
- textos de privacidade e suporte localizados.

4. Screenshots e criativos por idioma
- capturas reais do app no idioma alvo.
- destaque de beneficios: quiz, progresso, premium sem anuncios.

5. Politica de privacidade e conformidade
- pagina de privacidade acessivel e atualizada.
- tratamento de dados e consentimento de anuncios conforme regiao.

## Fontes de receita e separacao por plataforma

Receita do app vem de tres canais:

1. AdMob (anuncios)
- receita por impressao/clique em anuncios.
- nao passa pela Play Store nem pela App Store.

2. Google Play (Android)
- assinaturas (`premium_monthly`, `premium_yearly`).
- consumiveis (`credits_10`, `credits_50`, `credits_150`).

3. App Store Connect (iOS)
- assinaturas iOS.
- consumiveis iOS.

Resumo importante:

- anuncios sao pagos via AdMob;
- compras Android sao pagas via Google Play;
- compras iOS sao pagas via Apple;
- cada plataforma tem painel financeiro proprio.

## Configuracao para receber pagamentos

### AdMob payments

- conta AdMob verificada;
- perfil de pagamento configurado;
- dados fiscais e bancarios preenchidos;
- limite minimo de saque e forma de pagamento conferidos.

### Google Play payments profile

- perfil de pagamentos Google ativo;
- dados legais da entidade/pessoa;
- conta bancaria validada;
- informacoes fiscais configuradas.

### App Store banking/tax

- contratos ativos no App Store Connect;
- formulario fiscal completo;
- dados bancarios aprovados;
- status de pagamentos habilitado.

## Checklist Google Play

1. Conta de desenvolvedor criada e validada.
2. `Payments profile` configurado.
3. Conta bancaria vinculada.
4. Paises/regioes de disponibilidade definidos.
5. Classificacao indicativa preenchida.
6. Politica de privacidade publicada e linkada.
7. Produtos in-app criados:
- `premium_monthly`
- `premium_yearly`
- `credits_10`
- `credits_50`
- `credits_150`
8. Teste interno (`Internal testing`) ativo.
9. Testadores e `license testers` adicionados.
10. Build de teste interno enviado e instalado via Play.

## Checklist AdMob

1. Conta AdMob criada.
2. App cadastrado no AdMob.
3. Ad units criadas:
- banner
- interstitial
- rewarded
4. IDs de teste usados em desenvolvimento.
5. IDs reais usados somente em build de producao.
6. Pagamentos configurados no AdMob.
7. Politica de consentimento/privacidade revisada para anuncios.

## Checklist App Store

1. Conta Apple Developer ativa.
2. Banking e tax completos.
3. Disponibilidade do app por pais/regiao definida.
4. Produtos in-app criados (assinaturas e consumiveis).
5. Sandbox tester criado.
6. TestFlight configurado com build valido.
7. Fluxo de restore purchases testado.

## Ordem pratica de execucao recomendada

1. Android Brasil
- validar conteudo `pt-BR`, funil de cadastro, paywall e loja.
- rodar teste interno com anuncios de teste e IAP sandbox.

2. Android paises de lingua portuguesa
- adaptar textos de loja e politicas.
- expandir conteudo `pt` conforme necessidade local.

3. Android espanhol
- publicar interface `es`.
- inserir banco de perguntas `es` com curadoria.

4. iOS
- repetir funil validado no Android.
- ajustar diferencas de review e IAP da Apple.

5. Ingles
- consolidar UI + conteudo `en`.
- publicar em mercados anglofonos com ASO dedicado.

## Gate minimo antes de cada novo pais/idioma

1. App estavel (sem erros criticos).
2. Conteudo suficiente por nivel/dificuldade.
3. Conversao de monetizacao minimamente validada.
4. Pagamentos e contratos ativos na plataforma alvo.
5. Politica e compliance revisados.

## Observacoes operacionais

- manter planilha de controle por pais com status de:
  interface, conteudo, lojas, pagamentos, teste e publicacao.
- separar KPI por plataforma e pais:
  retencao, ARPDAU, taxa de assinatura, receita de anuncios.
- nao liberar anuncios/compra real em producao sem validar:
  RLS, Edge Functions e fluxo de restauracao.
