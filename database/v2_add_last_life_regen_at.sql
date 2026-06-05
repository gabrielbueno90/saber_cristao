-- Saber Cristao - Migration: add last_life_regen_at

alter table public.user_progress
  add column if not exists last_life_regen_at timestamptz;
