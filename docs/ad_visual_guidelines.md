# Ad Visual Guidelines

## Objetivo
Monetizar sem poluir a experiencia premium, biblica e focada do app.

## Onde anuncios aparecem

### HomeScreen
- banner adaptativo ancorado no fim do conteudo
- nunca no topo
- abaixo dos blocos principais e CTAs
- com espacamento antes do anuncio
- com rotulo discreto `Publicidade`
- so para usuarios nao premium

### LevelMapScreen
- banner adaptativo no rodape
- com `SafeArea`
- espaco reservado no layout
- nao cobre fases nem botoes
- em telas pequenas, o conteudo continua rolando acima do banner

### ResultScreen
- interstitial apenas em transicao natural
- tentativa ao sair para Home ou fases
- se falhar, o fluxo segue normalmente

### OutOfLivesScreen
- rewarded ad como opcao principal para usuario nao premium
- recompensa concedida somente apos callback de recompensa
- se nao houver anuncio, mostrar mensagem amigavel

## Onde anuncios nao aparecem
- QuizScreen durante pergunta
- StoreScreen
- PaywallScreen
- telas de autenticacao

## Regras de espacamento
- anuncio nunca colado em botao
- anuncio nunca colado em card principal
- anuncio nunca cobre CTA ou alternativa
- manter espacamento visual consistente antes do banner

## Frequencia inicial
- interstitial: no maximo 1 a cada 2 partidas concluidas
- rewarded: apenas por escolha do usuario
- banner: apenas em telas paradas e permitidas

## Premium
- premium nao ve banner
- premium nao ve interstitial
- premium nao depende de rewarded para continuar

## Web
- sem anuncio real
- placeholder seguro/no-op em debug
- sem quebra visual no Chrome

## Android e iOS
- usar banners adaptativos ancorados
- usar apenas IDs de teste em desenvolvimento
- testar em larguras pequenas e medias
- confirmar que `SafeArea` protege o rodape
