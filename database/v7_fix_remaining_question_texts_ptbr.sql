-- Ajustes residuais apos v6
-- Escopo: enunciados pt-BR ainda com estrutura "De forma mais precisa, o que como..."

begin;

update public.questions
set question_text = case question_text
  when 'De forma mais precisa, o que como os salvos passam a ser filhos de Deus em Cristo?' then 'De forma mais precisa, como chamamos a realidade pela qual os salvos passam a ser filhos de Deus em Cristo?'
  when 'De forma mais precisa, o que como os crentes participam dos benefícios da morte e ressurreição de Jesus?' then 'De forma mais precisa, como chamamos a realidade pela qual os crentes participam dos benefícios da morte e ressurreição de Jesus?'
  when 'De forma mais precisa, o que como somos justificados somente pela fé?' then 'De forma mais precisa, qual sola ensina que somos justificados somente pela fé?'
  when 'De forma mais precisa, o que como a salvação é pela graça de Deus, não por mérito humano?' then 'De forma mais precisa, qual sola ensina que a salvação é pela graça de Deus, não por mérito humano?'
  when 'De forma mais precisa, o que como o batismo aponta para a união do crente com Cristo em sua morte e ressurreição?' then 'De forma mais precisa, que prática aponta para a união do crente com Cristo em sua morte e ressurreição?'
  when 'De forma mais precisa, o que como a Ceia do Senhor anuncia a morte de Cristo até que ele venha?' then 'De forma mais precisa, que prática anuncia a morte de Cristo até que ele venha?'
  when 'De forma mais precisa, o que como a igreja é o corpo de Cristo e precisa de cuidado ordenado?' then 'De forma mais precisa, que realidade é descrita como o corpo de Cristo e precisa de cuidado ordenado?'
  when 'De forma mais precisa, o que como presbíteros e diáconos servem a igreja com responsabilidade e ordem?' then 'De forma mais precisa, como chamamos o modelo em que presbíteros e diáconos servem a igreja com responsabilidade e ordem?'
  when 'De forma mais precisa, o que como Deus usa Palavra, oração e sacramentos como meios de graça?' then 'De forma mais precisa, como chamamos a forma pela qual Deus usa Palavra, oração e sacramentos para edificar seu povo?'
  else question_text
end
where language = 'pt-BR'
  and is_active = true
  and review_status = 'approved'
  and question_text in (
    'De forma mais precisa, o que como os salvos passam a ser filhos de Deus em Cristo?',
    'De forma mais precisa, o que como os crentes participam dos benefícios da morte e ressurreição de Jesus?',
    'De forma mais precisa, o que como somos justificados somente pela fé?',
    'De forma mais precisa, o que como a salvação é pela graça de Deus, não por mérito humano?',
    'De forma mais precisa, o que como o batismo aponta para a união do crente com Cristo em sua morte e ressurreição?',
    'De forma mais precisa, o que como a Ceia do Senhor anuncia a morte de Cristo até que ele venha?',
    'De forma mais precisa, o que como a igreja é o corpo de Cristo e precisa de cuidado ordenado?',
    'De forma mais precisa, o que como presbíteros e diáconos servem a igreja com responsabilidade e ordem?',
    'De forma mais precisa, o que como Deus usa Palavra, oração e sacramentos como meios de graça?'
  );

commit;

-- Validacao
-- select id, level, difficulty, question_text
-- from public.questions
-- where language = 'pt-BR'
--   and question_text ilike 'De forma mais precisa, o que como%';
