// Native diagrams for the talk, drawn with plain Typst so they stay crisp and on-palette.
#import "divulga.typ": palette, fonts, accent

#let _mono(body, ..args) = text(font: fonts.mono, ..args, body)

/// Horizontal timeline. `events`: array of (year, label, kind) with kind in
/// "symb" | "conn" | "winter" | "boom".
#let timeline(events, height: 6.2em) = context {
  let c = accent.get()
  let color-of(kind) = if kind == "symb" { palette.violet } else if kind == "conn" { palette.blue } else if kind == "winter" { palette.muted } else { palette.coral }
  let n = events.len()
  block(width: 100%, height: height, {
    place(horizon + left, line(length: 100%, stroke: 3pt + palette.line))
    for (i, ev) in events.enumerate() {
      let (year, label, kind) = ev
      let x = (i + 0.5) / n * 100%
      let up = calc.rem(i, 2) == 0
      let col = color-of(kind)
      place(horizon + left, dx: x - 0.45em, circle(radius: 0.45em, fill: if kind == "winter" { palette.paper } else { col }, stroke: 2.5pt + col))
      place(
        if up { top + left } else { bottom + left },
        dx: x - 3.5em,
        box(width: 7em, align(center, {
          if not up { v(0.2em) }
          text(font: fonts.display, weight: "bold", size: 0.95em, fill: col, year)
          linebreak()
          text(size: 0.62em, fill: palette.ink-soft, label)
        })),
      )
    }
  })
}

/// A sentence whose words are linked by attention arcs to one focus word.
/// `words`: array of strings; `focus`: index; `weights`: array (same length) in [0,1].
#let attention(words, focus, weights, size: 1.2em) = context {
  let c = accent.get()
  let n = words.len()
  set text(size: size)
  layout(sz => {
    let w = sz.width
    let slot = w / n
    let base = 3.2em
    block(width: 100%, height: base + 1.6em, {
      for (i, word) in words.enumerate() {
        let cx = slot * (i + 0.5)
        let wgt = weights.at(i)
        if i != focus and wgt > 0.05 {
          let fx = slot * (focus + 0.5)
          let mid = (cx + fx) / 2
          let hgt = calc.min(base - 0.4em, 0.6em + calc.abs(i - focus) * 0.55em)
          place(top + left, curve(
            stroke: (paint: c.transparentize(100% - wgt * 100%), thickness: 1pt + 5pt * wgt, cap: "round"),
            curve.move((cx, base - 0.2em)),
            curve.quad((mid, base - 0.2em - hgt * 2), (fx, base - 0.2em)),
          ))
        }
        place(top + left, dx: cx - slot / 2, dy: base, box(width: slot, align(center, {
          let f = i == focus
          box(
            fill: if f { c } else { c.transparentize(100% - wgt * 35%) },
            inset: (x: 0.3em, y: 0.25em),
            text(font: fonts.display, weight: if f { "bold" } else { "medium" }, fill: if f { white } else { palette.ink }, word),
          )
        })))
      }
    })
  })
}

/// Row of boxes joined by arrows.
#let flow(steps, colors: none, size: 1em) = context {
  let c = accent.get()
  let n = steps.len()
  let cells = ()
  for (i, st) in steps.enumerate() {
    let col = if colors != none { colors.at(i) } else { c }
    cells.push(block(
      width: 100%,
      stroke: (top: 4pt + col),
      inset: (top: 0.6em),
      align(left, text(size: size, st)),
    ))
    if i < n - 1 {
      // arrow drawn on the same line as the top rules, so the steps read as one pipeline
      cells.push(box(width: 100%, height: 4pt, {
        place(top + left, dy: 2pt, line(start: (0.3em, 0pt), end: (100% - 0.5em, 0pt), stroke: 2pt + palette.muted))
        place(top + left, dx: 100% - 0.75em, dy: 2pt - 0.32em, polygon(fill: palette.muted, (0pt, 0pt), (0.55em, 0.32em), (0pt, 0.64em)))
      }))
    }
  }
  grid(columns: range(2 * n - 1).map(i => if calc.even(i) { 1fr } else { 2.6em }), align: top, ..cells)
}

/// The agent loop: perceive → think → act, around an environment.
#let agent-loop(size: 1em) = context {
  let c = accent.get()
  let node(label, col) = box(
    fill: col,
    inset: (x: 1em, y: 0.55em),
    text(font: fonts.display, weight: "bold", fill: white, size: size, label),
  )
  block(width: 100%, height: 9.5em, {
    place(center + horizon, circle(radius: 3.8em, stroke: (paint: palette.line, thickness: 3pt, dash: "dashed")))
    place(center + horizon, text(font: fonts.mono, size: 0.7em, fill: palette.muted, align(center)[obiettivo \ + strumenti]))
    place(center + top, node([Pensa], c))
    place(center + bottom, dx: -4.6em, node([Agisce], palette.coral))
    place(center + bottom, dx: 4.6em, node([Osserva], palette.green))
  })
}

/// A single artificial neuron (perceptron): labelled inputs with weights → Σ → output.
#let perceptron(inputs, weights, output, size: 1em) = context {
  let c = accent.get()
  set text(size: size)
  let n = inputs.len()
  let w = 15.9em
  let h = 7.5em
  let in-x = 4.2em
  let sum = (8.2em, h / 2)
  let r = 1.1em
  block(width: w, height: h, {
    for (i, (label, wt)) in inputs.zip(weights).enumerate() {
      let y = h * (i + 0.5) / n
      place(top + left, line(
        start: (in-x, y),
        end: (sum.at(0) - r, sum.at(1)),
        stroke: (paint: c, thickness: 0.8pt + 3pt * wt, cap: "round"),
      ))
      place(top + left, dx: 0em, dy: y - 1em, box(width: in-x - 0.5em, height: 2em, align(right + horizon, text(size: 0.8em, label))))
      let mx = in-x + (sum.at(0) - r - in-x) * 0.22
      let my = y + (sum.at(1) - y) * 0.22
      place(top + left, dx: mx - 0.9em, dy: my - 1.05em, box(
        fill: palette.paper, inset: 0.12em,
        text(font: fonts.mono, size: 0.55em, fill: palette.muted, "w=" + str(wt)),
      ))
    }
    place(top + left, dx: sum.at(0) - r, dy: sum.at(1) - r, circle(
      radius: r, fill: c,
      align(center + horizon, text(font: fonts.display, weight: "bold", fill: white, size: 1.1em, $Sigma$)),
    ))
    // output arrow, label centred on it
    let (ox, oy) = (sum.at(0) + r + 0.25em, sum.at(1))
    place(top + left, line(start: (ox, oy), end: (ox + 1.1em, oy), stroke: (paint: palette.ink, thickness: 2.5pt, cap: "round")))
    place(top + left, polygon(fill: palette.ink, (ox + 1em, oy - 0.3em), (ox + 1.45em, oy), (ox + 1em, oy + 0.3em)))
    place(top + left, dx: ox + 1.7em, dy: oy - 1em, box(height: 2em, align(horizon, text(font: fonts.display, weight: "bold", output))))
  })
}

/// A layered neural network: `layers` is the number of neurons per layer.
#let network(layers, width: 12em, height: 7.5em, r: 0.42em) = context {
  let c = accent.get()
  let L = layers.len()
  let pos(l, i) = {
    let n = layers.at(l)
    (width * (l + 0.5) / L, height * (i + 0.5) / n)
  }
  block(width: width, height: height, {
    for l in range(L - 1) {
      for i in range(layers.at(l)) {
        for j in range(layers.at(l + 1)) {
          place(top + left, line(start: pos(l, i), end: pos(l + 1, j), stroke: 0.6pt + c.transparentize(65%)))
        }
      }
    }
    for l in range(L) {
      for i in range(layers.at(l)) {
        let (x, y) = pos(l, i)
        let col = if l == 0 { palette.muted } else if l == L - 1 { palette.coral } else { c }
        place(top + left, dx: x - r, dy: y - r, circle(radius: r, fill: col, stroke: 1.5pt + palette.paper))
      }
    }
  })
}

/// A layered network drawn big: few large neurons, connections with varied
/// (deterministic pseudo-random) strength, so it reads as "learned weights".
/// `outputs`: optional array of (label, active) for the last layer, labelled at its right.
#let deep-network(layers, width: 20em, height: 6em, r: 0.55em, outputs: none) = context {
  let c = accent.get()
  let L = layers.len()
  let pos(l, i) = {
    let n = layers.at(l)
    (width * (l + 0.5) / L, height * (i + 0.5) / n)
  }
  // weight in [0, 1], stable across compiles
  let weight(l, i, j) = calc.rem(l * 53 + i * 31 + j * 17 + i * j * 7, 23) / 22
  block(width: width, height: height, {
    for l in range(L - 1) {
      for i in range(layers.at(l)) {
        for j in range(layers.at(l + 1)) {
          let w = weight(l, i, j)
          let w = w * w
          place(top + left, line(
            start: pos(l, i),
            end: pos(l + 1, j),
            stroke: (paint: c.transparentize(88% - 70% * w), thickness: 0.6pt + 4.4pt * w, cap: "round"),
          ))
        }
      }
    }
    for l in range(L) {
      for i in range(layers.at(l)) {
        let (x, y) = pos(l, i)
        let last = l == L - 1
        let on = not last or outputs == none or outputs.at(i).at(1)
        let col = if l == 0 { palette.muted } else if last { if on { palette.coral } else { palette.paper } } else { c }
        let rr = if last { r * 1.35 } else { r }
        if last and on {
          place(top + left, dx: x - rr * 1.6, dy: y - rr * 1.6, circle(radius: rr * 1.6, fill: palette.coral.transparentize(82%)))
        }
        place(top + left, dx: x - rr, dy: y - rr, circle(
          radius: rr, fill: col,
          stroke: if last and not on { 2.5pt + palette.muted } else { 3pt + palette.paper },
        ))
        if last and outputs != none {
          place(top + left, dx: x + rr * 1.9, dy: y - 0.6em, text(
            font: fonts.display, weight: "bold", size: 1em,
            fill: if on { palette.coral } else { palette.muted },
            outputs.at(i).at(0),
          ))
        }
      }
    }
  })
}

/// Scatter of dots. `points`: array of (x, y) in [0, 1]; `colors`: one per point.
#let scatter(points, colors, width: 7.6em, height: 3.6em, r: 0.26em) = box(
  width: width,
  height: height,
  {
    for ((x, y), col) in points.zip(colors) {
      place(top + left, dx: 0.4em + (width - 0.8em) * x - r, dy: 0.4em + (height - 0.8em) * y - r, circle(radius: r, fill: col))
    }
  },
)

/// Frameless panel for the learning flows.
#let panel(body, width: 7.6em, height: 3.6em) = box(
  width: width,
  height: height,
  inset: 0.35em,
  align(center + horizon, body),
)

/// One learning flow: label | input → network → output.
#let learning-flow(tag, caption, input, output, color: auto) = context {
  let c = if color == auto { accent.get() } else { color }
  let arrow = text(font: fonts.display, size: 1.3em, weight: "bold", fill: palette.muted, sym.arrow.r)
  grid(
    columns: (8em, auto, 1.5em, auto, 1.5em, auto),
    align: horizon + center,
    align(left, {
      box(fill: c, inset: (x: 0.5em, y: 0.3em), text(font: fonts.mono, size: 0.55em, weight: "medium", fill: white, tracking: 0.05em, upper(tag)))
      linebreak()
      text(size: 0.72em, fill: palette.ink-soft, caption)
    }),
    input,
    arrow,
    network((3, 4, 3), width: 3.8em, height: 3.4em, r: 0.24em),
    arrow,
    output,
  )
}

/// Straight arrow with a numbered badge and a short label at its midpoint.
#let _arrow(a, b, col, num, label, label-dy: -0.9em) = {
  let (x1, y1) = a
  let (x2, y2) = b
  let ang = calc.atan2((x2 - x1).to-absolute().pt(), (y2 - y1).to-absolute().pt())
  let h = 0.45em
  place(top + left, line(start: a, end: b, stroke: (paint: col, thickness: 2.5pt, cap: "round")))
  place(top + left, polygon(
    fill: col,
    (x2, y2),
    (x2 - h * calc.cos(ang) + h * 0.6 * calc.sin(ang), y2 - h * calc.sin(ang) - h * 0.6 * calc.cos(ang)),
    (x2 - h * calc.cos(ang) - h * 0.6 * calc.sin(ang), y2 - h * calc.sin(ang) + h * 0.6 * calc.cos(ang)),
  ))
  let mx = (x1 + x2) / 2
  let my = (y1 + y2) / 2
  place(top + left, dx: mx - 0.42em, dy: my - 0.42em, circle(radius: 0.42em, fill: col,
    align(center + horizon, text(font: fonts.mono, size: 0.55em, weight: "bold", fill: white, str(num)))))
  place(top + left, dx: mx - 3em, dy: my + label-dy, box(width: 6em, align(center,
    text(font: fonts.mono, size: 0.62em, weight: "medium", fill: col, label))))
}

/// The agent at work, revealed in `stage` steps (1–4):
/// 1 request · 2-3 search · 4-5 buy + calendar · 6 answer.
#let agent-diagram(stage, user-icon, llm-icon, tools) = context {
  let c = accent.get()
  let (ux, ax, tx) = (2.6em, 15.5em, 29em)
  let node(x, y, icon, label, active: true) = {
    place(top + left, dx: x - 1.3em, dy: y - 1.3em, icon)
    place(top + left, dx: x - 3.5em, dy: y + 1.35em, box(width: 7em, align(center,
      text(font: fonts.display, size: 0.7em, weight: "bold", fill: if active { palette.ink } else { palette.muted }, label))))
  }
  let (search, ticket, cal) = tools
  block(width: 100%, height: 10.8em, {
    place(top + left, dx: ax - 2.7em, dy: 5em - 2.7em, circle(radius: 2.7em, stroke: (paint: c, thickness: 1.5pt, dash: "dashed")))
    place(top + left, dx: ax - 2em, dy: 5em - 3.4em, box(width: 4em, align(center, text(font: fonts.mono, size: 0.55em, weight: "bold", fill: c, "AGENTE"))))
    node(ux, 5em, user-icon, [Tu])
    node(ax, 5em, llm-icon, [LLM])
    node(tx, 1.4em, (search.icon)(stage >= 2), [cerca treni], active: stage >= 2)
    node(tx, 5em, (ticket.icon)(stage >= 3), [biglietteria], active: stage >= 3)
    node(tx, 8.6em, (cal.icon)(stage >= 3), [calendario], active: stage >= 3)
    if stage >= 1 { _arrow((ux + 1.8em, 4.4em), (ax - 3.1em, 4.4em), palette.ink, 1, [richiesta]) }
    if stage >= 2 {
      _arrow((ax + 2.6em, 3.5em), (tx - 1.8em, 1em), palette.coral, 2, [cerca])
      _arrow((tx - 1.8em, 2.1em), (ax + 2.9em, 4.3em), palette.green, 3, [3 treni], label-dy: 0.55em)
    }
    if stage >= 3 {
      _arrow((ax + 3em, 5.2em), (tx - 1.8em, 5.2em), palette.coral, 4, [compra], label-dy: 0.55em)
      _arrow((ax + 2.6em, 6.6em), (tx - 1.8em, 8.6em), palette.coral, 5, [in agenda], label-dy: 0.55em)
    }
    if stage >= 4 { _arrow((ax - 3.1em, 5.8em), (ux + 1.8em, 5.8em), palette.green, 6, [fatto!], label-dy: 0.55em) }
  })
}

/// Row of chevron arrows with the text inside, and an optional caption under each.
/// `steps`: array of (inside, below) contents.
#let chevrons(steps, colors: none, height: 3em, notch: 1em, gap: 0.25em) = context {
  let c = accent.get()
  let n = steps.len()
  layout(sz => {
    let w = (sz.width - gap * (n - 1)) / n
    let row = for (i, (inside, _)) in steps.enumerate() {
      let col = if colors != none { colors.at(i) } else { c }
      let first = i == 0
      let pts = (
        (0pt, 0pt), (w - notch, 0pt), (w, height / 2), (w - notch, height), (0pt, height),
      )
      if not first { pts.push((notch, height / 2)) }
      let x = i * (w + gap)
      place(top + left, dx: x, polygon(fill: col, ..pts))
      place(top + left, dx: x + if first { 0.7em } else { notch + 0.3em }, box(
        width: w - notch - if first { 0.9em } else { notch + 0.4em },
        height: height,
        align(left + horizon, text(fill: white, inside)),
      ))
    }
    block(width: 100%, height: height, row)
    if steps.all(((_, b)) => b == none) { return }
    v(0.5em)
    grid(
      columns: (w,) * n,
      column-gutter: gap,
      align: top + left,
      ..steps.enumerate().map(((i, (_, below))) => pad(left: if i == 0 { 0.7em } else { notch + 0.3em }, right: notch, if below == none { [] } else { below })),
    )
  })
}

/// Horizontal bars on a linear scale. `rows`: array of (label, sub, value, value-label, color).
#let bars(rows, max: auto, label-width: 7em, bar-height: 0.9em) = context {
  let m = if max == auto { calc.max(..rows.map(r => r.at(2))) } else { max }
  layout(sz => {
    let full = (sz.width - label-width - 6.5em).to-absolute()
    grid(
      columns: (label-width, 1fr),
      column-gutter: 0.6em,
      row-gutter: 0.55em,
      align: (right + horizon, left + horizon),
      ..rows.map(((label, sub, v, vl, col)) => (
        {
          text(font: fonts.display, weight: "bold", size: 0.8em, label)
          if sub != none { linebreak(); text(font: fonts.mono, size: 0.5em, fill: palette.muted, sub) }
        },
        stack(dir: ltr, spacing: 0.4em,
          box(width: calc.max((full * v / m).to-absolute(), 3pt), height: bar-height, fill: col),
          box(height: bar-height, align(horizon, text(font: fonts.mono, size: 0.62em, weight: "bold", fill: col, vl))),
        ),
      )).flatten(),
    )
  })
}

/// Logarithmic scale with items above and below the axis.
/// `above` / `below`: arrays of (value, icon-or-none, label, value-label).
#let log-scale(above, below, from: 7, to: 14, height: 8.6em, show-bottom: true, unit: none) = context {
  let c = accent.get()
  layout(sz => {
    let w = sz.width
    let pad = 2.2em
    let x(v) = pad + (w - 2 * pad) * (calc.log(v) - from) / (to - from)
    let axis-y = height * 0.52
    block(width: w, height: height, {
      place(top + left, dy: axis-y, line(start: (pad - 1em, 0pt), end: (w - pad + 1em, 0pt), stroke: 2pt + palette.line))
      place(top + left, dx: w - pad + 0.9em, dy: axis-y - 0.3em, polygon(fill: palette.line, (0em, 0em), (0.5em, 0.3em), (0em, 0.6em)))
      for e in range(from, to + 1) {
        place(top + left, dx: x(calc.pow(10.0, e)) - 0.75pt, dy: axis-y - 0.25em, line(length: 0.5em, angle: 90deg, stroke: 1.5pt + palette.line))
      }
      if unit != none {
        place(top + left, dx: w - pad - 6em, dy: axis-y + 0.45em, box(width: 7em, align(right, text(font: fonts.mono, size: 0.45em, fill: palette.muted, unit))))
      }
      for (val, icon, label, vl) in above {
        let cx = x(val)
        place(top + left, dx: cx - 0.3em, dy: axis-y - 0.3em, circle(radius: 0.3em, fill: palette.ink, stroke: 2pt + palette.paper))
        place(top + left, dx: cx - 3em, dy: 0em, box(width: 6em, height: axis-y - 0.55em, align(center + bottom, stack(
          spacing: 0.3em,
          if icon != none { icon },
          text(font: fonts.display, weight: "bold", size: 0.7em, label),
          text(font: fonts.mono, size: 0.52em, fill: palette.muted, vl),
        ))))
      }
      if show-bottom {
        for (val, icon, label, vl) in below {
          let cx = x(val)
          place(top + left, dx: cx - 0.36em, dy: axis-y - 0.36em, rect(width: 0.72em, height: 0.72em, fill: c, stroke: 2pt + palette.paper))
          place(top + left, dx: cx - 3em, dy: axis-y + 0.6em, box(width: 6em, align(center + top, stack(
            spacing: 0.3em,
            box(fill: c, inset: (x: 0.3em, y: 0.2em), text(font: fonts.display, weight: "bold", size: 0.7em, fill: white, label)),
            text(font: fonts.mono, size: 0.52em, weight: "bold", fill: c, vl),
          ))))
        }
      }
    })
  })
}

/// Anatomy of an agent: the network (LLM) at the centre, goal and memory on the
/// left, tools on the right, joined by the act / observe loop.
#let agent-anatomy(goal, memory, tools, width: 25em, height: 9.6em) = context {
  let c = accent.get()
  let arrow(a, b, col, label: none, label-dy: -0.95em) = {
    let (x1, y1) = a
    let (x2, y2) = b
    let dir = if x2 > x1 { 1 } else { -1 }
    // cubic with horizontal tangents at both ends, so the head always lines up
    let ex = x2 - dir * 0.4em
    let mx = (x1 + ex) / 2
    place(top + left, curve(
      stroke: (paint: col, thickness: 2.5pt, cap: "round"),
      curve.move(a),
      curve.cubic((mx, y1), (mx, y2), (ex, y2)),
    ))
    place(top + left, polygon(fill: col, (x2, y2), (x2 - dir * 0.5em, y2 - 0.28em), (x2 - dir * 0.5em, y2 + 0.28em)))
    if label != none {
      place(top + left, dx: (x1 + x2) / 2 - 3em, dy: y1 + label-dy, box(width: 6em, align(center,
        text(font: fonts.mono, size: 0.55em, weight: "bold", fill: col, label))))
    }
  }
  let card(x, y, w, h, tag, col, body) = place(top + left, dx: x, dy: y, block(
    width: w, height: h, fill: palette.paper-dark, stroke: (top: 3pt + col), inset: (x: 0.55em, top: 0.45em),
    {
      text(font: fonts.mono, size: 0.5em, weight: "bold", tracking: 0.06em, fill: col, upper(tag))
      v(-0.35em)
      text(size: 0.6em, body)
    },
  ))
  let mid = height / 2
  block(width: width, height: height, {
    // the agent boundary
    place(top + left, rect(width: 100%, height: 100%, stroke: (paint: c, thickness: 1.5pt, dash: "dashed")))
    place(top + left, dx: 0.6em, dy: -0.45em, box(fill: palette.paper, inset: (x: 0.3em),
      text(font: fonts.mono, size: 0.55em, weight: "bold", tracking: 0.08em, fill: c, "AGENTE")))
    // left: goal and memory
    card(0.8em, 0.9em, 7em, 3.7em, [obiettivo], palette.ink, goal)
    card(0.8em, 5.1em, 7em, 3.7em, [memoria], palette.violet, memory)
    // centre: the network
    let (cx, cw) = (10.1em, 5.2em)
    place(top + left, dx: cx, dy: mid - 2.6em, block(width: cw, height: 4.6em, fill: white, stroke: 2.5pt + c, radius: 0.3em,
      align(center + horizon, network((3, 4, 4, 3), width: 4.4em, height: 3.8em, r: 0.24em)),
    ))
    place(top + left, dx: cx, dy: mid + 2.15em, box(width: cw, align(center, {
      text(font: fonts.display, weight: "bold", size: 0.7em, fill: c, "LLM")
      linebreak()
      text(font: fonts.mono, size: 0.48em, fill: palette.muted, "la rete neurale")
    })))
    arrow((7.9em, 2.75em), (cx - 0.15em, mid - 1em), palette.ink)
    arrow((7.9em, 6.95em), (cx - 0.15em, mid + 0.8em), palette.violet)
    // right: tools
    let tx = 18.3em
    place(top + left, dx: tx, dy: 0.75em, text(font: fonts.mono, size: 0.5em, weight: "bold", tracking: 0.06em, fill: palette.coral, "STRUMENTI"))
    for (i, t) in tools.enumerate() {
      place(top + left, dx: tx, dy: 1.7em + i * 1.85em, block(width: 5.9em, height: 1.45em, fill: palette.paper-dark,
        stroke: (left: 3pt + palette.coral), inset: (x: 0.45em), align(horizon, text(size: 0.6em, t))))
    }
    // the loop
    arrow((cx + cw + 0.1em, mid - 1.1em), (tx - 0.25em, mid - 1.1em), palette.coral, label: [agisce])
    arrow((tx - 0.25em, mid + 0.7em), (cx + cw + 0.1em, mid + 0.7em), palette.green, label: [osserva], label-dy: 0.35em)
  })
}
