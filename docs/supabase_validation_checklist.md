# Supabase Validation Checklist

## 1) Auth real
1. Rodar o app com `SUPABASE_URL` e `SUPABASE_ANON_KEY`.
2. Na tela de login em debug, confirmar o chip `Supabase conectado`.
3. Criar conta com email e senha.
4. Fazer logout.
5. Fazer login com a mesma conta.
6. Fechar e reabrir o app para validar persistência da sessão.
7. Testar `Esqueci minha senha`.

Esperado:
- cadastro, login e logout funcionando;
- sessão persistida;
- profile criado automaticamente na tabela `profiles`.

## 2) Fallback mock
1. Rodar o app sem `SUPABASE_URL` ou `SUPABASE_ANON_KEY`.
2. Confirmar o chip `Modo mock`.

Esperado:
- auth entra no fallback local/mock;
- quiz continua funcionando;
- perguntas usam fallback mock.

## 3) Perguntas reais
1. Estar autenticado no modo real.
2. Abrir um quiz.
3. Em debug, verificar `Perguntas: Supabase`.

Esperado:
- filtro aplicado em `questions`:
  - `language = 'pt-BR'`
  - `is_active = true`
  - `review_status = 'approved'`
- se não houver perguntas ou houver erro, deve aparecer fallback controlado:
  - `Perguntas: mock`
  - aviso amigável em debug.

## 4) user_progress
1. Fazer login com usuário novo.
2. Entrar na Home.
3. Confirmar criação de `user_progress` se ainda não existir.
4. Jogar uma fase.
5. Voltar para Home.
6. Fazer logout/login.

Esperado:
- `current_level`, `total_stars` e `total_score` persistem;
- `lives` e `credits` sincronizam;
- Home mostra em debug `Progresso: Remoto` quando o dado já está sincronizado.

## 5) Quiz attempts
1. Finalizar um quiz.
2. Verificar tabela `quiz_attempts`.

Esperado:
- um registro por conclusão;
- campos salvos:
  - `user_id`
  - `level_id`
  - `score`
  - `stars`
  - `correct_count`
  - `wrong_count`
  - `completed = true`
- recarregar ou voltar na tela não deve criar duplicidade imediata.

## 6) Vidas e créditos
1. Errar uma resposta e verificar se vida diminui.
2. Ir para `Sem vidas` e recuperar vida.
3. Comprar crédito fake na loja.
4. Gastar crédito em `Sem vidas`.

Esperado:
- vidas e créditos atualizam no app;
- em modo real, sincronizam com `user_progress`;
- créditos ainda são mutáveis pelo client apenas como limitação temporária de dev.

## 7) RLS manual
Validar manualmente no Supabase:
- usuário A não lê `profiles` de B;
- usuário A não lê `user_progress` de B;
- usuário A não lê `quiz_attempts` de B;
- usuário comum não insere/edita `questions`;
- usuário comum não insere/edita `purchases`;
- usuário comum não altera `is_premium` e `premium_until`.

## 8) Dados que você deve ver no Supabase
- `profiles`: um registro por usuário autenticado.
- `user_progress`: um registro por usuário.
- `quiz_attempts`: uma linha por quiz concluído.
- `questions`: seed aprovada e ativa.

## 9) Limitações temporárias
- créditos ainda podem ser alterados no client em dev;
- recompensas de anúncio ainda não passam por backend;
- compras ainda não passam por backend;
- premium ainda não é concedido por fluxo seguro de produção.
