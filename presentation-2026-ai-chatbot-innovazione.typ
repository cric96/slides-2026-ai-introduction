#import "@preview/touying:0.7.4": *
#import "theme/divulga.typ": *
#import "theme/diagrams.typ": *
#import "theme/icons.typ": *

// Speaker notes / pdfpc:
// typst query --root . --font-path fonts presentation-2026-ai-chatbot-innovazione.typ --field value --one "<pdfpc-file>" > slides.pdfpc
#let pdfpc-config = pdfpc.config(duration-minutes: 20, last-minutes: 3, note-font-size: 14)

#show: divulga-theme.with(
  config-common(preamble: pdfpc-config),
  config-info(title: [Intelligenza artificiale], author: [Gianluca Aguzzi]),
)

#title-slide(
  title: [Intelligenza\ artificiale],
  subtitle: [Capire per innovare, \ senza smettere di pensare],
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
      - *Ricerca*: AI collettiva, sistemi multi-agente, LLM
      
      #text(font: fonts.mono, size: 0.7em, fill: palette.muted)[gianluca.aguzzi\@unibo.it · gianluca.aguzzi.dev]
    ],
  )
]
#speaker-note[
  Presentazione veloce (20-30 secondi): chi sono e perché mi occupo di AI.
]

#statement-slide(dark: true, kicker: [30 novembre 2022], attribution: [ChatGPT, 1 milione di utenti in 5 giorni])[
  In cinque giorni, *un milione di persone* ha iniziato a parlare con una macchina.
]
#speaker-note[
  Apertura: tutti ricordiamo la prima volta che abbiamo usato ChatGPT.
  100 milioni di utenti in circa due mesi: la tecnologia di consumo più veloce di sempre.
  Domanda guida del talk: come ci siamo arrivati, cosa ci possiamo fare, cosa rischiamo.
]

// ===========================================================================
#part-slide(number: "01", title: [Capire l'AI], subtitle: [Cosa c'è dentro la scatola], color: palette.blue)

#slide(kicker: [Partiamo dalle parole])[
  #definition([intelligenza], pron: [in·tel·li·gèn·za], kind: [s.f.])[
    La capacità di *risolvere problemi mai visti prima*.
  ]
  #v(0.8em)
  #block(
    stroke: (left: 1.5pt + palette.muted),
    inset: (left: 0.9em, y: 0.2em),
    text(size: 0.72em, fill: palette.ink-soft)[
      #text(font: fonts.mono, weight: "bold", fill: palette.muted)[NOTA] #h(0.4em)
      Definirla resta un problema aperto: psicologi, filosofi e informatici non hanno una definizione condivisa
      (Legg e Hutter ne hanno raccolte oltre 70). Questa è una definizione _operativa_, utile per parlare di macchine.
    ],
  )
]
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
        text(font: fonts.mono, size: 1.8em, weight: "bold", fill: white)[n #sym.arrow.bar 2n],
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
      #text(font: fonts.mono, size: 0.7em, fill: palette.muted)[SE febbre E tosse ALLORA influenza]
    ],
    [
      #pic("images/perceptron.jpg", height: 5em)
      #v(0.3em)
      #pill([AI connessionista], fill: palette.blue)
      #v(-0.2em)
      #text(size: 1.05em)[*Reti che imparano* dagli esempi.]
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

#slide(title: [Dentro una rete neurale], repeat: 2, self => [
  #let (uncover,) = utils.methods(self)
  // three rows (label, diagram, caption) so both columns line up
  #grid(
    columns: (1fr, 1fr),
    rows: (auto, 7.4em, auto),
    column-gutter: 1.4em,
    row-gutter: 0.5em,
    align: (left + top),
    pill([un neurone], fill: palette.blue),
    uncover("2-", pill([tanti neuroni, a strati], fill: palette.coral)),
    align(center + horizon, perceptron(([febbre], [tosse], [dolori]), (0.8, 0.5, 0.2), [influenza?], size: 0.95em)),
    uncover("2-", align(center + horizon, network((3, 5, 5, 2)))),
    text(size: 0.8em)[Somma gli indizi, ciascuno col suo *peso*. \ Se il totale supera una soglia, "si accende".],
    uncover("2-", text(size: 0.8em)[*Imparare* = aggiustare milioni (oggi miliardi) di pesi, esempio dopo esempio.]),
  )
])
#speaker-note[
  Il perceptron di Rosenblatt (1958): un neurone artificiale. Riceve degli indizi, li pesa, li somma e decide.
  Differenza con l'AI simbolica: la regola "SE febbre E tosse" non la scrive nessuno. I pesi (quanto conta la febbre, quanto la tosse) li impara dagli esempi.
  Un neurone da solo è limitato (Minsky e Papert, 1969: primo inverno). Mettendone tanti a strati, "deep" learning, la rete impara concetti sempre più astratti.
  Un LLM moderno: centinaia di miliardi di pesi.
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
  #v(0.6em)
  #pause
  #text(size: 1.15em)[Nessuno basta da solo: è la *combinazione* a fare il salto.]
]
#speaker-note[
  Quattro ingredienti maturati insieme.
  Le idee di base esistevano dagli anni '80 (backpropagation).
  Mancavano dati in quantità e potenza di calcolo: le GPU, nate per la grafica dei videogiochi, sono perfette per i calcoli delle reti neurali.
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

#slide(title: [Come impara una macchina])[
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
    [per rinforzo], [prova, premio,\ riprova],
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

#image-slide(
  "images/datacenter.jpg",
  kicker: [Leggi di scala],
  caption: [Più dati, più calcolo: il modello migliora *in modo prevedibile*.],
  credit: [Foto: PiDatacenters, CC BY-SA 4.0],
)
#speaker-note[
  Le "scaling laws" (2020): l'errore scende in modo regolare aumentando dati e calcolo.
  Per le aziende ha voluto dire: investire in scala è una scommessa quasi sicura. Da qui la corsa ai data center.
]

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
    (inside([la biblioteca], [Pre-addestramento]), below([Legge mezza Internet e indovina la parola dopo.], [auto-supervisionato], palette.violet)),
    (inside([la scuola], [Fine-tuning]), below([Impara da esempi di domande e risposte giuste.], [supervisionato], palette.blue)),
    (inside([il tirocinio], [Feedback umano]), below([Le persone premiano la risposta migliore.], [per rinforzo], palette.coral)),
  ), colors: (palette.violet, palette.blue, palette.coral), height: 3em)
]
#speaker-note[
  Le tre fasi riusano i tre modi di imparare visti prima (stessi colori).
  Pre-addestramento: auto-supervisionato. Nessuno etichetta niente: la "risposta giusta" è la parola che segue davvero nel testo. Mesi su migliaia di GPU; impara lingua e conoscenza del mondo.
  Fine-tuning: supervisionato. Esempi di domande con la risposta scritta bene da persone: impara a fare l'assistente.
  Feedback umano (RLHF): per rinforzo. Le persone confrontano risposte e premiano la migliore; il modello impara le preferenze (utile, onesto, innocuo).
]

#slide(title: [Indovina la parola dopo])[
  #text(size: 1.25em)[La capitale d'Italia è #box(fill: palette.blue, inset: (x: 0.3em, y: 0.15em), text(fill: white, weight: "bold")[Roma])]

  #pause
  #text(size: 1.25em)[Alla fine del giallo, l'assassino è #box(stroke: (bottom: 3pt + palette.blue), inset: (x: 0.5em, y: 0.15em), text(fill: palette.blue, weight: "bold")[?])]
  #v(0.4em)
  #pause
  #definition([predire = comprimere], size: 1.4em)[
    Per indovinare bene la parola dopo, devi aver capito la storia, le persone, il mondo.
  ]
]
#speaker-note[
  La prima frase richiede solo memoria. La seconda richiede di aver capito tutto il romanzo: personaggi, moventi, indizi.
  Ecco perché un compito così semplice produce capacità così generali: per prevedere bene bisogna comprimere il mondo.
  Collegamento con la definizione iniziale.
]

#slide(title: [Dal modello all'agente])[
  #grid(
    columns: (1.15fr, 1fr),
    column-gutter: 1.4em,
    align: horizon,
    [
      #text(size: 1.5em, font: fonts.display, weight: "bold")[Un modello *risponde*.]
      #v(-0.3em)
      #text(size: 1.5em, font: fonts.display, weight: "bold")[Un agente *fa*.]
      #v(0.6em)
      #text(font: fonts.mono, size: 0.7em, fill: palette.muted)["Prenotami un treno per Roma venerdì mattina"]
      #v(-0.2em)
      #text(size: 0.85em)[cerca gli orari #sym.arrow.r confronta #sym.arrow.r compra #sym.arrow.r mette in calendario]
    ],
    agent-loop(),
  )
]
#speaker-note[
  Agente = LLM + strumenti (browser, email, codice, gestionali) + un obiettivo, in un ciclo: pensa, agisce, osserva il risultato, riprova.
  È qui che si sta spostando l'innovazione dal 2024-25: non più solo chat, ma lavoro svolto.
  Teniamolo a mente: è anche dove nascono i rischi (parte 3).
]

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

#statement-slide(kicker: [Buona notizia per le PMI], size: 2.2em)[
  Non serve costruire il modello. \ Il valore è nella *competenza di settore* e nei *dati*.
]
#speaker-note[
  Costruire un modello di frontiera costa miliardi: lo fanno pochissime aziende al mondo.
  Ma i modelli si "affittano". Quello che non si affitta è conoscere il proprio mestiere e avere i propri dati (ordini, processi, clienti).
  ISTAT 2025: AI usata dal 16,4% delle imprese con almeno 10 addetti (8,2% nel 2024); grandi imprese 53%, PMI 15,7%. Ostacolo principale: le competenze.
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
    sector("images/mammography.jpg", [medicina], [+29% tumori], [Screening al seno con l'AI.]),
    sector("images/waymo.jpg", [trasporti], [Zero autisti], [Robotaxi Waymo in servizio.]),
    sector("images/factory.jpg", [manifattura], [Guasti previsti], [Manutenzione prima del fermo.]),
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
    [*Un tutor personale per tutti*: disponibile alle 2 di notte, al ritmo di ciascuno.],
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

#statement-slide(dark: true, kicker: [Per chiudere], size: 2.6em)[
  Cosa scegliamo di continuare a fare *con la nostra testa*?
]
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
