param(
    [string]$EnvFile = ".env.local"
)

$ErrorActionPreference = "Stop"

function Mask-Secret {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return "<empty>"
    }

    if ($Value.Length -le 12) {
        return "****"
    }

    return "{0}...****" -f $Value.Substring(0, 10)
}

function Read-EnvFile {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Arquivo de configuracao local nao encontrado: $Path"
    }

    $values = @{}
    foreach ($line in Get-Content -LiteralPath $Path) {
        $trimmed = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed) -or $trimmed.StartsWith("#")) {
            continue
        }

        $separatorIndex = $trimmed.IndexOf("=")
        if ($separatorIndex -lt 1) {
            throw "Linha invalida no arquivo de configuracao: $trimmed"
        }

        $key = $trimmed.Substring(0, $separatorIndex).Trim()
        $value = $trimmed.Substring($separatorIndex + 1).Trim()
        $values[$key] = $value
    }

    return $values
}

$config = Read-EnvFile -Path $EnvFile

$requiredKeys = @(
    "SUPABASE_URL",
    "SUPABASE_ANON_KEY",
    "ENABLE_GOOGLE_SIGN_IN",
    "ENABLE_MOCK_AUTH"
)

foreach ($requiredKey in $requiredKeys) {
    if (-not $config.ContainsKey($requiredKey)) {
        throw "Chave obrigatoria ausente no arquivo local: $requiredKey"
    }
}

$supabaseUrl = $config["SUPABASE_URL"]
$supabaseAnonKey = $config["SUPABASE_ANON_KEY"]
$enableGoogleSignIn = $config["ENABLE_GOOGLE_SIGN_IN"]
$enableMockAuth = $config["ENABLE_MOCK_AUTH"]
$showDevBadges = if ($config.ContainsKey("SHOW_DEV_BADGES")) { $config["SHOW_DEV_BADGES"] } else { "false" }

if ([string]::IsNullOrWhiteSpace($supabaseUrl)) {
    throw "SUPABASE_URL esta vazio. Preencha o arquivo local antes de gerar o APK."
}

if ([string]::IsNullOrWhiteSpace($supabaseAnonKey)) {
    throw "SUPABASE_ANON_KEY esta vazio. Preencha o arquivo local antes de gerar o APK."
}

if ($enableMockAuth.ToLowerInvariant() -eq "true") {
    throw "ENABLE_MOCK_AUTH=true no arquivo local. Este script gera apenas APK conectado ao Supabase real."
}

if ($enableGoogleSignIn.ToLowerInvariant() -ne "true") {
    throw "ENABLE_GOOGLE_SIGN_IN precisa estar true para o build conectado."
}

Write-Host "Build conectado ao Supabase real" -ForegroundColor Green
Write-Host "SUPABASE_URL=$supabaseUrl"
Write-Host "SUPABASE_ANON_KEY=$(Mask-Secret -Value $supabaseAnonKey)"
Write-Host "ENABLE_GOOGLE_SIGN_IN=$enableGoogleSignIn"
Write-Host "ENABLE_MOCK_AUTH=$enableMockAuth"
Write-Host "SHOW_DEV_BADGES=$showDevBadges"

flutter clean
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter analyze
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter build apk --debug `
  --dart-define=SUPABASE_URL=$supabaseUrl `
  --dart-define=SUPABASE_ANON_KEY=$supabaseAnonKey `
  --dart-define=ENABLE_GOOGLE_SIGN_IN=$enableGoogleSignIn `
  --dart-define=ENABLE_MOCK_AUTH=$enableMockAuth `
  --dart-define=SHOW_DEV_BADGES=$showDevBadges

if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$apkPath = "build/app/outputs/flutter-apk/app-debug.apk"
if (-not (Test-Path -LiteralPath $apkPath)) {
    throw "Build finalizado sem encontrar o APK esperado em $apkPath"
}

Write-Host ""
Write-Host "APK gerado com sucesso:" -ForegroundColor Green
Write-Host $apkPath
