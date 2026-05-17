# Supabase Validation Checklist (Auth, Profile, Questions, Progress, Attempts)

## 1) Auth real
1. Rodar o app com `SUPABASE_URL` e `SUPABASE_ANON_KEY`.
2. Criar conta com email/senha.
3. Fazer logout e login novamente.
4. Fechar e reabrir app para validar persistência de sessão.
5. Testar "Esqueci minha senha".

Esperado:
- Login/register/logout funcionando.
- Sessão persistida.
- Registro em `profiles` criado/atualizado automaticamente.

## 2) Identificar modo real vs mock
No app, em debug:
- Login e Home exibem chip:
  - `Supabase conectado` (modo real)
  - `Modo mock` (fallback)
- Quiz exibe:
  - `Perguntas: Supabase`
  - `Perguntas: mock`

## 3) Perguntas reais
Confirme no Supabase `questions`:
- `language = 'pt-BR'`
- `is_active = true`
- `review_status = 'approved'`

Esperado:
- Quiz carrega perguntas do Supabase com esses filtros.
- Sem perguntas ou erro => fallback mock com aviso amigável em debug.

## 4) Progresso real
1. Login.
2. Jogar quiz até resultado.
3. Voltar Home.
4. Logout/login.

Esperado:
- `user_progress` criado se não existir.
- `current_level`, `total_stars`, `total_score` persistem.
- `lives` e `credits` sincronizam em eventos-chave.

## 5) Attempts reais
Ao concluir quiz:
- Deve inserir em `quiz_attempts`:
  - `user_id`, `level_id`, `score`, `stars`, `correct_count`, `wrong_count`, `completed`.
- Não deve duplicar attempt por clique repetido no resultado.

## 6) RLS manual (SQL Editor)
Teste no SQL Editor com JWT de usuário autenticado via app (ou usando API tester autenticado):

Verificações esperadas:
- usuário A não lê `profiles` de B
- usuário A não lê `user_progress` de B
- usuário A não lê `quiz_attempts` de B
- usuário comum não faz `insert/update/delete` em `questions`
- usuário comum não altera `is_premium`/`premium_until` em `profiles`
- usuário comum não escreve em `purchases`

## 7) TODOs de segurança (temporário)
- `credits` ainda pode mudar pelo client em modo dev/mock.
- Em produção, migrar mutações de créditos/recompensas/compras para Edge Functions com validação server-side.
