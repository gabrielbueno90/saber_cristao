create table if not exists public.user_level_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  level integer not null,
  best_score integer not null default 0,
  best_stars integer not null default 0,
  completed boolean not null default false,
  attempts_count integer not null default 0,
  last_played_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint user_level_progress_user_level_unique unique (user_id, level)
);

create index if not exists idx_user_level_progress_user_id
  on public.user_level_progress (user_id);

create index if not exists idx_user_level_progress_level
  on public.user_level_progress (level);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_user_level_progress_updated_at on public.user_level_progress;

create trigger trg_user_level_progress_updated_at
before update on public.user_level_progress
for each row
execute function public.set_updated_at();

alter table public.user_level_progress enable row level security;

drop policy if exists "user_level_progress_select_own" on public.user_level_progress;
create policy "user_level_progress_select_own"
on public.user_level_progress
for select
using (auth.uid() = user_id);

drop policy if exists "user_level_progress_insert_own" on public.user_level_progress;
create policy "user_level_progress_insert_own"
on public.user_level_progress
for insert
with check (auth.uid() = user_id);

drop policy if exists "user_level_progress_update_own" on public.user_level_progress;
create policy "user_level_progress_update_own"
on public.user_level_progress
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
