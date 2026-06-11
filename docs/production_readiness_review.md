# Production Readiness Review

Revisao tecnica de pre-lancamento do **Saber Cristao**.

## 1. Inicializacao do app

- [x] O app abre sem crash conhecido.
- [x] Splash funciona e nao derruba a navegacao.
- [x] Falha de Supabase nao deve derrubar a UI.
- [x] Falha de AdMob nao deve quebrar a experiencia.
- [x] Falha de IAP nao deve quebrar a experiencia.
- [x] Exceptions tecnicas nao devem aparecer para o usuario.
- [x] JSON cru nao deve aparecer na UI.

## 2. Configuracao por ambiente

- [x] `SUPABASE_URL` configurado via `dart-define`.
- [x] `SUPABASE_ANON_KEY` configurado via `dart-define`.
- [x] `ENABLE_GOOGLE_SIGN_IN` controlado por flag.
- [x] `SHOW_DEV_BADGES` controlado por flag.
- [x] Defaults seguros quando flags faltam.
- [x] UI sem badges tecnicos quando `SHOW_DEV_BADGES=false`.
- [x] Nenhuma chave completa deve ser logada.

## 3. Autenticacao

- [x] Cadastro email/senha.
- [x] Login email/senha.
- [x] Login Google.
- [x] Callback Google.
- [x] Logout.
- [x] Sessao persistente.
- [x] Recuperacao de senha.
- [x] Reset de senha.
- [x] Redirect `com.sabercristao.app://login-callback/`.
- [x] Redirect `com.sabercristao.app://reset-password/`.
- [x] Profile criado/carregado apos autenticar.
- [x] `user_progress` criado/carregado.

## 4. Roteamento

- [x] Usuario nao logado nao acessa telas protegidas.
- [x] Usuario logado nao fica preso no login.
- [x] Callback OAuth nao cai em Page Not Found.
- [x] Reset password nao cai em Page Not Found.
- [x] Botao voltar funciona.
- [x] Back button do Android nao quebra o fluxo.
- [x] Deep links nao exibem URL tecnica para o usuario.
- [x] 404 nao deve aparecer para usuario comum.

## 5. Supabase / Banco

- [x] `profiles`.
- [x] `questions`.
- [x] `user_progress`.
- [x] `quiz_attempts`.
- [x] `user_level_progress`.
- [x] `purchases`.
- [x] `ad_rewards`.
- [x] RLS ativo.
- [x] Policies principais revisadas.
- [x] Usuario nao acessa dados de outro usuario.
- [x] Perguntas lidas apenas com `is_active=true` e `review_status=approved`.
- [x] Progresso gravado no usuario certo.
- [x] `service_role` nao existe no app Flutter.

## 6. Quiz

- [x] Busca perguntas por `language`, `level` e `difficulty`.
- [x] Nao carrega tudo de uma vez.
- [x] Fallback controlado funciona.
- [x] Nao repete pergunta dentro da mesma sessao.
- [x] Calcula score corretamente.
- [x] Calcula estrelas corretamente.
- [x] Salva `quiz_attempts`.
- [x] Salva `user_progress`.
- [x] Salva `user_level_progress`.
- [x] Atualiza `current_level` corretamente.
- [x] Nao reduz a melhor estrela conquistada.

## 7. Estrelas e mapa de fases

- [x] `LevelMap` usa `best_stars` real.
- [x] Nao usa mais `completed ? 2 : 0`.
- [x] Fase com melhor resultado mostra a melhor estrela.
- [x] Fase bloqueada continua bloqueada.
- [x] Fase desbloqueada abre.
- [x] Sem overflow nos cards.
- [x] Banner nao cobre o conteudo.
- [x] Botao nao fica colado no fim da tela.

## 8. Vidas e creditos

- [x] Regra atual de vidas validada.
- [x] Uso de creditos isolado em camada propria.
- [x] Tela `OutOfLives` revisada.
- [x] Rewarded ad para vida.
- [x] Premium nao depende de anuncio.
- [x] Mutacoes de creditos dev/mock isoladas.
- [x] Nao simular cobranca real sem loja.

## 9. Perfil

- [x] Mostra nome/email.
- [x] Mostra status Premium/Gratuito.
- [x] Mostra estrelas, creditos e vidas.
- [x] Restaurar compras explicado.
- [x] Sair da conta funciona.
- [x] Nao mostra dados tecnicos.

## 10. Monetizacao

- [x] Banners apenas onde decidido.
- [x] Interstitial apenas em transicao.
- [x] Nenhum anuncio durante pergunta.
- [x] Premium remove anuncios.
- [x] Store continua mock/dev.
- [x] Paywall continua mock/dev.
- [x] Nenhum dinheiro real cobrado ainda.
- [x] Precos visuais revisados:
  - Premium mensal: R$ 7,99
  - Premium anual: R$ 59,90
  - Creditos 10/50/150 conforme definido.

## 11. UI/UX mobile

- [x] Sem overflow.
- [x] Botoes com largura consistente.
- [x] CTAs com respiro.
- [x] SafeArea revisado.
- [x] Teste em tela pequena Android.
- [x] Banners sem cobrir conteudo.
- [x] Textos nao cortados.
- [x] Tema biblico/premium consistente.
- [x] Icone e splash funcionando.
- [x] Nome correto: Saber Cristao.

## 12. Seguranca minima

- [x] `launch.json` ignorado no Git.
- [x] Anon key nao deve aparecer completa em log.
- [x] `service_role` nunca no app.
- [x] Compras/premium/creditos reais nao concedidos pelo client em producao.
- [x] Avisos de seguranca documentados como `SECURITY BEFORE PRODUCTION`.
- [x] RLS revisado.

## 13. Build Android

- [x] Package name: `com.sabercristao.app`.
- [x] `applicationId` correto.
- [x] `namespace` correto.
- [x] `AndroidManifest` correto.
- [x] Permissao `INTERNET` presente.
- [x] AdMob App ID de teste configurado.
- [x] Deep links configurados.
- [x] Build debug funcionando.
- [x] Futuro `appbundle` release preparado.
- [x] APK instala e abre.

## Top 20 riscos antes da Play Store

### P0 - Bloqueador

1. Validacao de compra real ainda sem Edge Function final.
2. Revisao humana de perguntas doutrinarias sensiveis ainda pendente.
3. Checklist final de publicacao de loja ainda nao concluido.

### P1 - Importante

4. Confirmar estabilidade do Google Login em rede movel real.
5. Confirmar reset de senha ponta a ponta em device real.
6. Confirmar `user_level_progress` em todos os niveis iniciais.
7. Confirmar anuncios de teste em Android real sem poluir a UI.
8. Confirmar restaurar compras em novo aparelho.
9. Confirmar restore e premium apos reinstalacao.
10. Confirmar limites de frequencia dos interstitials.
11. Confirmar desempenho com a base ampliada de perguntas.
12. Confirmar que nenhuma rota tecnica aparece ao usuario.

### P2 - Melhorar depois

13. Expandir analytics e funil comercial.
14. Refinar a experiencia visual do mapa de fases.
15. Adicionar mais revisao editorial por tema.
16. Preparar localizacao pt/es/en completa.
17. Preparar Play Store assets finais.
18. Expandir trilhas futuras e categorias.
19. Melhorar microanimacoes em telas-chave.
20. Acompanhar retencao e equilibrio das recompensas.
