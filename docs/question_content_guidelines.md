# Diretrizes de Conteúdo de Perguntas

Este documento define o padrão editorial inicial para as perguntas do `Saber Cristão`.

## Objetivo

Produzir perguntas bíblicas e doutrinárias:
- claras,
- fiéis às Escrituras,
- acessíveis ao público geral,
- coerentes com uma perspectiva cristã protestante reformada,
- adequadas para um jogo curto, progressivo e comercial.

## Schema obrigatório

Toda pergunta da tabela `public.questions` deve preencher:

- `language`
- `category`
- `difficulty`
- `level`
- `question_text`
- `option_a`
- `option_b`
- `option_c`
- `option_d`
- `correct_option`
- `explanation`
- `bible_reference`
- `doctrine_tag`
- `review_status`
- `is_active`

## Padrão de escrita do enunciado

- Fazer perguntas curtas e diretas.
- Evitar enunciados longos demais.
- Usar linguagem simples, reverente e natural.
- Preferir uma única ideia por pergunta.
- Evitar formulações ambíguas ou duplas negativas.

Bom padrão:
- `Quem foi...`
- `Em qual cidade...`
- `Qual sola afirma...`
- `Segundo Romanos...`

Evitar:
- perguntas com mais de uma interpretação plausível;
- perguntas que dependam de tradição denominacional muito específica sem explicação;
- perguntas cuja resposta exija detalhe obscuro logo nos níveis iniciais.

## Padrão das alternativas

- Sempre 4 alternativas.
- Apenas 1 correta.
- Distratores plausíveis, mas não enganosos de forma injusta.
- Não usar alternativas absurdas demais.
- Não repetir a resposta correta com palavras quase idênticas em outra opção.

## Padrão das explicações

- Explicação curta, didática e objetiva.
- Ideal: 1 ou 2 frases.
- Deve reforçar aprendizado, não apenas repetir a resposta.
- Sempre que possível, apontar a lógica bíblica ou doutrinária da resposta.

Exemplo de bom padrão:
- `A salvação é dom da graça de Deus, recebida pela fé e não pelo mérito humano.`

## Categorias aceitas inicialmente

- `Antigo Testamento`
- `Novo Testamento`
- `Evangelhos`
- `Personagens bíblicos`
- `Doutrina cristã`
- `Cinco Solas`
- `Reforma Protestante`
- `Oração e vida cristã`
- `Parábolas`
- `Salvação, fé e graça`

## Difficulty

Usar:

- `1` = fácil
- `2` = média
- `3` = difícil

Critério prático:

### Fácil
- fatos bíblicos amplamente conhecidos;
- personagens e eventos básicos;
- doutrinas muito introdutórias.

### Média
- exige lembrar contexto, livro, ensino ou relação entre temas;
- pode envolver compreensão doutrinária básica.

### Difícil
- exige maior atenção ao contexto bíblico ou histórico;
- pode envolver formulação doutrinária mais refinada;
- ainda deve continuar justa e respondível.

## Level

Distribuição inicial esperada:

- `1` a `5`: perguntas fáceis
- `6` a `10`: perguntas médias
- `11` a `15`: perguntas difíceis

Regra:
- `level` e `difficulty` devem andar juntos.
- Não colocar pergunta difícil em nível inicial.

## doctrine_tag

Usar tags curtas e consistentes, por exemplo:

- `graca`
- `fe_salvadora`
- `trindade`
- `sola_scriptura`
- `sola_fide`
- `sola_gratia`
- `solus_christus`
- `soli_deo_gloria`
- `justificacao`
- `santificacao`
- `oracao`
- `misericordia`
- `teologia_reformada`

Regra:
- preferir `snake_case`;
- usar tags que ajudem filtragem futura e organização editorial.

## review_status

Valores aceitos:

- `draft`
- `review`
- `approved`
- `archived`

Uso recomendado:

- `draft`: pergunta criada, ainda sem revisão;
- `review`: pergunta em avaliação teológica/editorial;
- `approved`: pergunta revisada e pronta para uso;
- `archived`: pergunta retirada do uso.

## is_active

- `true`: pergunta disponível para seleção no app;
- `false`: pergunta desativada temporariamente.

## Cuidados teológicos

- Manter fidelidade bíblica.
- Priorizar consenso cristão histórico nas perguntas iniciais.
- Em conteúdo reformado, usar linguagem clara e pastoral.
- Evitar polêmicas avançadas no começo.
- Evitar transformar debates secundários em verdade central do evangelho.

Para perguntas doutrinárias:
- incluir referência bíblica principal;
- evitar respostas baseadas apenas em tradição humana;
- formular com precisão e simplicidade.

## Cuidados com direitos autorais

- Não copiar trechos extensos de traduções bíblicas protegidas.
- Preferir referência bíblica em vez de citação longa.
- Se necessário, usar paráfrase curta e neutra.

## Checklist de revisão antes de publicar

Antes de marcar uma pergunta como `approved`, revisar:

1. O enunciado está claro?
2. Existe apenas uma alternativa correta?
3. As alternativas erradas são plausíveis?
4. A explicação está curta e didática?
5. A referência bíblica/doutrinária está correta?
6. A categoria está adequada?
7. A dificuldade está coerente com o nível?
8. A linguagem está reverente e acessível?
9. A pergunta evita ambiguidades?
10. Não há duplicidade com outra pergunta ativa?

## Boas práticas para expansão futura

- Revisar o banco por lotes temáticos.
- Evitar superconcentração em poucas categorias.
- Balancear dificuldade para retenção do jogador.
- Incluir revisão humana antes de publicar em massa.
- Marcar perguntas sensíveis para revisão teológica adicional.
