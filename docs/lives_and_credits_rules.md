# Lives and Credits Rules - Saber Cristao

## Objetivo

Definir a regra oficial de vidas e créditos para a V1 do app.

## Regra Free

- `max_lives = 5`
- Regeneracao de 1 vida a cada 30 minutos
- Se `lives = 0`, o usuario pode:
  - assistir anuncio rewarded e ganhar 1 vida
  - usar 1 credito para continuar
  - comprar creditos
  - aguardar regeneracao

## Regra Premium

- `max_lives = 10`
- Regeneracao de 1 vida a cada 15 minutos
- Nao ve anuncios
- Nao recebe banner nem interstitial
- Pode continuar usando creditos se desejar

## Campo adicional no Supabase

A tabela `public.user_progress` precisa ter:

- `last_life_regen_at timestamptz`

Uso:

- registrar o ultimo momento em que a regeneracao de vida foi avaliada
- calcular quanto tempo falta para a proxima vida
- impedir que o app passe de `max_lives`

## Comportamento esperado

Ao abrir o app ou carregar progresso:

1. Ler `lives`, `max_lives` e `last_life_regen_at`
2. Calcular o tempo desde a ultima regeneracao
3. Se houver tempo suficiente, adicionar 1 ou mais vidas ate o limite de `max_lives`
4. Atualizar `last_life_regen_at`
5. Sincronizar no Supabase quando houver usuario autenticado

## Comportamento quando zerar tudo

### Free

- mostrar `OutOfLivesScreen`
- exibir contador de proxima vida
- oferecer rewarded ad
- oferecer compra de creditos
- oferecer Premium

### Premium

- mostrar `OutOfLivesScreen`
- exibir contador mais rapido
- nao obrigar anuncio
- permitir uso de creditos

## Creditos

- continuam sendo a moeda interna
- podem ser usados para continuar fase
- podem ser usados para recuperar vida
- podem ser usados para dicas futuras

## Regra de seguranca

- `credits` e `premium` nao devem ser controlados livremente pelo client em producao
- a concessao deve migrar para Edge Functions antes da publicacao final
- `last_life_regen_at` deve ser validado e sincronizado pelo backend quando o fluxo sair do modo de preparacao

## Pendencias de producao

- implementar regeneracao completa no backend ou no sync do progresso
- validar `max_lives` por estado Premium
- garantir que `credits` nao sejam incrementados pelo client em producao
- validar recompensa de anuncio antes de conceder vida
