# Question Bank Review

Revisao da base de perguntas em pt-BR antes da expansao para 750 total.

## Escopo

- Confirmar contagem atual.
- Encontrar duplicatas.
- Identificar perguntas sem referencia ou explicacao.
- Revisar categorias e niveis com menor cobertura.
- Marcar pontos que exigem revisao humana/pastoral.

## Queries de validacao

### Total atual

```sql
select count(*) as total
from public.questions
where language = 'pt-BR';
```

### Por categoria

```sql
select category, count(*) as total
from public.questions
where language = 'pt-BR'
group by category
order by category;
```

### Por difficulty

```sql
select difficulty, count(*) as total
from public.questions
where language = 'pt-BR'
group by difficulty
order by difficulty;
```

### Por level

```sql
select level, difficulty, count(*) as total
from public.questions
where language = 'pt-BR'
group by level, difficulty
order by level, difficulty;
```

### Duplicatas

```sql
select question_text, count(*) as total
from public.questions
where language = 'pt-BR'
group by question_text
having count(*) > 1
order by total desc;
```

### Alternativa correta invalida

```sql
select id, question_text, correct_option
from public.questions
where language = 'pt-BR'
and correct_option not in ('A','B','C','D');
```

### Sem referencia ou explicacao

```sql
select id, question_text, explanation, bible_reference
from public.questions
where language = 'pt-BR'
and (
  explanation is null
  or trim(explanation) = ''
  or bible_reference is null
  or trim(bible_reference) = ''
);
```

## Pontos de revisao humana

- Perguntas doutrinarias sensiveis.
- Perguntas de Reforma Protestante.
- Perguntas sobre sacramentos.
- Perguntas sobre eleicao, perseveranca e soberania divina.
- Perguntas com linguagem historica ou teologica mais tecnica.
