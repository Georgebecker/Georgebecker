<#
.SYNOPSIS
Confere se as imagens de serviço externo usadas no README ainda respondem.

.DESCRIPTION
O README é feito de cards e badges hospedados fora do GitHub. Quando um desses
serviços cai, a imagem simplesmente não aparece: não há erro, só um espaço vazio.
Este script lê o README, separa as URLs dos serviços de imagem e mostra o código
HTTP de cada uma.

Um resultado 200 é o esperado. Qualquer outra coisa (402, 404, 503, erro de DNS)
significa trocar o card por outro serviço — o comentário no topo do README guarda
o histórico das trocas anteriores.

.PARAMETER Arquivo
Caminho do README. Por padrão, o README.md que fica um nível acima desta pasta.

.EXAMPLE
powershell -ExecutionPolicy Bypass -File scripts\conferir_imagens.ps1
#>
param(
    [string]$Arquivo = (Join-Path $PSScriptRoot '..\README.md'),
    [int]$TempoLimite = 30
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Arquivo)) {
    Write-Host "README não encontrado: $Arquivo" -ForegroundColor Red
    exit 2
}

# Só interessam as URLs de serviços de imagem; links de repositório e site ficam de fora.
$servicos = 'shields\.io|capsule-render\.vercel\.app|github-profile-summary-cards|ryglcloud|komarev\.com'

$texto = Get-Content -LiteralPath $Arquivo -Raw
$urls = @(
    [regex]::Matches($texto, '<img\b[^>]*\bsrc="(https://[^"\s>]+)"') |
        ForEach-Object { $_.Groups[1].Value }
    [regex]::Matches($texto, '!\[[^\]]*\]\((https://[^)\s]+)') |
        ForEach-Object { $_.Groups[1].Value }
    ) |
    Where-Object { $_ -match $servicos } |
    Select-Object -Unique

if (-not $urls) {
    Write-Host 'Nenhuma URL de imagem encontrada no README.' -ForegroundColor Yellow
    exit 2
}

$temCurl = [bool](Get-Command curl.exe -ErrorAction SilentlyContinue)
$falhas = New-Object System.Collections.Generic.List[string]

foreach ($url in $urls) {
    $codigo = 'ERRO'
    if ($temCurl) {
        $codigo = & curl.exe -s -o NUL -L --max-time $TempoLimite -w '%{http_code}' $url
    }
    else {
        try {
            $codigo = (Invoke-WebRequest -Uri $url -Method Get -TimeoutSec $TempoLimite -UseBasicParsing).StatusCode
        }
        catch {
            $codigo = 'ERRO'
        }
    }

    if ("$codigo" -eq '200') {
        Write-Host "$codigo  $url" -ForegroundColor DarkGray
    }
    else {
        Write-Host "$codigo  $url" -ForegroundColor Red
        $falhas.Add("$codigo $url")
    }
}

Write-Host ''
if ($falhas.Count -eq 0) {
    Write-Host ("Todas as {0} imagens responderam 200." -f $urls.Count) -ForegroundColor Green
    exit 0
}

Write-Host ("{0} de {1} imagens falharam:" -f $falhas.Count, $urls.Count) -ForegroundColor Red
$falhas | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
Write-Host 'Troque o serviço do card que falhou e registre a troca no comentário do topo do README.' -ForegroundColor Yellow
exit 1
