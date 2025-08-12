#let module_doc(
  name: "",
  description: "",
  functions: (),
) = {
  // Page setup
  set page(
    paper: "a4",
    margin: (top: 2cm, bottom: 2cm, left: 2.5cm, right: 2.5cm),
  )
  
  set text(
    font: "Inter",
    size: 11pt,
    lang: "en"
  )
  
  set heading(numbering: "1.")
  
  // Title
  align(center)[
    #block(
      fill: luma(240),
      inset: 20pt,
      radius: 8pt,
      width: 100%,
    )[
      #text(size: 24pt, weight: "bold")[#name Module]
    ]
  ]
  
  v(1.5em)
  
  // Module description
  if description != "" {
    block(
      fill: luma(250), 
      inset: 15pt,
      radius: 4pt,
      width: 100%,
    )[
      #text(size: 12pt)[#description]
    ]
    v(1em)
  }
  
  // Import section
  block(
    fill: luma(245),
    inset: 12pt,
    radius: 4pt,
    width: 100%,
  )[
    *Import:*
    #raw(lang: "rata", "library " + name + " as " + lower(name.slice(0, 1)) + name.slice(1).replace(regex("[A-Z]"), m => lower(m.text)))
  ]
  
  v(1.5em)
  
  // Functions section
  if functions.len() > 0 {
    heading(level: 1)[Functions]
    
    for func in functions {
      block(
        stroke: (left: 3pt + blue),
        inset: (left: 12pt, rest: 8pt),
        width: 100%,
        breakable: true,
      )[
        // Function signature
        text(size: 14pt, weight: "semibold", font: "JetBrains Mono")[
          #func.name(#func.args.join(", "))
        ]
        
        v(0.5em)
        
        // Function documentation
        if "doc" in func and func.doc != "" {
          text(size: 10pt)[#func.doc]
        } else {
          text(size: 10pt, style: "italic", fill: gray)[No documentation available]
        }
      ]
      
      v(0.8em)
    }
  } else {
    text(style: "italic", fill: gray)[No functions documented]
  }
}