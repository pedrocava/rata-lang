#let rata-manual(
  title: "Rata Programming Language Manual",
  subtitle: "",
  version: "0.0.1-alpha",
  author: "The Rata Team",
  date: datetime.today(),
  body
) = {
  // Configure document
  set document(title: title, author: author, date: date)
  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2cm),
    numbering: "1",
    number-align: center,
  )
  
  // Typography settings
  set text(
    font: ("Source Sans Pro", "Liberation Sans", "Arial"),
    size: 11pt,
    lang: "en"
  )
  
  // Headings
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(2em)
    block(
      text(
        size: 24pt,
        weight: "bold",
        fill: rgb("#2563eb"), // Rata blue
        it.body
      )
    )
    v(1em)
  }
  
  show heading.where(level: 2): it => {
    v(1.5em)
    block(
      text(
        size: 18pt,
        weight: "bold",
        fill: rgb("#1e40af"),
        it.body
      )
    )
    v(0.5em)
  }
  
  show heading.where(level: 3): it => {
    v(1em)
    block(
      text(
        size: 14pt,
        weight: "bold",
        fill: rgb("#1e3a8a"),
        it.body
      )
    )
    v(0.3em)
  }
  
  // Code blocks
  show raw.where(block: true): it => {
    block(
      fill: rgb("#f8fafc"),
      stroke: rgb("#e2e8f0"),
      inset: 1em,
      radius: 4pt,
      width: 100%,
      text(
        font: ("Source Code Pro", "Consolas", "Monaco", "monospace"),
        size: 9.5pt,
        it
      )
    )
  }
  
  // Inline code
  show raw.where(block: false): it => {
    box(
      fill: rgb("#f1f5f9"),
      inset: (x: 3pt, y: 1pt),
      radius: 2pt,
      text(
        font: ("Source Code Pro", "Consolas", "Monaco", "monospace"),
        size: 9.5pt,
        fill: rgb("#0f172a"),
        it
      )
    )
  }
  
  // Links
  show link: it => {
    text(fill: rgb("#2563eb"), underline: true, it)
  }
  
  // Lists
  set list(indent: 1em, body-indent: 0.5em)
  set enum(indent: 1em, body-indent: 0.5em)
  
  // Tables
  show table: it => {
    block(
      stroke: rgb("#e2e8f0"),
      inset: 0.5em,
      radius: 4pt,
      it
    )
  }
  
  // Quotes/callouts
  show quote: it => {
    block(
      fill: rgb("#fef3c7"),
      stroke: (left: 4pt + rgb("#f59e0b")),
      inset: 1em,
      radius: 4pt,
      it.body
    )
  }
  
  // Title page
  align(center)[
    #v(4cm)
    
    // Logo placeholder - replace with actual Rata logo
    #box(
      width: 3cm,
      height: 3cm,
      fill: rgb("#2563eb"),
      radius: 8pt,
      stroke: none
    )[
      #align(center + horizon)[
        #text(
          size: 48pt,
          fill: white,
          weight: "bold",
          font: ("Source Sans Pro", "Arial")
        )[R]
      ]
    ]
    
    #v(1cm)
    
    #text(
      size: 32pt,
      weight: "bold",
      fill: rgb("#1e40af")
    )[#title]
    
    #if subtitle != "" {
      v(0.5cm)
      text(size: 18pt, fill: rgb("#64748b"))[#subtitle]
    }
    
    #v(1cm)
    
    #text(size: 14pt, fill: rgb("#64748b"))[
      Version #version \
      #date.display("[month repr:long] [day], [year]")
    ]
    
    #v(2cm)
    
    #text(size: 12pt, fill: rgb("#64748b"))[
      #author
    ]
  ]
  
  // Table of contents
  pagebreak()
  
  align(center)[
    #text(size: 24pt, weight: "bold", fill: rgb("#2563eb"))[Table of Contents]
  ]
  
  v(1em)
  
  outline(
    title: none,
    depth: 3,
    indent: auto
  )
  
  // Main content
  pagebreak()
  
  body
  
  // Footer with generation info
  place(
    bottom + center,
    dy: -1cm,
    block[
      #line(length: 100%, stroke: rgb("#e2e8f0"))
      #v(0.5em)
      #text(
        size: 9pt,
        fill: rgb("#64748b")
      )[
        Generated with Typst • Rata Programming Language Manual • #date.display("[month repr:short] [year]")
      ]
    ]
  )
}

// Syntax highlighting for Rata code
#let rata-code(code) = {
  raw(
    code,
    lang: "rata"  // Custom language for syntax highlighting
  )
}

// Callout boxes for special content
#let note(body) = {
  block(
    fill: rgb("#dbeafe"),
    stroke: (left: 4pt + rgb("#3b82f6")),
    inset: 1em,
    radius: 4pt,
    width: 100%
  )[
    #text(weight: "bold", fill: rgb("#1e40af"))[Note: ] #body
  ]
}

#let warning(body) = {
  block(
    fill: rgb("#fef3c7"),
    stroke: (left: 4pt + rgb("#f59e0b")),
    inset: 1em,
    radius: 4pt,
    width: 100%
  )[
    #text(weight: "bold", fill: rgb("#92400e"))[Warning: ] #body
  ]
}

#let tip(body) = {
  block(
    fill: rgb("#d1fae5"),
    stroke: (left: 4pt + rgb("#10b981")),
    inset: 1em,
    radius: 4pt,
    width: 100%
  )[
    #text(weight: "bold", fill: rgb("#065f46"))[Tip: ] #body
  ]
}

#let example(title: "", body) = {
  block(
    fill: rgb("#f3f4f6"),
    stroke: rgb("#d1d5db"),
    inset: 1em,
    radius: 4pt,
    width: 100%
  )[
    #if title != "" [
      #text(weight: "bold", fill: rgb("#374151"))[Example: #title]
      #v(0.5em)
    ]
    #body
  ]
}