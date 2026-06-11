# Question Bank Status

## Estado atual assumido

- Total atual de perguntas em pt-BR: `110`
- Nova expansao planejada: `640`
- Total esperado apos a seed: `750`

## Distribuicao final planejada da nova seed

| Categoria | Quantidade nova |
|---|---:|
| Antigo Testamento | 60 |
| Novo Testamento | 60 |
| Evangelhos | 60 |
| Personagens bíblicos | 45 |
| Parábolas | 35 |
| Doutrina cristã | 60 |
| Salvação, fé e graça | 60 |
| Cinco Solas | 40 |
| Reforma Protestante | 35 |
| Oração e vida cristã | 40 |
| Aliança e promessa | 35 |
| Igreja e sacramentos | 30 |
| Epístolas paulinas | 25 |
| Sabedoria bíblica | 25 |
| Profetas | 30 |

## Distribuicao por difficulty da nova seed

- `1` fácil: `220`
- `2` médio: `260`
- `3` difícil: `160`

## Distribuicao por level da nova seed

- Levels 1 a 5: cobertura forte de conteudo basico.
- Levels 6 a 10: cobertura media com conexao doutrinaria.
- Levels 11 a 15: cobertura dificil com teologia biblica e temas mais maduros.

## Observacoes de qualidade

- Perguntas doutrinarias sensiveis devem receber revisao humana.
- A base deve evitar duplicatas obvias.
- Explicacoes devem continuar curtas e edificantes.
- O app deve buscar por `language`, `level`, `difficulty`, `is_active` e `review_status`.

## Proximos passos

1. Rodar `database/v4_seed_questions_to_750.sql` no Supabase.
2. Conferir total final com query de contagem.
3. Validar duplicatas e campos vazios.
4. Revisar a amostragem doutrinaria com cuidado pastoral.
5. Rebuild do APK de teste se o banco novo alterar qualquer fluxo.
