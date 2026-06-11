# Supabase SMTP Setup

## Objetivo
Garantir que o fluxo de recuperação de senha por e-mail funcione com confiabilidade antes do lançamento.

## Situação atual
- O app envia o pedido de recuperação via Supabase Auth.
- A validação real de entrega do e-mail depende da configuração do Supabase e do provedor SMTP.
- Se o e-mail padrão do Supabase não for confiável no ambiente de produção, recomendamos SMTP próprio.

## Provedores recomendados
- Resend
- Brevo
- SendGrid
- Postmark

## Dados necessários
- SMTP host
- Porta
- Username
- Password ou API key
- Sender email
- Sender name

## Onde configurar no Supabase
1. Abrir o projeto no Supabase.
2. Ir em `Authentication`.
3. Abrir `SMTP Settings` ou `Email Settings`.
4. Informar os dados do provedor.
5. Salvar e testar.

## Redirect URLs necessárias
- `com.sabercristao.app://login-callback/`
- `com.sabercristao.app://reset-password/`

## Como testar
1. Abrir o app deslogado.
2. Tocar em `Esqueci minha senha`.
3. Informar um e-mail cadastrado.
4. Confirmar que o link chega na caixa de entrada ou spam.
5. Abrir o link no celular.
6. Confirmar que o app abre em `ResetPasswordScreen`.
7. Definir uma nova senha.
8. Fazer login com a nova senha.

## Observação de segurança
- Não versionar senhas, API keys ou segredos de SMTP no repositório.
- Se a entrega de e-mails falhar nos testes reais, ocultar ou desabilitar o fluxo no RC1.
