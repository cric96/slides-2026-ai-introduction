# Intelligenza artificiale: dall'avvento dei chatbot all'innovazione

Talk divulgativo (20 min) in [Typst](https://typst.app) + [Touying](https://touying-typ.github.io).

```sh
make pdf     # compila il PDF (i font sono in ./fonts)
make watch   # ricompila a ogni modifica
make notes   # esporta le note per pdfpc
```

## Struttura

- `presentation-2026-ai-chatbot-innovazione.typ` — le slide, con note per il relatore (`#speaker-note`).
- `theme/divulga.typ` — il tema: testo grande, un colore per sezione, definizioni "da dizionario", foto a tutta pagina.
- `theme/diagrams.typ` — diagrammi nativi (timeline, attenzione, flusso, ciclo dell'agente).
- `fonts/` — Space Grotesk (titoli), Inter (testo), JetBrains Mono (etichette). Licenza OFL. Icone disegnate in `theme/icons.typ`.
- `images/` — foto (crediti in `images/CREDITS.md`).

## Tipi di slide

| Funzione | Uso |
| --- | --- |
| `title-slide` | copertina scura con foto a destra |
| `part-slide` | apre una sezione, imposta colore e etichetta del footer |
| `slide` | kicker + titolo grande + contenuto, centrato in verticale |
| `statement-slide` | una frase enorme (chiara, scura o colorata) |
| `image-slide` | foto a tutta pagina con didascalia |
| `split-slide` | foto a metà pagina + testo |

Diagrammi: `timeline`, `attention`, `flow`, `agent-loop`, `perceptron`, `network`, `learning-flow`, `scatter`.

Componenti: `definition`, `senses`, `big-number`, `card`, `pill`, `quote-block`, `pic`, `source`.
