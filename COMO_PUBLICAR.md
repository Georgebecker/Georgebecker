# Como publicar e manter este README no perfil do GitHub

**Estado atual: já publicado.** O repositório <https://github.com/Georgebecker/Georgebecker>
é público, a branch é `main` e o perfil em <https://github.com/Georgebecker> mostra este
`README.md` automaticamente.

O GitHub só faz isso quando existe um repositório com **nome igual ao usuário**
(`Georgebecker`) e o `README.md` na raiz dele. Nada mais é preciso: sem Actions, sem
deploy.

## Rotina de atualização

```powershell
cd D:\Projetos\perfil-github
# edite o README.md
git add README.md
git commit -m "Perfil: <o que mudou>"
git push
```

O perfil reflete a mudança em segundos. O commit passa antes pelos ganchos de
`.githooks/`: `pre-commit` (segredo), `commit-msg` (coautoria de IA) e `pre-push`
(a segunda barreira dos dois).

## Antes de publicar: conferir as imagens

Metade do README são cards de serviços externos gratuitos. Se um deles cair, a imagem
some sem erro visível — então vale checar o status HTTP de todas as URLs:

```powershell
cd D:\Projetos\perfil-github
$txt = [System.IO.File]::ReadAllText("README.md", [System.Text.Encoding]::UTF8)
$urls = [regex]::Matches($txt, 'https://[^"\s\)]+') | ForEach-Object { $_.Value } |
    Where-Object { $_ -match 'shields\.io|vercel\.app|komarev|ryglcloud|demolab' } |
    Select-Object -Unique
foreach ($u in $urls) {
    try {
        $r = Invoke-WebRequest -Uri $u -Method Head -TimeoutSec 20 -MaximumRedirection 5
        "$($r.StatusCode) $u"
    } catch { "ERRO $u" }
}
```

Tudo em `200` é o esperado. Qualquer `402`, `503` ou erro de DNS significa trocar o card
por outro serviço (o comentário no topo do `README.md` guarda o histórico dessas quedas:
`github-profile-trophy.vercel.app` deu 402 e `streak-stats.demolab.com` deu 503).

## Se algum dia o repositório deixar de existir

```powershell
gh repo create Georgebecker --public --source . --push --description "Perfil e projetos de George Herman Becker"
```

Pela interface do site: <https://github.com/new>, nome **Georgebecker**, visibilidade
**Public**, depois **Add file > Upload files** com o `README.md` desta pasta.

## Dicas de manutenção

- Projetos em destaque: confira se os links abrem e se o card mostra o repositório certo.
- Repositório novo? Acrescente nas tabelas de projetos (e no card de pin, se for destaque).
- Tecnologia nova? Só entra em **Tecnologias e ferramentas** depois de aparecer em algum
  repositório — o README documenta o que existe, não o que se pretende aprender.
- Autor do commit é sempre você: nada de trailer de coautoria de IA (o `commit-msg`
  bloqueia, e é assim de propósito).
