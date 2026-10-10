#import "@preview/touying:0.7.4": *
#import "theme/divulga.typ": *
#import "theme/diagrams.typ": *
#import "theme/icons.typ": *

// Speaker notes / pdfpc:
// typst query --root . --font-path fonts presentation-2026-ai-chatbot-innovazione.typ --field value --one "<pdfpc-file>" > slides.pdfpc
#let pdfpc-config = pdfpc.config(duration-minutes: 20, last-minutes: 3, note-font-size: 14)

#show: divulga-theme.with(
  config-common(preamble: pdfpc-config, handout: sys.inputs.at("handout", default: "false") == "true"),
  config-info(title: [Intelligenza artificiale], author: [Gianluca Aguzzi]),
)

#title-slide(
  title: [Intelligenza\ artificiale],
  subtitle: [Cosa c'è dentro un chatbot, e come possiamo sfruttarli],
  author: [Gianluca Aguzzi],
  affiliation: [Università di Bologna · DISI],
  date: [2026],
  image-path: "images/brain.jpg",
)

#slide(kicker: [Chi sono])[
  #grid(
    columns: (auto, 1fr),
    column-gutter: 1.8em,
    align: horizon,
    box(
      width: 7.5em,
      height: 7.5em,
      radius: 100%,
      clip: true,
      stroke: 5pt + palette.blue,
      image("images/myself.png", width: 100%, height: 100%, fit: "cover"),
    ),
    [
      #text(font: fonts.display, size: 1.9em, weight: "bold", tracking: -0.02em)[Gianluca Aguzzi]
      #v(-0.6em)
      #text(size: 0.95em, fill: palette.muted)[Ricercatore · Università di Bologna]
      #v(0.2em)
      #set text(size: 0.85em)
      - *Insegnamento*: Ingegneria del Software, Agenti per lo Sviluppo del Software
      - *Ricerca*: AI collettiva, sistemi multi-agente, LLM
      
      #text(font: fonts.mono, size: 0.7em, fill: palette.muted)[gianluca.aguzzi\@unibo.it · gianluca.aguzzi.dev]
    ],
  )
]
#speaker-note[
  Presentazione veloce (20-30 secondi): chi sono e perché mi occupo di AI.
]

/*
#statement-slide(dark: true, kicker: [30 novembre 2022], attribution: [ChatGPT, 1 milione di utenti in 5 giorni])[
  In cinque giorni, *un milione di persone* ha iniziato a parlare con una macchina.
]
#speaker-note[
  Apertura: tutti ricordiamo la prima volta che abbiamo usato ChatGPT.
  100 milioni di utenti in circa due mesi: la tecnologia di consumo più veloce di sempre.
  Domanda guida del talk: come ci siamo arrivati, cosa ci possiamo fare, cosa rischiamo.
]*/

// ===========================================================================
#part-slide(number: "01", title: [Capire l'AI], subtitle: [Cosa c'è dentro la scatola], color: palette.blue)

#slide(kicker: [Partiamo dalle parole], repeat: 2, self => [
  #let answer = [La capacità di *risolvere problemi mai visti prima*.]
  #definition([intelligenza], pron: [in·tel·li·gèn·za], kind: [s.f.])[
    #if self.subslide >= 2 { answer } else { hide(answer) }
  ]
  #v(0.8em)
  #block(
    stroke: (left: 1.5pt + palette.muted),
    inset: (left: 0.9em, y: 0.2em),
    text(size: 0.72em, fill: palette.ink-soft)[
      #pause
      #text(font: fonts.mono, weight: "bold", fill: palette.muted)[NOTA] #h(0.4em)
      Definirla resta un problema aperto: psicologi, filosofi e informatici non hanno una definizione condivisa.
      
      Questa è una definizione _operativa_, utile per parlare di macchine.

    ],
  )
])
#speaker-note[
  Definizione ripresa da Nello Cristianini, "Forma mentis" (Il Mulino, 2026): "L'intelligenza è la capacità di risolvere problemi mai visti prima."
  Sottolineare che non c'è accordo: Legg e Hutter (2007) hanno raccolto più di 70 definizioni diverse.
  Memorizzare non basta (non funziona sul nuovo), tirare a caso nemmeno.
]

#slide(title: [Comprimere, comprendere, prevedere])[
  #senses(
    [*Comprimere*: descrivere tanti dati con poche regole, invece di memorizzarli.],
    [*Comprendere*: quella descrizione compatta è un _modello_ del mondo.],
    [*Prevedere*: il modello funziona anche su casi mai visti.],
  )
  #v(0.8em)
  #pause
  #quote-block(size: 1.3em, who: [slogan nato dalle idee di Ray Solomonoff (1964) · N. Cristianini, _Forma mentis_])[
    La compressione è la comprensione.
  ]
]
#speaker-note[
  Idea di Ray Solomonoff, presente a Dartmouth nel 1956: imparare = prevedere come continua una sequenza di simboli.
  Per prevedere bisogna trovare regolarità, cioè descrivere i dati in modo compatto: la descrizione compressa è un modello, e richiede comprensione.
  Ritrovata da Kolmogorov e Chaitin (teoria algoritmica dell'informazione). Gli LLM la applicano su scala gigantesca: il modello è molto più piccolo dei dati, quindi non può memorizzarli, deve trovare regolarità.
]

#slide(title: [Un gioco: come continua?], repeat: 5, self => [
  #let (uncover, only) = utils.methods(self)
  #let tile(body, fill: none, ink: palette.ink, stroke: 3pt + palette.ink) = box(
    width: 2.5em,
    height: 2.4em,
    fill: fill,
    stroke: (bottom: stroke),
    align(center + horizon, text(font: fonts.display, size: 1.5em, weight: "bold", fill: ink, body)),
  )
  #let mystery(n) = tile(
    fill: palette.blue.lighten(88%),
    stroke: 3pt + palette.blue,
    ink: palette.blue,
    {
      only("1")[?]
      only("2-")[#n]
    },
  )
  #v(0.6em)
  #align(center, stack(dir: ltr, spacing: 0.45em, ..("2", "4", "6", "8", "10", "12", "14").map(tile), mystery("16")))
  #v(0.8em)
  #align(center)[
    #uncover("3-")[#text(size: 1.15em)[E il *millesimo* numero?]]
    #h(0.3em)
    #uncover("4-")[#box(fill: palette.blue, inset: (x: 0.35em, y: 0.15em), text(size: 1.15em, fill: white, weight: "bold")[2000])]
  ]
  #v(0.6em)
  #uncover("5-")[
    #align(center, block(
      fill: palette.ink,
      inset: (x: 1.4em, y: 0.8em),
      grid(
        columns: (auto, auto),
        column-gutter: 1.2em,
        align: horizon,
        text(font: fonts.mono, size: 1.8em, weight: "bold", fill: white)[n#box(
          baseline: 0.18em - 0.32em,
          inset: (x: 0.3em),
          grid(
            columns: 3,
            align: horizon,
            line(length: 0.36em, angle: 90deg, stroke: 4pt + palette.sun),
            line(length: 1em, stroke: 4pt + palette.sun),
            polygon(fill: palette.sun, (0em, 0em), (0.38em, 0.18em), (0em, 0.36em)),
          ),
        )2n],
        text(size: 0.8em, fill: white.transparentize(20%))[infiniti numeri, \ #text(fill: palette.sun, weight: "bold")[una riga] di regola],
      ),
    ))
  ]
])
#speaker-note[
  Gioco col pubblico: chiedere il numero mancante (16), poi il millesimo: chi ha memorizzato la lista non lo sa, chi ha trovato la regola sì.
  Ultimo passaggio: la regola è la lista compressa.
  La regola occupa meno spazio (comprime) e funziona anche oltre la lista (prevede).
  Stesso esempio di Solomonoff: 010101… "zero è sempre seguito da uno".
  Teniamolo a mente: tornerà quando parliamo di "predire la parola successiva".
]

#slide(title: [Due strade per costruire una mente])[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.2em,
    align: top,
    [
      #pic("images/deepblue.jpg", height: 5em)
      #v(0.3em)
      #pill([AI simbolica], fill: palette.violet)
      #v(-0.2em)
      #text(size: 1.05em)[*Regole scritte a mano* da esperti.]
      #v(-0.4em)
      #let kw(k) = text(weight: "bold", fill: palette.violet, k)
      #text(font: fonts.mono, size: 0.7em, fill: palette.muted)[#kw[SE] hai la febbre #kw[E] la tosse #kw[ALLORA] hai l'influenza]
    ],
    [
      #pic("images/perceptron.jpg", height: 5em)
      #v(0.3em)
      #pill([AI connessionista], fill: palette.blue)
      #v(-0.2em)
      #text(size: 1.05em)[*"Reti" che imparano* dagli esempi.]
      #v(-0.4em)
      #text(font: fonts.mono, size: 0.7em, fill: palette.muted)[10 000 cartelle cliniche #sym.arrow.r la rete trova la regola]
    ],
  )
]
#speaker-note[
  Simbolica: logica, regole esplicite, sistemi esperti. Trasparente ma fragile: il mondo ha troppe eccezioni.
  Connessionista: ispirata ai neuroni (Perceptron di Rosenblatt, 1958). Le regole non le scriviamo: emergono dai dati.
  Foto: Deep Blue (IBM, 1997) e il Mark I Perceptron.
]

#slide(title: [Il neurone: un piccolo decisore (micro)])[
  #let h = 11.6em
  #let badge(n) = circle(radius: 0.55em, fill: palette.blue, stroke: 2pt + white,
    align(center + horizon, text(font: fonts.mono, size: 0.6em, weight: "bold", fill: white, str(n))))
  #let at(x, y, n) = place(top + left, dx: x - 0.55em, dy: y - 0.55em, badge(n))
  #grid(
    columns: (auto, 1fr),
    column-gutter: 1.6em,
    align: horizon,
    box(width: h * 611 / 715, height: h, {
      pic("images/neuron-cajal.jpg", height: h)
      at(h * 0.5, h * 0.2, 1)
      at(h * 0.33, h * 0.5, 2)
      at(h * 0.43, h * 0.74, 3)
      place(bottom + right, dx: -0.3em, dy: -0.3em, text(font: fonts.mono, size: 8pt, fill: palette.muted)[S. Ramón y Cajal, 1899])
    }),
    [
      #senses(
        [*Dendriti*: ricevono segnali da migliaia di altri neuroni.],
        [*Corpo*: li somma.],
        [*Assone*: se la somma supera una soglia, il neurone "_si accende_" e passa il segnale.],
      )
      #v(0.5em)
      #text(size: 0.75em, fill: palette.ink-soft)[Le connessioni (*sinapsi*) si rafforzano con l'uso: \ è così che il cervello impara.]
    ],
  )
]
#speaker-note[
  Disegno originale di Santiago Ramón y Cajal (1899): cellule di Purkinje del cervelletto di piccione. Cajal, Nobel 1906, fu il primo a capire che il cervello è fatto di cellule separate, i neuroni.
  Il nostro cervello ne ha circa 86 miliardi, ognuno collegato a migliaia di altri.
  Funzionamento semplificato: i dendriti raccolgono, il corpo somma, l'assone "spara" se si supera la soglia (tutto o niente).
  Regola di Hebb (1949): "neuroni che si attivano insieme si collegano più forte". Imparare = cambiare la forza delle connessioni.
]

#slide(title: [Il neurone artificiale])[
  #let row(bio, art) = (
    text(font: fonts.mono, size: 0.7em, fill: palette.muted, bio),
    box(width: 1.3em, height: 0.6em, {
      place(left + horizon, line(length: 0.9em, stroke: (paint: palette.muted.lighten(30%), thickness: 2pt, cap: "round")))
      place(right + horizon, polygon(fill: palette.muted.lighten(30%), (0em, 0em), (0.4em, 0.22em), (0em, 0.44em)))
    }),
    text(size: 0.78em, art),
  )
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.6em,
    align: horizon,
    perceptron(([febbre], [tosse], [dolori]), (0.8, 0.5, 0.2), [influenza?], size: 0.88em),
    grid(
      columns: (auto, auto, 1fr),
      column-gutter: 0.4em,
      row-gutter: 0.75em,
      align: (right + horizon, center + horizon, left + horizon),
      ..row([dendriti], [*ingressi*: gli indizi]),
      ..row([sinapsi], [*pesi*: un numero per ogni indizio]),
      ..row([corpo], [*somma*: combina gli indizi pesati]),
      ..row([assone], [*uscita*: acceso o spento]),
    ),
  )
  #v(0.9em)
  #align(center, block(
    fill: palette.ink,
    inset: (x: 1.2em, y: 0.6em),
    text(fill: white)[#text(fill: palette.sun, weight: "bold")[Imparare] = aggiustare i pesi, esempio dopo esempio.],
  ))
]
#speaker-note[
  Il perceptron di Frank Rosenblatt (1958) copia lo schema del neurone, in versione matematica: ogni indizio ha un peso, si sommano, si confronta con una soglia.
  Differenza con l'AI simbolica: la regola "SE febbre E tosse" non la scrive nessuno. I pesi (quanto conta la febbre, quanto la tosse) li impara dagli esempi, come le sinapsi che si rafforzano.
  Un neurone da solo è limitato (Minsky e Papert, 1969: contribuisce al primo inverno).
]

#slide(title: [Tanti neuroni, a strati])[
  #text(size: 0.75em, fill: palette.ink-soft)[
    *Hubel e Wiesel* (1959): nel cervello del gatto i primi neuroni visivi vedono solo _linee_, \ quelli successivi _forme_ sempre più complesse.
  ]
  #v(0.2em)
  #pause
  #let layers = (
    ([pixel], "images/cnn-pixel.jpg"),
    ([bordi], "images/cnn-edges.jpg"),
    ([forme], "images/cnn-patterns.jpg"),
    ([parti], "images/cnn-parts.jpg"),
    ([oggetti], "images/cnn-objects.jpg"),
  )
  #align(center, block(width: 22em, {
    deep-network((5, 4, 4, 3, 2), width: 22em, height: 4.4em, r: 0.4em, outputs: (([gatto], false), ([cane], true)))
    v(-0.2em)
    grid(
      columns: (1fr,) * 5,
      row-gutter: 0.25em,
      ..layers.map(((_, path)) => align(center, pic(path, width: 2.4em, height: 2.4em, radius: 0.25em))),
      ..layers.enumerate().map(((i, (l, _))) => align(center, text(
        font: fonts.mono, size: 0.58em, weight: "bold",
        fill: if i == 4 { palette.coral } else { palette.ink-soft }, l))),
    )
    v(-0.3em)
    align(right, text(font: fonts.mono, size: 7pt, fill: palette.muted)[cosa "vede" ogni strato di una rete vera (GoogLeNet) · Olah et al., Distill 2017, CC BY 4.0])
  }))
  #pause
  #v(0.1em)
  #align(center, text(size: 0.8em)[Negli strati profondi la rete *comprime*: tiene solo ciò che serve per capire.])
]
#speaker-note[
  David Hubel e Torsten Wiesel (1959, Nobel 1981): registrando i neuroni della corteccia visiva del gatto scoprono che alcuni rispondono solo a una linea con una certa inclinazione; più avanti nella catena, neuroni che combinano queste linee in forme.
  Kunihiko Fukushima (1980) traduce l'idea nel Neocognitron, antenato delle reti convoluzionali di LeCun (1989) e di AlexNet (2012).
  Deep learning = tanti strati. Ogni strato riassume il precedente: dai pixel ai bordi, alle forme, alle parti, all'oggetto.
  Collegamento con "la compressione è la comprensione": in profondità milioni di pixel diventano pochi numeri che descrivono il concetto. Un LLM moderno: centinaia di miliardi di pesi.
]

#slide(title: [Come impara una macchina -- _Machine Learning_])[
  #let lab(icon, l) = stack(spacing: 0.12em, icon, text(font: fonts.mono, size: 0.42em, fill: palette.muted, l))
  #let grey = palette.muted.lighten(30%)
  // the same mixed animals, first unlabelled and grey, then grouped and coloured
  #let mixed(cat-fill, dog-fill) = grid(
    columns: 3, column-gutter: 0.6em, row-gutter: 0.1em,
    cat(size: 1.55em, fill: cat-fill), dog(size: 1.55em, fill: dog-fill), cat(size: 1.55em, fill: cat-fill),
    dog(size: 1.55em, fill: dog-fill), cat(size: 1.55em, fill: cat-fill), dog(size: 1.55em, fill: dog-fill),
  )
  #let group(body, col) = box(
    stroke: (bottom: 3pt + col), inset: (x: 0.15em, bottom: 0.2em), body,
  )
  #learning-flow(
    [supervisionato], [esempi _con_ la risposta],
    panel(grid(
      columns: 4, column-gutter: 0.35em,
      lab(cat(size: 1.55em), [gatto]), lab(dog(size: 1.55em), [cane]),
      lab(dog(size: 1.55em), [cane]), lab(cat(size: 1.55em), [gatto]),
    )),
    panel(grid(
      columns: 3, column-gutter: 0.3em, align: horizon,
      cat(size: 2em, fill: palette.muted.lighten(20%)),
      text(fill: palette.muted, sym.arrow.r),
      text(font: fonts.display, size: 1.3em, weight: "bold", fill: palette.blue)[gatto],
    )),
    color: palette.blue,
  )
  #v(-0.1em)
  #pause
  #learning-flow(
    [non supervisionato], [dati _senza_ risposta],
    panel(mixed(grey, grey)),
    panel(grid(
      columns: 2, column-gutter: 1.2em,
      group(grid(columns: 2, gutter: 0.1em, cat(size: 1.2em, fill: palette.blue), cat(size: 1.2em, fill: palette.blue), cat(size: 1.2em, fill: palette.blue)), palette.blue),
      group(grid(columns: 2, gutter: 0.1em, dog(size: 1.2em, fill: palette.coral), dog(size: 1.2em, fill: palette.coral), dog(size: 1.2em, fill: palette.coral)), palette.coral),
    )),
    color: palette.violet,
  )
  #v(-0.1em)
  #pause
  #learning-flow(
    [per rinforzo], [premio o punizione],
    panel(grid(
      columns: 4, column-gutter: 0.15em, align: horizon,
      robot-fallen(size: 1.9em), text(font: fonts.display, weight: "bold", fill: palette.coral)[−1],
      robot-standing(size: 1.9em), text(font: fonts.display, weight: "bold", fill: palette.green)[+1],
    )),
    panel(grid(
      columns: (auto, 1fr), column-gutter: 0.2em, align: horizon,
      robot-standing(size: 2.1em, fill: palette.green),
      text(size: 0.66em)[impara a \ stare *in piedi*],
    )),
    color: palette.coral,
  )
]
#speaker-note[
  Tre flussi, stessa rete: cambia cosa le diamo da mangiare.
  Supervisionato: esempi etichettati (foto + "gatto"); poi riconosce foto mai viste. Es. diagnosi, spam.
  Non supervisionato: gli stessi animali, ma senza etichette. La rete li raggruppa da sola per somiglianza: non sa che si chiamano "gatti" e "cani", sa solo che sono due gruppi. Es. clienti simili, anomalie.
  Rinforzo: nessuno gli dice come camminare. Il robot prova: se cade −1, se resta in piedi +1. Dopo migliaia di tentativi impara (AlphaGo, robotica, e il feedback umano dei chatbot).
]

#slide(title: [Inverni e primavere])[
  #v(1em)
  #timeline((
    ([1950], [Turing: "le macchine possono pensare?"], "symb"),
    ([1956], [Dartmouth: nasce il nome "AI"], "symb"),
    ([1958], [Il Perceptron], "conn"),
    ([anni ’70], [Primo inverno], "winter"),
    ([anni ’80], [Sistemi esperti], "symb"),
    ([anni ’90], [Secondo inverno], "winter"),
    ([2012], [AlexNet: il deep learning vince], "boom"),
    ([2017], [Il Transformer], "boom"),
    ([2022], [ChatGPT], "boom"),
  ), height: 8em)
  #v(0.8em)
  #align(center)[
    #pill([simbolica], fill: palette.violet) #h(0.4em)
    #pill([connessionista], fill: palette.blue) #h(0.4em)
    #pill([inverno], fill: palette.muted) #h(0.4em)
    #pill([rinascita], fill: palette.coral)
  ]
]
#speaker-note[
  Le promesse superano i risultati, arrivano tagli ai fondi: gli "inverni" dell'AI.
  2012: AlexNet stravince la gara ImageNet di riconoscimento immagini, errore da circa 26% a 15%. Da lì il deep learning conquista tutto.
  2016 AlphaGo, 2017 Transformer, 2022 ChatGPT.
]

/*
#image-slide(
  "images/go.jpg",
  kicker: [2016 · Seul],
  caption: [AlphaGo batte Lee Sedol. La "mossa 37" nessun umano l'avrebbe giocata.],
  credit: [Foto: Dietmar Rabich, CC BY-SA 4.0],
)
#speaker-note[
  Il Go ha più configurazioni possibili che atomi nell'universo: impossibile scriverne le regole strategiche a mano.
  La mossa 37 della seconda partita: i commentatori la considerarono un errore, poi si rivelò geniale.
  È il primo segnale pubblico che una macchina può generalizzare oltre ciò che le abbiamo insegnato.
]
*/

#slide(title: [Perché proprio ora?])[
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    column-gutter: 1em,
    align: top,
    card(tag: [01], number: true, title: [Metodi])[Apprendimento Automatico "profondo" (deep learning).],
    card(tag: [02], number: true, title: [Architetture])[Reti neurali "Transformer" con attenzione (attention).],
    card(tag: [03], number: true, title: [Dati])[WWW: testi, immagini, video, codice, audio.],
    card(tag: [04], number: true, title: [Hardware])[GPU: calcolo parallelo a basso costo.],
  )
]
#speaker-note[
  Quattro ingredienti maturati insieme.
  Le idee di base esistevano dagli anni '80 (backpropagation).
  Mancavano dati in quantità e potenza di calcolo: le GPU, nate per la grafica dei videogiochi, sono perfette per i calcoli delle reti neurali.
]

#slide(title: [Cos'è un LLM?])[
  #text(size: 1.1em)[Una rete neurale enorme, allenata sui testi, che *prevede la parola successiva*.]
  #v(1em)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 1.2em,
    align: top,
    card(title: [#hl[L]arge])[Miliardi di pesi, migliaia di miliardi di parole lette.],
    card(title: [#hl[L]anguage])[Impara dal linguaggio: libri, siti, codice.],
    card(title: [#hl[M]odel])[Una descrizione *compressa* del testo (e del mondo).],
  )
]
#speaker-note[
  ChatGPT, Claude, Gemini sono chatbot costruiti sopra un LLM.
  Le tre lettere sono la mappa delle prossime slide: Large (quanto leggono, quanto sono grandi), Language (il Transformer), Model (come nasce, indovina la parola dopo).
  "Model" richiama "comprimere, comprendere, prevedere": il modello è la descrizione compatta che serve a prevedere.
]

#split-slide("images/library.jpg", title: [Quanto "leggono"?], side: left, ratio: 42%, credit: [Diliff, CC BY-SA 4.0])[
  #v(0.4em)
  #big-number(size: 2.2em, [15 000 miliardi], [di "pezzi di parola" (token) per allenare un modello moderno])
  #v(0.6em)
  #big-number(size: 2.2em, [> 100 000 anni], [per leggerli tutti, 8 ore al giorno], color: palette.ink)
]
#speaker-note[
  Ordine di grandezza: Llama 3 (Meta, 2024) è stato addestrato su circa 15 mila miliardi di token.
  Conto: circa 11 mila miliardi di parole, a 250 parole al minuto per 8 ore al giorno fa ben oltre centomila anni.
  Da qui la "fame" di dati e di calcolo (data center, energia).
]

#slide(title: [Quanto sono "large"?])[
  #text(size: 0.85em)[Ogni *peso* è un numero, e in memoria occupa 2 byte.]
  #v(0.4em)
  #bars((
    ([il tuo portatile], [memoria], 16, [16 GB], palette.ink),
    ([GPT-2], [2019 · 1,5 mld di pesi], 3, [3 GB], palette.blue.lighten(40%)),
    ([GPT-3], [2020 · 175 mld di pesi], 350, [350 GB], palette.blue.lighten(20%)),
    ([Kimi K2], [2025 · 1 000 mld di pesi], 2000, [2 000 GB], palette.blue),
  ), label-width: 8em)
  #v(0.1em)
  #pause
  #align(center, block(
    fill: palette.ink,
    inset: (x: 1.2em, y: 0.6em),
    text(fill: white)[Solo per #text(fill: palette.sun, weight: "bold")[tenerlo in memoria] servono circa 25 GPU da 80 GB.],
  ))
]
#speaker-note[
  Un "peso" è un numero; in 16 bit occupa 2 byte. Quindi: miliardi di pesi × 2 = GB.
  GPT-2 (OpenAI, 2019): 1,5 miliardi. GPT-3 (2020): 175 miliardi. Kimi K2 (Moonshot AI, 2025): mille miliardi, uno dei più grandi modelli aperti. I modelli chiusi (GPT-5, Claude, Gemini) non dichiarano le dimensioni.
  2 TB = 2000 GB: 25 schede GPU H100 da 80 GB, solo per caricarlo, senza contare la memoria per "pensare". Con la compressione (quantizzazione, 4-8 bit) si scende a 0,6-1 TB, ma resta fuori portata di un PC.
  Il portatile in barra è quasi invisibile: è questo il punto.
]

#slide(title: [Più grandi di un cervello?], repeat: 2, self => [
  #let photo(path) = box(width: 2.6em, height: 2.6em, radius: 50%, clip: true, stroke: 2pt + palette.paper, pic(path, width: 2.6em, height: 2.6em))
  #log-scale(
    (
      (5e7, photo("images/animal-fly.jpg"), [moscerino], [50 mln]),
      (1e9, photo("images/animal-bee.jpg"), [ape], [1 mld]),
      (1e11, photo("images/animal-mouse.jpg"), [topo], [100 mld]),
      (1e13, photo("images/animal-cat.jpg"), [gatto], [10 000 mld]),
      (1e14, photo("images/animal-human.jpg"), [uomo], [100 000 mld]),
    ),
    (
      (6e7, none, [AlexNet], [60 mln]),
      (1.5e9, none, [GPT-2], [1,5 mld]),
      (1.75e11, none, [GPT-3], [175 mld]),
      (1e12, none, [Kimi K2], [1 000 mld]),
    ),
    show-bottom: self.subslide >= 2,
    height: 9.4em,
    unit: [ogni tacca = ×10],
  )
  #v(-0.6em)
  #align(center, text(size: 0.8em)[
    #text(fill: palette.ink)[● sinapsi] #h(1em)
    #text(fill: palette.blue)[■ pesi] #h(1em)
    #text(fill: palette.muted)[(paragone grossolano: 1 peso ≈ 1 sinapsi)]
  ])
])
#speaker-note[
  Confronto grossolano ma utile: il peso di una rete è l'analogo della forza di una sinapsi.
  Moscerino: connettoma completo pubblicato su Nature nel 2024 (FlyWire): circa 140 000 neuroni e 50 milioni di sinapsi. Ape: circa 1 milione di neuroni, ordine di un miliardo di sinapsi. Topo: circa 70 milioni di neuroni, ordine di 100 miliardi di sinapsi. Gatto: circa 10 000 miliardi. Uomo: 86 miliardi di neuroni, 100-1000 mila miliardi di sinapsi. Sono ordini di grandezza.
  AlexNet (2012), la rete profonda che ha fatto ripartire tutto, aveva circa 60 milioni di pesi: quanto le sinapsi di un moscerino.
  I modelli più grandi stanno tra il topo e il gatto. Il nostro cervello ha ancora circa 100 volte più connessioni, consuma 20 watt e impara da molti meno esempi.
  Attenzione: una sinapsi è molto più complessa di un numero; il paragone serve solo per l'ordine di grandezza.
]

#slide(title: [Il Transformer: l'attenzione])[
  #text(size: 1em, fill: palette.muted)[Ogni parola guarda tutte le altre e decide quali *contano*.]
  #v(1.6em)
  #attention(
    ("La", "gatta", "non", "salta", "sul", "tavolo", "perché", "è", "stanca"),
    8,
    (0.05, 1.0, 0.25, 0.45, 0.0, 0.2, 0.35, 0.5, 0.0),
    size: 0.92em,
  )
  #v(1em)
  #pause
  #text(size: 1.1em)[Chi è stanca? Il modello "collega" *stanca* a *gatta*, non a _tavolo_.]
]
#speaker-note[
  "Attention Is All You Need", Google, 2017.
  Prima si leggeva il testo parola per parola, in sequenza. Il Transformer guarda tutto insieme, in parallelo.
  Il parallelismo è il segreto: sfrutta perfettamente le GPU.
]

/*
#image-slide(
  "images/datacenter.jpg",
  kicker: [Leggi di scala],
  caption: [Più dati, più calcolo: il modello migliora *in modo prevedibile*.],
  credit: [Foto: PiDatacenters, CC BY-SA 4.0],
)
#speaker-note[
  Le "scaling laws" (2020): l'errore scende in modo regolare aumentando dati e calcolo.
  Per le aziende ha voluto dire: investire in scala è una scommessa quasi sicura. Da qui la corsa ai data center.
]*/

#slide(title: [Come nasce un LLM])[
  #let inside(k, t) = [
    #text(font: fonts.mono, size: 0.55em, fill: white.transparentize(25%), upper(k)) \
    #box(text(font: fonts.display, size: 0.9em, weight: "bold", t))
  ]
  #let below(body, how, col) = [
    #pill(how, fill: col)
    #v(0.1em)
    #text(size: 0.8em, body)
  ]
  #chevrons((
    (inside([come l'evoluzione], [Pre-addestramento]), below([Indovina la parola dopo su mezza Internet: *comprimendo*, si forma il "cervello".], [non supervisionato], palette.violet)),
    (inside([come la scuola], [Fine-tuning]), below([Impara *come comportarsi*: esempi di domande e risposte giuste.], [supervisionato], palette.blue)),
    (inside([come il lavoro], [Feedback umano]), below([Si affina *sul campo*: le persone premiano la risposta migliore.], [per rinforzo], palette.coral)),
  ), colors: (palette.violet, palette.blue, palette.coral), height: 3em)
]
#speaker-note[
  Le tre fasi riusano i tre modi di imparare visti prima (stessi colori). Analogia: evoluzione, scuola, lavoro.
  Pre-addestramento, come l'evoluzione: auto-supervisionato. Nessuno etichetta niente: la "risposta giusta" è la parola che segue davvero nel testo. Per indovinarla deve comprimere (torna "la compressione è la comprensione"): si forma la struttura che permette di capire lingua e mondo. Come l'evoluzione ha costruito in milioni di anni un cervello pronto a imparare. Mesi su migliaia di GPU, la fase più costosa.
  Fine-tuning, come la scuola: supervisionato. Esempi di domande con la risposta scritta bene da persone: non impara tanto cose nuove, impara come comportarsi, cioè a fare l'assistente.
  Feedback umano (RLHF), come il lavoro: per rinforzo. Le persone confrontano risposte e premiano la migliore; il modello si affina sul campo secondo le preferenze (utile, onesto, innocuo). Oggi è la fase che cresce di più (modelli che "ragionano").
  Limite dell'analogia: l'evoluzione non trasmette conoscenze specifiche, il pre-addestramento invece ne accumula moltissime.
]

#slide(title: [Indovina la parola dopo], repeat: 2, self => [
  #let show-probs = self.subslide >= 2
  // one candidate: token, probability bar, percentage
  #let cand(tok, p, top: false) = (
    align(right, text(font: fonts.display, weight: "bold", size: 1.05em, fill: if top { palette.blue } else { palette.ink-soft }, tok)),
    box(width: 7em, height: 0.85em, {
      place(left + horizon, box(width: 100%, height: 100%, fill: palette.paper-dark))
      place(left + horizon, box(width: 7em * p / 100, height: 100%, fill: if top { palette.blue } else { palette.blue.lighten(55%) }))
    }),
    text(font: fonts.mono, size: 0.65em, weight: "bold", fill: if top { palette.blue } else { palette.muted }, str(p) + "%"),
  )
  #let blank = box(stroke: (bottom: 3pt + palette.blue), inset: (x: 0.5em, y: 0.1em), text(fill: palette.blue, weight: "bold")[?])
  #let probs = grid(
    columns: (auto, auto, auto),
    column-gutter: 0.5em,
    row-gutter: 0.5em,
    align: horizon,
    ..(([Roma], 92), ([una], 3), ([Milano], 2), ([Firenze], 1), ([Torino], 1)).enumerate().map(((i, (t, p))) => cand(t, p, top: i == 0)).flatten(),
  )
  #grid(
    columns: (auto, 1fr),
    column-gutter: 2.5em,
    align: horizon,
    text(size: 1.4em)[La capitale \ d'Italia è #blank],
    if show-probs { probs } else { hide(probs) },
  )
  #v(1.2em)
  #let msg = align(center, text(size: 0.85em)[Il modello non "sa" la risposta: dà una *probabilità* a ogni parola possibile.])
  #if show-probs { msg } else { hide(msg) }
])
#speaker-note[
  È lo stesso gioco dei numeri dell'inizio, ma con le parole. Il modello non conosce una risposta: assegna una probabilità a ogni parola possibile e sceglie tra le più probabili. Le percentuali sono illustrative.
  "una" è plausibile: "La capitale d'Italia è una città...". Il modello considera tutte le continuazioni.
  Come per 2, 4, 6, 8 bisognava trovare la regola, per dare il 92% a "Roma" bisogna aver compresso conoscenza sul mondo. Prevedere bene richiede di comprimere: torna l'idea dell'inizio.
  Esempio da raccontare a voce: "Alla fine del giallo, l'assassino è…": per indovinarlo bisogna aver capito tutto il romanzo (personaggi, moventi, indizi). Ecco perché un compito così semplice produce capacità così generali.
]

#slide(title: [Parola dopo parola], repeat: 5, self => [
  #let prompt = ("La", "capitale", "d'Italia", "è")
  #let gen = ("Roma,", "la", "città", "eterna")
  #let tok(t, fill, ink, weight: "medium") = box(fill: fill, inset: (x: 0.3em, y: 0.2em), text(font: fonts.display, weight: weight, fill: ink, t))
  #let row(i) = {
    box(stroke: (paint: palette.muted, thickness: 1pt, dash: "dashed"), inset: 0.2em, {
      prompt.map(t => tok(t, palette.paper-dark, palette.ink)).join(h(0.2em))
      for t in gen.slice(0, i) { h(0.2em); tok(t, palette.blue.lighten(85%), palette.blue) }
    })
    h(0.5em)
    text(fill: palette.muted, sym.arrow.r)
    h(0.5em)
    tok(gen.at(i), palette.blue, white, weight: "bold")
  }
  #text(size: 0.9em, stack(spacing: 0.4em, ..range(4).map(i => if self.subslide > i { row(i) } else { hide(row(i)) })))
  #v(0.4em)
  #let cards = grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 1.2em,
    align: top,
    card(title: [Prompt])[Il testo di partenza: la *tua domanda*.],
    card(title: [Autoregressivo])[Ogni parola scritta *torna in ingresso*.],
    card(title: [Contesto])[Ciò che rilegge a ogni passo: la sua *unica memoria*.],
  )
  #if self.subslide >= 5 { cards } else { hide(cards) }
])
#speaker-note[
  Il modello prevede una parola sola. Per scrivere una risposta la aggiunge al testo e ricomincia: rilegge tutto, prevede la successiva, e così via. È il significato di "autoregressivo".
  Il prompt è l'inizio del testo: la nostra domanda (più istruzioni nascoste dell'app). Per questo il modo in cui chiediamo cambia la risposta.
  Il contesto (la riga tratteggiata) è tutto ciò che il modello vede in quel momento: chat, documenti allegati, risposte già date. Oggi può contenere centinaia di migliaia di parole, qualche romanzo.
  Il modello non impara mentre parliamo: i pesi non cambiano. Chiusa la chat, dimentica. La "memoria" delle app sono appunti salvati e rimessi nel prompt.
  Siccome sceglie tra le parole più probabili, la stessa domanda può dare risposte diverse.
]

#slide(title: [Dal modello all'agente])[
  #text(size: 1.2em, font: fonts.display, weight: "bold")[Un modello *risponde*. Un agente *fa*.]
  #v(0.9em)
  #align(center, agent-anatomy(
    ["Prenotami un treno per Roma venerdì mattina"],
    [le tue preferenze, cosa ha già fatto],
    ([cerca sul web], [biglietteria], [calendario], [email]),
  ))
]
#speaker-note[
  Agente = LLM + strumenti (browser, email, codice, gestionali) + un obiettivo, in un ciclo: pensa, agisce, osserva il risultato, riprova.
  È qui che si sta spostando l'innovazione dal 2024-25: non più solo chat, ma lavoro svolto.
  Teniamolo a mente: è anche dove nascono i rischi (parte 3).
]

/*
#slide(title: [Un agente al lavoro], repeat: 4, self => [
  #let on(icon) = active => icon(size: 2.6em, fill: if active { palette.ink } else { palette.muted.lighten(30%) })
  #let llm = box(width: 2.6em, height: 2.6em, align(center + horizon, network((3, 4, 3), width: 2.6em, height: 2.2em, r: 0.17em)))
  #agent-diagram(
    self.subslide,
    person(size: 2.6em),
    llm,
    (
      (icon: on(magnifier)),
      (icon: on(train)),
      (icon: on(calendar)),
    ),
  )
])
#speaker-note[
  Esempio concreto: "Prenotami un treno per Roma venerdì mattina".
  1 la richiesta arriva all'LLM. 2-3 l'agente usa lo strumento di ricerca e legge i risultati (3 treni). 4-5 compra il biglietto più economico e lo mette in calendario. 6 risponde: fatto.
  L'agente è l'LLM più gli strumenti, in un ciclo.
  Pensa (decide il prossimo passo), agisce (usa uno strumento: un sito, un'app, un gestionale), osserva il risultato, e ricomincia finché l'obiettivo è raggiunto.
  Il modello non "sa" gli orari: li va a cercare con uno strumento. E spende soldi veri: qui nasce la domanda sulla sicurezza (parte 3).
]
*/

// ===========================================================================
#part-slide(number: "02", title: [Innovare con l'AI], subtitle: [Dalla ricerca alle imprese], color: palette.green)

#slide(title: [Chi inventa e chi cambia il mondo])[
  #v(0.8em)
  #grid(
    columns: (1fr, auto, 1fr),
    column-gutter: 1em,
    align: (top, horizon, top),
    card(tag: [2017 · Google], title: [_Attention Is All You Need_])[La ricerca che inventa il Transformer.],
    text(font: fonts.display, size: 2.4em, weight: "bold", fill: palette.muted, sym.arrow.r),
    card(tag: [2022 · OpenAI], title: [ChatGPT \ ])[Il prodotto che lo porta a tutti.],
  )
  #v(0.8em)
  #pause
  #text(size: 1.15em)[La ricerca apre la porta. *Chi la attraversa* non è sempre chi l'ha aperta.]
]
#speaker-note[
  Il Transformer è pubblicato da Google, apertamente. OpenAI lo usa ("GPT" = Generative Pre-trained Transformer) e lancia ChatGPT.
  Lezione: la ricerca pubblica è un bene comune; il vantaggio va a chi sa trasformarla in prodotto.
]

#statement-slide(kicker: [], size: 2.2em)[
  Non serve costruire il modello. \ Il valore è nella *competenza di settore* e nei *dati*.
]
#speaker-note[
  Costruire un modello di frontiera costa miliardi: lo fanno pochissime aziende al mondo.
  Ma i modelli si "affittano". Quello che non si affitta è conoscere il proprio mestiere e avere i propri dati (ordini, processi, clienti).
  ISTAT 2025: AI usata dal 16,4% delle imprese con almeno 10 addetti (8,2% nel 2024); grandi imprese 53%, PMI 15,7%. Ostacolo principale: le competenze.
]

#slide(title: [Chiuso o aperto?])[
  #let pro(t) = [#text(fill: palette.green, weight: "bold")[+] #t]
  #let con(t) = [#text(fill: palette.coral, weight: "bold")[−] #t]
  #v(0.4em)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.6em,
    align: top,
    card(tag: [GPT · Claude · Gemini], title: [Chiusi: si affittano])[
      Via app o API, sui server di chi li produce. \
      #pro[I più potenti, zero infrastruttura.] \
      #con[Non si ha controllo sui dati.]
    ],
    card(tag: [Llama · Mistral · Qwen · DeepSeek], title: [Aperti: si scaricano])[
      I pesi sono pubblici: girano *sui tuoi server*. \
      #pro[Dati in casa, personalizzabili.] \
      #con[Servono hardware e competenze.]
    ],
  )
  #v(0.8em)
  #pause
  #align(center, block(
    fill: palette.ink,
    inset: (x: 1.2em, y: 0.6em),
    text(fill: white)[#text(fill: palette.sun, weight: "bold")["Aperto"] = pesi scaricabili. Quasi mai i dati di allenamento.],
  ))
]
#speaker-note[
  Chiusi: GPT (OpenAI), Claude (Anthropic), Gemini (Google). Si pagano a consumo o in abbonamento; il modello non lascia mai i server del produttore.
  Aperti: Llama (Meta), Mistral (Francia), Qwen e DeepSeek (Cina), Kimi K2 visto prima. In Italia: Minerva (Sapienza), Velvet (Almawave), Italia (iGenius). Di solito sono qualche mese indietro rispetto ai migliori chiusi.
  Per un'azienda: dati sensibili (sanità, legale, progetti) → un modello aperto in casa; prototipo veloce → uno chiuso.
  "Aperto" di solito vuol dire open-weight: si scaricano i pesi, ma non i dati né la ricetta completa. Le licenze possono avere limiti d'uso.
  Collegamento con "Quanto sono large?": i più grandi aperti richiedono decine di GPU; quelli piccoli (pochi miliardi di pesi) girano su un buon PC.
]

#slide(title: [Le imprese italiane e l'AI])[
  #v(0.6em)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 1em,
    big-number([16,4%], [delle imprese (≥ 10 addetti) usa l'AI nel 2025]),
    big-number([×2], [rispetto all'anno prima (8,2%)], color: palette.ink),
    big-number([~60%], [di chi rinuncia lo fa per mancanza di competenze], color: palette.coral),
  )
  #source[Fonte: ISTAT, Imprese e ICT, 2025]
]
#speaker-note[
  Il collo di bottiglia non è la tecnologia, sono le persone che la sanno usare nel proprio contesto.
  Qui entra l'università (vedi dopo).
]

#slide(kicker: [Un nuovo linguaggio di programmazione], align: horizon)[
  #quote-block(who: [Andrej Karpathy, 2023])[
    The hottest new programming language is *English*.
  ]
]
#speaker-note[
  Karpathy (ex Tesla, cofondatore OpenAI). Programmare sta diventando "descrivere bene cosa si vuole".
]

#slide(title: [Il software diventa di tutti])[
  #let row(label, note, col, steps, colors) = grid(
    columns: (4.9em, 1fr),
    column-gutter: 1em,
    align: (left + horizon, left),
    {
      text(font: fonts.mono, size: 0.65em, weight: "bold", tracking: 0.08em, fill: col, upper(label))
      v(-0.5em)
      text(size: 0.6em, fill: palette.muted, note)
    },
    chevrons(steps.map(t => (text(size: 0.68em, weight: "bold", t), none)), colors: colors, height: 2.2em, notch: 0.8em),
  )
  #let grey = palette.muted.lighten(15%)
  #row([prima], [mesi, costi alti], palette.muted,
    ([chi ha il problema], [un programmatore], [il software]), (grey, grey, grey))
  #v(0.4em)
  #pause
  #row([ora], [ore, costi bassi], palette.green,
    ([chi ha il problema], [lo descrive a parole], [il software]), (palette.green.lighten(20%), palette.green.darken(15%), palette.green.lighten(20%)))
  #v(2em)
  #pause
  #quote-block(size: 1em, who: [Jensen Huang, CEO di NVIDIA · World Government Summit, 2024])[
    Ora *tutti nel mondo sono programmatori*. È il miracolo dell'AI.
  ]
]
#speaker-note[
  Prima: chi aveva un'idea (il ristoratore, il medico, l'artigiano) doveva spiegarla a un programmatore, aspettare, pagare.
  Ora: descrive a parole cosa gli serve e un assistente AI scrive il codice. Es. "una pagina per prenotare i tavoli, tre fasce orarie, massimo 40 coperti, mail di conferma".
  Non sparisce il programmatore: si sposta su problemi più difficili. Ma il software smette di essere un collo di bottiglia per chi conosce il proprio mestiere.
  Collegamento con la slide sulle PMI: il valore è nella competenza di settore.
  Citazione (traduzione): "Everybody in the world is now a programmer. This is the miracle of AI" (Jensen Huang, World Government Summit, Dubai, feb. 2024). Huang aggiunge che "il linguaggio di programmazione è quello umano".
  Messaggio chiave: chi conosce il problema ora può costruire la soluzione. Anche Microsoft (Nadella) e Karpathy ("Software 3.0") parlano di democratizzazione dello sviluppo software.
]

#slide(title: [Quattro settori, quattro casi])[
  #let sector(path, tag, title, body) = [
    #pic(path, height: 5.2em)
    #v(-0.1em)
    #text(font: fonts.mono, size: 0.6em, weight: "bold", fill: palette.green, upper(tag))
    #v(-0.55em)
    #text(font: fonts.display, size: 1.05em, weight: "bold", title)
    #v(-0.6em)
    #text(size: 0.72em, fill: palette.ink-soft, body)
  ]
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    column-gutter: 0.8em,
    sector("images/mammography.jpg", [medicina], [Identificazione], [Screening al seno con l'AI.]),
    sector("images/waymo.jpg", [trasporti], [Zero autisti], [Robotaxi Waymo in servizio.]),
    sector("images/factory.jpg", [manifattura], [Guasti previsti], [Manutenzione preventiva.]),
    sector("images/wind.jpg", [energia], [−40% energia], [Raffreddamento data center.]),
  )
]
#speaker-note[
  Medicina: studio MASAI (Svezia, Lancet Digital Health 2025), 100 mila donne: +29% tumori individuati, −44% letture per i radiologi.
  Trasporti: Waymo opera robotaxi senza conducente in diverse città USA.
  Manifattura: manutenzione predittiva e controllo qualità visivo: pochi dati di fabbrica + un modello pronto.
  Energia: DeepMind, 2016: −40% di energia per il raffreddamento; oggi anche previsione di produzione eolica e gestione delle reti.
  (Scegliere 1 caso da raccontare per esteso in base al pubblico.)
]

#split-slide("images/student.jpg", title: [E l'università?], side: right, ratio: 40%, credit: [Gary Todd, CC0])[
  #v(0.2em)
  #senses(
    [*Un tutor personale per tutti*: sempre disponibile, al ritmo di ciascuno.],
    [*Ricerca più veloce*: AlphaFold, Nobel per la Chimica 2024.],
    [*Gli studenti come ponte* verso le aziende: portano le competenze dove servono.],
  )
]
#speaker-note[
  Tutor: studio di Harvard (2025): un tutor AI ben progettato ha più che raddoppiato l'apprendimento rispetto a una lezione attiva, in meno tempo.
  Ricerca: AlphaFold ha predetto la struttura di quasi tutte le proteine note.
  Ponte: tesi e tirocini in azienda sono il canale più rapido per trasferire queste competenze alle PMI.
]

// ===========================================================================
#part-slide(number: "03", title: [Le sfide], subtitle: [Cosa può andare storto], color: palette.coral)

#slide(kicker: [Sfida 1])[
  #v(0.6em)
  #definition([cognitive offloading], pron: [scaricamento cognitivo], kind: [loc. ingl.], size: 2.8em)[
    Affidare a uno strumento esterno un lavoro che farebbe la nostra testa.
    #v(0.2em)
    #text(size: 0.8em, fill: palette.muted)[Lo facciamo da sempre: la lista della spesa, la calcolatrice, il navigatore.]
  ]
]
#speaker-note[
  Non è un male in sé: liberiamo memoria per altro. Il problema è quando smettiamo di esercitare capacità che ci servono.
]

#slide(title: [Lo stesso strumento, due risultati])[
  #text(size: 0.9em, fill: palette.muted)[Studenti di liceo, matematica, con GPT-4 durante gli esercizi.]
  #v(0.4em)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.2em,
    align: top,
    card(tag: [AI che dà le risposte])[
      #grid(columns: (1fr, 1fr),
        big-number(size: 2em, [+48%], [negli esercizi], color: palette.green),
        big-number(size: 2em, [−17%], [all'esame, senza AI], color: palette.coral),
      )
    ],
    card(tag: [AI che fa da tutor])[
      #grid(columns: (1fr, 1fr),
        big-number(size: 2em, [+127%], [negli esercizi], color: palette.green),
        big-number(size: 2em, [≈ 0], [nessun danno all'esame], color: palette.ink),
      )
    ],
  )
  #source[Bastani et al., "Generative AI without guardrails can harm learning", PNAS 2025]
]
#speaker-note[
  Esperimento su circa mille studenti in Turchia.
  Con l'AI "libera" copiano: vanno meglio mentre la usano, peggio quando viene tolta.
  Con l'AI progettata come tutor (indizi, non soluzioni) il danno sparisce.
  Messaggio: conta come usiamo lo strumento, non solo lo strumento.
]

#slide(kicker: [Sfida 2], title: [Più autonomia, più rischi])[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.4em,
    align: top,
    [
      #big-number(size: 2.2em, [×2 ogni 7 mesi], [la durata dei compiti che un agente AI riesce a completare da solo])
      #source[METR, 2025]
    ],
    [
      #v(0.4em)
      #senses(
        [Un errore in chat è una *risposta sbagliata*.],
        [Un errore di un agente è un'*azione sbagliata*.],
        [Serve *guardare dentro* i modelli: l'interpretabilità.],
      )
    ],
  )
]
#speaker-note[
  METR misura quanto lungo (in tempo umano) può essere un compito che un agente porta a termine: raddoppia circa ogni 7 mesi.
  Più deleghiamo, più conta capire perché il modello decide qualcosa: oggi sono in larga parte "scatole nere".
  L'interpretabilità prova ad aprire la scatola: trovare i concetti e i "circuiti" dentro la rete.
]

#slide(kicker: [Sfida 3], title: [Le regole che ancora mancano])[
  #v(0.2em)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.8em,
    align: top,
    card(tag: [UE · AI Act], title: [Alto rischio rinviato])[
      Obblighi spostati a *dicembre 2027* (e agosto 2028 per i prodotti regolati).
    ],
    card(tag: [Italia · L. 132/2025], title: [Decreti in arrivo])[
      Schemi di decreti attuativi approvati dal Governo a giugno 2026, iter in corso.
    ],
    card(tag: [Domanda aperta], title: [Chi risponde?])[
      Quando l'AI sbaglia: chi la produce, chi la vende o chi la usa?
    ],
  )
]
#speaker-note[
  AI Act in vigore da agosto 2024; divieti da febbraio 2025; regole sui modelli generali da agosto 2025.
  Il "Digital Omnibus" (in vigore da luglio 2026) rinvia gli obblighi sui sistemi ad alto rischio.
  Italia: legge 132/2025, prima legge nazionale organica in UE; i decreti attuativi stanno completando il quadro.
  Esempio concreto per "chi risponde": un'auto autonoma che sbaglia, una diagnosi suggerita dall'AI.
]

/*
#statement-slide(dark: true, kicker: [Per chiudere], size: 2.6em)[
  Cosa scegliamo di continuare a fare *con la nostra testa*?
]*/

#speaker-note[
  Ricapitolo in tre frasi: capire è comprimere, e le macchine ora lo fanno su scala enorme.
  Il valore per noi è nella competenza, non nel modello.
  La sfida non è solo tecnica: è decidere cosa delegare e cosa no.
]

#statement-slide(fill: palette.blue, kicker: [Grazie!], size: 2.4em)[
  Domande?
  #v(0.6em)
  #text(font: fonts.mono, weight: "regular", size: 0.35em)[gianluca.aguzzi\@unibo.it · gianluca.aguzzi.dev]
]
