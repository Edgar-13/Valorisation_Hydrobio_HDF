source("packages.R")

# load("R:/ServicesRegionaux/Service_Connaissance/7-Laboratoire_hydrobiologie/Donnees/Syntheses_et_valorisation/Outil_valorisation_HB_HDF_2025/data_carte.rda", envir = .GlobalEnv)
# load("R:/ServicesRegionaux/Service_Connaissance/7-Laboratoire_hydrobiologie/Donnees/Syntheses_et_valorisation/Outil_valorisation_HB_HDF_2025/data_hydrobio.rda", envir = .GlobalEnv)

load("data/data_carte.rda", envir = .GlobalEnv)
load("data/data_hydrobio.rda", envir = .GlobalEnv)

# Charge tous les fichiers R dans app/R (les modules)
module_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
sapply(module_files, source)

addResourcePath("static", "www")

choix_departements <- list(
  "Zones prédéfinies" = list(
    "Hauts-de-France (tout)" = "HDF",  # ← valeur spéciale
    "Grand Est (tout)" = "GE",  # ← valeur spéciale
    "Île-de-France (tout)" = "IdF"  # ← valeur spéciale
  ),
  "Hauts-de-France" = list(
    "Aisne (02)" = "02",
    "Nord (59)" = "59",
    "Oise (60)" = "60",
    "Pas-de-Calais (62)" = "62",
    "Somme (80)" = "80"
  ),
  "Grand Est" = list(
    "Ardennes (08)" = "08",
    "Marne (51)" = "51",
    "Haute-Marne (52)" = "52",
    "Meuse (55)" = "55"
  ),
  "Île-de-France" = list(
    "Seine-et-Marne (77)" = "77",
    "Val-d'Oise (95)" = "95"
  )
)

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "static/style.css"),
    tags$link(rel = "icon", type = "image/png", href = "static/favicon.png")
  ),


        div(
          style ="display: flex; justify-content: space-between;align-items: center;position: relative;z-index: 10;",
          h1(
          class = "TitreAppli",
          "Suivis hydrobiologiques en Hauts-de-France"
        ),
        mod_export_print_ui("export_print")
      ),
        div(
          div("Date d'accès aux données:"),
          mod_load_data_ui("donnees"),
          style = "position: absolute; bottom: 0, width: 10%;"
        ),
        img(
          src = "static/logo.png",
          alt = 'logo',
          style = '
                    position:fixed;
                    bottom:0;
                    right:0;
                    padding:10px;
                    width:200px;
                    '
        ),
        img(
          src = "static/filigrane.png",
          alt = "filigrane",
          style = '
                    position:fixed;
                    bottom:0;
                    right:0;
                    padding:0px;
                    width:800px;
                    z-index : -1;
                    color:rgb(153, 215, 247);
                    '
          ##99D7F7;
        ),

  sidebarLayout(
    sidebarPanel = sidebarPanel(
      width = 2,
      h2("Panneau de sélection"),

      div(
        style = "margin-bottom: 20px;",
        mod_selecteur_ui(
          id = "departements",
          titre = "Zone géographique",
          texte = "Tous",
          choix = choix_departements,
          choix_multiple = TRUE
        )
      ),

      div(
        style = "margin-bottom: 20px;",
        mod_selecteur_ui(
          id = "eqb",
          titre = "Eléments de qualité biologique",
          texte = "Tous",
          choix = c(
            "Diatomées" = 10,
            "Macrophytes" = 27,
            "Macroinvertébrés" = 13,
            "Poissons" = 4
          ),
          choix_multiple = TRUE
        )
        #div(class = "page-break")
      ),

      div(class = "no-print",
        style = "display : none; margin-bottom: 20px;",
        mod_regie_ui(
          id = "regie",
          titre = "Stations suivies au moins une fois en régie"
        )
      ),

      div (class = "no-print",
        style = "margin-bottom: 20px;",
        mod_selecteur_ordre_taxons_ui(id = "ordre_taxons")
      )
    ),

    mainPanel = mainPanel(
          width = 10,
          tabsetPanel(
            tabPanel(
              title = "Communautés",
              fluidRow(
                column(
                  width = 7,
                  mod_carte_ui(
                    id = "carte",
                    hauteur = "500px"
                  ),
                  div(class = "page-break"),
                  mod_synthese_toutes_stations_ui(
                    id = "bilan_stations"
                  )
                ),
                column(
                  width = 5,
                  mod_synthese_station_ui(id = "synthese_station")
                )
              )
            ),
            tabPanel(
              title = "Taxons",
              fluidRow(
                column(
                  width = 7,
                  mod_repartition_taxons_ui(id = "carte_taxons",
                                            hauteur = "500px")
                ),
                div(class = "page-break"),
                column(
                  width = 5,
                  mod_synthese_taxon_ui(id = "synthese_taxon")
                )
              )
            ),
            tabPanel(
              title = p(class = "TabMethode", "Données & Traitements"),
              fluidRow(
                column(
                  width = 12,
                  mod_donnees_traitements_ui(id = "texte_methode")
                )
              )
            )
          )
        )
      )
    )

server <- function(input, output, session) {
  # Your application server logic

  # Télécharge et charge dans l'espace de travail les données: "donnees_carte",
  # "donnees_carte_taxons", "indices", "listes_taxo", "resumes_listes",
  # "stations", "acronymes_indices", "date_donnees"

  mod_load_data_server("donnees")

  #load_data_hydrobio()

  choix_departements <- mod_selecteur_server(id = "departements")
  choix_eqbs <- mod_selecteur_server(id = "eqb")
  choix_stations <- mod_regie_server(id = "regie", choix_eqb = choix_eqbs, choix_dep = choix_departements)

  station <- mod_carte_server(
    "carte",
    donnees_carte = donnees_carte,
    choix_stations = choix_stations
  )

  ordre_taxon <- mod_selecteur_ordre_taxons_server(
    id = "ordre_taxons",
    choix_station = station,
    choix_eqb = choix_eqbs
  )

  mod_synthese_toutes_stations_server(
    id = "bilan_stations",
    stations = stations,
    indices = etat_bio,
    choix_stations = choix_stations,
    choix_eqb = choix_eqbs
  )

  mod_synthese_station_server(
    id = "synthese_station",
    resumes_listes = resumes_listes,
    stations = stations,
    regie = regie,
    indices = indices,
    acronymes_indices = acronymes_indices,
    valeurs_seuils_stations = valeurs_seuils_stations,
    parametres_eqr = parametres_eqr,
    etat_bio = etat_bio,
    listes_taxo = listes_taxo,
    choix_station = station,
    choix_eqb = choix_eqbs,
    ordre_taxon = ordre_taxon,
    choix_stations = choix_stations
  )


  repartition <- mod_repartition_taxons_server(
    id = "carte_taxons",
    listes = donnees_carte_taxons,
    choix_stations = choix_stations,
    choix_eqbs = choix_eqbs
  )

  mod_synthese_taxon_server(
    id = "synthese_taxon",
    repartition = repartition,
    choix_stations = choix_stations
  )
  mod_export_print_server("export_print")
}

# # Ouvre une page web pour lancer l'application
# port <- 1234
# shiny::runApp(
#   shinyApp(ui, server),
#   port = port,
#   launch.browser = function(url) {
#     browseURL(url)  # utilisation du navigateur par défaut
#   }
# )

shinyApp(ui,server)
