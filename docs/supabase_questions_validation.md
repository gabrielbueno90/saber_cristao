# Validacao de Perguntas no Supabase

Use estas queries depois de rodar `database/v1_seed_questions.sql` e
`database/v2_seed_questions_expansion.sql`.

## Total esperado

O total esperado e pelo menos `110` perguntas em `pt-BR`.

```sql
select count(*) as total
from public.questions
where language = 'pt-BR';
```

## Total por categoria e dificuldade

```sql
select 
  category,
  difficulty,
  count(*) as total
from public.questions
where language = 'pt-BR'
group by category, difficulty
order by category, difficulty;
```

## Total por nivel e dificuldade

```sql
select
  level,
  difficulty,
  count(*) as total
from public.questions
where language = 'pt-BR'
group by level, difficulty
order by level, difficulty;
```

## Perguntas ativas e aprovadas usadas pelo app

```sql
select
  level,
  difficulty,
  count(*) as total
from public.questions
where language = 'pt-BR'
  and is_active = true
  and review_status = 'approved'
group by level, difficulty
order by level, difficulty;
```

## Confirmar que o app esta usando Supabase

Em modo debug, abra o quiz e confira:

- `Perguntas: Supabase`
- dificuldade esperada da fase
- quantidade esperada de perguntas

Se aparecer `Perguntas: mock`, verifique:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- RLS da tabela `questions`
- se existem perguntas com `is_active = true`
- se existem perguntas com `review_status = 'approved'`

## Regra atual de selecao

- Niveis `1` a `5`: `difficulty = 1`, com `5` perguntas por fase.
- Niveis `6` a `10`: `difficulty = 2`, com `7` perguntas por fase.
- Niveis `11` a `15`: `difficulty = 3`, com `10` perguntas por fase.

O app tenta buscar primeiro perguntas do nivel exato. Se faltarem perguntas,
ele completa com perguntas da mesma dificuldade. Se ainda assim nao houver
perguntas, usa fallback mock controlado em debug.

## Limitacao temporaria de progresso

Hoje `user_progress` guarda progresso agregado:

- `current_level`
- `total_stars`
- `total_score`
- `lives`
- `credits`

Ainda nao existe progresso por fase. Para preservar melhor estrela por fase e
historico de tentativas por nivel, criar futuramente a migration:

```sql
create table public.user_level_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  level integer not null,
  best_score integer not null default 0,
  best_stars integer not null default 0,
  completed boolean not null default false,
  attempts_count integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, level)
);
```
