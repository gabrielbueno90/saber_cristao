# Go Live Checklist - Saber Cristao

Status permitidos: `Nao iniciado`, `Em andamento`, `Bloqueado`, `Pronto`.

| Area | Item | Status | Responsavel | Observacao | Proxima acao |
| --- | --- | --- | --- | --- | --- |
| Produto/App | Package name final definido | Pronto | Dev | `com.sabercristao.app` aplicado | Validar em build Android local |
| Produto/App | Nome do app definido | Pronto | Produto/Dev | `Saber Cristao` no app e `Saber Cristao` no Android label | Revisar naming final de branding nas lojas |
| Produto/App | Tema visual aprovado | Pronto | Produto/Design | Identidade biblica premium aplicada | Ajustes finos apos testes em devices reais |
| Produto/App | Login funcionando | Pronto | Dev | Fluxo com Supabase ativo | Revalidar em Android fisico |
| Produto/App | Home funcionando | Pronto | Dev | Home premium + estado remoto/debug | Validar ergonomia em telas pequenas |
| Produto/App | Quiz funcionando | Pronto | Dev | Selecao por nivel/dificuldade ativa | Expandir banco para niveis 11-15 |
| Produto/App | Progresso funcionando | Pronto | Dev | `user_progress` com sync remoto | Evoluir para progresso por fase futuramente |
| Produto/App | Store funcionando | Pronto | Dev | Fluxo visual e servico de compras preparados | Conectar compra sandbox real |
| Produto/App | Paywall funcionando | Pronto | Dev | Tela comercial + restore estruturado | Ligar em validacao real de compra |
| Produto/App | OutOfLives funcionando | Pronto | Dev | Fluxo de conversao com rewarded/credito | Validar UX em Android real |
| Produto/App | Botoes de voltar revisados | Pronto | Dev | Rotas secundarias com retorno claro | Revalidar em fluxo completo |
| Produto/App | Build Android debug gerando | Em andamento | Dev | Ambiente local do agente bloqueou build | Rodar `flutter build apk --debug` localmente |
| Supabase | Tabelas criadas | Pronto | Dev | Schema V1 aplicado | Revisao final antes de producao |
| Supabase | RLS ativado | Pronto | Dev | RLS configurado nas tabelas principais | Revisar policies apos Edge Functions |
| Supabase | Auth email/senha funcionando | Pronto | Dev | Fluxo real validado | Retestar com usuarios novos |
| Supabase | Google OAuth configurado | Em andamento | Dev | Estrutura pronta, depende de console/provedor | Finalizar credenciais e redirects |
| Supabase | Profiles funcionando | Pronto | Dev | Criacao/atualizacao automatica ativa | Auditar campos opcionais |
| Supabase | User progress funcionando | Pronto | Dev | Leitura/escrita remota funcionando | Migrar logica sensivel para backend |
| Supabase | Questions funcionando | Pronto | Dev | Filtro por idioma/nivel/dificuldade ativo | Aumentar volume por nivel dificil |
| Supabase | Quiz attempts funcionando | Pronto | Dev | Gravacao de tentativas ativa | Adicionar paines de auditoria futuramente |
| Supabase | Seeds aplicadas | Pronto | Dev | V1 + V2 aplicados | Planejar V3 |
| Supabase | 110 perguntas confirmadas | Pronto | Produto/Dev | Confirmado no dashboard | Manter query de auditoria semanal |
| Supabase | Proxima expansao de perguntas planejada | Em andamento | Conteudo/Dev | Necessario reforco nivel 11-15 | Criar `v3_seed_questions_expansion.sql` |
| Conteudo | 100+ perguntas pt-BR | Pronto | Conteudo | Base inicial robusta ativa | Aumentar cobertura de fases dificeis |
| Conteudo | Revisao biblica/doutrinaria inicial | Em andamento | Conteudo | Revisao inicial feita, ainda nao completa | Rodada editorial por categoria |
| Conteudo | Guia editorial criado | Pronto | Conteudo | Documento de padrao ja existe | Usar em toda nova seed |
| Conteudo | Niveis 1 a 15 com perguntas | Em andamento | Conteudo | Niveis 11-15 com baixa densidade | Completar 10 perguntas por fase dificil |
| Conteudo | Reforcar niveis 11 a 15 | Nao iniciado | Conteudo | Gap atual para regra de 10 perguntas | Criar lote dedicado de perguntas dificeis |
| Conteudo | Planejar 300 perguntas | Em andamento | Conteudo/Produto | Estrategia definida, execucao pendente | Planejar lotes V3-V5 |
| Conteudo | Planejar traducao espanhol | Nao iniciado | Conteudo | Sem banco `es` ainda | Definir glossario + lote inicial |
| Conteudo | Planejar traducao ingles | Nao iniciado | Conteudo | Sem banco `en` ainda | Definir glossario + lote inicial |
| Monetizacao - Ads | Camada AdMob criada | Pronto | Dev | Servicos e regras centralizadas | Validar em Android real |
| Monetizacao - Ads | IDs de teste configurados | Pronto | Dev | Fluxo de teste preparado | Verificar exibicao em device |
| Monetizacao - Ads | Banner responsivo | Pronto | Dev | Slot responsivo em telas permitidas | QA em multiplas resolucoes |
| Monetizacao - Ads | Interstitial com frequencia controlada | Pronto | Dev | Frequencia inicial implementada | Ajustar por dados reais |
| Monetizacao - Ads | Rewarded em OutOfLives | Pronto | Dev | Fluxo integrado | Teste real Android/iOS |
| Monetizacao - Ads | Premium bloqueia ads | Pronto | Dev | Regra aplicada via monetization state | Validar com conta premium real |
| Monetizacao - Ads | AdMob real criado | Nao iniciado | Produto/Dev | Falta cadastro de app/ad units reais | Criar app no AdMob |
| Monetizacao - Ads | Ad units reais criadas | Nao iniciado | Produto/Dev | Apenas teste no momento | Criar unidades por plataforma |
| Monetizacao - Ads | IDs reais por ambiente configurados | Nao iniciado | Dev | Falta variaveis de prod/staging | Implementar config por ambiente |
| Monetizacao - Ads | Consentimento LGPD/GDPR pendente | Nao iniciado | Produto/Dev | Necessario antes de escalar | Escolher CMP e integrar consentimento |
| Monetizacao - Compras | PurchaseService criado | Pronto | Dev | Camada de compras implementada | Validar sandbox com produtos reais |
| Monetizacao - Compras | Product IDs definidos | Pronto | Dev | IDs padronizados no app | Espelhar exatamente nas lojas |
| Monetizacao - Compras | Paywall visual pronto | Pronto | Produto/Dev | Tela pronta para conversao | Refinar copy com preco real |
| Monetizacao - Compras | Store visual pronta | Pronto | Produto/Dev | Tela pronta para consumiveis | Integrar retorno de compra real |
| Monetizacao - Compras | Produtos Google Play criados | Nao iniciado | Produto | Nao criado no console ainda | Criar consumiveis e assinaturas |
| Monetizacao - Compras | Assinaturas criadas | Nao iniciado | Produto | Dependente de Play Console | Criar `premium_monthly/yearly` |
| Monetizacao - Compras | Consumiveis criados | Nao iniciado | Produto | Dependente de Play Console | Criar `credits_10/50/150` |
| Monetizacao - Compras | License testers configurados | Nao iniciado | Produto | Necessario para sandbox Android | Adicionar contas de teste |
| Monetizacao - Compras | Compra sandbox testada | Nao iniciado | Dev/Produto | Sem produto publicado em teste interno | Publicar build em internal testing |
| Monetizacao - Compras | Restore purchases testado | Nao iniciado | Dev/Produto | Fluxo pronto, nao validado no device | Testar com assinatura sandbox |
| Monetizacao - Compras | Edge Function validate_purchase criada | Pronto | Dev | Skeleton seguro criado | Evoluir para validacao real da loja |
| Monetizacao - Compras | Validacao real Google Play pendente | Bloqueado | Dev | Bloqueado por credenciais/produtos loja | Integrar API Google Play na Edge Function |
| Google Play Console | Conta de desenvolvedor criada | Em andamento | Produto | Status nao confirmado no projeto | Confirmar conta ativa |
| Google Play Console | App criado | Nao iniciado | Produto | Ainda nao confirmado | Criar app no console |
| Google Play Console | Package name configurado | Nao iniciado | Produto | Package final pronto no app, falta console | Criar app com `com.sabercristao.app` |
| Google Play Console | Payments profile configurado | Nao iniciado | Produto/Financeiro | Sem confirmacao | Configurar perfil de pagamentos |
| Google Play Console | Conta bancaria configurada | Nao iniciado | Financeiro | Sem confirmacao | Vincular conta bancaria |
| Google Play Console | Pais Brasil selecionado | Nao iniciado | Produto | Sem confirmacao | Definir disponibilidade BR inicial |
| Google Play Console | Classificacao indicativa | Nao iniciado | Produto | Sem confirmacao | Preencher questionario |
| Google Play Console | Politica de privacidade | Em andamento | Produto/Dev | Documento base existe, falta publicacao final | Publicar URL definitiva na loja |
| Google Play Console | Descricao curta | Nao iniciado | Produto | Sem texto final de loja | Preparar copy PT-BR |
| Google Play Console | Descricao completa | Nao iniciado | Produto | Sem texto final de loja | Preparar copy PT-BR |
| Google Play Console | Screenshots | Nao iniciado | Produto/Design | Ainda nao produzidas para loja | Capturar fluxo final Android |
| Google Play Console | Icone | Em andamento | Design | Base existe, sem validacao final de loja | Finalizar assets 512x512 |
| Google Play Console | Feature graphic | Nao iniciado | Design | Ausente | Criar arte 1024x500 |
| Google Play Console | Teste interno criado | Nao iniciado | Produto | Ainda nao configurado | Criar `Internal testing` |
| Google Play Console | Build enviado | Nao iniciado | Dev | Sem APK/AAB validado no console | Subir primeiro AAB |
| Google Play Console | Testadores adicionados | Nao iniciado | Produto | Sem trilha criada | Adicionar lista de testers |
| Internacionalizacao | Estrategia Brasil primeiro | Pronto | Produto | Definida em documentacao | Executar plano BR |
| Internacionalizacao | Paises de lingua portuguesa planejados | Pronto | Produto | Ordem definida | Priorizar apos BR |
| Internacionalizacao | Espanhol planejado | Pronto | Produto | Ordem definida | Preparar conteudo `es` |
| Internacionalizacao | Ingles planejado | Pronto | Produto | Ordem definida | Preparar conteudo `en` |
| Internacionalizacao | UI preparada para i18n | Em andamento | Dev | Estrutura parcial; traducoes completas pendentes | Implementar localizations completas |
| Internacionalizacao | Banco questions preparado por language | Pronto | Dev | Campo `language` ativo | Inserir `es/en` gradualmente |
| Internacionalizacao | Textos da loja pt-BR | Em andamento | Produto | Base em elaboracao | Fechar copy de release BR |
| Internacionalizacao | Textos da loja es | Nao iniciado | Produto | Nao iniciado | Produzir versao ES |
| Internacionalizacao | Textos da loja en | Nao iniciado | Produto | Nao iniciado | Produzir versao EN |
| Seguranca | service_role fora do app | Pronto | Dev | Nao exposto no Flutter | Manter politica |
| Seguranca | launch.json ignorado no Git | Pronto | Dev | Arquivo real local ignorado | Manter rotina de revisao |
| Seguranca | RLS revisado | Em andamento | Dev | RLS ativo, hardening adicional pendente | Revisao apos Edge Functions finais |
| Seguranca | Premium nao editavel pelo client | Em andamento | Dev | Restricao parcial; modo dev ainda existe | Remover mutacao client em prod |
| Seguranca | Purchases bloqueado para client | Em andamento | Dev | Tabela protegida, fluxo real ainda pendente | Consolidar apenas via Edge Function |
| Seguranca | Ad rewards controlado | Em andamento | Dev | Controle inicial existe | Migrar concessao para backend |
| Seguranca | Credits ainda dev/client | Bloqueado | Dev | Limite atual assumido em dev | Mover para `spend_credit` backend |
| Seguranca | Migrar creditos para Edge Function | Nao iniciado | Dev | Planejado | Implementar funcao segura |
| Seguranca | Migrar premium para Edge Function | Nao iniciado | Dev | Planejado | Integrar `validate_purchase` completa |
| Seguranca | Validar compras no backend | Em andamento | Dev | Skeleton criado | Validacao Google/Apple real |
| Build e Testes | Rodar no Chrome | Pronto | Dev | Fluxo principal validado | Regressao apos cada release |
| Build e Testes | Rodar no Android Emulator | Em andamento | Dev | Necessita rodada final com package novo | Executar smoke test completo |
| Build e Testes | Rodar em celular fisico | Nao iniciado | Dev/Produto | Ainda pendente | Testar em 1-2 aparelhos reais |
| Build e Testes | Gerar APK debug | Em andamento | Dev | Processo bloqueado no ambiente do agente | Rodar localmente e arquivar build |
| Build e Testes | Gerar AAB release | Nao iniciado | Dev | Falta assinatura/release config | Preparar keystore e build |
| Build e Testes | Testar login real | Pronto | Dev | Validado com Supabase | Retestar em Android |
| Build e Testes | Testar quiz real | Pronto | Dev | Perguntas reais carregando | Revalidar niveis 11-15 apos expansao |
| Build e Testes | Testar progresso real | Pronto | Dev | Sync remoto ativo | Testar multi-sessao Android |
| Build e Testes | Testar anuncios teste | Em andamento | Dev | Estrutura pronta, precisa rodada em device | Validar banner/interstitial/rewarded |
| Build e Testes | Testar compras sandbox | Nao iniciado | Dev/Produto | Depende de produtos na loja | Criar produtos e testar internal |
| Build e Testes | Testar logout/login | Pronto | Dev | Fluxo funcional | Rodada regressiva final |
| Build e Testes | Testar tela pequena | Em andamento | Dev | Ajustes principais feitos | QA em 360/375/390/412 px |
| Build e Testes | Testar modo premium | Em andamento | Dev | Simulacao dev existe | Validar premium real via compra |
| Lancamento Android Brasil | Checklist tecnico pronto | Em andamento | Dev | Faltam build Android e QA final | Fechar smoke test em emulator/device |
| Lancamento Android Brasil | Checklist monetizacao pronto | Em andamento | Dev/Produto | Faltam produtos loja + sandbox validado | Concluir IAP/Ads teste com console |
| Lancamento Android Brasil | Checklist loja pronto | Nao iniciado | Produto | Metadados/arte ainda pendentes | Preencher listing completo |
| Lancamento Android Brasil | Teste interno aprovado | Nao iniciado | Produto/QA | Sem trilha ativa ainda | Criar e validar internal testing |
| Lancamento Android Brasil | Teste fechado aprovado | Nao iniciado | Produto/QA | Etapa posterior ao interno | Planejar closed test curto |
| Lancamento Android Brasil | Ajustes finais | Nao iniciado | Time | Depende de testes internos | Consolidar feedback |
| Lancamento Android Brasil | Publicacao producao Brasil | Nao iniciado | Produto | Etapa final | Submeter release BR |

## Top 10 bloqueadores para lancamento

1. Build Android debug/AAB ainda nao fechado em pipeline local confirmado.
2. Produtos reais de compra (assinaturas e consumiveis) ainda nao criados no Google Play.
3. `Internal testing` ainda nao configurado no Play Console.
4. Compra sandbox ainda nao validada de ponta a ponta em Android.
5. `validate_purchase` ainda e skeleton sem validacao real Google Play.
6. Creditos ainda com mutacao client-side em fluxo dev.
7. Premium ainda depende de logica dev em parte do fluxo.
8. AdMob real (app/ad units/pagamentos) ainda nao configurado.
9. Metadados de loja (descricao, screenshots, feature graphic) ainda incompletos.
10. Conteudo de niveis 11 a 15 ainda abaixo da meta de 10 perguntas por fase dificil.

## Proximas 5 acoes recomendadas

1. Fechar build Android local: `flutter clean`, `flutter pub get`, `flutter build apk --debug`, `flutter build appbundle --release`.
2. Criar app e produtos no Google Play Console (`premium_monthly`, `premium_yearly`, `credits_10/50/150`) + `license testers`.
3. Publicar build em `Internal testing` e validar compras sandbox + restore.
4. Configurar AdMob real (conta, app, ad units, pagamentos) mantendo IDs de teste fora de producao ate QA final.
5. Expandir conteudo para niveis 11-15 (meta: 10 perguntas por fase) com nova seed versionada.

## Ordem pratica para chegar ao primeiro dinheiro

1. Gerar build Android
2. Criar app no Play Console
3. Configurar AdMob
4. Configurar produtos in-app
5. Publicar em teste interno
6. Validar compra sandbox
7. Validar anuncios de teste
8. Publicar Android Brasil
