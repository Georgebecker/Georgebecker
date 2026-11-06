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

Boa parte do README são cards e badges de serviços externos gratuitos. Se um deles cair,
a imagem some sem erro visível — então todo `git push` deveria ser precedido do
verificador, que lê o `README.md`, separa as URLs dos serviços de imagem e mostra o
código HTTP de cada uma:

```powershell
cd D:\Projetos\perfil-github
powershell -ExecutionPolicy Bypass -File scripts\conferir_imagens.ps1
```

Tudo em `200` é o esperado (o script sai com código 0). Qualquer `402`, `404`, `503` ou
erro de DNS significa trocar o card por outro serviço — e registrar a troca no
comentário do topo do `README.md`, que é o histórico das quedas.

Serviços aprovados hoje (06/11/2026):

| Serviço | Uso |
|---|---|
| `img.shields.io` | badges de tecnologia, contato e apoio — o mais estável |
| `capsule-render.vercel.app` | faixas de cabeçalho e rodapé |
| `github-profile-summary-cards.vercel.app` | todos os cards de estatística |
| `trophy.ryglcloud.net` | troféus (espelho; o original `github-profile-trophy.vercel.app` dá 402) |
| `komarev.com/ghpvc` | contador de visitantes |

Fora de propósito: `github-readme-stats.vercel.app` (HTTP 503 por limite de uso — os
cards de estatística, linguagens e os *pin cards* de repositório saíram por isso) e
`streak-stats.demolab.com` (HTTP 503 em 26/10/2026).

Um ícone que não existe no Simple Icons (por exemplo `powershell`) não quebra nada: o
badge do shields.io aparece só com o texto, sem o desenho.

## Se algum dia o repositório deixar de existir

```powershell
gh repo create Georgebecker --public --source . --push --description "Perfil e projetos de George Herman Becker"
```

Pela interface do site: <https://github.com/new>, nome **Georgebecker**, visibilidade
**Public**, depois **Add file > Upload files** com o `README.md` desta pasta.

## Topics do repositório do perfil

Os *topics* aparecem na barra lateral do repositório e ajudam quem procura por assunto no
GitHub. Sugestão em kebab-case:

```text
python, sql, dados-abertos, loop-engineering, automacao, ia, wordpress, laravel, fastapi, docker, portfolio
```

Para aplicar sem sair do terminal:

```powershell
gh repo edit Georgebecker/Georgebecker --add-topic python --add-topic sql --add-topic dados-abertos `
  --add-topic loop-engineering --add-topic automacao --add-topic ia --add-topic wordpress `
  --add-topic laravel --add-topic fastapi --add-topic docker --add-topic portfolio
```

## Dicas de manutenção

- Projetos em destaque: confira se os links abrem e se a descrição ainda bate com o
  repositório (estrelas e stack mudam; o README deve acompanhar).
- Repositório novo? Acrescente na tabela de **destaques** ou de **outros repositórios**,
  sempre com o estágio honesto (`publicado`, `MVP` ou `rascunho`).
- Tecnologia nova? Só entra em **Tecnologias e ferramentas** depois de aparecer em algum
  repositório — o README documenta o que existe, não o que se pretende aprender.
- Autor do commit é sempre você: nada de trailer de coautoria de IA (o `commit-msg`
  bloqueia, e é assim de propósito).
