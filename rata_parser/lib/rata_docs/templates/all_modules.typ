#let all_modules_doc(modules: ()) = {
  // Page setup
  set page(
    paper: "a4",
    margin: (top: 2cm, bottom: 2cm, left: 2.5cm, right: 2.5cm),
    header: align(right)[
      #text(size: 9pt, fill: gray)[Rata Standard Library]
    ],
    numbering: "1",
  )
  
  set text(
    font: "Inter",
    size: 11pt,
    lang: "en"
  )
  
  set heading(numbering: "1.")
  
  // Title page
  align(center + horizon)[
    #text(size: 36pt, weight: "bold")[Rata]
    #v(0.5em)
    #text(size: 24pt)[Standard Library]
    #v(0.5em) 
    #text(size: 16pt, fill: gray)[Function Reference]
    #v(2em)
    #text(size: 12pt, style: "italic")[
      Generated from source code docstrings
    ]
  ]
  
  pagebreak()
  
  // Table of contents
  outline(title: "Modules", indent: 2em)
  
  pagebreak()
  
  // Module sections
  for module in modules {
    heading(level: 1)[#module.name]
    
    if module.module_doc != "" and module.module_doc != none {
      block(
        fill: luma(250),
        inset: 15pt, 
        radius: 4pt,
        width: 100%,
      )[
        #text(size: 10pt)[#module.module_doc]
      ]
      v(1em)
    }
    
    // Import example
    block(
      fill: luma(245),
      inset: 10pt,
      radius: 4pt,
    )[
      #raw(lang: "rata", "library " + module.name)
    ]
    
    v(1em)
    
    if module.functions.len() > 0 {
      heading(level: 2)[Functions]
      
      // Create a grid of function signatures
      let func_rows = ()
      for func in module.functions.sorted(key: f => f.name) {
        let signature = text(font: "JetBrains Mono", size: 9pt)[
          *#func.name*(#func.args.join(", "))
        ]
        
        let description = if "doc" in func and func.doc != "" and func.doc != none {
          text(size: 9pt)[#func.doc.split(".").at(0).trim() + "."]
        } else {
          text(size: 9pt, style: "italic", fill: gray)[No description]
        }
        
        func_rows.push((signature, description))
      }
      
      table(
        columns: (2fr, 3fr),
        stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
        fill: (x, y) => if calc.odd(y) { luma(250) } else { white },
        inset: 8pt,
        align: (left, left),
        [*Function*], [*Description*],
        ..func_rows.flatten()
      )
    } else {
      text(style: "italic", fill: gray)[No functions documented]
    }
    
    v(2em)
    
    if module != modules.last() {
      pagebreak()
    }
  }
}