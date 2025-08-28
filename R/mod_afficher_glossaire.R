mod_afficher_glossaire_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(
      class = "print-glossaire page-break",
      style = "margin-top: 40px;",
      h3("Glossaire",
         style = "text-align : left; margin-left : 10%"),
      tags$ul(
        tags$li(tags$b("EQR :"), " Ecological Quality Ratio (ratio de qualité écologique)"),
        tags$li(tags$b("IBD :"), " Indice Biologique Diatomées"),
        tags$li(tags$b("IBMR :"), " Indice Biologique Macrophyte en Rivière"),
        tags$li(tags$b("IPR :"), " Indice Poissons Rivière"),
        tags$li(tags$b("I2M2 :"), " Indice Invertébrés Multi-Métrique"),
        tags$li(tags$b("IBG :"), " Indice Biologique Global"),
        tags$li(tags$b("GCE :"), " Grands Cours d'Eau")
      )
    )
  )
}

mod_afficher_glossaire_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  })
}
