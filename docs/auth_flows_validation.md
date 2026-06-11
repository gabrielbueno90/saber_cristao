# Auth Flows Validation

## Checklist

## Status RC1
- Login email/senha: ativo e travado para sessão real apenas.
- Login Google: ativo com tentativa real de OAuth.
- Recuperação por email: ativa, mas depende de validação real de SMTP/email no ambiente.
- Alterar senha logado: implementado em `/change-password`.

### 1. Cadastro email/senha
- Abrir `/register`
- Criar conta
- Confirmar criação de `profiles`

### 2. Login email/senha
- Abrir `/login`
- Entrar com email e senha válidos
- Confirmar Home

### 3. Login Google
- Abrir `/login`
- Confirmar botão `Entrar com Google`
- Validar retorno ao app e Home

### 4. Logout
- Abrir `/profile`
- Tocar em `Sair da conta`
- Confirmar retorno ao Login

### 5. Sessão persistente
- Fechar o app
- Abrir novamente
- Confirmar login mantido

### 6. Recuperação de senha
- Abrir `/forgot-password`
- Enviar link de recuperação
- Confirmar entrega do e-mail no celular

### 7. Reset de senha
- Abrir o link recebido no celular
- Confirmar rota `/reset-password`
- Definir nova senha
- Voltar para Login

### 7b. Alterar senha logado
- Abrir `/profile`
- Tocar em `Alterar senha`
- Definir nova senha e confirmação
- Confirmar logout e login com a nova senha

### 8. Criação de profile
- Após qualquer login, validar `public.profiles`

### 9. Criação de user_progress
- Após abrir Home autenticado, validar `public.user_progress`

## Redirects no Supabase

### Site URL
- Use a URL do ambiente web que estiver testando.

### Redirect URLs
- `com.sabercristao.app://login-callback/`
- `com.sabercristao.app://reset-password`

## SMTP
- Ver [docs/supabase_smtp_setup.md](supabase_smtp_setup.md)

## Deep links usados
- Login Google: `com.sabercristao.app://login-callback/`
- Reset password: `com.sabercristao.app://reset-password`

## Como testar no Android
1. Instalar o APK com `--dart-define` correto.
2. Rodar login email/senha.
3. Rodar login Google.
4. Rodar recuperação e reset de senha.

## Queries úteis

### auth.users
```sql
select id, email, created_at, last_sign_in_at
from auth.users
order by created_at desc
limit 10;
```

### auth.identities
```sql
select id, user_id, provider, provider_id, email, created_at
from auth.identities
order by created_at desc
limit 10;
```

### profiles
```sql
select id, user_id, display_name, email, auth_provider, created_at
from public.profiles
order by created_at desc
limit 10;
```

### user_progress
```sql
select id, user_id, current_level, total_stars, total_score, lives, max_lives, credits, created_at
from public.user_progress
order by created_at desc
limit 10;
```

### user_level_progress
```sql
select id, user_id, level, best_score, best_stars, completed, attempts_count, last_played_at, created_at, updated_at
from public.user_level_progress
order by updated_at desc
limit 20;
```
