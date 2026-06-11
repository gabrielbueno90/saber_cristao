-- Saber Cristao - V5 Question Indexes for Quiz Queries
-- Optimizes the exact quiz lookup and the fallback-by-difficulty lookup.

create index if not exists idx_questions_active_approved_lang_level_difficulty
  on public.questions (language, level, difficulty)
  where is_active = true and review_status = 'approved';

create index if not exists idx_questions_active_approved_lang_difficulty
  on public.questions (language, difficulty)
  where is_active = true and review_status = 'approved';
