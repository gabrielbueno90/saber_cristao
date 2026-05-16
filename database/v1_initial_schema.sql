-- Saber Cristao - V1 Initial Schema
-- Run this in Supabase SQL Editor first.

-- Extensions
create extension if not exists "pgcrypto";

-- =====================================================
-- 1) TABLES
-- =====================================================

create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  display_name text,
  email text,
  avatar_url text,
  auth_provider text,
  language text not null default 'pt-BR',
  country text,
  is_premium boolean not null default false,
  premium_until timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  language text not null,
  category text not null,
  difficulty integer not null check (difficulty between 1 and 5),
  level integer not null check (level >= 1),
  question_text text not null,
  option_a text not null,
  option_b text not null,
  option_c text not null,
  option_d text not null,
  correct_option text not null check (correct_option in ('A', 'B', 'C', 'D')),
  explanation text not null,
  bible_reference text,
  doctrine_tag text,
  review_status text not null check (review_status in ('draft', 'review', 'approved', 'archived')),
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.user_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  current_level integer not null default 1 check (current_level >= 1),
  total_stars integer not null default 0 check (total_stars >= 0),
  total_score integer not null default 0 check (total_score >= 0),
  lives integer not null default 5 check (lives >= 0),
  max_lives integer not null default 5 check (max_lives >= 1),
  credits integer not null default 0 check (credits >= 0),
  last_sync_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.quiz_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  level_id integer not null check (level_id >= 1),
  score integer not null default 0 check (score >= 0),
  stars integer not null default 0 check (stars between 0 and 3),
  correct_count integer not null default 0 check (correct_count >= 0),
  wrong_count integer not null default 0 check (wrong_count >= 0),
  used_continue boolean not null default false,
  completed boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.purchases (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  platform text not null check (platform in ('android', 'ios')),
  product_id text not null,
  transaction_id text,
  purchase_token text,
  status text not null check (status in ('pending', 'completed', 'failed', 'cancelled', 'refunded')),
  type text not null check (type in ('subscription', 'consumable')),
  amount integer not null default 0 check (amount >= 0),
  created_at timestamptz not null default now()
);

create table if not exists public.ad_rewards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  ad_type text not null,
  placement text,
  reward_type text not null check (reward_type in ('life', 'credit', 'hint', 'double_reward', 'continue')),
  reward_amount integer not null default 0 check (reward_amount >= 0),
  created_at timestamptz not null default now()
);

-- =====================================================
-- 2) INDEXES
-- =====================================================

create index if not exists idx_profiles_user_id on public.profiles(user_id);
create index if not exists idx_profiles_email on public.profiles(email);

create index if not exists idx_questions_lang_active_review_level
  on public.questions(language, is_active, review_status, level);
create index if not exists idx_questions_category on public.questions(category);
create index if not exists idx_questions_difficulty on public.questions(difficulty);

create index if not exists idx_user_progress_user_id on public.user_progress(user_id);

create index if not exists idx_quiz_attempts_user_created
  on public.quiz_attempts(user_id, created_at desc);
create index if not exists idx_quiz_attempts_level on public.quiz_attempts(level_id);

create index if not exists idx_purchases_user_created
  on public.purchases(user_id, created_at desc);
create unique index if not exists idx_purchases_transaction_unique
  on public.purchases(transaction_id)
  where transaction_id is not null;

create index if not exists idx_ad_rewards_user_created
  on public.ad_rewards(user_id, created_at desc);

-- =====================================================
-- 3) TRIGGERS (updated_at)
-- =====================================================

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_profiles_set_updated_at on public.profiles;
create trigger trg_profiles_set_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();

drop trigger if exists trg_user_progress_set_updated_at on public.user_progress;
create trigger trg_user_progress_set_updated_at
before update on public.user_progress
for each row
execute function public.set_updated_at();

-- =====================================================
-- 4) RLS
-- =====================================================

alter table public.profiles enable row level security;
alter table public.questions enable row level security;
alter table public.user_progress enable row level security;
alter table public.quiz_attempts enable row level security;
alter table public.purchases enable row level security;
alter table public.ad_rewards enable row level security;

-- =====================================================
-- 5) POLICIES
-- =====================================================

-- Profiles: read/insert own, update own excluding premium fields
drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
on public.profiles
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
on public.profiles
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "profiles_update_own_safe" on public.profiles;
create policy "profiles_update_own_safe"
on public.profiles
for update
to authenticated
using (auth.uid() = user_id)
with check (
  auth.uid() = user_id
  and is_premium = (select p.is_premium from public.profiles p where p.id = profiles.id)
  and premium_until is not distinct from (select p.premium_until from public.profiles p where p.id = profiles.id)
);

-- Questions: authenticated users can read only active + approved
drop policy if exists "questions_select_active_approved" on public.questions;
create policy "questions_select_active_approved"
on public.questions
for select
to authenticated
using (is_active = true and review_status = 'approved');

-- No insert/update/delete policy for authenticated users on questions.
-- That means users cannot write questions from client.

-- User progress: own read/insert/update
drop policy if exists "user_progress_select_own" on public.user_progress;
create policy "user_progress_select_own"
on public.user_progress
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "user_progress_insert_own" on public.user_progress;
create policy "user_progress_insert_own"
on public.user_progress
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "user_progress_update_own" on public.user_progress;
create policy "user_progress_update_own"
on public.user_progress
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- TODO: move credits/premium-sensitive mutations to Edge Functions in production.

-- Quiz attempts: own read + own insert only
drop policy if exists "quiz_attempts_select_own" on public.quiz_attempts;
create policy "quiz_attempts_select_own"
on public.quiz_attempts
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "quiz_attempts_insert_own" on public.quiz_attempts;
create policy "quiz_attempts_insert_own"
on public.quiz_attempts
for insert
to authenticated
with check (auth.uid() = user_id);

-- No update/delete policies for quiz_attempts.

-- Purchases: own read only
drop policy if exists "purchases_select_own" on public.purchases;
create policy "purchases_select_own"
on public.purchases
for select
to authenticated
using (auth.uid() = user_id);

-- No insert/update/delete policies for purchases from client.
-- TODO: insert/update purchases via secure backend validation (Edge Function).

-- Ad rewards: own read only
drop policy if exists "ad_rewards_select_own" on public.ad_rewards;
create policy "ad_rewards_select_own"
on public.ad_rewards
for select
to authenticated
using (auth.uid() = user_id);

-- Optional DEV-ONLY policy for ad reward insert from client:
-- (leave commented in production)
-- create policy "ad_rewards_insert_own_dev_only"
-- on public.ad_rewards
-- for insert
-- to authenticated
-- with check (auth.uid() = user_id);

